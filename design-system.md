# GigOS Design System — MVP Specification
**Version:** 1.0
**Date:** 2026-07-29
**Based on:** PRD v2 + System Architecture v1
**Pilot Market:** San Diego County

---

## 1. DESIGN PHILOSOPHY

### The Platform's Character

GigOS should feel like a **trusted marketplace mediator** — not a corporate HR tool, not a sketchy gig app, not a cold job board.

The design language says:
- **We take work seriously.** This is people's livelihood.
- **We're transparent about how we work.** The AI explains itself.
- **We're on the worker's side.** But we respect employers too.
- **We're local and human.** San Diego, not Silicon Valley.

### Core Design Principles

| Principle | What it means in practice |
|-----------|---------------------------|
| **Transparency by default** | Every AI recommendation has a green explanation box. No black boxes. |
| **Trust signals everywhere** | Reputation badges, employer ratings, payment history — all visible before applying. |
| **Respect the worker** | No dark patterns. No countdown timers. No fake urgency. Worker decides. |
| **Mobile-first, local context** | San Diego neighborhoods, commute times, transit info — all geospatially relevant. |
| **Safety without restriction** | Risk categories and verification requirements scale with actual risk. |

---

## 2. COLOR SYSTEM

### Brand Green — Trust & Growth
Used for: Primary CTAs, success states, trust indicators, AI explanation boxes, match confirmations.

```
Brand 50:  #f0fdf4  (lightest — backgrounds)
Brand 100: #dcfce7  (explanation box backgrounds)
Brand 200: #bbf7d0  (borders)
Brand 300: #86efac  (icons, highlights)
Brand 400: #4ade80  (accents)
Brand 500: #22c55e  (PRIMARY — buttons, badges)
Brand 600: #16a34a  (hover states)
Brand 700: #15803d  (pressed states)
Brand 800: #166534  (dark text on light)
Brand 900: #14532d  (darkest)
```

### Navy — Professional & Stable
Used for: Navigation, headers, employer dashboard, primary text, contrast elements.

```
Navy 50:  #f0f4f8  (lightest backgrounds)
Navy 100: #d9e2ec
Navy 200: #bcccdc
Navy 300: #9fb3c8
Navy 400: #829ab1
Navy 500: #627d98
Navy 600: #486581
Navy 700: #334e68
Navy 800: #1e3a5f  (PRIMARY — dark backgrounds)
Navy 900: #0f2744  (darkest)
```

### Semantic Colors

| Purpose | Color | Usage |
|---------|-------|-------|
| Success | Brand 500 | Confirmations, matches, positive signals |
| Warning | Amber 500 | Cautions, below-market rates, attention needed |
| Error/High Risk | Red 500 | High-risk gigs, disputes, serious flags |
| Info | Navy 500 | Neutral information, employer stats |
| Risk: Low | Green 100 bg / Green 800 text | Low-risk gig badge |
| Risk: Medium | Amber 100 bg / Amber 800 text | Medium-risk gig badge |
| Risk: High | Red 100 bg / Red 800 text | High-risk gig badge |

### What NOT to Use
- Pure black (#000) for text — use Navy 900
- Pure white (#fff) for backgrounds — use Slate 50 or Navy 50
- Red for anything except serious warnings or high-risk indicators
- Gradient backgrounds on cards (stick to solid tints)

---

## 3. TYPOGRAPHY

### Font Family
**Inter** (Google Fonts) — chosen for: excellent readability on mobile, wide language support, clean and professional without being cold.

### Type Scale

| Element | Size | Weight | Line Height |
|---------|------|--------|-------------|
| H1 (Page titles) | 24px / 1.5rem | 700 (Bold) | 1.2 |
| H2 (Section headers) | 18px / 1.125rem | 600 (Semibold) | 1.3 |
| H3 (Card titles) | 16px / 1rem | 600 (Semibold) | 1.4 |
| Body (Default) | 14px / 0.875rem | 400 (Regular) | 1.5 |
| Body Bold | 14px | 600 (Semibold) | 1.5 |
| Small / Caption | 12px / 0.75rem | 400 or 500 | 1.4 |
| Micro / Badges | 11px / 0.6875rem | 500–600 | 1.2 |

### Usage Rules
- H1 only once per page (page title)
- H2 for major sections within a page
- H3 for card/section headers
- Body text: max 60–70 characters per line (readability)
- Labels: 12px, Semibold, uppercase tracking for categories
- Never use font weights below 400 for body text

---

## 4. SPACING & LAYOUT

### Spacing Scale
Base unit: 4px

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Micro spacing, badge padding |
| sm | 8px | Tight spacing, icon gaps |
| md | 16px | Standard element spacing |
| lg | 24px | Card padding, section gaps |
| xl | 32px | Major section gaps |
| 2xl | 48px | Page section dividers |

### Border Radius
| Token | Value | Usage |
|-------|-------|-------|
| sm | 8px | Badges, small elements |
| md | 12px | Buttons, inputs |
| lg | 16px | Cards |
| xl | 20–24px | Feature cards, modals |

### Shadows
```
Shadow SM: 0 1px 2px rgba(0,0,0,0.05)     — Subtle lift
Shadow MD: 0 4px 6px rgba(0,0,0,0.07)     — Cards on white
Shadow LG: 0 10px 25px rgba(0,0,0,0.1)    — Hover lift on cards
```

### Layout Breakpoints
- Mobile: 0–639px (primary target for workers)
- Tablet: 640–1023px (employer occasional use)
- Desktop: 1024px+ (employer primary, admin)

---

## 5. CORE COMPONENTS

### 5.1 Buttons

**Primary Button**
- Background: Brand 500
- Text: White, 14px Semibold
- Padding: 12px 20px (py-3 px-5)
- Border Radius: 12px
- Hover: Brand 600
- Pressed: Brand 700
- Disabled: Gray, 50% opacity

**Secondary Button**
- Background: Transparent
- Border: Navy 900, 1.5px
- Text: Navy 900, 14px Semibold
- Hover: Navy 50 background

**Tertiary Button**
- Background: Transparent
- Border: Gray 200, 1px
- Text: Navy 700, 14px Medium
- Hover: Gray 50 background

**Warning Button**
- Background: Amber 500
- Text: White
- Used for: Dispute submission, destructive actions

### 5.2 Cards

**Gig Card (Standard)**
- Background: White
- Border Radius: 16px
- Padding: 20px
- Shadow: SM
- Hover: Shadow LG, translateY(-2px)
- Border: None (standard)

**Gig Card (Featured/Top Match)**
- Same as standard
- Border: 2px Brand 300
- "Top Match" badge in top-right corner

**Info Card**
- Background: Slate 50 or Navy 50
- Border Radius: 12px
- Padding: 16px
- Shadow: None

### 5.3 AI Explanation Box
The signature component of GigOS. Every AI recommendation gets one.

**Structure:**
```
┌─────────────────────────────────────────────────┐
│ [Icon]  Why we matched this for you            │
│         Bullet point 1 with checkmark          │
│         Bullet point 2 with checkmark           │
│         Bullet point 3 with checkmark           │
│         [Optional: Opportunity Score]           │
└─────────────────────────────────────────────────┘
```

**Variants:**
- **Green (Why Matched):** Brand 50 background, Brand 200 border, Brand icon
- **Amber (AI Suggestion):** Amber 50 background, Amber 200 border, Amber icon
- **Navy (Market Context):** Navy 50 background, Navy 200 border, Navy icon

### 5.4 Form Elements

**Text Input**
- Height: 40px (py-2.5)
- Padding: 12px 16px (px-4)
- Border: Gray 300, 1px
- Border Radius: 12px
- Focus: Ring Brand 500, 2px; Border Brand 500
- Placeholder: Gray 400

**Select**
- Same as Text Input
- Background: White (not gray)

**Textarea**
- Same styling
- Resize: None (vertical only optional)
- Min height: 80px for 3-row

### 5.5 Badges & Tags

**Tier Badges**

| Tier | Background | Text | Size |
|------|-----------|------|------|
| New | Gray 200 | Gray 600 | 12px / 0.75rem |
| Verified (Bronze) | #cd7f32 | White | 12px |
| Trusted (Silver) | Gray 400 | White | 12px |
| Preferred (Gold) | Amber 400 | Amber 900 | 12px |
| Elite (Platinum) | Navy 900 | White, Brand 400 initials | 12px |
| Suspended (Black) | Gray 900 | White | 12px |

**Risk Badges**

| Risk | Background | Text |
|------|-----------|------|
| Low | Green 100 | Green 800 |
| Medium | Amber 100 | Amber 800 |
| High | Red 100 | Red 800 |

### 5.6 Opportunity Score Display
Circular progress ring with number in center. Five sub-scores shown below or beside.

**Ring:**
- Size: 56px (worker cards), 64px (gig detail)
- Track: Gray 200
- Fill: Brand 500
- Stroke width: 5px
- Score: Navy 900, Bold, centered

**Sub-scores:**
- Displayed as 5 columns
- Score number: Bold, Navy 800, 18px
- Label: Gray 500, 12px
- Below-target scores: Navy 500 color (de-emphasized)

---

## 6. NAVIGATION PATTERNS

### Worker App (Mobile-First)

**Bottom Navigation (Mobile):**
- Home / Feed (gig discovery)
- Applications
- My Gigs
- Messages
- Profile

**Top Bar:**
- GigOS logo (left)
- Notifications icon (right)
- Profile avatar (right)

### Employer Portal

**Side Navigation (Desktop):**
- Fixed left sidebar, 256px wide
- Navy 900 background
- White text
- Active item: Brand 500 background
- Sections: Dashboard, Post Gig, My Gigs, Workers

### Shared Patterns
- Back button: Left arrow + text, Navy 600, hover Navy 900
- Page titles: H1, left-aligned
- Breadcrumbs: Not used (keep navigation flat)

---

## 7. LAYOUT TEMPLATES

### 7.1 Gig Discovery Feed
Two-column layout:
- **Main (65%):** Scrollable gig feed — single column, max-width 640px centered
- **Sidebar (35%):** Worker status, profile completeness, Gap Finder teaser

Mobile: Sidebar content moves below feed.

### 7.2 Gig Detail Page
Three-column layout:
- **Main (60%):** Gig description, AI explanation, commute details
- **Right Sidebar (40%):** Employer profile card, Apply CTA, Market context

Mobile: Single column, sidebar content stacks below main content.

### 7.3 Employer Dashboard
Full-width with left sidebar navigation (256px).

### 7.4 Form Flows (Signup, Post Gig)
Single column, max-width 480px, centered. Progress steps shown at top.

---

## 8. ICON SYSTEM

### Icon Library
**Lucide Icons** (via CDN) — MIT licensed, consistent 24px stroke icons.

### Key Icons by Purpose
| Purpose | Icon | Notes |
|---------|------|-------|
| AI / Explanation | Lightbulb | Used in all AI explanation boxes |
| Location | Map Pin | Commute, service area |
| Money / Pay | Dollar sign | Pay rates |
| Time | Clock | Duration, hours |
| Star | Star | Ratings, reviews |
| Check | Checkmark | Confirmations, completion |
| Alert | Alert triangle | Warnings, flags |
| Calendar | Calendar | Dates, scheduling |
| Profile | User | Worker profiles |
| Building | Building | Employer profiles |
| Team | Users | Team Builder |
| Chevron | Chevron right | Navigation, expand |

### Icon Sizing
- Inline (with text): 16px / 20px
- Standalone (buttons): 20px / 24px
- Feature icons (cards): 24px / 32px

### Icon Colors
- Default: Navy 400
- Active/Brand: Brand 500
- Warning: Amber 500
- Error: Red 500

---

## 9. INTERACTION PATTERNS

### 9.1 Card Hover
Cards lift slightly on hover (translateY -2px) with shadow increase. Communicates interactivity without aggressive styling.

### 9.2 Button Press
Buttons darken on press (Brand 700). No dramatic scale changes.

### 9.3 Tooltips
Small informational tooltips appear on hover. Navy 800 background, white text, 12px, no border. Used for: what Opportunity Score means, what a tier requires.

### 9.4 Loading States
Skeleton loaders for cards (gray animated pulse). Spinner (Brand 500) for button actions. Never block the entire page.

### 9.5 Empty States
Friendly illustration + message + CTA. Example: "No gigs match your area yet — expand your service area or check back soon."

### 9.6 Modals
Centered, max-width 480px, white background, 24px border radius. Overlay: Navy 900 at 50% opacity. Close button top-right.

---

## 10. ANIMATION GUIDELINES

### Principles
- Subtle, purposeful motion — not decorative
- Motion communicates state changes, not personality
- Fast is better — 150–250ms for micro-interactions

### Transitions
- Page transitions: Instant (no fade)
- Card hover: 200ms ease-out
- Button press: 100ms
- Modal open: 200ms ease-out
- Toast notification: Slide in from top, 300ms

### What NOT to Animate
- No loading spinners on initial page load (use skeleton)
- No bouncing, pulsing, or attention-seeking animations
- No confetti or celebration animations
- No auto-playing carousels

---

## 11. ACCESSIBILITY

### Color Contrast
- All text: minimum 4.5:1 contrast ratio
- Large text (18px+): minimum 3:1
- Interactive elements: minimum 3:1 against adjacent colors
- Never rely on color alone — always pair with text/icons

### Touch Targets
- Minimum 44px × 44px for all interactive elements on mobile
- Adequate spacing between tappable elements (at least 8px gap)

### Screen Readers
- All icons have aria-labels
- Form inputs have associated labels
- AI explanation boxes have proper semantic structure (not just decorative divs)
- Color-coded status indicators have text alternatives

---

## 12. SCREEN INVENTORY

### Worker Screens (14 total)

| Screen | Priority | Description |
|--------|----------|-------------|
| Welcome / Landing | Must | Value props, sign-up CTA |
| Sign Up | Must | Email/phone verification |
| Profile Setup | Must | Skills, transport, availability |
| Gig Discovery Feed | Must | AI-ranked gig list with explanations |
| Gig Detail | Must | Full gig info + AI explanation + employer |
| Apply Confirmation | Must | Review before submitting |
| Agreement Review | Must | Mutual consent flow |
| Dashboard | Must | Income, active gigs, applications, reputation |
| Check In/Out | Must | One-tap timestamp with location |
| Leave Review (Worker) | Must | Rating employer after gig |
| Employer Profile | Should | See who you're working for |
| Flag Dispute | Should | Report an issue with evidence upload |
| Team Builder | Future | Recruit teammates for gigs |
| Gap Finder | Should | Skill gap analysis + learning path |

### Employer Screens (6 total)

| Screen | Priority | Description |
|--------|----------|-------------|
| Employer Dashboard | Must | Active gigs, applicant counts |
| Post a Gig | Must | Multi-step gig creation with AI pricing |
| Review Applicants | Must | Worker cards with match scores |
| Send Offer | Must | Propose terms to worker |
| Confirm Completion | Must | Release payment after gig |
| Leave Review (Employer) | Must | Rate worker after gig |

### Design System Screens (4 total)

| Screen | Purpose |
|--------|---------|
| Colors | Color palette reference |
| Components | All UI components |
| AI Explanation Patterns | The four recurring AI output formats |
| Reputation Tiers | Tier badge reference with definitions |

---

## 13. SAMPLE DATA SETS

All wireframes use realistic San Diego data:

**Worker:**
- Name: Maria Garcia
- Location: Chula Vista
- Skills: Bartending, Event Setup, Serving
- Transport: Car (2019 Honda Civic)
- Tier: Verified
- Rating: 4.6★ (5 reviews)
- Completed gigs: 5

**Employer:**
- Name: Riverside Events Co.
- Location: Downtown San Diego
- Tier: Verified
- Rating: 4.6★ (47 reviews)
- Workers hired: 89
- Payment speed: <24 hours
- Repeat worker rate: 87%

**Sample Gigs:**
- Birthday Party Bartender: $24/hr, Downtown, Sat 5pm–11pm, Low Risk
- Event Setup Crew: $20/hr, Mission Valley, Sun 7am–3pm, Medium Risk
- House Cleaning: $18/hr flat, North Park, Mon 9am–1pm, Low Risk

---

## 14. TECHNICAL NOTES

### Tailwind CSS Classes Used
All wireframes built with Tailwind CSS via CDN. Key customizations in tailwind.config.js:
- Extended colors for brand palette
- Extended font family for Inter
- Custom border radius tokens

### Responsive Approach
- Mobile-first breakpoints
- lg: breakpoint for sidebar layouts
- No horizontal scrolling at any breakpoint

### CDN Dependencies
```html
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
```

---

*Design System v1 — Ready for engineering handoff*