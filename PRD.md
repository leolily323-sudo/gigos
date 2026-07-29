# GigOS — Product Requirements Document
**Version:** 2.0
**Date:** 2026-07-28
**Status:** Aligned — Ready for Architecture
**Phase:** MVP — Local Gig Network

---

## FOUNDER'S NOTE

This document describes a platform built on a specific belief: **people are smarter when they have better information.**

AI is not the boss. AI is not the authority. AI is an advisor, an organizer, and an investigator — a tool that makes hidden patterns visible and complicated processes simpler, while humans remain the ones who decide, agree, negotiate, and resolve.

The platform exists to maximize genuine opportunity, reduce exploitation, and build trust through transparency rather than restriction. Safety matters. Freedom matters more. We protect people without taking their agency.

---

## 1. PRODUCT VISION

**What we're NOT building:**
- Another job board that shows a list and hopes for the best
- A gig aggregator that scrapes postings from other platforms
- A Fiverr or Upwork competitor for remote digital work
- A surveillance system that grades and blocks workers based on scores
- An AI that decides for people

**What we ARE building:**
An AI-powered opportunity marketplace that treats everyday people as full participants in their professional lives — giving them the information, tools, and relationships they need to find work, negotiate fairly, protect themselves, and grow.

**The platform feels like:**
*"A trusted marketplace where AI handles the logistics, the matching, and the paperwork — so people can focus on the work and the relationships that matter."*

**Core philosophy — The Three Principles:**

| Principle | Meaning |
|-----------|---------|
| **Maximize opportunity** | Every design decision asks: does this open doors or close them? |
| **Humans remain in control** | AI advises, organizes, and explains. People decide, agree, and resolve. |
| **Evidence and transparency, not assumptions** | We show our work. We don't secretly gate, block, or manipulate. |

---

## 2. IDENTITY: WHO THIS PLATFORM IS FOR

### Primary: Gig Workers
Everyday people who do local, on-site work — movers, bartenders, cleaners, tutors, handypeople, event staff, delivery couriers, yard workers, personal service providers.

They are not "talent." They are not "providers." They are workers who deserve fair pay, honest employers, and real information.

### Secondary: Employers
Small businesses, event organizers, homeowners, restaurant managers, venue operators — anyone who needs reliable local workers for real-world jobs.

They are not "clients." They are people trying to run their businesses and need help. Good employers deserve to be recognized. Bad ones should be visible.

### The platform exists for both sides equally.
A marketplace that only protects one side collapses. Our job is to make both workers AND employers more successful — which means protecting both from bad actors on the other side.

---

## 3. CORE PRODUCT PHILOSOPHY: AI BEHAVIOR RULES

*These rules apply to every AI feature in the platform. They are not UX guidelines — they are product law.*

### The Golden Rule
**AI increases transparency and safety. AI never becomes an authority that overrides human decisions.**

### AI May:
- Show you information you couldn't easily find yourself
- Warn you about risks, unusual patterns, or potential problems
- Organize evidence, timelines, and relevant data
- Suggest next steps based on evidence and patterns
- Detect inconsistencies or red flags and surface them
- Facilitate communication between parties
- Recommend pricing ranges based on market data
- Help people understand what others in similar situations have done
- Track, aggregate, and display reputation honestly
- Investigate patterns across large datasets that humans can't see

### AI May NOT:
- Automatically block someone from applying to or posting a job based solely on a score
- Declare a gig complete without human confirmation
- Move, hold, release, or refund money independently
- Decide who is right in a dispute
- Set prices or rates — only guide and inform
- Bypass any agreement protections based on trust tier
- Override mutual consent requirements
- Make decisions about platform access without human review (except safety-based hard blocks documented in Decision 2)
- Make assumptions about intent — must always ask for clarification when data is ambiguous

### Every AI Output Must:
- Explain its reasoning in plain language
- Show what data it used
- Acknowledge uncertainty when present
- Make clear that the human is free to disregard the recommendation
- Never obscure that the AI is an AI

### The Test
Before shipping any AI feature, ask:
*"Does this AI make the human more powerful, or does it replace the human's judgment with our judgment?"*

If it replaces judgment, it doesn't ship. If it empowers judgment, it ships with an explanation.

---

## 4. BUSINESS MODEL

### Workers: Freemium
- **Free tier:** Full platform access — profile, job discovery, matching, team formation, reviews, dispute participation
- **Premium tier (future):** Advanced AI tools — Gap Finder deep-dive, AI proposal builder, career coaching, market intel dashboards

**Rationale:** Workers must have full access to the marketplace and all trust/reputation features. Premium AI tools are additive, not gatekeeping.

### Employers: Free to Post, Pay on Results
- **Free tier:** Post jobs, receive applications, manage gigs
- **Premium tier (future):** Subscription for access to verified talent pool, advanced matching, featured postings

**Rationale:** Charge when employers hire successfully, not when they search. This aligns incentives.

### Payment Processing
- Stripe connected via restricted API key (per user context)
- In-app payments supported for employers who want escrow and protection
- Cash agreements can be recorded in-platform for documentation and trust tracking
- Platform never holds money unnecessarily — payments flow directly where possible
- No active payment processing in MVP unless required for escrow feature

### Geographic Launch
- Phase 1: **One focused local market** — selected by data (see Section 10)
- Phase 2: Nearby cities/metropolitan areas
- Phase 3: Regional/national expansion
- Remote opportunities treated as a separate category — can appear nationally in Phase 2+ without geographic matching constraints

---

## 5. TRUST & REPUTATION SYSTEM

### Core Principle: Prestige, Not Punishment

Reputation on this platform is a **prestige system** — it represents trust, reliability, and experience. It does not function as a permission system.

**Everyone can apply to any job regardless of reputation tier.**

The goal is to make high prestige desirable and achievable, not to make low prestige limiting.

### How It Works

**Reputation is composed of:**
- Completed gigs (volume and consistency)
- Employer reviews (rating + written)
- Coworker reviews (rating + written)
- Reliability (show-up rate, on-time rate)
- Professional behavior (flag system for conduct violations)
- Tenure (platform history)

**Reputation tiers (worker):**

| Tier | Name | Visual | How to reach it |
|------|------|--------|-----------------|
| New | New | No badge | Just joined |
| Established | Verified | Bronze badge | 5+ completed gigs, 80%+ completion rate |
| Trusted | Trusted | Silver badge | 15+ gigs, 4.0+ avg rating, 90%+ reliability |
| Highly Trusted | Preferred | Gold badge | 30+ gigs, 4.5+ avg rating, 95%+ reliability |
| Elite | Elite | Platinum badge | 50+ gigs, 4.8+ avg rating, consistent excellence |
| Black | Suspended | Black badge | Verified severe violations only |

**Reputation tiers (employer):**

| Tier | Name | Visual | How to reach it |
|------|------|--------|-----------------|
| New | New | No badge | Just joined |
| Active | Verified | Bronze badge | 3+ completed hires, paid on time |
| Established | Trusted | Silver badge | 10+ hires, 4.0+ avg worker rating |
| Preferred | Preferred | Gold badge | 25+ hires, 4.5+ avg worker rating, low dispute rate |
| Elite | Elite | Platinum badge | 50+ hires, 4.8+ avg, dispute-free for 12+ months |
| Black | Suspended | Black badge | Verified fraud, violence, serious violations |

### What Tiers Unlock (Positive Signals Only)
- Higher-tier workers get priority visibility in "recommended" sections (opt-in)
- Higher-tier employers get "preferred employer" badge that attracts more applicants
- Tier is shown prominently — it's a status signal, not a gate

### What Tiers Do NOT Do
- **Never block** a worker from applying to any job
- **Never block** an employer from posting any job
- **Never override** mutual agreement rules
- **Never determine** completion or payment independently
- **Never grant permission** to bypass any safety or agreement rules

### Hard Blocks (Safety-Based Only)
The only actions that remove platform access without human review are:

| Violation | Action |
|-----------|--------|
| Confirmed identity theft or fraud | Permanent ban |
| Violence or credible threat of violence | Permanent ban |
| Repeated severe misconduct after warnings | Suspended until human review |
| Serious safety violations | Suspended until human review |

Every other action — low ratings, disputes, missed gigs — is surfaced to other users through transparency, not blocked by the platform.

### The Principle Behind This
A worker with a low rating is showing a pattern. An employer deserves to see that pattern. But that worker also needs to earn their way back up, and blocking them from opportunities doesn't help anyone.

Show the data. Let people decide.

---

## 6. DISPUTE RESOLUTION

### Core Principle: AI Gathers. Humans Decide.

Disputes are resolved through a three-tier process designed to be fair, evidence-based, and human-accountable.

### Tier 1: Direct Resolution Encouraged
- Platform prompts both parties to communicate directly
- AI provides a structured summary of the situation to both parties (agreed terms, timeline, evidence submitted)
- Both parties can propose a resolution
- If they agree — platform records the resolution and closes the dispute

### Tier 2: AI Investigation (Evidence Collection)
When direct resolution fails, AI assists human reviewers by:
- Organizing all evidence in a structured format
- Building a timeline from messages, check-in/check-out data, photos, payment records
- Surfacing relevant patterns: Has this employer done this before? Is this a first-time issue or a pattern?
- Highlighting inconsistencies between what was agreed and what happened
- Flagging potential exploitation, misrepresentation, or bad faith

**AI does NOT decide who is right.** It makes sure human reviewers have the complete picture.

### Tier 3: Human Resolution Team
A trained team reviews the compiled evidence and makes a decision.

**Decisions can include:**
- Payment release (full or partial)
- Dispute sustained in favor of worker or employer
- No-action (dispute dismissed — both parties keep their standing)
- Account action if warranted (warning, suspension, removal)

**Appeal process:**
- Either party can appeal within 7 days
- New evidence can be submitted
- Appeal is reviewed by a different human reviewer

### Evidence AI May Collect and Organize:
- Messages exchanged before and during the gig
- Check-in / check-out timestamps
- Location verification (if opted in)
- Photos or videos submitted by either party
- Payment records (in-platform or documented cash)
- Work history (has this pattern occurred before?)
- Previous dispute outcomes for both parties
- Any relevant communications outside the platform (submitted by parties)

### What AI May NOT Do in Disputes:
- Declare a winner
- Order payment released or held without human approval
- Decide that one party is lying
- Impose penalties unilaterally

---

## 7. GIG COMPLETION & PAYMENT SYSTEM

### Core Principle: Work and Money Are Separate Systems. Neither Runs on Trust.

**Completion and payment are always separate, explicit processes. No AI automates either.**

### Gig Completion

**Completion requirements scale with risk and value:**

| Gig Type | Example | Completion Requirements |
|----------|---------|------------------------|
| Low risk | Dog walking, bartending, cleaning | Check-in/check-out, optional photos, mutual confirmation |
| Medium risk | Moving help, tutoring, yard work | Check-in/out, photos, work log, description |
| High risk / high value | Construction, trade work, multi-day events | Milestones, detailed documentation, employer + worker sign-off |

**Completion confirmation requires:**
- All agreed completion criteria met (documented in the agreement)
- Both parties confirm OR deadline passes without objection
- If either party disputes: Tier 2/3 dispute process begins before completion recorded

**AI's role in completion:**
- Send reminders when gig approaches end time
- Prompt both parties to confirm or dispute
- Organize evidence if a dispute is opened
- Track completion rate and flag patterns

**AI's role does NOT include:**
- Automatically marking a gig complete
- Declaring completion criteria met without mutual confirmation

### Payment System

**Payment method is agreed upon BEFORE the gig begins — not during or after.**

**Payment is a mutual agreement. Either party can propose a method. The final method is locked once all parties confirm.**

**Available payment methods:**
- Cash (recorded in platform for trust documentation)
- In-app payment (Stripe-powered)
- Direct bank transfer
- Other agreed electronic methods

**Once the gig begins, no one party can unilaterally change:**
- Payment method
- Payment amount
- Scope of work
- Completion requirements
- Deadline

**All changes require:**
- A change request through the app
- Confirmation from all affected parties
- Full audit trail: original agreement → change requested → by whom → who approved → timestamp

### Rate Guidance (AI-Guided Negotiation)

**No artificial floors or ceilings. The platform does not set prices.**

AI provides market context:
- "Similar gigs in [area] typically pay $X–$Y per hour"
- "Workers with your experience level and ratings in this category charge $X–$Y on average"
- "Jobs at this rate in your area receive [more/fewer] applications than market average"

AI warns about unusual situations:
- To employer: "This offer is more than 30% below the typical range for this category — you may receive fewer quality applications"
- To worker: "This rate is significantly above the typical range — please confirm the scope matches the pay"

Both parties negotiate directly. AI observes and flags manipulation, not dictates terms.

### Cash Payment Documentation

Many workers need same-day cash payment. This is legitimate and must be supported.

Platform tracks:
- Cash payment agreed upon before gig
- Cash confirmed received (both parties can mark confirmed)
- Cash disputed (opens resolution process)

**Why this matters:** Even cash gigs should be on record. It creates trust history. An employer who consistently pays cash promptly builds the same reputation as one paying through the app.

---

## 8. SAFETY SYSTEM: RISK-SCALED VERIFICATION

### Core Principle: Safety Scales with Risk. Not Everyone Needs the Same Verification.

**We don't lock everyone out. We match verification requirements to the actual risk of the gig.**

The goal is to prevent the platform from becoming a scammer's playground while not treating every new user like a criminal.

### Gig Risk Categories

| Risk Level | Example Gigs | Additional Requirements |
|------------|-------------|------------------------|
| Low risk | Barber house calls, birthday bartending, dog walking, cleaning | Standard identity verification only |
| Medium risk | Moving help, event staffing, tutoring, yard work | Standard verification + background check flag if requested by employer |
| High risk | Construction, trade labor, high-value delivery, multi-day events | Stronger proof of identity + optional background check + equipment verification |
| Highest risk | Work involving vulnerable populations, expensive equipment, machinery | Full verification + platform review before posting goes live |

### Identity Verification (Baseline — All Users)
- Phone number verification
- Email verification
- Government ID upload (for future trust features)
- Selfie match to ID (optional for MVP, required for high-risk gigs in v2)

### Background Checks
- Not required by default
- Available as an opt-in signal for employers who want it
- Workers can proactively complete a background check to earn a verification badge
- Background check results belong to the worker — they control who sees them
- Never shown to employers as a red/yellow/green score — shown as "Background check completed [date]"

### Employer Verification
- Phone and email verification (same as workers)
- Business verification (optional —llogo, business license) earns a "Verified Business" badge
- No mandatory business registration for individual employers (homeowners, party hosts)
- Payment method verified before posting goes live

### Safety Red Flags (AI-Detected, Human Reviewed)
AI flags patterns that warrant human review:
- Job posting significantly below market rate with no explanation
- Employer with multiple similar disputes
- Worker with pattern of gig abandonment
- Inconsistencies in job description that suggest deception
- High-risk gig posted by new employer with no platform history

**Flagged content does not auto-remove.** A human reviews and decides.

---

## 9. KEY ARCHITECTURAL PRINCIPLES

### Platform Design Philosophy
The architecture must support three non-negotiable outcomes:

1. **Human control over all material decisions** — no AI decision to block, pay, complete, or ban without human review
2. **Complete transparency** — every score, recommendation, and AI output shows reasoning
3. **Mutual consent as the foundation** — agreements require confirmation; changes require re-confirmation

### Data Model

```
Worker Profile ←→ Gig ←→ Employer Profile
     ↓              ↓            ↓
  Reviews       Agreement     Reviews
     ↓              ↓            ↓
Coworker ←———→  Payments  ←———→ Coworker
Reviews              ↓         Reviews
     ↓         Completion
Team History         ↓
              Dispute (if any)
```

### Profile Architecture
- Worker and employer profiles are structurally parallel (both have reputation, history, reviews)
- Reputation is per-category, not global (a cleaner can be Elite in cleaning but New in moving)
- Profile is portable: every worker has a shareable profile link (`[platform].com/w/[username]`)
- Profile data is owned by the user; platform is the steward

### Agreement Architecture
Every gig has a structured agreement record containing:
- Original terms (posted by employer, accepted by worker)
- Any change requests + approvals
- Completion confirmation status
- Payment status and method
- Dispute status and outcome

**All of this is immutable once created — changes create new versions, never overwrite.**

### AI Layer Principles
- Every AI recommendation includes: what data was used, reasoning, confidence level, what could change the recommendation
- AI models are evaluated for accuracy and bias quarterly
- Human review is embedded in every consequential AI decision (completion, payment, access)

### Technical Constraints
- Stripe: restricted API key — no full key exposure; scoped to payment use cases only
- Google Maps API: routing, distance, commute time for transportation matching
- Email/SMS: notification infrastructure for review prompts, agreement updates, dispute alerts
- File storage: portfolio uploads, certification documents, evidence in disputes

---

## 10. FEATURE REQUIREMENTS

### MVP Feature Prioritization

**Launch-blockers (MUST ship):**
1. Worker Profile
2. Employer Profile
3. Job Posting + Discovery
4. AI Opportunity Score (with explanations)
5. Agreement / Offer / Acceptance flow
6. Basic Coworker Reviews
7. Basic Employer Reviews
8. Team Builder (basic)
9. Dispute Flag + Evidence Collection (Tier 1 + Tier 2 initiation)
10. Freelancer Dashboard

**Important (ship in first 4–6 weeks post-launch):**
11. Gap Finder
12. Transportation Intelligence (commute calculator)
13. Worked With Before (team history + re-invite)
14. AI Proposal Builder
15. Human Resolution Team (operational — not built, but staffed)

**v2 (post-stabilization):**
16. Team Chemistry Score
17. Course Finder
18. AI Career Coach (push notifications + plans)
19. AI Market Intelligence (external data feeds)
20. Advanced verification (document-based, background check integration)

---

### FEATURE 1: AI Freelancer Profile

**Problem solved:** Workers maintain fragmented, platform-locked professional identities. Employers can't verify skills. No unified record of a worker's real history.

**What it is:** A persistent, portable professional identity that lives with the worker, builds automatically from completed work, and represents genuine capability.

**Profile data fields:**

| Field | Type | Notes |
|-------|------|-------|
| Core identity | Name, photo, location | Baseline verification (phone + email) |
| Skills | Tagged list + proficiency (beginner/intermediate/expert) | Self-reported + employer-confirmed (employer can endorse specific skills) |
| Experience | Work history auto-populated from completed gigs | Each entry shows: gig type, employer, date, employer rating |
| Certifications | Name, issuer, expiry, proof | Self-reported; full verification deferred to v2 |
| Portfolio | Up to 10 items (photos, descriptions) | Evidence of completed work |
| References | Name, relationship, verification status | Can be employer or coworker references |
| Languages | Language + proficiency | Self-reported |
| Equipment | Tools/equipment available | Relevant for trade/labor gigs |
| Transportation | Mode(s) + vehicle details | Car, motorcycle, bicycle, public, rideshare, walking |
| Service area | Neighborhood or radius from home | Updated dynamically via GPS opt-in |
| Availability | Weekly schedule template | Recurring + one-off blocks |
| Preferred work | Job categories, shift preferences | Behavior-influenced + explicit |
| Desired income | Hourly target + minimum acceptable | Private to platform only |
| Reputation tier | Current tier + visual badge | Shown to others |

**How it improves automatically:**
- Completed gigs auto-populate experience
- Employer skill endorsements accumulate
- Coworker review data fills in soft-skills profile
- Gap Finder tracks skill acquisitions
- Profile completion score shows what's missing

**AI Enhancement:**
- Suggest missing skills based on job history
- Flag contradictions: "Your profile says 'expert in X' but you've never worked a job requiring X"
- Recommend profile sections to complete based on jobs the worker is targeting
- Detect skill drift: "You've done 8 cleaning gigs but your profile says you're a mover — update it?"

**Sharing:** Every profile has a public URL (`/w/[username]`) shareable anywhere. Shows: name, photo, tier badge, top skills, verified endorsements, and recent employer ratings. Does NOT show: desired income, private notes, internal IDs.

---

### FEATURE 2: Employer Profile

**Problem solved:** Workers have no way to research employers before accepting work. Bad employers drive away good workers. Good employers have no way to stand out.

**What it is:** An employer profile that shows their history, payment record, and reputation — so workers can make informed decisions.

**Profile data fields:**

| Field | Type | Notes |
|-------|------|-------|
| Core identity | Name/business name, photo or logo, location | Verified phone + email |
| Business type | Individual, small business, company | Self-reported |
| Verification | "Verified Business" badge if documentation provided | Optional |
| Jobs posted | History of all postings + outcomes | Completion rate, abandonment rate |
| Hire rate | % of postings that result in hired worker |
| Payment record | % of gigs paid on time, average payment speed | Private metrics visible to workers before applying |
| Worker ratings received | Average + written reviews | From worker reviews |
| Dispute history | Number of disputes filed, outcomes | Only shows resolved disputes |
| Repeat workers | % of gigs where same worker was re-hired |
| Reputation tier | Current tier + visual badge |

**What workers see before applying:**
- Employer tier badge
- Average worker rating
- Payment speed ("Pays within 24 hours: 89% of gigs")
- Total hires completed
- Repeat worker rate ("48% of their workers have worked for them more than once")

**Employer controls:** Can respond publicly to reviews. Cannot hide or remove reviews. Cannot see who left a negative review.

---

### FEATURE 3: AI Gig Discovery

**Problem solved:** Workers scroll through every job on the platform, not just the ones that make sense. They waste time on jobs they can't reach, aren't qualified for, or areposted by employers with poor records.

**What it is:** An intelligent job feed ranked for each worker with explicit explanations.

**Ranking factors (weighted):**

| Factor | Weight | Source |
|--------|--------|--------|
| Skill match | High | Profile skills vs. job requirements |
| Experience | Medium | Profile history vs. job requirements |
| Distance / commute | High | Job location + worker service area + transport mode |
| Transport feasibility | High | Does worker have the required mode? |
| Schedule compatibility | High | Availability vs. gig timing |
| Equipment readiness | Medium | Profile equipment list vs. requirements |
| Employer quality | High | Payment history, rating, dispute rate |
| Estimated fit score | High | Composite of above |

**Every job card in the feed shows:**
- Job title, company/location, pay, start time
- "Why we recommended this:" [one-line specific reason]
- Match breakdown: "4/5 skills match, 12 min commute, 4.7★ employer, pays $X–$Y range"
- Opportunity Score components (see Feature 4)
- Red flags if detected: "This employer has 2 unresolved disputes" or "This rate is 40% below market for this category"

**Transportation warnings (per job):**
- Commute time and cost (by worker's declared transport mode)
- Route reliability: "Typically 85% reliable, expect ~10 min delay on weekdays"
- Early-morning flag: "No public transit runs before 6 AM on Sundays"
- Weather note: "Rain adds ~20 min to this commute on average"

**Job posting fields:**

| Field | Required | Notes |
|-------|----------|-------|
| Title | Yes | Plain language |
| Category | Yes | Predefined list (see Section 10 for launch categories) |
| Description | Yes | Rich text — AI analyzes for red flags |
| Location | Yes | Address (shown to matched workers; general area shown in feed) |
| Start datetime | Yes | |
| End datetime / duration | Yes | |
| Pay rate | Yes | AI shows market range immediately upon entry |
| Pay type | Yes | Hourly / flat / tip share / cash |
| Payment method | Yes | Must be agreed before worker accepts |
| Transportation requirements | Yes | Required mode, parking situation |
| Equipment requirements | Yes | List |
| Skills required | Yes | Tagged |
| Experience level | No | Beginner / intermediate / expert |
| Team size needed | No | For crew/team gigs |
| Risk category | Platform-assigned | Based on AI analysis of description, pay, requirements |

**AI red flag detection (on job posting):**
- Pay significantly below market with no explanation → flag for review
- Requirements that contradict each other → warning to employer
- Vague description with high pay → elevated review before going live
- First-time employer with no history posting high-risk gig → additional scrutiny

---

### FEATURE 4: Opportunity Score

**Problem solved:** Workers can't quickly assess whether a job is worth pursuing. They apply blind and waste time on poor matches.

**What it is:** A transparent composite score showing how well a specific job fits a specific worker — broken into explainable components.

**Components:**

| Component | What it measures |
|-----------|-----------------|
| **Qualification** | How many required skills the worker has (not a gate — shown alongside gaps) |
| **Logistics** | Commute time, cost, transport feasibility |
| **Earnings** | Rate vs. market range for this category and this worker's experience level |
| **Trust** | Employer reputation — payment history, worker ratings, dispute rate |
| **Growth** | Does this gig offer skill development or recurring work potential? |

**Display format:**
```
Opportunity Score: 84/100
Qualification: 9/10  — You meet 4/5 required skills
Logistics: 8/10      — 12 min by car, ~$4.50 fuel cost
Earnings: 7/10       — $18/hr is below market for your experience level ($20–$25)
Trust: 10/10        — Employer has 4.7★ avg, pays in <24hr, 0 disputes
Growth: 6/10        — Standard gig, some chance of recurring work

⚠️ Note: Earnings run is below your stated minimum.
  AI recommends negotiating to $20/hr before accepting.
```

**Key principle:** The score is information, not a filter. Workers can apply to any job regardless of score.

---

### FEATURE 5: Agreement / Offer / Acceptance Flow

**Problem solved:** Gig agreements happen in texts, phone calls, or vague platform posts. Nobody knows what was actually agreed to until something goes wrong.

**What it is:** A structured, mutual agreement system where every term is explicit, recorded, and requires confirmation from all parties.

**Flow:**

1. **Employer posts job** → terms are explicit: pay, method, time, location, requirements
2. **Worker applies** → can include a message and/or proposed terms
3. **Offer extended** → employer sends formal offer to selected worker(s)
4. **Worker accepts** → agreement is locked; both parties receive confirmation
5. **Pre-gig confirmation** → 24 hours before, both parties confirm they're still on
6. **Gig occurs**
7. **Post-gig completion** → both parties confirm OR dispute opens
8. **Payment** → executes per agreement terms

**Change management:**
- Any party can request a change before the gig starts
- Change requires re-confirmation from all affected parties
- Original agreement is preserved; change creates a new version with full audit trail
- During the gig: scope changes require immediate re-confirmation before extra work begins

**What happens if parties disagree before the gig?**
- Either party can decline the offer before accepting
- After acceptance: either party can cancel, but cancellation is recorded on both profiles
- Pattern of cancellations affects reputation

**Cash payment recording:**
- Employer selects "Cash" as payment method
- Worker confirms acceptance of cash
- After gig: worker marks "Cash received" or "Cash not received"
- If disputed: opens resolution process; employer reputation is affected

---

### FEATURE 6: Coworker Reviews

**Problem solved:** Workers are reviewed by employers everywhere. Nobody ever reviews the peers they worked beside. This hides the soft skills — teamwork, communication, reliability — that matter most on team gigs.

**What it is:** A peer review system that activates after every multi-person gig.

**Trigger:** Gig ends → review prompt sent to all workers on the gig

**Review questions:**

| Question | Type | Purpose |
|----------|------|---------|
| Would you work with this person again? | Yes / No + comment | Quick signal |
| Communication | 1–5 stars | Did they share information clearly? |
| Reliability | 1–5 stars | Did they show up, on time? |
| Professionalism | 1–5 stars | Respect, attitude, hygiene |
| Teamwork | 1–5 stars | Collaboration, ego, support |
| Leadership (if applicable) | 1–5 stars | Did they step up when needed? |
| Problem solving | 1–5 stars | Did they fix things without being asked? |
| What did they do well? | Free text | Constructive |
| What could they improve? | Free text | Constructive |

**Integrity rules:**
- Both parties must submit before either is published (prevents retaliation editing)
- If one party doesn't respond in 7 days, their response is held another 7 days — then published without the counterpart (marked "Review pending from counterpart")
- Reviews cannot be edited after submission
- Reviews are tied to the specific gig category — a bad review from a moving gig doesn't hurt a tutoring profile
- Statistical anomaly detection flags inflated review patterns

**Redemption:**
- Scores improve through subsequent positive gigs
- Trajectory shown: "Communication score improved: 3 of last 4 gigs rated 5★"
- Bad scores are never hidden — context and trend are shown instead

---

### FEATURE 7: Employer Reviews (Worker → Employer)

**Problem solved:** Employers rate workers everywhere. Workers have no systematic way to evaluate employers before accepting work, and no record of payment problems, bait-and-switch, or exploitation.

**What it is:** A reputation system that lets workers review employers with the same seriousness employers bring to reviewing workers.

**Review questions:**

| Question | Type | Purpose |
|----------|------|---------|
| Were you paid on time? | Yes / No + comment | Core protection signal |
| Was the pay amount accurate? | Yes / No + comment | No bait-and-switch |
| Was the scope clearly defined beforehand? | 1–5 stars | Pre-gig clarity |
| Communication quality | 1–5 stars | Employer responsiveness |
| Professionalism | 1–5 stars | Respect, fairness |
| Would you work for this employer again? | Yes / No + comment | Rehire signal |

**Display:** Employer score shown with individual reviews, gig type, date. Written reviews shown in full — not summarized.

**Worker protections:**
- Employer cannot see who left a negative review (prevents retaliation)
- Employer sees only aggregate score, not individual reviewer identities for negative reviews
- Reviews are per-category (a bad review in moving doesn't affect the employer's tutoring reputation)
- Flag system for serious issues: non-payment, harassment, bait-and-switch, no-show

**Flag → Human Review escalation:**
- 1 flag: Review triggered; employer notified of pattern
- 2 flags: Employer posting suspended pending review
- 3 flags: Employer removed from platform

---

### FEATURE 8: Team Builder

**Problem solved:** Employers need multiple workers for one gig but have no reliable way to assemble a qualified team. Workers who know each other have no easy way to propose themselves as a crew.

**What it is:** An AI-assisted team assembly system that respects relationships, trust history, and logistics.

**When it activates:**
- Employer posts a gig requiring N workers
- Worker applies and says "I can bring a team"
- AI scans for compatible teammates

**Teammate selection criteria (weighted):**

| Criterion | Weight | Source |
|-----------|--------|--------|
| Skill match | High | Profile |
| Distance / location | High | Service area |
| Availability | High | Schedule |
| Transport feasibility | High | Transportation profile |
| Previous collaboration | High | Worked With Before |
| Team Chemistry Score | Medium | Historical performance (when available) |
| Equipment compatibility | Medium | Profile |
| Schedule conflict | Low | Warn, don't block |

**Invitation flow:**
1. Employer posts team gig (N workers needed)
2. Worker applies with "Form team" option
3. AI recommends teammates with reasoning — "Great for this gig: [Name] — worked together 3 times, 4.8 avg rating, lives 8 min away"
4. Worker reviews, selects, edits message
5. AI generates personalized invite for each teammate
6. Teammates accept/decline
7. Confirmed team submitted to employer

**Team Recall (integrated):**
- Prioritize teammates who have worked with the requestor before
- Show inactive teammates: "Last worked with you 7 months ago — may be available"
- Never re-suggest archived teammates (explicitly removed by worker)

---

### FEATURE 9: Gap Finder

**Problem solved:** Workers don't know what specific skills would unlock meaningfully better opportunities. Generic career advice is useless. Learning the wrong thing wastes time and money.

**What it is:** A targeted skill-gap analysis that connects specific skills to real job postings, real earning potential, and real learning paths.

**How it works:**

1. Worker selects target: job category or income goal (e.g., "I want to do construction gigs paying $25+/hr")
2. AI identifies the gap: what skills appear on those job postings that the worker doesn't have
3. For each missing skill:
   - **Time to learn:** Estimated range (not false precision — "1–2 weeks", "1–3 months")
   - **Cost:** Free / under $50 / $50–$500 / $500+
   - **Difficulty:** Easy / Medium / Hard
   - **Expected uplift:** "Unlocks construction gigs in your area — typically pay $22–$28/hr"
4. AI recommends shortest high-value path first
5. Connects to 3–5 real job postings that would become accessible

**Gap Finder display:**
```
🎯 Your target: Construction gigs, $25+/hr
You're missing:
1. [Basic carpentry hand tools proficiency] — Easy, ~1–2 weeks, free (YouTube + practice)
   Required on 60% of construction postings in your area
   Unlocks: 12 current postings near you

2. [OSHA 10 construction safety cert] — Medium, ~1 week, ~$100
   Required on 40% of construction postings in your area
   Unlocks: 8 current postings — avg pay $27/hr

Gap Finder can show you courses for [2] if you want structured learning.
```

**AI behavior rules (Gap Finder):**
- Never fabricate timelines or earnings — always say "estimated," "typically," "based on market data"
- Never recommend skills with no connection to actual job postings
- If the target is unrealistic, say so: "To earn $100/hr as a new freelancer in this market isn't realistic. Here's what is realistic:"
- Respect stated preferences — don't recommend driving jobs to someone who said no driving
- Always show why the skill matters with real data, not generic career advice

---

### FEATURE 10: Transportation Intelligence

**Problem solved:** Workers apply to jobs they can't realistically get to. Employers lose workers to commute problems they didn't see coming.

**What it is:** A logistics engine that treats transportation as a first-class matching input — not a filter applied after the fact.

**Worker data captured:**
- Primary transportation modes (car, motorcycle, bicycle, public transit, rideshare, walking)
- Vehicle details (relevant for hauling, delivery)
- Licensed/insured status (self-reported, with verification path)
- Service area (neighborhood list or radius from home)
- Availability windows by time

**Per-job transportation requirements:**
- Required transport mode
- Parking (provided / not provided / cost)
- Load/unload demands (physical)
- Schedule start time logistics

**Matching rules:**
- Never match a worker to a job their declared transport mode cannot reach
- Never recommend a bicycle worker for a job requiring a car
- Always show commute cost and time for recommended matches
- Flag: "No public transit before 6 AM on weekends — this 5 AM job may not be feasible by transit"

**Commute calculator (shown on every recommended job):**
- Travel time (by worker's declared mode)
- Cost (fuel, transit fare, parking)
- Route reliability: "This route is typically on-time 88% of the time — average delay 7 minutes"
- Parking cost and availability

**Weather flag (MVP: static; v2: live weather API):**
- "Heavy rain adds ~25 min to this commute on average"
- "This outdoor gig on Saturday has a 30% chance of rain — consider indoor backup"

---

### FEATURE 11: Worked With Before

**Problem solved:** Workers build real relationships over time — people they've worked well with, people they'd avoid, people they'd want on a team again. This history disappears on every new platform.

**What it is:** A private, persistent team relationship manager.

**What it tracks (per coworker):**
- Who you worked with (per gig)
- When and what kind of gig
- Your rating of them (from coworker reviews)
- Their rating of you (from coworker reviews)
- Private notes ("Great on moving gigs, terrible with early mornings")
- Archived status (removed from suggestions, not deleted)

**Worker actions:**
- **Browse history** — searchable, filterable list of all coworkers
- **Re-invite** — "Invite to team for this gig" (with pre-written message they can edit)
- **Archive** — Remove from suggestions without losing history
- **Tag** — Private labels: "Best for moving," "Excellent communicator," "Avoid for catering"
- **Reconnect prompt** (v2): "You haven't worked with [Name] in 8 months. They're active in your area."

**Privacy:** Team history is 100% private. No other user can see your history. Employers see only aggregate team chemistry scores, not individual relationship data.

---

### FEATURE 12: Freelancer Dashboard

**Problem solved:** Workers manage their freelance life across texts, email, spreadsheets, and memory. There's no single place that shows them their professional status, active work, income, and growth opportunities.

**What it is:** A unified command center for the worker's freelance operation.

**Dashboard sections:**

| Section | Content |
|---------|---------|
| **Active gigs** | Current gigs: date, employer, pay, status, location, commute |
| **Applications** | Pending: job, status (viewed?, responded?), your proposed terms |
| **This week's schedule** | Confirmed gigs + open availability blocks |
| **Income** | This week/month/year vs. target; trend by category; effective hourly rate |
| **Reputation tier** | Current tier, badge, component scores, trend |
| **Skills** | Current skills vs. Gap Finder targets |
| **Team invitations** | Pending teammate requests |
| **Learning** | Courses in progress, completed, recommended next |
| **Employer reviews** | Recent reviews + written responses |
| **Career Coach** | AI recommendations: skills to add, rate adjustments, seasonal strategies |
| **Network** | Teammates worked with, team chemistry, re-invite shortcuts |

**Income tracking (MVP):**
- Manual entry for gigs outside platform
- Auto-import for platform gigs
- Shows: by week, month, year; by job category; effective hourly rate

---

### FEATURE 13: Dispute Flag + Evidence Collection (Tier 2)

**Problem solved:** When something goes wrong, workers and employers have no structured way to document what happened, present evidence, or get a fair resolution. Disputes become messy "he said/she said" situations.

**What it is:** A structured dispute initiation and evidence gathering system — the AI investigative layer before a human reviewer looks at the case.

**Filing a dispute:**
- Either party can file within 14 days of gig completion
- File: select reason, describe what happened, submit supporting evidence
- AI automatically collects: messages, timestamps, check-in/out data, payment records, photos
- Both parties see each other's submissions
- Either party can propose a resolution
- If they agree: resolved. If not: escalated to Human Resolution Team.

**Evidence AI collects and organizes:**
- Gig agreement terms (original + any change versions)
- Messages between parties
- Check-in / check-out timestamps
- Location data (if opted in)
- Photos/videos submitted
- Payment records (in-platform or documented cash)
- Worker's reputation history with employer
- Employer's reputation history with workers
- Patterns: has this issue occurred before with either party?

**AI does NOT:**
- Decide who is right
- Recommend a resolution
- Impose any outcome

**Human Resolution Team reviews compiled evidence and decides.**

---

## 11. INITIAL JOB CATEGORIES (MVP Launch)

Launch with categories that are:
- High demand
- Fast turnaround (same day / same week payment)
- Low barrier to entry
- Quick reputation building
- Lower initial safety complexity

**Approved for MVP launch:**
1. **Event staffing** — bartenders, servers, setup/cleanup crew
2. **Cleaning and home services** — house cleaning, deep cleaning, move-in/move-out
3. **Yard work** — lawn mowing, leaf cleanup, basic landscaping
4. **Moving help** — furniture moving, hauling, heavy lifting
5. **General assistance** — running errands, shopping, simple assembly
6. **Personal services** — barbers (house calls), beauty services, tutoring

**Deferred to v2 (after trust system is proven):**
- Construction and trade labor
- Specialized professional services
- High-value delivery
- Healthcare adjacent services

---

## 12. GEOGRAPHIC LAUNCH STRATEGY

### Phase 1: Single Focused Market
Launch in **one medium-density metropolitan area** selected by evidence:

**Selection criteria (data-driven):**
- Gig demand volume (active job postings on competing platforms)
- Worker supply potential (population density, labor force participation)
- Employer activity (business density, SMB presence)
- Competition intensity (Upwork/Fiverr dominance in local vs. remote)
- Average gig value (pay rates for target categories)
- Repeat usage potential (recurring needs — events, recurring cleaning)
- User acquisition cost (organic reach potential)
- Safety and regulatory environment
- Personal founder knowledge (bonus — not a substitute for data)

### Phase 2: Adjacent Expansion
Expand to nearby cities / metropolitan areas once:
- Phase 1 market reaches density targets
- Platform processes are proven
- Team is operational

### Phase 3: Regional / National
Broader expansion with established playbook.

**Remote gigs (separate track):**
- Not geography-constrained — can expand nationally in Phase 2
- Matching based on skills, availability, time zones — not location

---

## 13. SUCCESS METRICS

### Worker-Side
| Metric | What it measures |
|--------|-----------------|
| Profile completion rate | Adoption of core tool |
| Application → hire rate | Opportunity matching quality |
| Win rate by Opportunity Score tier | Does higher score predict success? |
| Gig completion rate | Platform reliability |
| Coworker review response rate | Engagement with trust system |
| Income growth (month/month) | Platform actual value |
| Tier progression rate | Path to higher prestige |
| Gap Finder: skills acquired within 90 days | AI career tool value |

### Employer-Side
| Metric | What it measures |
|--------|-----------------|
| Jobs posted | Supply generation |
| Time to fill | Matching efficiency |
| Worker no-show rate | Worker reliability signal |
| Repeat posting rate | Employer satisfaction |
| Net hire satisfaction score | Outcome quality |

### Platform-Side
| Metric | What it measures |
|--------|-----------------|
| Worker retention (return within 30 days) | Core value |
| Employer retention (post again within 60 days) | Core value |
| Dispute resolution satisfaction | Fairness perception |
| AI recommendation engagement rate | Do users trust explanations? |
| Trust tier vs. actual behavior correlation | Is the prestige system accurate? |
| NPS (worker + employer) | Overall satisfaction |

---

## 14. RISK REGISTER

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Platform used primarily for scams or exploitation | Medium | Risk-scaled verification; AI red flag detection; Human Resolution Team |
| Employers boycott because workers can review them | Medium | Build employer value first; proven workers first; show benefits of good reputation |
| Coworker reviews inflated (everyone gives 5★) | High | Dual-submission rule; anomaly detection; pattern analysis across large data |
| Dispute process too slow to be useful | High | SLA targets for Human Resolution Team; clear timelines communicated |
| Workers avoid high-prestige gigs because they're afraid of rating risk | Medium | Show score trajectory; emphasize improvement, not perfection |
| AI Opportunity Score is wrong too often and erodes trust | Medium | Start conservative; always show reasoning; easy feedback mechanism |
| Chicken-and-egg: not enough workers for employers | High | Pre-launch worker acquisition; Gap Finder + Profile as standalone value before marketplace |

---

## 15. OPEN QUESTIONS — NOW CLOSED

| Previous Question | Resolution |
|-------------------|-----------|
| Employer vetting at launch | Open marketplace with risk-scaled verification (Decision 1) |
| Reputation gates job access | No gates — prestige system (Decision 2) |
| Dispute resolution | Three-tier: direct → AI evidence → Human Resolution Team (Decision 3) |
| Gig completion confirmation | Separate from payment; mutual confirmation required; scales with risk (Decision 4) |
| Rate floors/ceilings | No artificial limits; AI guides with market data (Decision 5) |
| Geographic scope | Single focused market (Decision 6) |
| Initial job categories | Everyday-accessible categories only (Decision 7) |

---

## 16. DEPENDENCIES

### Technical
- **Google Maps API** — routing, distance, commute calculations
- **Stripe** — restricted API key; payment infrastructure ready but not actively processing in MVP unless escrow is shipped
- **Email/SMS delivery** — review prompts, agreement updates, dispute notifications
- **File storage** — portfolio uploads, certification documents, dispute evidence

### Organizational
- **Human Resolution Team** — must be staffed before launch; operates concurrently with product
- **Category expertise** — need someone who understands local gig market dynamics per launch city
- **Legal review** — dispute process, payment recording, liability coverage for cash gigs

---

*GigOS PRD v2.0 — Core principles locked. Architecture phase next.*