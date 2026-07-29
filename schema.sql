-- =============================================================================
-- GigOS — PostgreSQL Schema (MVP Launch — San Diego County)
-- Tech Stack: Next.js + Supabase (PostgreSQL) + Mapbox + Claude 3.5
-- Status: MVP v1 — supports full worker/employer flow + disputes + reviews
-- =============================================================================

-- =============================================================================
-- ENUMS
-- =============================================================================
CREATE TYPE verification_level AS ENUM ('unverified', 'identity', 'employment', 'full');
CREATE TYPE user_role AS ENUM ('worker', 'employer', 'admin', 'resolution_staff');
CREATE TYPE reputation_tier AS ENUM ('new', 'verified', 'trusted', 'preferred', 'elite', 'suspended');
CREATE TYPE gig_status AS ENUM ('draft', 'open', 'filled', 'in_progress', 'completed', 'cancelled');
CREATE TYPE application_status AS ENUM ('pending', 'offered', 'accepted', 'declined', 'withdrawn');
CREATE TYPE agreement_status AS ENUM ('pending', 'confirmed', 'in_progress', 'completed', 'disputed', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'released', 'disputed', 'cancelled');
CREATE TYPE payment_method AS ENUM ('cash', 'venmo', 'zelle', 'paypal', 'in_app');
CREATE TYPE dispute_status AS ENUM ('open', 'evidence_collected', 'under_review', 'decided', 'appealed');
CREATE TYPE appeal_status AS ENUM ('none', 'filed', 'upheld', 'overturned');
CREATE TYPE review_type AS ENUM ('employer_to_worker', 'worker_to_employer', 'coworker');
CREATE TYPE skill_proficiency AS ENUM ('beginner', 'intermediate', 'expert');
CREATE TYPE endorsement_source AS ENUM ('self_reported', 'employer_endorsed', 'platform_verified');
CREATE TYPE evidence_type AS ENUM ('message', 'photo', 'document', 'check_in_out', 'payment_record', 'other');

-- =============================================================================
-- USERS (workers AND employers share one table)
-- =============================================================================
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT NOT NULL UNIQUE,
    password_hash   TEXT NOT NULL,
    display_name    TEXT NOT NULL,
    avatar_url      TEXT,
    role            user_role NOT NULL DEFAULT 'worker',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,

    -- Verification
    verification_level  verification_level NOT NULL DEFAULT 'unverified',
    identity_verified   BOOLEAN NOT NULL DEFAULT FALSE,
    employment_verified BOOLEAN NOT NULL DEFAULT FALSE,

    -- Reputation (computed fields, not AI-derived)
    reputation_tier     reputation_tier NOT NULL DEFAULT 'new',
    reliability_score   NUMERIC(5,2) NOT NULL DEFAULT 0.00,  -- 0.00 to 100.00

    -- Risk (AI-computed, stored for audit)
    risk_flags      JSONB NOT NULL DEFAULT '[]',
    risk_summary    TEXT,

    last_active_at  TIMESTAMPTZ
);

CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_tier ON users(reputation_tier);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);

-- =============================================================================
-- WORKER PROFILES (additional fields for workers)
-- =============================================================================
CREATE TABLE worker_profiles (
    user_id         UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    bio             TEXT,
    headline        TEXT,

    -- Transport
    has_car         BOOLEAN NOT NULL DEFAULT FALSE,
    has_bike        BOOLEAN NOT NULL DEFAULT FALSE,
    has_transit_pass BOOLEAN NOT NULL DEFAULT FALSE,
    can_relocate    BOOLEAN NOT NULL DEFAULT FALSE,

    -- Work preferences
    min_hourly_rate NUMERIC(7,2),   -- e.g. 18.00
    preferred_payment_method payment_method NOT NULL DEFAULT 'cash',

    -- Location
    home_lat        NUMERIC(10,7),
    home_lng        NUMERIC(10,7),
    home_neighborhood TEXT,          -- e.g. "North Park"

    -- Availability
    availability_notes TEXT,         -- freeform availability notes

    -- Stats (denormalized for fast reads)
    total_gigs_completed    INTEGER NOT NULL DEFAULT 0,
    total_gigs_cancelled    INTEGER NOT NULL DEFAULT 0,
    avg_rating              NUMERIC(3,2) NOT NULL DEFAULT 0.00,
    total_reviews           INTEGER NOT NULL DEFAULT 0,

    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- EMPLOYER PROFILES (additional fields for employers)
-- =============================================================================
CREATE TABLE employer_profiles (
    user_id         UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    business_name   TEXT,
    bio             TEXT,

    -- Business info
    business_type   TEXT,           -- e.g. "Restaurant", "Event Venue"
    website_url     TEXT,
    address_street  TEXT,
    address_lat     NUMERIC(10,7),
    address_lng     NUMERIC(10,7),

    -- Verification docs
    verification_docs JSONB NOT NULL DEFAULT '[]',
    -- [{type: "business_license", url: "...", uploaded_at: "..."}]

    -- Stats (denormalized)
    total_gigs_posted    INTEGER NOT NULL DEFAULT 0,
    total_hires          INTEGER NOT NULL DEFAULT 0,
    avg_rating           NUMERIC(3,2) NOT NULL DEFAULT 0.00,
    total_reviews        INTEGER NOT NULL DEFAULT 0,

    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- SKILL TAXONOMY (platform-wide skill definitions)
-- =============================================================================
CREATE TABLE skill_taxonomy (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug        TEXT NOT NULL UNIQUE,    -- "server_bartending", "mover"
    name        TEXT NOT NULL,           -- "Server / Bartending"
    category    TEXT NOT NULL,           -- "Food & Beverage", "Labor"
    description TEXT,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX idx_skill_taxonomy_category ON skill_taxonomy(category);
CREATE INDEX idx_skill_taxonomy_slug ON skill_taxonomy(slug);

-- =============================================================================
-- SKILL ASSERTIONS (skills a worker claims/proves)
-- =============================================================================
CREATE TABLE skill_assertions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    skill_id        UUID NOT NULL REFERENCES skill_taxonomy(id),
    proficiency     skill_proficiency NOT NULL DEFAULT 'beginner',
    source          endorsement_source NOT NULL DEFAULT 'self_reported',
    verified_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(user_id, skill_id)
);

CREATE INDEX idx_skill_assertions_user ON skill_assertions(user_id);
CREATE INDEX idx_skill_assertions_skill ON skill_assertions(skill_id);

-- =============================================================================
-- SERVICE AREAS (neighborhoods a worker covers)
-- =============================================================================
CREATE TABLE service_areas (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL,           -- "Downtown", "North Park"
    lat         NUMERIC(10,7),
    lng         NUMERIC(10,7),
    radius_miles NUMERIC(5,2) NOT NULL DEFAULT 10.00,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(user_id, name)
);

CREATE INDEX idx_service_areas_user ON service_areas(user_id);

-- =============================================================================
-- AVAILABILITY BLOCKS (weekly recurring availability)
-- =============================================================================
CREATE TABLE availability_blocks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CHECK (start_time < end_time)
);

CREATE INDEX idx_availability_user ON availability_blocks(user_id);
CREATE INDEX idx_availability_day ON availability_blocks(user_id, day_of_week);

-- =============================================================================
-- EQUIPMENT (equipment a worker has access to)
-- =============================================================================
CREATE TABLE equipment (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL,           -- "Hand truck / dollie", "Pickup truck"
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_equipment_user ON equipment(user_id);

-- =============================================================================
-- PORTFOLIO ITEMS (photos of past work)
-- =============================================================================
CREATE TABLE portfolio_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    skill_id    UUID REFERENCES skill_taxonomy(id),
    photo_url   TEXT NOT NULL,
    caption     TEXT,
    gig_id      UUID,                    -- nullable; may not be platform gigs
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_portfolio_user ON portfolio_items(user_id);
CREATE INDEX idx_portfolio_skill ON portfolio_items(skill_id);

-- =============================================================================
-- TEAM RELATIONSHIPS (private to worker — their coworkers)
-- =============================================================================
CREATE TABLE team_relationships (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    coworker_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    gig_id                  UUID,        -- nullable; relationship predates platform
    your_rating_of_coworker SMALLINT CHECK (your_rating_of_coworker BETWEEN 1 AND 5),
    coworker_rating_of_you  SMALLINT CHECK (coworker_rating_of_you BETWEEN 1 AND 5),
    private_notes           TEXT,        -- only the worker sees this
    archived                BOOLEAN NOT NULL DEFAULT FALSE,
    last_worked_together    TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(user_id, coworker_id)
);

CREATE INDEX idx_team_user ON team_relationships(user_id);
CREATE INDEX idx_team_coworker ON team_relationships(coworker_id);

-- =============================================================================
-- GIGS (posted by employers)
-- =============================================================================
CREATE TABLE gigs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Who posted it
    employer_id     UUID NOT NULL REFERENCES users(id),
    gig_category    UUID NOT NULL REFERENCES skill_taxonomy(id),

    -- Core info
    title           TEXT NOT NULL,
    description     TEXT NOT NULL,

    -- Location
    address_street  TEXT NOT NULL,
    address_lat     NUMERIC(10,7) NOT NULL,
    address_lng     NUMERIC(10,7) NOT NULL,
    show_address    BOOLEAN NOT NULL DEFAULT TRUE,   -- vs. just show neighborhood
    neighborhood    TEXT,                            -- extracted for feed display

    -- Schedule
    scheduled_start TIMESTAMPTZ NOT NULL,
    scheduled_end   TIMESTAMPTZ NOT NULL,
    duration_hours  NUMERIC(5,2) NOT NULL,

    -- Pay
    pay_rate        NUMERIC(7,2) NOT NULL,           -- e.g. 22.00
    pay_type        TEXT NOT NULL,                    -- "hourly", "flat", "per_task"
    max_pay         NUMERIC(7,2),                    -- for range postings

    -- Requirements
    required_skills         UUID[] DEFAULT '{}',
    required_equipment       TEXT[] DEFAULT '{}',
    required_transport       TEXT[] DEFAULT '{}',     -- ["car", "truck"]
    required_experience      TEXT[] DEFAULT '{}',    -- ["beginner", "intermediate"]
    team_size                SMALLINT NOT NULL DEFAULT 1,

    -- AI-assigned (stored for audit)
    risk_category    TEXT NOT NULL,                   -- "low", "medium", "high"
    risk_factors     JSONB NOT NULL DEFAULT '[]',     -- [{factor, severity, explanation}]
    ai_pricing_context JSONB,                        -- market rate data used

    -- Status
    status           gig_status NOT NULL DEFAULT 'draft',
    application_deadline TIMESTAMPTZ,

    -- Stats (denormalized)
    view_count       INTEGER NOT NULL DEFAULT 0,
    application_count INTEGER NOT NULL DEFAULT 0,

    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    published_at     TIMESTAMPTZ
);

CREATE INDEX idx_gigs_employer ON gigs(employer_id);
CREATE INDEX idx_gigs_category ON gigs(gig_category);
CREATE INDEX idx_gigs_status ON gigs(status);
CREATE INDEX idx_gigs_scheduled_start ON gigs(scheduled_start);
CREATE INDEX idx_gigs_location ON gigs(address_lat, address_lng);
CREATE INDEX idx_gigs_risk ON gigs(risk_category);
CREATE INDEX idx_gigs_created ON gigs(created_at DESC);

-- =============================================================================
-- GIG PHOTOS (employer-provided gig photos)
-- =============================================================================
CREATE TABLE gig_photos (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gig_id      UUID NOT NULL REFERENCES gigs(id) ON DELETE CASCADE,
    photo_url   TEXT NOT NULL,
    caption     TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_gig_photos_gig ON gig_photos(gig_id);

-- =============================================================================
-- GIG BOOKMARKS (workers saving gigs)
-- =============================================================================
CREATE TABLE gig_bookmarks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gig_id      UUID NOT NULL REFERENCES gigs(id) ON DELETE CASCADE,
    worker_id   UUID NOT NULL REFERENCES users(id),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(gig_id, worker_id)
);

CREATE INDEX idx_gig_bookmarks_worker ON gig_bookmarks(worker_id);

-- =============================================================================
-- APPLICATIONS (workers applying to gigs)
-- =============================================================================
CREATE TABLE applications (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gig_id                  UUID NOT NULL REFERENCES gigs(id),
    worker_id               UUID NOT NULL REFERENCES users(id),

    -- Worker's application
    message                 TEXT,
    proposed_hourly_rate   NUMERIC(7,2),             -- if worker proposes different rate
    proposed_payment_method payment_method,

    -- Status
    status                  application_status NOT NULL DEFAULT 'pending',

    -- AI match
    ai_match_score          NUMERIC(5,2),            -- 0.00 to 100.00
    ai_match_explanation    JSONB,                    -- {factors: [{name, weight, score, explanation}]}

    -- Timestamps
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    responded_at            TIMESTAMPTZ,

    UNIQUE(gig_id, worker_id)
);

CREATE INDEX idx_applications_gig ON applications(gig_id);
CREATE INDEX idx_applications_worker ON applications(worker_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_created ON applications(created_at);

-- =============================================================================
-- AGREEMENTS (the confirmed contract for a gig)
-- =============================================================================
CREATE TABLE agreements (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gig_id          UUID NOT NULL UNIQUE REFERENCES gigs(id),

    worker_id       UUID NOT NULL REFERENCES users(id),
    employer_id     UUID NOT NULL REFERENCES users(id),

    status          agreement_status NOT NULL DEFAULT 'pending',

    -- Payment
    payment_method_agreed payment_method NOT NULL,
    pay_rate_agreed       NUMERIC(7,2) NOT NULL,   -- locked at agreement time

    -- Agreement terms (all versions preserved — immutable)
    terms_history   JSONB NOT NULL DEFAULT '[]',
    -- [{rate, payment_method, completion_requirements, confirmed_by: [uuid], timestamp}]

    -- Check-in / check-out
    check_in_at     TIMESTAMPTZ,
    check_in_lat    NUMERIC(10,7),
    check_in_lng    NUMERIC(10,7),
    check_out_at    TIMESTAMPTZ,
    check_out_lat   NUMERIC(10,7),
    check_out_lng   NUMERIC(10,7),

    -- Completion
    completion_confirmed_worker   BOOLEAN NOT NULL DEFAULT FALSE,
    completion_confirmed_employer BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at         TIMESTAMPTZ,

    -- Payment
    payment_status        payment_status NOT NULL DEFAULT 'pending',
    payment_released_at  TIMESTAMPTZ,

    -- Dispute link
    dispute_id            UUID,    -- set if disputed

    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_agreements_gig ON agreements(gig_id);
CREATE INDEX idx_agreements_worker ON agreements(worker_id);
CREATE INDEX idx_agreements_employer ON agreements(employer_id);
CREATE INDEX idx_agreements_status ON agreements(status);
CREATE INDEX idx_agreements_payment_status ON agreements(payment_status);

-- =============================================================================
-- REVIEWS (employer↔worker and coworker)
-- =============================================================================
CREATE TABLE reviews (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agreement_id    UUID NOT NULL REFERENCES agreements(id),

    reviewer_id     UUID NOT NULL REFERENCES users(id),
    reviewee_id     UUID NOT NULL REFERENCES users(id),
    review_type     review_type NOT NULL,

    gig_id          UUID NOT NULL REFERENCES gigs(id),
    gig_category    UUID NOT NULL REFERENCES skill_taxonomy(id),

    -- Ratings (JSONB structure varies by type)
    ratings         JSONB NOT NULL,
    -- Employer→Worker: {reliability, quality, communication, professionalism}
    -- Worker→Employer: {punctuality, clarity, fairness, communication}
    -- Coworker: {communication, reliability, professionalism, teamwork, leadership, problem_solving}

    written_feedback    TEXT,
    would_work_again    BOOLEAN,         -- nullable; only for coworker reviews

    -- Publication (coworker reviews wait for mutual submission)
    published_at        TIMESTAMPTZ,     -- null until published
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One review per reviewer per agreement per type
    UNIQUE(agreement_id, reviewer_id, review_type)
);

CREATE INDEX idx_reviews_agreement ON reviews(agreement_id);
CREATE INDEX idx_reviews_reviewee ON reviews(reviewee_id);
CREATE INDEX idx_reviews_gig_category ON reviews(gig_category);
CREATE INDEX idx_reviews_published ON reviews(published_at) WHERE published_at IS NOT NULL;

-- =============================================================================
-- DISPUTES
-- =============================================================================
CREATE TABLE disputes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agreement_id    UUID NOT NULL UNIQUE REFERENCES agreements(id),

    filed_by        UUID NOT NULL REFERENCES users(id),
    filed_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    reason          TEXT NOT NULL,        -- short reason: "non-payment", "safety_concern", etc.
    description     TEXT NOT NULL,        -- detailed description from filer

    -- AI analysis
    ai_evidence_summary     JSONB,        -- structured summary from Dispute Evidence Agent
    ai_relevant_factors    JSONB,        -- [{factor, evidence, relevance}]

    -- Resolution
    status          dispute_status NOT NULL DEFAULT 'open',
    resolution      TEXT,                -- Human Resolution Team's decision
    decided_by      UUID REFERENCES users(id),  -- resolution_staff
    decided_at      TIMESTAMPTZ,

    -- Appeal
    appeal_status   appeal_status NOT NULL DEFAULT 'none',
    appeal_decision TEXT,
    appeal_decided_by UUID REFERENCES users(id),
    appeal_decided_at TIMESTAMPTZ,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_disputes_agreement ON disputes(agreement_id);
CREATE INDEX idx_disputes_filed_by ON disputes(filed_by);
CREATE INDEX idx_disputes_status ON disputes(status);

-- =============================================================================
-- DISPUTE EVIDENCE
-- =============================================================================
CREATE TABLE dispute_evidence (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dispute_id          UUID NOT NULL REFERENCES disputes(id) ON DELETE CASCADE,

    submitted_by        UUID NOT NULL REFERENCES users(id),

    evidence_type       evidence_type NOT NULL,
    content             TEXT NOT NULL,              -- URL or text
    caption             TEXT,

    -- AI analysis of this piece of evidence
    ai_relevance_note   TEXT,

    submitted_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dispute_evidence_dispute ON dispute_evidence(dispute_id);
CREATE INDEX idx_dispute_evidence_submitter ON dispute_evidence(submitted_by);

-- =============================================================================
-- PAYMENT METHODS (per user — stored payment info for agreements)
-- =============================================================================
CREATE TABLE user_payment_methods (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    method          payment_method NOT NULL,

    -- Method-specific details (encrypted at rest in production)
    handle          TEXT,               -- e.g. Venmo username, phone number
    label           TEXT,               -- e.g. "Personal Venmo", "Work Zelle"

    is_verified     BOOLEAN NOT NULL DEFAULT FALSE,
    is_default      BOOLEAN NOT NULL DEFAULT FALSE,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_payment_methods_user ON user_payment_methods(user_id);

-- =============================================================================
-- ADMIN ACTION LOG (full audit trail for platform operations)
-- =============================================================================
CREATE TABLE admin_actions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id        UUID NOT NULL REFERENCES users(id),
    action_type     TEXT NOT NULL,      -- "user_suspended", "tier_overridden", "dispute_decided"
    target_user_id  UUID REFERENCES users(id),
    target_id       UUID,               -- entity acted upon (dispute_id, gig_id, etc.)
    payload         JSONB NOT NULL DEFAULT '{}',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_actions_admin ON admin_actions(admin_id);
CREATE INDEX idx_admin_actions_target ON admin_actions(target_user_id);
CREATE INDEX idx_admin_actions_type ON admin_actions(action_type);
CREATE INDEX idx_admin_actions_created ON admin_actions(created_at);

-- =============================================================================
-- UPDATED_AT TRIGGER (auto-update updated_at on relevant tables)
-- =============================================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER worker_profiles_updated_at BEFORE UPDATE ON worker_profiles
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER employer_profiles_updated_at BEFORE UPDATE ON employer_profiles
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER team_relationships_updated_at BEFORE UPDATE ON team_relationships
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER agreements_updated_at BEFORE UPDATE ON agreements
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER disputes_updated_at BEFORE UPDATE ON disputes
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) — Supabase handles this, but noted for docs
-- =============================================================================
-- RLS is enabled per-table in Supabase. Key policies:
--
-- users: users can read their own row; admins can read all
-- worker_profiles: same user can read/write own; public can read (no PII)
-- employer_profiles: same user can read/write own; public can read (no PII)
-- gigs: public read for open gigs; employer owns their gigs
-- applications: only worker (own) and employer (their gig) can see
-- agreements: only the two parties can see their agreement
-- reviews: published reviews are public; unpublished are private to parties
-- disputes: only the filer and resolution staff can see
-- dispute_evidence: only the filer and resolution staff can see
-- team_relationships: user_id owner can see their own rows only
-- skill_assertions, service_areas, availability_blocks, equipment, portfolio_items:
--       user can CRUD their own; public read for display (no PII)
-- gig_bookmarks: worker can only see their own bookmarks
-- user_payment_methods: private to the user only
-- admin_actions: visible to admins only

-- =============================================================================
-- SEED DATA: San Diego Skill Taxonomy
-- =============================================================================
INSERT INTO skill_taxonomy (slug, name, category) VALUES
    ('server_bartending', 'Server / Bartending', 'Food & Beverage'),
    ('mover', 'Mover / Labor', 'Labor'),
    ('event_staff', 'Event Staff', 'Events'),
    ('cleaner', 'House Cleaner', 'Home Services'),
    ('tutor', 'Tutor / Teacher', 'Education'),
    ('delivery_driver', 'Delivery Driver', 'Transportation'),
    ('yard_work', 'Yard Work / Landscaping', 'Home Services'),
    ('personal_chef', 'Personal Chef / Meal Prep', 'Food & Beverage'),
    ('photographer', 'Photographer', 'Events'),
    ('dj', 'DJ / Music', 'Events'),
    ('security', 'Security / Bouncer', 'Events'),
    ('handyman', 'Handyman / Trades', 'Home Services'),
    ('personal_shopper', 'Personal Shopper', 'Errands'),
    ('caregiver', 'Caregiver / Companion', 'Health'),
    ('beauty', 'Hair / Makeup / Beauty', 'Personal Services'),
    ('fitness', 'Fitness Instructor / Coach', 'Health'),
    ('tech_support', 'Tech Support / IT', 'Professional'),
    ('writing', 'Writing / Editing', 'Professional'),
    ('photography', 'Photography / Videography', 'Creative'),
    ('other', 'Other', 'General');
