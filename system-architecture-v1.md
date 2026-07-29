# Gig Marketplace System Architecture v1
**Version:** 1.0
**Date:** 2026-07-28
**Based on:** PRD v2
**Pilot Market:** San Diego County, California
**Status:** Ready for Engineering

---

## PREAMBLE: ARCHITECTURE PRINCIPLES

Every architectural decision flows from the product law established in PRD v2:

**AI is an advisor, investigator, organizer, and assistant. AI is never an authority.**

This means:
- Every AI output must be explainable in plain language to a non-technical user
- Every consequential action requires human confirmation
- No automated system can deny opportunity, release money, or close an account without human review
- The architecture must make AI transparent, not invisible

**Trust is built through transparency, not restriction.**

The architecture prioritizes:
1. Making every signal visible to the people who need it
2. Never hiding information that protects users
3. Never creating opaque gates that people can't understand or appeal

**The pilot market is San Diego County.** All architecture decisions for launch are optimized for this geography, population density, and gig economy profile.

---

## 1. SYSTEM OVERVIEW

### 1.1 Platform Purpose

This platform is an AI-assisted local work marketplace connecting gig workers with employers in the San Diego County area. The platform's role is not to control the transaction but to make it safer, more transparent, and more efficient than informal markets (Craigslist posts, text-based arrangements, word-of-mouth).

### 1.2 Core Platform Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│   Worker App (mobile-first web)  │  Employer Portal (web)   │
│              │                                   │           │
│         Gig Feed                              Job Dashboard  │
│      Profile Builder                         Applicant View   │
│      Dashboard                               Agreement View   │
│      Messages                                Messages        │
│      Reviews                                 Reviews         │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   AI INFERENCE LAYER                        │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │Matching Agent│  │Market Advisor │  │ Safety Agent      │  │
│  │              │  │              │  │                   │  │
│  │ Job→Worker   │  │ Pricing      │  │ Risk Categorize   │  │
│  │ recommendations│  │ Transparency │  │ Flag Anomalies    │  │
│  │ Explain WHY  │  │ Warn Parties │  │ Recommend Guards  │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │Career Growth │  │Dispute       │  │ Completion        │  │
│  │Agent         │  │Evidence Agent│  │ Agent             │  │
│  │              │  │              │  │                   │  │
│  │ Skill Gaps   │  │ Collect      │  │ Remind            │  │
│  │ Course Recs  │  │ Organize     │  │ Prompt Confirm    │  │
│  │ Path Plans   │  │ Summarize    │  │ Cannot Complete    │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                    DATA / DOMAIN LAYER                       │
│                                                              │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │   Users    │  │   Gigs     │  │ Agreements │              │
│  │            │  │            │  │            │              │
│  │ Worker     │  │ Postings   │  │ Terms      │              │
│  │ Profile    │  │ Categories │  │ Changes    │              │
│  │ Reputation │  │ Locations  │  │ Confirm    │              │
│  │ Skills     │  │ Schedule   │  │ Complet.   │              │
│  │ Transport  │  │ Pay/Method │  │ Payments   │              │
│  └────────────┘  └────────────┘  └────────────┘              │
│                                                              │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │ Applications│ │  Reviews   │  │  Disputes  │              │
│  │            │  │            │  │            │              │
│  │ Offers     │  │ Employer→W │  │ Evidence   │              │
│  │ Acceptances│  │ Worker→Emp │  │ Timeline   │              │
│  │ History    │  │ Coworker   │  │ Decisions  │              │
│  └────────────┘  └────────────┘  └────────────┘              │
│                                                              │
│  ┌────────────┐  ┌────────────┐                              │
│  │ Team History│ │   AI      │                              │
│  │            │  │ Explanations│                             │
│  │ Relationships│ │ Reasons   │                              │
│  │ Archived    │  │ Confidences│                             │
│  └────────────┘  └────────────┘                              │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                 INFRASTRUCTURE LAYER                        │
│                                                              │
│  Auth (JWT) │ Stripe (restricted key) │ Maps API            │
│  Email/SMS  │ File Storage            │ Search/Filter      │
│  Audit Log  │ Background Jobs         │ Analytics         │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 The Marketplace Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                   LIFECYCLE OVERVIEW                        │
└─────────────────────────────────────────────────────────────┘

[1. SIGNUP] ──────────────────────────────────────────────────
  Worker: Creates account → Verifies email/phone
        → Completes profile (skills, transport, location, availability)
        → Receives "New" tier automatically

  Employer: Creates account → Verifies email/phone
          → Basic business info
          → Can post immediately (open marketplace)

[2. PROFILE CREATION] ─────────────────────────────────────────
  Worker builds profile:
    - Skills (self-reported + employer-endorsed over time)
    - Transportation mode(s)
    - Service area (neighborhoods or radius)
    - Weekly availability
    - Equipment owned
    - Portfolio items (photos of past work)

  AI Enhancement:
    - Propose missing profile fields based on target job categories
    - Flag contradictions between stated skills and gig history
    - Suggest profile completeness improvements

  AI Limitation:
    - Does NOT verify skills automatically
    - Does NOT assign proficiency levels without employer confirmation
    - Cannot publish profile changes without worker review

[3. GIG DISCOVERY] ────────────────────────────────────────────
  Matching Agent:
    - Considers: skills, distance, transport, schedule, employer quality
    - Ranks all open gigs for each worker
    - Every recommended gig includes "Why we matched this for you"

  Example:
    "You match this event bartender gig because:
     - Your profile lists 'bartending' as a skill
     - Location is 8 minutes from your service area
     - Your availability matches the Saturday 6pm start
     - Employer has a 4.6★ rating and 89% on-time payment history
     - Pay ($22/hr) is above market average ($18–$24 range)"

  Transport Intelligence:
    - Shows commute time, cost, parking for each recommended gig
    - Warns about transit limitations for early-morning starts
    - Never recommends a gig that is logistically infeasible

  AI Limitation:
    - Matching Agent ADVISES. Worker decides which gigs to apply to.
    - No minimum score required to apply
    - Worker can apply to any gig regardless of match quality

[4. APPLICATION] ─────────────────────────────────────────────
  Worker applies:
    - Optional: personalized message to employer
    - Optional: proposed terms (rate, payment method)
    - AI Proposal Builder can assist (worker reviews and edits)

  Employer receives:
    - Worker profile link
    - Opportunity Score (informational, not gating)
    - Worker reputation tier
    - Skills match summary
    - AI explanation of why this worker applied

  AI Limitation:
    - AI does NOT filter applications
    - AI does NOT auto-reject any applicant
    - Employer sees all applicants

[5. AGREEMENT] ────────────────────────────────────────────────
  Employer selects worker → Sends formal offer

  Offer includes:
    - Gig details (date, time, location, description)
    - Agreed pay rate
    - Payment method (must be agreed before gig starts)
    - Completion requirements
    - Any equipment or transportation requirements

  Worker reviews → Can accept, decline, or counter

  When accepted:
    - Agreement is LOCKED
    - Both parties receive confirmation
    - Pre-gig reminder scheduled (24hr before)

  Change management:
    - Any change requires re-confirmation from all parties
    - Original agreement preserved in audit trail
    - All versions stored immutably

  AI Role:
    - AI shows market pricing range at offer stage
    - AI warns if rate is significantly below market
    - AI warns if payment method is unusual

  AI Limitation:
    - AI does NOT approve or reject agreements
    - AI does NOT prevent any agreed terms
    - AI cannot modify an agreement unilaterally

[6. WORK COMPLETION] ───────────────────────────────────────────
  Day-of:
    - Check-in button (worker taps → timestamp + location logged)
    - Check-out button (worker taps → timestamp logged)

  Completion confirmation:
    - Employer confirms: "Work completed as agreed" → proceeds to payment
    - OR: Employer flags issue → dispute flow opens

  AI Role (completion):
    - Send reminder before gig end time
    - Prompt both parties to confirm completion
    - Collect timestamp data for evidence record
    - If dispute opened: hand off to Dispute Evidence Agent

  AI Limitation:
    - AI cannot mark gig complete
    - AI cannot release or hold payment
    - Completion requires explicit human confirmation

[7. REVIEWS] ───────────────────────────────────────────────────
  Post-completion:
    - Employer reviews worker (1–5 stars + written)
    - Worker reviews employer (1–5 stars + written)
    - Coworker reviews (for multi-person gigs)

  Review integrity:
    - Both parties must submit before either is published
    - Reviews tied to specific gig category
    - Cannot edit after submission

  AI Role:
    - Prompt both parties to review
    - Organize submitted feedback for display
    - Track review patterns that indicate reliability

  AI Limitation:
    - AI does NOT average or adjust review scores
    - AI does NOT suppress bad reviews
    - All reviews are published as submitted

[8. REPUTATION GROWTH] ─────────────────────────────────────────
  Reputation tiers are cumulative:
    New → Verified → Trusted → Preferred → Elite

  Each tier has explicit, public requirements (not hidden formulas):
    - Number of completed gigs
    - Completion rate
    - Average rating
    - Reliability (show-up, on-time)
    - Dispute rate

  Badges are visible to employers:
    - Bronze (Verified), Silver (Trusted), Gold (Preferred), Platinum (Elite)

  Redemption mechanic:
    - Workers with low scores in specific areas can improve through consistent performance
    - Platform shows trajectory: "Your reliability has improved — 4 of last 5 gigs on time"

  AI Role:
    - Calculate tier eligibility (algorithmically, published formula)
    - Surface improvement suggestions

  AI Limitation:
    - AI cannot revoke tier without human review
    - AI cannot manually boost someone's tier
    - Tier does NOT block any worker's access to any gig
```

---

## 2. USER TYPES AND PERMISSIONS

### 2.1 Worker

**Definition:** Any user who creates a profile to perform local, on-site gig work.

**Account creation:**
- Email + password OR phone + SMS OTP
- Must verify email and phone before profile is active
- Government ID upload required only for high-risk gig categories (v2); not MVP

**Profile creation:**
- Required: Name, photo, location (neighborhood or city), primary transportation mode, service area, weekly availability
- Optional (but encouraged): Skills, certifications, equipment, portfolio, desired rate range, languages
- Profile completeness score shown to worker to encourage full profiles

**Skills:**
- Self-reported: Worker selects from predefined skill taxonomy
- Proficiency level: Beginner / Intermediate / Expert (self-assessed)
- Employer-endorsed: When an employer rates a worker 4+ stars, they can endorse specific skills
- Skill assertions are evidence-backed over time, not just claims

**Availability:**
- Weekly recurring schedule (blocks of available hours)
- One-off unavailable dates
- Updated at any time; changes don't affect already-accepted gigs

**Transportation:**
- Mode(s): Car, motorcycle, bicycle, public transit, rideshare, walking
- Vehicle details (for car/motorcycle): make/model/year — helps with hauling gigs
- Licensed and insured: Boolean (self-reported with verification path in v2)
- Service area: Neighborhood list or radius from stated home base

**Applications:**
- Worker sees AI-ranked gig feed with explanations
- Worker applies to any gig regardless of match quality or reputation tier
- Worker can include message and proposed terms
- Worker sees all their applications and their status

**Work history:**
- Auto-populated from completed gigs
- Shows: gig category, employer, date, employer rating, pay received
- Private notes field: Worker can add personal notes about each employer

**Reputation growth:**
- Tiers displayed publicly on profile
- Requirements for each tier are published and transparent
- No hidden algorithms determining access

**AI assistance limits for Workers:**
- AI may recommend gigs → worker chooses
- AI may warn about unusual pay → worker decides
- AI may suggest skill improvements → worker chooses
- AI may NOT block worker from any gig
- AI may NOT auto-apply to gigs
- AI may NOT modify profile without worker review

---

### 2.2 Gig Poster / Employer

**Definition:** Any user who creates and posts gig opportunities to hire workers.

**Account creation:**
- Email + password OR phone + SMS OTP
- Must verify email and phone before posting
- Business verification optional — earns a "Verified Business" badge

**Posting a gig:**
1. Select category from predefined list
2. Write title and description
3. Enter location (exact address hidden from other users until they apply)
4. Set start date/time and estimated duration
5. Set pay rate → AI immediately shows market range for that category in San Diego
6. Select pay type: Hourly / Flat / Tip share / Cash
7. Select payment method options (must agree with worker before gig starts)
8. Select required transportation mode (if any)
9. List required equipment (if any)
10. Select required skills (from taxonomy)
11. State experience level required (optional)
12. State team size needed (if multi-person)
13. AI assigns risk category (Low / Medium / High) → employer can see and override with explanation

**Risk category assignment (AI):**
- AI analyzes: gig description, pay rate, required equipment, category history
- Assigns Low / Medium / High with explanation
- Employer can override if they believe category is wrong
- High-risk gigs receive additional verification prompts before going live

**Viewing applicants:**
- Employer sees all workers who applied
- Each applicant shows: profile, tier badge, Opportunity Score (optional use), skill match, AI explanation of why worker applied
- Employer can message applicants before selecting
- Employer selects worker → sends formal offer

**Sending an offer:**
- Employer proposes terms: rate, payment method, any special requirements
- Worker accepts / declines / counters
- On acceptance: agreement is locked and confirmed by both parties

**After the gig:**
- Employer confirms completion OR flags a dispute
- Employer leaves review for worker
- Payment executes per agreement terms

**AI assistance limits for Employers:**
- AI may show market rate ranges → employer sets their rate
- AI may warn if rate is significantly below market → employer decides
- AI may flag unusual patterns → human reviews
- AI may NOT reject employer's posting
- AI may NOT filter which applicants employer sees
- AI may NOT prevent employer from selecting any applicant

---

### 2.3 Human Resolution Team

**Definition:** A trained platform team that makes final decisions on disputes after AI has organized evidence. This is a human role, not an automated one.

**Who they are:**
- Trained dispute resolution staff (2–4 people for MVP in San Diego market)
- Not the same people who built the product
- Operate under published decision guidelines
- Decisions are documented and appealable

**Their process (Tier 3 of dispute flow):**
1. Receive compiled evidence from Dispute Evidence Agent
2. Review all submitted evidence from both parties
3. Review any prior history between the parties
4. Review applicable platform guidelines
5. Make a decision: payment release, partial payment, no-action, account warning, or removal
6. Document the decision with reasoning
7. Notify both parties

**What they CAN do:**
- Decide to release held payment (full or partial)
- Decide that a dispute has no merit and take no action
- Issue warnings to either party
- Escalate account suspension to platform admin
- Recommend platform removal for severe violations

**What they CANNOT do:**
- Make decisions without reviewing evidence
- Act without a dispute being filed by one of the parties
- Reverse a mutual agreement that both parties confirmed without new information
- Delegate decisions to AI

**Accountability:**
- Decision guidelines are published
- Decisions can be appealed (new evidence or procedural complaint)
- Appeals reviewed by a different team member
- Quarterly audit of dispute outcomes for consistency

---

### 2.4 Platform Administrator

**Definition:** Technical and operational staff who manage platform safety, system health, and policy enforcement.

**Permissions:**
- View flagged content (job postings, profiles, disputes)
- Suspend accounts pending human review (not permanent ban without process)
- Remove content that violates published policies
- Access audit logs for investigative purposes
- Manage Human Resolution Team workflows

**What they CANNOT do:**
- Release payments or hold payments without dispute process
- Permanently ban users without Human Resolution Team finding severe violation
- Access private user data without investigative justification
- Modify AI matching outputs or reputation calculations
- Override mutual agreements

**Safety actions (with documentation):**
- Suspend new postings from flagged accounts pending review
- Temporarily restrict accounts alleged to be fraudulent
- Remove gig postings flagged by Safety Agent as high-risk + suspicious
- Escalate to Human Resolution Team for accounts accused of violence or fraud

---

## 3. DATABASE ARCHITECTURE

### 3.1 Design Principles

- **Immutable audit trail:** Every state change creates a new record. Nothing is overwritten.
- **Worker and employer are structurally parallel:** Both are "users" with profiles, reputation, and history
- **Agreements are the central record:** Every gig resolves to one agreement with a complete history
- **AI outputs are stored, not recomputed:** Every AI explanation is stored with the recommendation so we can audit it later

### 3.2 Entity Relationship Overview

```
User (worker OR employer)
  ├── profile_data (JSON blob — flexible fields)
  ├── verification_status
  ├── reputation_scores (per category)
  ├── tier
  ├── created_at
  └── updated_at

User (as Worker)
  ├── skills[] → SkillAssertion (skill + proficiency + endorsements)
  ├── availability[] → AvailabilityBlock
  ├── transportation → TransportProfile
  ├── service_area → ServiceArea
  ├── equipment[] → EquipmentItem
  ├── portfolio[] → PortfolioItem
  ├── work_history[] → Agreement (as worker)
  ├── team_history[] → TeamRelationship (private to worker)
  └── reviews_received[] → Review (as worker)

User (as Employer)
  ├── business_info → BusinessProfile
  ├── gigs_posted[] → Gig
  ├── hires[] → Agreement (as employer)
  ├── reviews_received[] → Review (as employer)
  └── verification_docs[]

Gig
  ├── employer_id → User
  ├── category
  ├── title, description
  ├── location (address stored; area shown in feed)
  ├── schedule (start, end, duration)
  ├── pay_rate, pay_type
  ├── payment_methods[] (agreed options)
  ├── required_transport
  ├── required_equipment[]
  ├── required_skills[]
  ├── experience_level
  ├── team_size
  ├── risk_category (AI-assigned)
  ├── status: draft / open / filled / in_progress / completed / cancelled
  └── created_at

Application
  ├── gig_id → Gig
  ├── worker_id → User
  ├── message (optional)
  ├── proposed_terms (optional)
  ├── status: pending / offered / accepted / declined / withdrawn
  ├── ai_match_explanation (stored)
  └── created_at

Agreement
  ├── gig_id → Gig
  ├── worker_id → User
  ├── employer_id → User
  ├── status: pending / confirmed / in_progress / completed / disputed / cancelled
  ├── terms_version[] (immutable — all versions stored)
  │   └── rate, payment_method, completion_requirements, confirmed_by[], timestamp
  ├── check_in (timestamp + location)
  ├── check_out (timestamp + location)
  ├── completion_confirmation_worker: bool
  ├── completion_confirmation_employer: bool
  ├── payment_status: pending / released / disputed / cancelled
  ├── payment_method_agreed
  ├── dispute_id → Dispute (if any)
  └── completed_at

Review
  ├── agreement_id → Agreement
  ├── reviewer_id → User
  ├── reviewee_id → User
  ├── review_type: employer→worker / worker→employer / coworker
  ├── ratings (JSON — varies by type)
  ├── written_feedback
  ├── published_at (null until both parties submit for coworker; immediate for employer↔worker)
  └── gig_category

CoworkerReview (extends Review for multi-person gigs)
  ├── agreement_id
  ├── gig_id
  ├── reviewer_id (worker)
  ├── reviewee_id (coworker)
  ├── ratings: communication, reliability, professionalism, teamwork, leadership, problem_solving
  ├── would_work_again: bool
  ├── positive_text, improvement_text
  └── published_at

Dispute
  ├── agreement_id → Agreement
  ├── filed_by → User
  ├── filed_at
  ├── reason
  ├── description (from filer)
  ├── evidence[] → DisputeEvidence
  ├── ai_evidence_summary (from Dispute Evidence Agent)
  ├── status: open / evidence_collected / under_review / decided / appealed
  ├── resolution (from Human Resolution Team)
  ├── decided_by → HumanResolutionStaff
  ├── decided_at
  ├── appeal_status: none / filed / upheld / overturned
  └── appeal_decision

DisputeEvidence
  ├── dispute_id
  ├── submitted_by → User
  ├── evidence_type: message / photo / document / check_in_out / payment_record / other
  ├── content (URL or text)
  ├── ai_relevance_note (what the AI found relevant)
  └── submitted_at

TeamRelationship (private to worker)
  ├── worker_id → User (owner — private to them)
  ├── coworker_id → User
  ├── gig_id → Gig (nullable — relationship predates platform)
  ├── your_rating_of_coworker
  ├── coworker_rating_of_you
  ├── private_notes (worker's own notes)
  ├── archived: bool
  └── last_worked_together

SkillAssertion
  ├── user_id → User
  ├── skill_id → SkillTaxonomy
  ├── proficiency: beginner / intermediate / expert
  ├── endorsements[] → { employer_id, gig_id, rating_given }
  └── source: self_reported / employer_endorsed / platform_verified
```

### 3.3 Reputation Tier Calculation

**Each worker/employer has a tier per gig category.**

| Tier | Name | Requirements (Published) |
|------|------|--------------------------|
| 0 | New | Account created |
| 1 | Verified | 5+ completed gigs, 80%+ completion rate |
| 2 | Trusted | 15+ gigs, 4.0+ avg rating, 90%+ reliability |
| 3 | Preferred | 30+ gigs, 4.5+ avg rating, 95%+ reliability |
| 4 | Elite | 50+ gigs, 4.8+ avg rating, 99%+ reliability |
| X | Suspended | Human Resolution Team finding only |

**Reliability score calculation:**
```
reliability = (gigs_completed_on_time / gigs_accepted) × 100
```
Cancellations before the gig starts do not count against reliability unless it becomes a pattern (3+ cancellations in 30 days).

**AI's role in tier calculation:**
- AI computes the score using the published formula
- No hidden modifiers
- Worker can see exactly which numbers determine their tier
- AI cannot manually adjust tier

---

## 4. AI ARCHITECTURE

### 4.1 Design Philosophy

**Every AI module is explainable by default.** No black-box scoring. Every output a user sees includes the reasoning behind it, what data was used, and what could change the output.

**AI modules do not call each other.** Each has a specific, bounded purpose. A user's Opportunity Score does not trigger a career recommendation automatically.

**Human-in-the-loop is enforced at the architectural level.** Not as an afterthought — each module specifies exactly where human confirmation is required before consequential action.

---

### 4.2 Module A: Matching Agent

**Purpose:** Help workers discover relevant gigs and help employers discover relevant workers. Ranking and recommendation, not filtering or blocking.

**Inputs:**
- Worker profile: skills, transport mode, service area, availability, reputation tier, history
- Gig details: requirements, location, schedule, pay, employer reputation
- Platform data: aggregate performance of similar gigs, typical match rates

**Matching Logic (ranked, not filtered):**

```
MatchScore = weighted_sum(
  skill_match_ratio × 0.25,
  transport_feasibility × 0.20,
  distance_score × 0.15,
  schedule_compatibility × 0.15,
  employer_trust_score × 0.15,
  pay_competitiveness × 0.10
)

where:
  skill_match_ratio = (worker skills matching requirements) / (total requirements)
  transport_feasibility = 1.0 if feasible, 0 if not (hard constraint — no score given if infeasible)
  distance_score = decreasing function of commute time
  schedule_compatibility = overlap between worker availability and gig window
  employer_trust_score = normalized employer reputation score
  pay_competitiveness = job_rate / market_average_for_category
```

**Note:** `transport_feasibility = 0` is a hard constraint — the gig is not shown if the worker cannot physically reach it with their declared transport. This is not a low score, it's a non-recommendation.

**Outputs:**

1. **Ranked gig feed** for each worker (top 50, paginated)
2. **Per-gig explanation card:**
   ```
   "We recommend this gig because:
    - Your profile skills (bartending, event setup) match 4/5 requirements
    - Location is 8 minutes from [Neighborhood] by car
    - Saturday 6pm start fits your stated availability
    - Employer 'Riverside Events Co.' has a 4.6★ rating (Trusted tier)
    - Pay ($22/hr) is in the upper range for this category in San Diego
    - No transit concern: gig ends at 11pm, public transit available"

   Commute: 8 min by car, ~$3.50 fuel, street parking available
   Opportunity Score: 84/100 (Qualification: 9, Logistics: 9, Earnings: 8, Trust: 10, Growth: 6)
   ```
3. **Ranked applicant feed** for each employer (sorted by match quality)

**Explanation system:**
- Every recommendation includes a plain-language "why"
- Each factor in the score is explained individually
- Confidence level shown: "This match is [High/Medium/Low] confidence based on [X] completed gigs by similar workers"

**Limitations:**
- Matching Agent does NOT hide gigs from workers
- If a worker specifically searches for a gig outside their transport range, they see it with a warning
- Low match score does not prevent application
- AI cannot learn to prefer certain workers over others for reasons unrelated to fit (e.g., cannot weight based on who pays more to promote)

---

### 4.3 Module B: Market Advisor Agent

**Purpose:** Provide transparent, data-driven pricing information so both workers and employers can negotiate with real market context.

**What it knows:**
- All completed gigs in San Diego County by category
- Pay rates, gig duration, worker experience level, employer tier
- Historical trends (monthly average by category)
- Transport mode adjustments (car jobs vs. transit-accessible jobs)

**Outputs:**

1. **Market pricing range** (shown when employer sets pay rate):
   ```
   "For event bartender gigs in San Diego:
    - Market range (middle 80%): $16–$26/hr
    - Typical rate for workers with your experience level: $19–$23/hr
    - Workers with Preferred/Elite tier average: $22–$26/hr

    Tip: Gigs at $18/hr or below receive 40% fewer applications than market average."
   ```

2. **Rate warning to worker** (when applying to below-market gig):
   ```
   "This offer ($14/hr) is 22% below the typical range ($18–$24/hr) for this
    category in San Diego. This is not a block — you can still apply.
    Consider mentioning your expected rate in your message."
   ```

3. **Rate warning to employer** (when posting below market):
   ```
   "The rate you've entered ($15/hr) is below 80% of similar gigs in this
    category in San Diego. You may receive fewer quality applications.
    Suggested range: $18–$24/hr for this type of work."
   ```

4. **Pay trend signal** (in worker dashboard):
   ```
   "Event staffing pay in San Diego has increased 8% over the past 3 months.
    Average hourly rate: $20/hr (up from $18.50 in April)."
   ```

**What it does NOT do:**
- Does NOT set a floor or ceiling
- Does NOT prevent any transaction at any price
- Does NOT recommend specific rates — only shows what the market is doing
- Does NOT consider anything except real completed gig data

---

### 4.4 Module C: Safety Agent

**Purpose:** Assess gig risk level, detect anomalies, and recommend appropriate safeguards — not block gigs or gate access.

**Risk Category Assignment:**

Every gig is assigned one of three risk categories:

| Category | Criteria | Safeguards Required |
|----------|----------|---------------------|
| **Low** | Standard description, market-rate pay, no heavy equipment, no hazardous conditions | Basic identity verification |
| **Medium** | Physical labor, expensive equipment, private residence, multi-person team | Basic verification + optional background check offer |
| **High** | Heavy machinery, construction, work with vulnerable populations, high cash value, multi-day | Full verification prompts, detailed completion criteria, potential platform review before going live |

**Risk assessment inputs:**
- Gig description (NLP analysis for hazard keywords, coercion signals, unrealistic promises)
- Pay rate vs. category average (very low pay + high demands = elevated risk)
- Required equipment (does it require specialized knowledge to operate?)
- Location type (private residence vs. public venue vs. industrial site)
- Category historical dispute rate
- Employer account history (new employer + high-risk gig = elevated)

**Outputs:**

1. **Risk category badge** on every gig posting (shown to both employer and workers who apply):
   ```
   "This gig is categorized as Medium Risk.
    Safeguards: Background check available (optional), work log recommended,
    completion requires photo evidence of work performed."
   ```

2. **Red flag alert** (sent to platform admin for human review — not automatic removal):
   ```
   "This gig posting has been flagged for review:
    - Pay rate ($8/hr) is 60% below market for moving help
    - Description mentions 'no questions asked' work
    - Posted by new employer account

    A human will review within 4 hours. The posting remains visible but
    marked as 'Under Review.'"
   ```

3. **Completion requirement template** (recommended based on risk):
   ```
   "For a Medium-Risk moving help gig, we recommend:
    - Check-in/check-out with location
    - Photo evidence before and after
    - Written description of items moved
    These requirements will be shown to both parties in the agreement."
   ```

**What it does NOT do:**
- Cannot remove a gig posting without human review
- Cannot prevent an employer from posting
- Cannot block a worker from applying to a high-risk gig
- Cannot assign a risk category without explanation
- Cannot override human judgment

---

### 4.5 Module D: Career Growth Agent

**Purpose:** Help workers understand their current position, identify achievable next steps, and make informed decisions about skill development. Operates on worker dashboard and Gap Finder interface.

**What it knows:**
- Worker's profile (skills, experience, transport, location)
- Worker's completed gigs and income history
- Job market data (what skills are requested, what they pay)
- Course and certification options (curated list for MVP)

**Gap Finder Logic:**

1. Worker states a target: job category or income level
2. System identifies all gigs in that category paying at or above target rate
3. System identifies skills required on those gigs that worker does not have
4. For each missing skill:
   - Estimate learning time (conservative: Easy = 1–2 weeks, Medium = 1–3 months, Hard = 3–6 months)
   - Estimate cost (Free / Under $50 / $50–$500 / $500+)
   - Identify market demand (% of postings requiring this skill in San Diego)
   - Show expected pay uplift ("Workers with [Skill] earn $X–$Y/hr vs. current $Z/hr")
   - Connect to actual job postings that would become accessible

5. Surface the shortest high-value path first

**Outputs:**

1. **Gap Finder Report** (shown on dashboard):
   ```
   "To qualify for construction gigs paying $25+/hr in San Diego:

   Missing: OSHA 10 construction safety certification
   - Time to acquire: 1–2 weeks (online + exam)
   - Cost: ~$100
   - Required on: 35% of construction gig postings in San Diego
   - Expected impact: Opens access to 12 current postings near you
   - Typical pay range with cert: $24–$30/hr

   Shortest path to reaching your $25/hr goal: 4–6 weeks

   This is an estimate based on market data. Actual results vary."
   ```

2. **Course Recommendations** (curated list, not affiliate-heavy):
   ```
   "For OSHA 10 certification:
   Recommended: OSHA10.com Online Training — $100, ~10 hours, recognized nationally
   Alternatives considered: [Local union course — $250, 2 days — why we didn't choose it]
   "
   ```

3. **Dashboard growth card**:
   ```
   "Your average hourly rate this month: $19.50
   Workers at Preferred tier in your categories average: $23–$27/hr
   Suggested next step: Add professional bartending certification (1 weekend, ~$150)
   Estimated impact: Opens access to higher-end event bartender gigs ($22–$28/hr)"
   ```

**What it does NOT do:**
- Cannot guarantee job placement after skill acquisition
- Cannot promise specific income outcomes
- Cannot fabricate learning timelines (must acknowledge uncertainty)
- Cannot recommend skills with no market data backing
- Cannot enroll worker in courses automatically

---

### 4.6 Module E: Dispute Evidence Agent

**Purpose:** When a dispute is filed, this agent collects, organizes, and summarizes all relevant evidence so Human Resolution Team can make a fully informed decision efficiently.

**Trigger:** Dispute filed by worker or employer

**Evidence collection process:**

1. **Gather agreement history:**
   - Original terms posted
   - All change requests and approvals
   - Confirmation timestamps from both parties

2. **Gather communication:**
   - All in-app messages between parties before and during gig
   - External communications submitted by either party (screenshots, etc.)

3. **Gather timestamps:**
   - Check-in and check-out (if used)
   - Agreement acceptance timestamp
   - Gig start/end vs. scheduled times

4. **Gather payment records:**
   - In-app payment status (if applicable)
   - Cash documentation (if recorded)

5. **Gather patterns:**
   - Has this employer had similar disputes before?
   - Has this worker had disputes before?
   - What is the dispute rate for this gig category?
   - Any red flags in prior interactions?

6. **Gather context:**
   - Gig description vs. what was actually performed
   - Weather or external factors submitted as evidence
   - Any third-party corroboration

**Output:** Evidence Dossier (structured document):
```
DISPUTE #D-2024-0847
Filed by: [Worker] on 2024-07-15
Gig: Moving Help — Chula Vista — 2024-07-14

AGREEMENT RECORD:
- Original terms: $20/hr, 4 hours estimated, cash payment
- Change: None requested
- Confirmed by: Both parties 2024-07-13

COMMUNICATION TIMELINE:
- 2024-07-13 9:14am: Employer confirmed details
- 2024-07-14 10:02am: Worker checked in
- 2024-07-14 2:48pm: Employer asked for additional help (outside scope)
- 2024-07-14 3:15pm: Worker declined extra work citing scope
- 2024-07-14 4:02pm: Worker checked out
- 2024-07-14 6:30pm: Dispute filed

EVIDENCE SUMMARY:
Worker claims: Completed agreed 4 hours of moving furniture. Employer refused to pay
  citing "incomplete work" after asking for additional unpaid work.
Employer claims: Worker refused to complete full job, left after 4 hours despite
  job requiring full day.

PATTERN CHECK:
- Employer: 2 prior disputes (both resolved in favor of worker)
- Worker: 0 prior disputes
- This category dispute rate: 8%

AI RELEVANCE NOTE:
"Employer has pattern of disputes involving scope disagreements. Worker has
no prior disputes. Scope change was requested mid-gig and declined before
additional work began."

Evidence dossier complete. Passed to Human Resolution Team."
```

**What it does NOT do:**
- Cannot decide who is right
- Cannot recommend a payment outcome
- Cannot dismiss evidence from either party
- Cannot make credibility judgments

---

### 4.7 Completion Agent

**Purpose:** Manage the structured completion workflow without making completion decisions.

**Workflow management:**
- 24-hour pre-gig reminder to both parties
- At gig end time: prompt both parties to confirm completion
- If no confirmation within 12 hours: follow-up prompt to both
- If employer confirms completion → trigger payment flow
- If employer disputes → open dispute record, route to Dispute Evidence Agent
- If worker disputes completion claim → open dispute record

**Reminder content:**
```
"[Gig Name] ends today at 6pm.
Both parties: Please confirm work completion within 12 hours.
Worker: Tap 'Confirm Completion' when done.
Employer: Tap 'Confirm and Release Payment' when satisfied, or 'Flag Issue' if needed."
```

**What it does NOT do:**
- Cannot mark gig complete without human confirmation
- Cannot release, hold, or redirect any payment
- Cannot close a dispute

---

## 5. USER EXPERIENCE FLOWS

### 5.1 Worker Flow

**SIGNUP:**
1. Enter email + phone → verification code sent to both
2. Verify both → create password
3. Welcome screen: "Let's build your profile"
4. Enter name, upload photo
5. Select neighborhood (San Diego: dropdown of neighborhoods + Chula Vista)
6. Select primary transportation mode
7. Set service area (which neighborhoods will you work in?)
8. Set weekly availability (drag-and-drop calendar)
9. Add skills (searchable taxonomy — can add up to 15)
10. Add equipment owned (optional)
11. Set desired rate range (private — shown only to AI, not employers)
12. Profile preview → "Your profile is ready"
13. Dashboard loads with gig recommendations

**FINDING WORK:**
1. Dashboard shows: "X gigs match your profile today"
2. Tap "See Matches" → gig feed (ranked by Matching Agent)
3. Each gig card shows:
   - Title, category, employer tier badge, location (area), pay, start time
   - "Why this matches you:" [2-3 sentence explanation]
   - Opportunity Score components (optional — can be hidden)
   - Commute time/cost
4. Tap gig → full gig detail:
   - Full description
   - AI risk badge (Low/Medium/High)
   - Employer profile summary
   - Completion requirements
   - Pay rate + market range comparison
5. "Apply" button → optional message + optional proposed terms → submit
6. Confirmation: "Application sent. Employer typically responds within X hours."
7. Application status visible in Dashboard under "Applications"

**AGREEMENT:**
1. Receive push/email: "You've received an offer!"
2. Open offer: See terms, employer profile, Opportunity Score
3. Options: Accept / Decline / Counter
4. Counter: Propose different rate or payment method → sent back to employer
5. On Accept: "Agreement confirmed. Gig details added to your calendar."
6. 24hr before: Reminder with gig details + "Confirm you're still on"
7. Day of: "Check In" button → tap when arriving → timestamp + location saved

**COMPLETING WORK:**
1. Tap "Check Out" when done → timestamp saved
2. Employer confirms completion
3. Push notification: "Work confirmed! Please leave your review."
4. Leave review: Star ratings + written feedback
5. "Thank you! Your review has been submitted. It will publish once [employer] submits theirs."
6. Payment: If cash → prompted to confirm "Cash received" / "Cash not received"
7. Reputation updated → see new tier badge if progressed

**DISPUTE (if needed):**
1. On Dashboard → "Flag an issue" on completed gig
2. Select reason: Non-payment / Safety issue / Scope disagreement / Other
3. Describe what happened
4. Upload evidence: photos, messages
5. AI confirms: "Your dispute has been filed. [Employer] has 7 days to respond.
   Our Human Resolution Team will review once both sides have submitted."
6. Track status: "Under Review" → "Decision Made" → read outcome

---

### 5.2 Employer Flow

**POSTING A GIG:**
1. Dashboard → "Post a Gig"
2. Select category: [Event Staff: Bartender / Server / Setup] / [Cleaning] / [Yard Work] / [Moving Help] / [General Assistance] / [Personal Services]
3. Enter title: "Birthday party bartender needed — Saturday 5pm"
4. Enter description: [Rich text editor — AI scans for red flags in real-time]
5. Enter location: Address (shown only to hired worker)
6. Set date/time: Start, estimated duration
7. Set pay rate: AI shows market range as employer types → "Similar gigs in San Diego pay $18–$24/hr"
8. Select pay type: Hourly / Flat / Tip share / Cash
9. Select payment methods you'll accept: [Cash] / [In-app payment] / [Other]
10. Required transport: [None needed] / [Must have car] / [Must have bike] / etc.
11. Required equipment (optional)
12. Required skills (searchable taxonomy)
13. Team size needed (if applicable)
14. AI assigns risk category: [Low Risk] — shown with explanation
15. Preview posting → "Looks good" / Edit
16. Post → "Your gig is live. Workers matching your needs will see it today."

**REVIEWING APPLICANTS:**
1. Dashboard → "X applicants for [Gig Name]"
2. See each applicant card:
   - Photo, name, tier badge
   - Skill match: "Matches 4/5 required skills"
   - Avg rating + number of reviews
   - "Why they applied" (AI explanation)
   - Opportunity Score (if enabled)
3. Tap applicant → full profile
4. Options: "Send Offer" / "Message First" / "Pass"
5. Send Offer: Confirm rate and terms → "Offer sent to [Worker]"
6. Worker accepts → agreement confirmed → both parties notified

**AFTER THE GIG:**
1. Push notification: "[Worker] has checked out. Please confirm completion."
2. Review work against agreement terms
3. Options: "Confirm Completion & Release Payment" / "Flag an Issue"
4. On confirm: Payment processes (if in-app) OR prompt to confirm cash handed over
5. Prompted to leave review: Star ratings + written feedback
6. Review submitted

**DISPUTE (if needed):**
1. On Dashboard → "Flag an issue" on completed gig
2. Select reason → describe → upload evidence
3. Human Resolution Team reviews

---

### 5.3 Dispute Flow (Full)

```
DISPUTE PROCESS — STEP BY STEP

Step 1: Dispute Filed
  Who: Worker OR Employer
  Where: Completed gig page → "Flag an Issue"
  What: Select reason, describe, upload evidence
  AI action: Creates DisputeEvidence record, begins evidence collection
  Status: "Open"

Step 2: Evidence Collection (72 hours max)
  Both parties notified
  Both parties can submit additional evidence
  AI Evidence Agent compiles dossier
  Both parties see each other's submissions
  Status: "Evidence Collecting"

Step 3: Direct Resolution Window (48 hours)
  Platform prompts both parties to resolve directly
  AI shows structured summary of agreement terms and what each party claims
  Either party can propose resolution
  If they agree: dispute closed, no HR involvement needed
  Status: "Direct Resolution" → resolved OR "Escalated"

Step 4: Human Resolution Review
  If not resolved: Escalate to Human Resolution Team
  HR Reviewer receives AI Evidence Dossier
  HR Reviewer reviews all evidence + prior history
  HR Reviewer makes decision
  Status: "Under Review"

Step 5: Decision Issued
  Both parties notified with decision + reasoning
  Payment actioned if applicable (full / partial / none)
  Account status updated if applicable (warning, etc.)
  Status: "Decided"

Step 6: Appeal Window (7 days)
  Either party can file appeal with new evidence
  Appeal reviewed by different HR Reviewer
  Appeal decision: Uphold / Overturn / Modify
  Status: "Appealed" → "Final"
```

---

## 6. MVP ARCHITECTURE

### Scope Principle: Ship the trust flywheel first

The MVP must establish the core trust loop: workers can build reputation, employers can post with confidence, and both sides benefit from transparency. Everything else is secondary.

### Version 1 MVP (Launch — San Diego County)

**Must ship:**

| Component | Description |
|-----------|-------------|
| **User accounts** | Worker + Employer, email + phone verification |
| **Worker profile** | Core fields: name, photo, skills, transport, availability, service area, equipment |
| **Employer profile** | Basic info, tier badge, review summary |
| **Gig posting** | All 6 categories, all required fields, AI risk assignment |
| **Gig discovery** | Matching Agent feed with explanations, search + filter |
| **Opportunity Score** | 5-component score with explanations |
| **Agreement flow** | Offer → Accept/Counter → Locked agreement, change management |
| **In-app messaging** | Simple thread per gig application |
| **Completion flow** | Check-in/out, dual confirmation, payment method recording |
| **Employer → Worker reviews** | 5-star + written, published after both submit |
| **Worker → Employer reviews** | 5-star + written, per-category, anonymous |
| **Reputation tiers** | New → Verified → Trusted → Preferred → Elite (with published requirements) |
| **Safety Agent** | Risk categorization, red flag detection, safeguard recommendations |
| **Market Advisor** | Real-time market range on job posting, pay warnings |
| **Human Resolution Team** | Staffed and operational (not built — this is a team, not software) |
| **Dashboard** | Active gigs, applications, income tracking (manual), reputation tier |

**Not in MVP:**
- Coworker reviews (v2 — requires multiple workers per gig, need density first)
- Team Builder (v2 — requires proven team histories)
- Gap Finder / Career Growth (v2 — need gig volume first)
- Stripe payment processing (MVP uses cash and tracking; in-app payments deferred to v2)
- Background check integration (v2)
- Mobile native app (web app mobile-first)

### Version 2 (First Post-Launch Update — 4–8 weeks after launch)

| Feature | Description |
|---------|-------------|
| Coworker reviews | Peer reviews for multi-person gigs |
| Team Builder | AI teammate recommendations + invite flow |
| Worked With Before | Private team history, re-invite |
| Gap Finder | Skill gap analysis tied to real postings |
| Transportation Intelligence | Full commute calculator, route reliability, weather |
| AI Proposal Builder | Pre-fill applications, rate suggestions |
| Dispute Evidence Agent | Automated evidence collection for HR Team |
| Stripe integration | In-app payments for employers who want escrow |
| Completion Agent | Automated reminders, confirmation prompts |

### Version 3 (Market Validation → Scaling)

| Feature | Description |
|---------|-------------|
| Team Chemistry Score | Aggregated team performance data |
| Course Finder | Curated course recommendations with ROI tracking |
| AI Career Coach | Push notifications, personalized career plans |
| Advanced verification | Government ID + selfie match |
| Background check integration | Worker-optional, employer-requestable |
| Multi-city expansion | Adjacent markets to San Diego |
| Remote work category | Skills-based matching (not location-based) |

### Future (Scaling Phase)

- White-label API for HR/staffing companies
- Worker collectives / crew formation tools
- Insurance referral partnerships
- Payroll integration for employers
- Advanced analytics dashboard for employers
- Mobile native app (iOS + Android)

---

## 7. PAYMENT ARCHITECTURE

### Core Principle: Work and Money Are Separate Systems

Payment architecture is designed around the rule that **no AI system can independently release, hold, or redirect money**. Every payment action requires human confirmation.

### Payment Methods Supported

| Method | How it works | Platform role |
|--------|-------------|---------------|
| **Cash** | Agreed in advance, recorded in agreement | Document only — platform tracks agreed vs. confirmed received |
| **In-app (Stripe)** | Employer pays into platform escrow; released on completion confirmation | Full payment trail, dispute hold capability |
| **Direct bank transfer** | Agreed outside platform | Platform documents agreed amount; parties confirm receipt |
| **Other electronic** | Venmo, PayPal, Cash App — agreed in advance | Platform documents method; parties confirm receipt |

### Payment Flow (In-App)

```
[Employer posts gig] → Rate and payment method recorded in gig
        ↓
[Agreement confirmed] → Payment method locked in agreement
        ↓
[Gig starts] → No payment action
        ↓
[Worker checks in] → Timestamp logged
        ↓
[Worker checks out] → Timestamp logged
        ↓
[Employer confirms completion] → OR [Worker flags issue → dispute opens]
        ↓
[Payment executes per agreement]
  - In-app: Stripe releases funds to worker (minus platform fee if applicable)
  - Cash: Worker prompted to confirm "Cash received"
  - Direct transfer: Both parties reminded; worker confirms receipt
        ↓
[Reviews submitted]
```

### Cash Payment Documentation

Cash is a legitimate, common payment method in the San Diego local gig market. Platform handles it as follows:

- Employer selects "Cash" as payment method in gig posting
- Worker must explicitly accept cash payment method when reviewing offer
- Post-gig: Platform sends reminder to both parties
- Worker confirms: "Cash received" or "Cash not received"
- If "not received": Dispute flow opens
- Cash payment record is stored and affects employer payment reputation score

**Why this matters:** An employer who consistently pays cash promptly builds the same "pays on time" reputation as one using in-app payments.

### Stripe Integration (Current State)

Stripe account is connected via restricted API key.

MVP approach: Stripe infrastructure is in place but in-app payment processing is not activated. MVP operates on cash + documented direct payments.

v2 activation: In-app Stripe payments become available as an option for employers who want escrow and dispute protection. Platform fee (if any) is calculated but documented — not collected in MVP.

### What AI Cannot Do With Payments

| Action | Who Can Do It |
|--------|--------------|
| Release held payment | Human Resolution Team decision only |
| Refund payment | Human Resolution Team decision only |
| Cancel agreement | Both parties mutually |
| Change payment amount | Both parties mutually (with re-confirmation) |
| Change payment method | Both parties mutually (before gig starts) |
| Mark work complete | Employer (or mutual confirmation) |

---

## 8. TRUST, SAFETY, AND SECURITY MODEL

### 8.1 Identity Verification

**All users (workers and employers):**
- Email verification (required)
- Phone verification via SMS OTP (required)
- Password: minimum 10 characters

**Workers (additional, based on gig risk):**

| Gig Risk | Verification Required |
|----------|----------------------|
| Low | Email + phone only |
| Medium | Above + (optional) background check offer displayed to employer |
| High | Above + ID upload prompt (deferred to v2) |

**Employers (additional):**
- Business verification optional (earns "Verified Business" badge)
- Payment method verification before first posting (Stripe or bank account for cash)

**Verification is not a gate.** A worker without background check completion can still apply to Medium-risk gigs. The employer sees the verification status and decides.

### 8.2 Fraud Prevention

**Employer-side:**
- AI detects: multiple similar low-pay postings from new accounts → elevated review
- AI detects: pattern of disputes resolved against employer → flag for HR review
- Cash payment tracking: employer who consistently doesn't confirm cash receipt → affects reputation
- Identity verification: phone + email must be confirmed before posting

**Worker-side:**
- Application pattern detection: one person creating multiple worker profiles → flagged
- Check-in location: worker's location must be within reasonable distance of gig location (opt-in)
- Gig abandonment pattern: 3+ accepted gigs cancelled day-of → reputation flag
- No-show pattern: impacts reliability score

**Platform-side:**
- Audit log: all significant actions logged with timestamp and actor
- No payment manipulation: AI cannot move money
- Agreement immutability: terms versions are append-only

### 8.3 Abuse Prevention

**Review integrity:**
- Dual submission rule (both parties must submit before reviews publish — coworker reviews)
- Written reviews cannot be edited after submission
- Anomaly detection: statistically inflated review averages are flagged for HR review

**Harassment prevention:**
- In-app messaging: Platform can review message history if reported
- Block function: Workers can block employers (and vice versa) — prevents future applications or offers
- Zero tolerance for threats or explicit content in messages → immediate account suspension

**Dispute abuse prevention:**
- Three disputes filed and dismissed within 60 days → review flag
- Dispute filed after completion but evidence submission window missed → HR discretion
- False dispute filing (AI evidence shows worker was clearly in the wrong) → affects filing party's reputation

### 8.4 Privacy Protection

**Data minimization:**
- Gig location: Exact address shown only to hired worker after agreement confirmed
- Worker's exact address: Never collected (only neighborhood/service area)
- Phone numbers: Masked in-app (workers see "Message sent" — actual contact info exchange is opt-in)

**Data sharing:**
- Worker profile: Shareable public link (`/w/[username]`) — worker controls what's shown
- No data sold to third parties
- No data shared with employers beyond what worker has applied with

**Account security:**
- JWT-based authentication
- Session management: active sessions visible, can be revoked
- Password reset via email + phone verification

---

## 9. PILOT MARKET: SAN DIEGO COUNTY

### Why San Diego County

**Selected because:**
- Population: ~1.3M in city of San Diego + ~275K in Chula Vista = strong density for marketplace
- Gig economy maturity: High demand for event staffing (Conventions, Petco Park, beach events), home services, moving
- Weather: Year-round outdoor and event gig season — less seasonal disruption than northern markets
- Sprawl vs. density: Mix of dense urban neighborhoods (Downtown, North Park, Hillcrest) and suburban (Chula Vista, El Cajon) — tests transport matching across modes
- Competition: Existing platforms are remote-focused (Upwork) or general (Craigslist) — no strong local-gig-focused incumbent
- Founder context: Personal experience in this market (per earlier conversation)

### Initial Focus Areas Within San Diego County

**Phase 1 neighborhoods (by density and gig demand):**

| Neighborhood | Primary gig categories | Rationale |
|-------------|----------------------|-----------|
| Downtown San Diego | Event staffing, bartending, server | Conventions, nightlife, Petco Park events |
| Chula Vista | Moving help, yard work, cleaning | Residential density, family homes |
| North Park / Hillcrest | Cleaning, personal services, tutoring | Urban professionals, recurring needs |
| Mission Valley | Event staffing, general assistance | Convention center, shopping centers |
| La Jolla | Personal services, tutoring | Higher-income clients, premium rates possible |

### San Diego Market Characteristics

**Demand signals (estimated from market research):**
- Event staffing: High volume, weekends, higher pay ($18–$28/hr bartender)
- Moving help: High volume, summer months, medium pay ($17–$22/hr)
- Cleaning: Recurring weekly/biweekly, steady, $16–$22/hr
- Yard work: Seasonal, moderate, $15–$20/hr
- General assistance: Lower volume, variable pay, good for new workers
- Personal services: Barber/beauty rates $20–$35/hr, high skill premium

**Transportation patterns:**
- Car-dependent city overall — transport feasibility is a real constraint
- Some transit access in Downtown, North Park, Hillcrest
- Limited late-night transit — early morning and late night gigs need car/ride-share
- Parking challenges in Downtown — affects commuter cost calculation

**Competitive landscape:**
- Craigslist: Dominates informal local gig postings — no trust system
- TaskRabbit: Expensive for workers, limited San Diego density
- Facebook Groups: Informal, no trust system, no agreement documentation
- Indeed: Primarily W-2 and remote jobs

**Expansion triggers:**
- 20+ active daily gig postings in a category → category is "established" in market
- 50+ completed gigs per month → reputation system has sufficient data
- Employer repeat posting rate > 30% → value proposition proven

---

## 10. TECH STACK RECOMMENDATION

### Principles for Stack Selection

- **Speed to first deploy:** MVP should be buildable in 8–12 weeks with 1–2 engineers + AI assistance
- **Cost at launch:** Minimal infrastructure spend until product-market fit validated
- **Scalability afterward:** Architecture should support growth; stack should not need rewrite at 10x users
- **AI-native:** First-class AI/ML integration from the start
- **San Diego-optimized:** Maps, geocoding, local search are core, not optional

### Recommended Stack

#### Frontend

**Framework:** Next.js 14 (App Router)
- Reason: React ecosystem, excellent for content-heavy + interactive web app, fast deployment via Vercel
- Worker app and Employer portal can share components
- Server-side rendering for SEO (gig discovery pages should be crawlable)

**Styling:** Tailwind CSS
- Reason: Fast development, consistent design system, low maintenance

**Mobile:** Progressive Web App (PWA) first
- Reason: Faster than building native apps for MVP. Add native iOS/Android in v3.
- Service workers for offline capability (worker in-field with poor signal)

**State management:** Zustand (lightweight) or React Query + Context
- Reason: Simple, minimal boilerplate

#### Backend

**Framework:** Node.js + Fastify OR Next.js API Routes (for MVP simplicity)
- Fastify if needing more structure; Next.js API Routes if prioritizing simplicity and shared codebase
- Recommendation: **Next.js API Routes** — single repo, fastest deployment, sufficient for MVP scale

**ORM:** Prisma
- Reason: Type-safe, excellent DX, supports PostgreSQL and MySQL, easy migrations
- Schema-first design fits the structured data model above

**Runtime:** Node.js 20 LTS

#### Database

**Primary: PostgreSQL (via Supabase or Neon)**
- Supabase: Free tier sufficient for MVP, built-in auth, edge functions, excellent for San Diego-based team
- Neon: Serverless PostgreSQL, excellent scaling story, pay-as-you-go
- Recommendation: **Supabase** — auth, database, storage, edge functions in one platform, generous free tier

**Why PostgreSQL over alternatives:**
- Relational data model (workers, gigs, agreements, reviews — all interconnected)
- Full-text search (gig discovery search)
- JSON support for flexible profile fields and AI outputs
- Strong consistency required for financial/reputation data

**Search:**
- PostgreSQL full-text search for MVP (sufficient for San Diego market size)
- Upgrade to Elasticsearch or Typesense when gig volume exceeds 10K active postings

**Analytics / Audit Log:**
- PostgreSQL append-only tables for audit trail
- Simple read replica or direct queries for dashboard analytics

#### AI / LLM

**Primary AI: OpenAI GPT-4o or Claude 3.5 Sonnet**
- Both excellent for generation, explanation, and reasoning tasks
- Recommendation: **Claude 3.5 Sonnet** — superior instruction following for structured explanation generation; better for the "explain WHY" requirement
- OpenAI as fallback for cost optimization in v2

**AI Infrastructure:**
- Build an AI Gateway (simple API wrapper) that routes to OpenAI/Claude
- All AI calls are API calls — no fine-tuning needed at MVP
- Store all AI outputs in database (not recomputed)

**AI Modules — Implementation Approach:**

| Module | Implementation | Notes |
|--------|---------------|-------|
| Matching Agent | Retrieval + ranking (vector similarity for skills + SQL ranking for logistics) | No fine-tuning needed |
| Market Advisor | Aggregated SQL queries on completed gigs table | No LLM needed for stats; LLM for natural language output |
| Safety Agent | Rule-based risk scoring + LLM for red flag analysis on gig descriptions | Start rule-based, add LLM as data grows |
| Career Growth Agent | Gap analysis via SQL + LLM for natural language recommendations | Requires job posting volume first |
| Dispute Evidence Agent | LLM (Claude/GPT) to summarize and organize evidence | Most complex AI module; needs structured prompt engineering |
| Completion Agent | Simple scheduling + notifications (no LLM needed) | Cron jobs + email/SMS APIs |

**Vector storage:** Supabase pgvector extension
- For skill matching (embed skill taxonomy, match worker skills to job requirements)
- Already included in Supabase

#### Authentication

**Platform auth: Supabase Auth**
- Email/password + phone (SMS OTP)
- JWT-based sessions
- Row-level security: Users can only read/write their own data

**Admin auth:**
- Separate admin role in database, separate auth context
- No external dependency

#### Maps / Geocoding

**Maps: Mapbox or Google Maps Platform**
- Mapbox: Better pricing for startups, excellent JS SDK
- Google Maps: More familiar API, slightly more expensive
- Recommendation: **Mapbox** — better developer experience, free tier sufficient for MVP

**Geocoding:** Mapbox Geocoding API
- Convert gig addresses to coordinates
- Calculate service area polygons for worker matching

**Routing:** Mapbox Directions API
- Commute time and cost calculation for Transportation Intelligence

**Map display:** Mapbox GL JS
- Show gig density on a map for employer job posting preview

#### Notifications

**Email:** Resend or SendGrid
- Recommendation: **Resend** — much simpler API, excellent React email components, free tier generous

**SMS:** Twilio
- Industry standard, reliable, good deliverability
- Use for: verification codes, agreement reminders, review prompts

**Push notifications:** Web Push API (PWA) + OneSignal (if native app in v3)

#### File Storage

**Supabase Storage**
- Worker portfolio photos
- Gig photos (before/after completion)
- Dispute evidence
- 100GB free tier on Supabase

#### Payments

**Stripe (already connected)**
- Restricted API key — never full key
- MVP: Infrastructure in place but not processing payments
- v2: Activate Stripe Connect for in-app escrow payments
- Note: Platform fee percentage TBD — not set in MVP

#### Deployment

**Primary: Vercel**
- Zero-config Next.js deployment
- Edge functions for low-latency AI responses
- Generous free tier
- Fast builds

**Database: Supabase**
- Managed PostgreSQL, auth, storage
- Free tier: 500MB database, 1GB storage, 50K monthly users

**Monitoring:**
- Vercel built-in analytics
- Sentry for error tracking (frontend + backend)
- Simple: console.log + Vercel function logs for MVP

#### Cost Estimate (MVP / Month)

| Service | Plan | Est. Cost |
|---------|------|-----------|
| Vercel | Pro | $20/mo |
| Supabase | Pro | $25/mo (when exceeding free tier) |
| Mapbox | Starter | $0–$50/mo (based on API calls) |
| Resend | Free | $0 |
| Twilio | Pay-as-you-go | $5–$20/mo (at San Diego MVP scale) |
| Sentry | Free | $0 |
| **Total** | | **$50–$115/mo** |

At MVP scale (under 1,000 users), infrastructure costs should remain under $100/month.

### What NOT to Use

- **No MongoDB:** Relational data model fits PostgreSQL better; reviews and agreements need strong consistency
- **No custom auth:** Supabase Auth is sufficient and faster to implement
- **No Kubernetes:** Massive over-engineering for MVP; Vercel + Supabase scales without ops overhead
- **No separate ML platform:** All AI is API calls; no model training infrastructure needed at MVP

---

## 11. DEVELOPMENT ROADMAP

### Phase 1: Prototype (Weeks 1–4)

**Goal:** Validate core user flows — worker finds gig, employer posts gig, agreement forms.

**Deliverables:**
- Next.js app with landing page + sign-up / sign-in
- Worker profile creation (core fields)
- Employer gig posting (all 6 categories)
- Basic gig listing page (no AI matching — chronological + basic filter)
- Basic agreement flow (offer → accept → confirmation email)
- Supabase schema deployed

**Complexity:** Medium
**Team:** 1–2 engineers
**Dependencies:** Design system ready, Supabase project configured, Mapbox API keys

**Success metrics:**
- 5 internal users can complete full worker → employer → agreement flow
- No data loss between steps

---

### Phase 2: MVP Launch — San Diego (Weeks 5–12)

**Goal:** Live product with core trust and matching infrastructure.

**Deliverables:**

*Weeks 5–6: Core matching and AI*
- Matching Agent (ranking algorithm + explanations)
- Opportunity Score (5-component)
- Market Advisor (real-time pricing on job creation)
- Safety Agent (risk categorization + red flag detection)
- Transportation Intelligence (Mapbox integration, commute calculator)

*Weeks 7–8: Reviews and reputation*
- Employer → Worker review flow
- Worker → Employer review flow
- Reputation tier calculation + display
- Review integrity rules (dual submission)

*Weeks 9–10: Agreements and completion*
- Full agreement flow with change management (all terms versions stored)
- Check-in / check-out (timestamp + location)
- Completion confirmation (dual confirmation required)
- Cash payment documentation
- Completion Agent (reminders, prompts)

*Weeks 11–12: Dashboard and polish*
- Worker dashboard (applications, active gigs, income tracking)
- Employer dashboard (applicants, active gigs, hires)
- Email + SMS notifications (Resend + Twilio)
- Human Resolution Team briefing + operating procedures
- Security hardening (auth, rate limiting, input validation)
- Bug fixes and QA

**Complexity:** High
**Team:** 2–3 engineers + 1 designer + 1 product (founder)
**Dependencies:** Phase 1 complete, design system delivered, Mapbox and AI APIs configured, Human Resolution Team hired/trained

**Success metrics:**
- 50+ completed gigs on platform
- Worker and employer NPS ≥ 40
- Zero incidents of unauthorized payment release
- Human Resolution Team resolves 100% of disputes within SLA

---

### Phase 3: Market Validation (Months 3–4)

**Goal:** Prove marketplace flywheel — workers return, employers post again, trust system is credible.

**Success criteria:**
- Worker retention: 40%+ return within 30 days
- Employer repeat posting rate: 30%+ post again within 60 days
- 10+ Worker → Employer reviews per category (reputation system credible)
- Average Opportunity Score of hired workers: 70+ (matching is working)
- Zero fraud incidents
- Human Resolution Team avg resolution time: <72 hours

**Key questions to answer:**
- Do workers come back without external prompting?
- Do employers find the matching quality better than Craigslist?
- Is the reputation system affecting worker application behavior?
- Is the Safety Agent catching real red flags?

**Deliverables:**
- Cohort analysis dashboard (worker retention, employer retention)
- Gap Finder (skill gap → job postings connection)
- Team Builder beta (limited to workers with 3+ completed gigs)
- Worked With Before beta
- Coworker reviews (for multi-person gigs — only after enough team gigs exist)

---

### Phase 4: Scaling (Months 5–8)

**Goal:** Prove expansion model and prepare for adjacent markets.

**Expansion criteria (San Diego first):**
- San Diego: 500+ active workers, 100+ monthly gigs, NPS 50+
- Reputation system has enough data to power Team Chemistry Score

**Deliverables:**
- Team Chemistry Score (activate calculation, show to employers)
- Course Finder (curated list, affiliate disclosure)
- Advanced verification (government ID + selfie, background checks)
- Stripe in-app payments (activate)
- Team Builder full launch
- AI Career Coach (push notifications + periodic digest)
- Mobile app research: Begin React Native or Flutter investigation
- Adjacent market research: Los Angeles / Orange County feasibility study

---

## 12. ARCHITECTURE DECISION SUMMARY

### Biggest Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Database | PostgreSQL (Supabase) | Structured data, strong consistency, full-text search, pgvector for skills matching |
| Frontend | Next.js + Tailwind | Fastest dev velocity for full-stack web app, SEO-friendly |
| AI approach | API-first (Claude/GPT) | No fine-tuning needed; explanations are prompting, not training |
| Maps | Mapbox | Better pricing for startup, excellent JS SDK, routing included |
| Auth | Supabase Auth | Built-in, zero custom code, row-level security |
| Deployment | Vercel + Supabase | Zero ops overhead, sufficient scale for MVP through validation |
| AI separation | Modular agents | Each module explainable independently; no single AI making all decisions |

### Biggest Remaining Unknowns

1. **Matching accuracy at launch:** We won't have enough data to validate the matching algorithm until 50+ gigs complete. Initial recommendations will be relatively naive (skills + distance). This is acceptable — matching improves with data.

2. **Coworker review dynamics:** We don't know if workers will actually review each other honestly. Dual-submission rule helps but we need to see the volume of reviews submitted vs. gigs completed.

3. **Employer willingness to be reviewed:** Employers who post only good experiences will love the system. Employers who have disputes may push back. The Human Resolution Team needs to be trained and thick-skinned.

4. **Cash payment tracking accuracy:** If parties don't mark "cash received," we have no verification. Employer payment reputation may be inaccurate in MVP. This improves with trust.

5. **Geographic density:** San Diego's sprawl could make transportation matching too restrictive in suburban areas. May need to tune service area defaults as we learn commute patterns.

6. **Gig volume vs. category balance:** We might get strong adoption in one category (moving help) but weak adoption in another (personal services). This affects how fast reputation systems stabilize per category.

### What Must Be Tested Before Major Investment

1. **Core flow:** Can a worker complete sign-up → apply → get hired → get paid → leave review in under 30 minutes?

2. **Matching quality:** Do workers who apply to AI-recommended gigs have a higher hire rate than workers who apply randomly?

3. **Reputation effect:** Do higher-tier workers get hired at higher rates than lower-tier workers with similar skills?

4. **Employer value:** Do employers who post on the platform return to post again? What is their NPS?

5. **Safety Agent precision:** How many red flags does the Safety Agent catch vs. false positives vs. missed actual threats?

### Recommended Next Steps

**Immediate (Week 1):**
1. Set up Supabase project (database + auth)
2. Deploy Next.js repo skeleton to Vercel
3. Design system kickoff: Get Figma or similar for wireframes
4. Confirm Mapbox API keys
5. Brief Human Resolution Team candidates (must be hired before launch)

**Week 2:**
1. Build database schema (Prisma schema from ERD above)
2. Implement Supabase Auth (email + phone)
3. Worker profile creation form
4. Employer profile creation form

**Week 3–4:**
1. Gig posting flow (all 6 categories)
2. Basic gig listing (no AI yet — chronological + category filter)
3. Agreement/offer flow (offer → accept → confirmation)
4. Prototype demo: Internal test of full worker → employer → agreement flow

**Parallel (Week 2+):**
1. Design system finalized: All component states
2. AI Gateway: Simple API wrapper for Claude/OpenAI
3. Matching Agent v1: Skills + distance ranking (SQL-based, no LLM yet)
4. Market Advisor: SQL aggregation of gig data + LLM for natural language output

---

*System Architecture v1 — Ready for Engineering*