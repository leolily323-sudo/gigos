# GigOS — Architecture & Wireframes Review Package

## What Was Built

Three documents + one interactive prototype covering the complete MVP design:

### 1. System Architecture v1 (73KB)
Complete technical specification covering:
- Platform overview and lifecycle (Signup → Profile → Discovery → Agreement → Completion → Review → Reputation)
- User roles and permissions (Worker, Employer, Human Resolution Team, Platform Admin)
- Full database schema (users, gigs, applications, agreements, reviews, disputes, team history)
- Five AI modules: Matching Agent, Market Advisor, Safety Agent, Career Growth Agent, Dispute Evidence Agent
- UX flows for all three user types (worker, employer, dispute)
- MVP scope (v1 vs v2 vs future)
- Payment architecture (work/money separate)
- Trust, safety, and security model
- Tech stack recommendations (Next.js + Supabase + Mapbox + Claude 3.5)
- Development roadmap (Phase 1: weeks 1–4 prototype, Phase 2: weeks 5–12 MVP launch)

### 2. Interactive Wireframes (148KB HTML)
28 screens covering the complete user experience:

**Worker Flow:**
1. Welcome / Landing
2. Sign Up (email + phone verification)
3. Profile Setup (skills, transport, service area)
4. Gig Discovery Feed (AI-ranked with explanations)
5. Gig Detail + AI Explanation (full breakdown)
6. Apply Confirmation
7. Agreement Review (mutual consent)
8. Worker Dashboard
9. Check In/Out
10. Leave Review (employer review)
11. Employer Profile (transparency)
12. Flag Dispute

**Employer Flow:**
13. Employer Dashboard
14. Post a Gig (multi-step with AI pricing)
15. Review Applicants
16. Send Offer

**Design System:**
17. Colors (brand green + navy + risk colors)
18. Components (buttons, cards, forms, badges)
19. AI Explanation Patterns (4 recurring patterns)
20. Reputation Tiers (with definitions)

### 3. Design System v1 (15KB)
Complete design specification:
- Color system with hex codes and usage rules
- Typography (Inter, type scale)
- Spacing and layout system
- All component specifications
- Navigation patterns
- Animation guidelines
- Accessibility requirements
- Sample data sets (San Diego-specific)

---

## Key Design Decisions to Review

### A. The AI Explanation Box Pattern
Every AI output uses a consistent green box with lightbulb icon and bullet points. This is the signature pattern of GigOS — it makes transparency a visual identity, not just a policy.

**Review question:** Does this pattern feel right? Is it too verbose? Does it build trust or slow down the experience?

### B. Opportunity Score Display
Circular ring with 87 score + five sub-scores (Qualification, Logistics, Earnings, Trust, Growth). Shown prominently on every gig card and gig detail.

**Review question:** Is the 0–100 score meaningful or misleading? Should we show sub-scores more prominently? Is the ring the right visual?

### C. Reputation as Prestige Badges
Bronze/Silver/Gold/Platinum/Black badges. Shown on every worker card and employer profile. "Verified" is bronze, not gray — we want people to aspire to it.

**Review question:** Are these badges the right metaphor? Should we use something less game-like? Is Black the right name for suspended accounts?

### D. Risk Category Badges
Low Risk (green), Medium Risk (amber), High Risk (red) shown on every gig. Calculated by AI based on gig description, pay, equipment, category history.

**Review question:** Is showing risk to workers patronizing or protective? Should high-risk gigs be hidden from new workers, or shown with prominent warnings?

### E. Green Explanation Box vs. Amber Warning Box
Green = AI recommendation explanation. Amber = AI suggestion (advisory). Navy = Market data context.

**Review question:** Is the three-color system clear enough? Could it confuse users who associate any colored box with "warning"?

### F. Mutual Consent Flow
Every agreement requires explicit accept/decline. Payment method is locked in the agreement. Changes require re-confirmation.

**Review question:** Is the flow too formal for casual gig work? Could it slow down hiring? Does the "mutual consent" messaging feel empowering or bureaucratic?

### G. Navigation Architecture
Worker app: bottom nav (5 items). Employer portal: left sidebar. Mobile-first throughout.

**Review question:** Is the employer sidebar appropriate for occasional vs. power users? Should we consider a simpler employer experience?

---

## San Diego Specificity

Every wireframe uses real San Diego data:
- Neighborhood names: Downtown, Chula Vista, National City, North Park, Mission Valley
- Commute times: "8 min from Chula Vista"
- Market rates: "$16–$24/hr for bartending in San Diego"
- Transit notes: "No public transit before 6 AM on weekends"

**Review question:** Is the localization convincing enough? Should we show specific employers/gig names that feel even more real?

---

## What's Ready for Engineering

The wireframes are fully interactive HTML with:
- Working navigation between screens
- Realistic sample data throughout
- All states shown (hover, active, empty, featured)
- Responsive layout (works on desktop and mobile)

Engineering can begin from these wireframes directly. No additional design translation needed.

---

## Open Items Before Engineering Kickoff

1. **Database schema:** ✅ DONE — `schema.sql` written from scratch, 18 tables, full PostgreSQL with enums, indexes, RLS policy notes, and San Diego seed data.
2. **Review sign-off** on the 7 design decision questions above
3. **Confirm scope:** Are all 28 screens in scope for v1, or should some be deferred?
4. **AI module scoping:** Matching Agent, Market Advisor, Safety Agent — are these all v1 features or should some be v2?
5. **Human Resolution Team:** This is a team, not software. Has this been staffed/planned?

---

## Engineering Status

| Component | Status |
|----------|--------|
| PRD v2 | ✅ Complete |
| System Architecture | ✅ Complete |
| Wireframes (28 screens) | ✅ Complete |
| Design System | ✅ Complete |
| **PostgreSQL Schema** | ✅ **Complete — schema.sql** |
| API Spec | ⬜ Pending |
| Database Migrations | ⬜ Pending |
| Engineering Kickoff | ⬜ Pending design sign-off |

---

## Files

| File | Purpose |
|------|---------|
| `PRD.md` | Product Requirements Document v2 |
| `system-architecture-v1.md` | Technical architecture specification |
| `wireframes.html` | Interactive HTML wireframes (open in browser) |
| `design-system.md` | Design system documentation |
| `REVIEW-SUMMARY.md` | This document |