# GigOS — API Route Specifications

**Version:** 1.0
**Stack:** Next.js App Router + Supabase (PostgreSQL) + Prisma ORM
**Base URL:** `/api/v1`

---

## Authentication

All protected routes require a Supabase JWT in the `Authorization: Bearer <token>` header.

### Public Routes (no auth required)
- `GET /api/v1/gigs` — browse open gigs
- `GET /api/v1/gigs/:id` — gig detail
- `GET /api/v1/workers/:id` — worker profile (public fields only)
- `GET /api/v1/employers/:id` — employer profile (public fields only)
- `GET /api/v1/skills` — skill taxonomy
- `GET /api/v1/reviews` — published reviews (public)
- `POST /api/v1/auth/register` — create account
- `POST /api/v1/auth/login` — get JWT

### Protected Routes (auth required)
All other routes require a valid JWT for the requesting user.

---

## Users

### `POST /api/v1/auth/register`
Create a new user account.

**Body:**
```json
{
  "email": "string",
  "phone": "string",
  "password": "string",
  "displayName": "string",
  "role": "worker" | "employer"
}
```

**Response `201`:**
```json
{
  "user": { "id", "email", "phone", "displayName", "role", "createdAt" },
  "token": "jwt_string"
}
```

**Errors:** `400` validation failed, `409` email/phone already exists

---

### `POST /api/v1/auth/login`
Authenticate and receive a JWT.

**Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response `200`:**
```json
{
  "user": { "id", "email", "displayName", "role", "reputationTier" },
  "token": "jwt_string"
}
```

**Errors:** `401` invalid credentials

---

### `GET /api/v1/users/me`
Get the authenticated user's full profile.

**Response `200`:**
```json
{
  "id": "uuid",
  "email": "string",
  "phone": "string",
  "displayName": "string",
  "avatarUrl": "string | null",
  "role": "worker | employer",
  "verificationLevel": "unverified | identity | employment | full",
  "identityVerified": true,
  "employmentVerified": false,
  "reputationTier": "new | verified | trusted | preferred | elite | suspended",
  "reliabilityScore": 0.00,
  "riskFlags": [],
  "lastActiveAt": "timestamp",
  "createdAt": "timestamp"
}
```

**Errors:** `401` unauthorized

---

### `PATCH /api/v1/users/me`
Update the authenticated user's profile.

**Body** (all fields optional):
```json
{
  "displayName": "string",
  "avatarUrl": "string",
  "phone": "string"
}
```

**Response `200`:**
```json
{
  "user": { ... updated user object ... }
}
```

---

## Worker Profiles

### `GET /api/v1/workers/:id`
Get a worker's public profile.

**Response `200`:**
```json
{
  "user": { "id", "displayName", "avatarUrl", "reputationTier", "reliabilityScore", "lastActiveAt" },
  "profile": {
    "bio": "string | null",
    "headline": "string | null",
    "hasCar": true,
    "hasBike": false,
    "hasTransitPass": false,
    "canRelocate": false,
    "minHourlyRate": 18.00,
    "preferredPaymentMethod": "cash",
    "homeNeighborhood": "North Park",
    "availabilityNotes": "string",
    "totalGigsCompleted": 12,
    "totalGigsCancelled": 1,
    "avgRating": 4.83,
    "totalReviews": 10
  },
  "skills": [
    { "skillId": "uuid", "name": "Server / Bartending", "proficiency": "intermediate", "source": "employer_endorsed", "verifiedAt": "timestamp" }
  ],
  "serviceAreas": [
    { "name": "Downtown", "radiusMiles": 10.00 }
  ],
  "portfolio": [
    { "id": "uuid", "photoUrl": "string", "caption": "string | null" }
  ]
}
```

---

### `PUT /api/v1/workers/profile`
Create or update the authenticated worker's profile.

**Body:**
```json
{
  "bio": "string",
  "headline": "string",
  "hasCar": false,
  "hasBike": false,
  "hasTransitPass": true,
  "canRelocate": false,
  "minHourlyRate": 20.00,
  "preferredPaymentMethod": "venmo",
  "homeNeighborhood": "North Park",
  "availabilityNotes": "Weekends only, evenings after 6pm"
}
```

**Response `200`:** `{ "profile": { ... } }`

---

### `GET /api/v1/workers/search`
Search workers by skill, location, availability.

**Query params:**
| Param | Type | Description |
|-------|------|-------------|
| `skill` | string | skill slug filter |
| `neighborhood` | string | service area name |
| `availableOn` | ISO date | date to check availability |
| `hasEquipment` | string | equipment name |
| `minRating` | number | minimum avg rating |
| `maxHourlyRate` | number | cap on hourly rate |
| `transport` | string | "car", "bike", "transit" |
| `sortBy` | string | "rating", "reliability", "distance" |
| `page` | number | default 1 |
| `limit` | number | default 20, max 50 |

**Response `200`:**
```json
{
  "workers": [ ... worker public profiles ... ],
  "total": 143,
  "page": 1,
  "limit": 20
}
```

---

## Employer Profiles

### `GET /api/v1/employers/:id`
Get an employer's public profile.

**Response `200`:**
```json
{
  "user": { "id", "displayName", "avatarUrl", "reputationTier", "reliabilityScore" },
  "profile": {
    "businessName": "string | null",
    "bio": "string | null",
    "businessType": "Restaurant",
    "websiteUrl": "string | null",
    "addressStreet": "string | null",
    "totalGigsPosted": 8,
    "totalHires": 5,
    "avgRating": 4.50,
    "totalReviews": 4
  }
}
```

---

### `PUT /api/v1/employers/profile`
Create or update the authenticated employer's profile.

**Body:**
```json
{
  "businessName": "string",
  "bio": "string",
  "businessType": "Restaurant",
  "websiteUrl": "string",
  "addressStreet": "string"
}
```

---

## Skills & Equipment

### `GET /api/v1/skills`
Get the full skill taxonomy.

**Response `200`:**
```json
{
  "categories": [
    {
      "name": "Food & Beverage",
      "skills": [
        { "id": "uuid", "slug": "server_bartending", "name": "Server / Bartending", "description": "string" }
      ]
    }
  ]
}
```

---

### `GET /api/v1/workers/:id/skills`
Get a worker's claimed skills.

**Response `200`:**
```json
{
  "skills": [
    { "id": "uuid", "skillId": "uuid", "name": "Server / Bartending", "proficiency": "intermediate", "source": "employer_endorsed", "verifiedAt": "timestamp" }
  ]
}
```

---

### `POST /api/v1/workers/me/skills`
Add a skill assertion for the authenticated worker.

**Body:**
```json
{
  "skillId": "uuid",
  "proficiency": "beginner | intermediate | expert"
}
```

**Response `201`:** `{ "assertion": { ... } }`

---

### `DELETE /api/v1/workers/me/skills/:assertionId`
Remove a skill assertion.

**Response `204`:** No content

---

## Service Areas & Availability

### `PUT /api/v1/workers/me/service-areas`
Replace all service areas for the authenticated worker.

**Body:**
```json
{
  "serviceAreas": [
    { "name": "Downtown", "lat": 32.7157, "lng": -117.1611, "radiusMiles": 10 }
  ]
}
```

**Response `200`:** `{ "serviceAreas": [ ... ] }`

---

### `GET /api/v1/workers/:id/availability`
Get a worker's weekly recurring availability.

**Response `200`:**
```json
{
  "availabilityBlocks": [
    { "dayOfWeek": 1, "startTime": "09:00", "endTime": "17:00", "isAvailable": true }
  ],
  "notes": "string"
}
```

---

### `PUT /api/v1/workers/me/availability`
Replace all availability blocks for the authenticated worker.

**Body:**
```json
{
  "availabilityBlocks": [
    { "dayOfWeek": 1, "startTime": "09:00", "endTime": "17:00", "isAvailable": true }
  ]
}
```

---

## Equipment & Portfolio

### `POST /api/v1/workers/me/equipment`
Add equipment for the authenticated worker.

**Body:**
```json
{
  "name": "Hand truck / dollie",
  "description": "Heavy duty, 500lb capacity"
}
```

**Response `201`:** `{ "equipment": { "id", "name", "description" } }`

---

### `DELETE /api/v1/workers/me/equipment/:id`
Remove equipment.

**Response `204`:** No content

---

### `POST /api/v1/workers/me/portfolio`
Add a portfolio item.

**Body:**
```json
{
  "skillId": "uuid | null",
  "photoUrl": "string",
  "caption": "string | null",
  "gigId": "uuid | null"
}
```

**Response `201`:** `{ "portfolioItem": { ... } }`

---

### `DELETE /api/v1/workers/me/portfolio/:id`
Remove a portfolio item.

**Response `204`:** No content

---

## Gigs

### `GET /api/v1/gigs`
Browse open gigs with filters.

**Query params:**
| Param | Type | Description |
|-------|------|-------------|
| `skill` | string | category slug filter |
| `neighborhood` | string | neighborhood filter |
| `date` | ISO date | gigs on a specific date |
| `minPay` | number | minimum hourly rate |
| `maxPay` | number | maximum hourly rate |
| `risk` | string | "low", "medium", "high" |
| `teamSize` | number | exact team size needed |
| `sortBy` | string | "date", "pay", "distance" |
| `lat` | number | latitude for distance sort |
| `lng` | number | longitude for distance sort |
| `page` | number | default 1 |
| `limit` | number | default 20, max 50 |

**Response `200`:**
```json
{
  "gigs": [
    {
      "id": "uuid",
      "title": "Server needed for Saturday dinner",
      "description": "string",
      "employer": { "id", "displayName", "avgRating" },
      "skill": { "id", "name" },
      "neighborhood": "North Park",
      "scheduledStart": "2026-08-01T18:00:00Z",
      "scheduledEnd": "2026-08-01T23:00:00Z",
      "durationHours": 5.00,
      "payRate": 22.00,
      "payType": "hourly",
      "teamSize": 2,
      "riskCategory": "low",
      "applicationCount": 3,
      "createdAt": "timestamp"
    }
  ],
  "total": 47,
  "page": 1,
  "limit": 20
}
```

---

### `GET /api/v1/gigs/:id`
Get gig detail.

**Response `200`:**
```json
{
  "gig": {
    "id": "uuid",
    "employer": { "id", "displayName", "businessName", "avgRating", "totalHires" },
    "skill": { "id", "name" },
    "title": "string",
    "description": "string",
    "addressStreet": "123 Main St",
    "showAddress": true,
    "neighborhood": "North Park",
    "scheduledStart": "timestamp",
    "scheduledEnd": "timestamp",
    "durationHours": 5.00,
    "payRate": 22.00,
    "payType": "hourly",
    "maxPay": null,
    "requiredSkills": [{ "id", "name" }],
    "requiredEquipment": ["Hand truck"],
    "requiredTransport": ["car"],
    "requiredExperience": ["intermediate"],
    "teamSize": 2,
    "riskCategory": "low",
    "riskFactors": [],
    "status": "open",
    "applicationDeadline": "timestamp | null",
    "photos": [{ "id", "photoUrl", "caption" }],
    "applicationCount": 3,
    "viewCount": 142,
    "isBookmarked": false,
    "createdAt": "timestamp"
  }
}
```

---

### `POST /api/v1/gigs`
Create a new gig (employer only).

**Body:**
```json
{
  "skillId": "uuid",
  "title": "Server needed for Saturday dinner",
  "description": "Looking for experienced server for a 50-person private dinner...",
  "addressStreet": "123 Main St",
  "addressLat": 32.7157,
  "addressLng": -117.1611,
  "showAddress": true,
  "scheduledStart": "2026-08-01T18:00:00Z",
  "scheduledEnd": "2026-08-01T23:00:00Z",
  "payRate": 22.00,
  "payType": "hourly",
  "maxPay": null,
  "requiredSkillIds": ["uuid"],
  "requiredEquipment": ["Hand truck"],
  "requiredTransport": ["car"],
  "requiredExperience": ["intermediate"],
  "teamSize": 2,
  "applicationDeadline": "2026-07-31T23:59:00Z",
  "photos": ["url1", "url2"]
}
```

**Response `201`:**
```json
{
  "gig": { ... full gig object ... },
  "aiRiskAssessment": {
    "riskCategory": "low",
    "riskFactors": [],
    "marketRateData": { "median": 21.50, "range": "18-25" }
  }
}
```

**Errors:** `403` not an employer, `400` validation failed

---

### `PATCH /api/v1/gigs/:id`
Update a gig (employer only, own gigs only).

**Body** (all fields optional):
```json
{
  "title": "string",
  "description": "string",
  "scheduledStart": "timestamp",
  "scheduledEnd": "timestamp",
  "payRate": 24.00,
  "applicationDeadline": "timestamp"
}
```

**Response `200`:** `{ "gig": { ... } }`

**Errors:** `403` not owner, `409` gig already has applications

---

### `DELETE /api/v1/gigs/:id`
Delete a gig (employer only, own gigs only, must be draft or open with no applications).

**Response `204`:** No content

---

### `POST /api/v1/gigs/:id/publish`
Publish a draft gig (employer only).

**Response `200`:** `{ "gig": { ... } }`

---

### `POST /api/v1/gigs/:id/bookmark`
Bookmark a gig (worker only).

**Response `201`:** `{ "bookmark": { "id", "gigId", "workerId", "createdAt" } }`

---

### `DELETE /api/v1/gigs/:id/bookmark`
Remove a bookmark (worker only).

**Response `204`:** No content

---

### `GET /api/v1/gigs/:id/applications`
List applications for a gig (employer only, own gigs).

**Response `200`:**
```json
{
  "applications": [
    {
      "id": "uuid",
      "worker": { "id", "displayName", "avatarUrl", "reputationTier", "avgRating" },
      "message": "string",
      "proposedHourlyRate": 22.00,
      "proposedPaymentMethod": "venmo",
      "status": "pending",
      "aiMatchScore": 87.50,
      "aiMatchExplanation": { "factors": [...] },
      "createdAt": "timestamp"
    }
  ]
}
```

---

## Applications

### `POST /api/v1/gigs/:id/apply`
Apply to a gig (worker only).

**Body:**
```json
{
  "message": "I have 3 years of serving experience...",
  "proposedHourlyRate": 22.00,
  "proposedPaymentMethod": "venmo"
}
```

**Response `201`:** `{ "application": { ... }, "aiMatchScore": 87.50 }`

**Errors:** `409` already applied, `410` gig not open, `400` application deadline passed

---

### `PATCH /api/v1/applications/:id`
Worker updates their own pending application.

**Body:**
```json
{
  "message": "Updated message...",
  "proposedHourlyRate": 23.00
}
```

**Response `200`:** `{ "application": { ... } }`

---

### `DELETE /api/v1/applications/:id`
Withdraw a pending application (worker only).

**Response `204`:** No content

---

### `POST /api/v1/applications/:id/offer`
Employer makes an offer on an application.

**Response `200`:** `{ "application": { "status": "offered" } }`

---

### `POST /api/v1/applications/:id/accept`
Worker accepts an offer.

**Response `200`:** `{ "application": { "status": "accepted" }, "agreement": { ... } }`

---

### `POST /api/v1/applications/:id/decline`
Employer declines an application OR worker declines an offer.

**Response `200`:** `{ "application": { "status": "declined" } }`

---

## Agreements

### `GET /api/v1/agreements/:id`
Get agreement detail (parties only).

**Response `200`:**
```json
{
  "agreement": {
    "id": "uuid",
    "gig": { "id", "title", "skill", "scheduledStart", "scheduledEnd" },
    "worker": { "id", "displayName", "avatarUrl", "phone" },
    "employer": { "id", "displayName", "businessName", "phone" },
    "status": "confirmed",
    "paymentMethodAgreed": "venmo",
    "payRateAgreed": 22.00,
    "checkInAt": null,
    "checkOutAt": null,
    "completionConfirmedWorker": false,
    "completionConfirmedEmployer": false,
    "paymentStatus": "pending",
    "createdAt": "timestamp"
  }
}
```

---

### `POST /api/v1/agreements/:id/confirm-terms`
Both parties confirm agreement terms (employer or worker).

**Response `200`:** `{ "agreement": { ... } }`

---

### `POST /api/v1/agreements/:id/check-in`
Worker checks in to a gig (with location).

**Body:**
```json
{
  "lat": 32.7157,
  "lng": -117.1611
}
```

**Response `200`:** `{ "agreement": { "checkInAt": "timestamp" } }`

---

### `POST /api/v1/agreements/:id/check-out`
Worker checks out of a gig (with location).

**Body:**
```json
{
  "lat": 32.7157,
  "lng": -117.1611
}
```

**Response `200`:** `{ "agreement": { "checkOutAt": "timestamp" } }`

---

### `POST /api/v1/agreements/:id/confirm-completion`
Worker or employer confirms completion.

**Body:**
```json
{
  "role": "worker | employer"
}
```

**Response `200`:** `{ "agreement": { "completionConfirmedWorker": true, "completedAt": "timestamp" } }`

**Notes:** When both parties confirm, `paymentStatus` moves to `released` (for in-app payments) or the payment release is triggered based on agreed method.

---

### `POST /api/v1/agreements/:id/cancel`
Cancel an agreement (employer or worker, only before check-in).

**Body:**
```json
{
  "reason": "string"
}
```

**Response `200`:** `{ "agreement": { "status": "cancelled" } }`

---

## Disputes

### `POST /api/v1/agreements/:id/dispute`
File a dispute (worker or employer, after agreement is active).

**Body:**
```json
{
  "reason": "non_payment | safety_concern | no_show | quality_issue | other",
  "description": "Detailed description of what happened..."
}
```

**Response `201`:**
```json
{
  "dispute": {
    "id": "uuid",
    "agreementId": "uuid",
    "status": "open",
    "filedAt": "timestamp"
  },
  "aiEvidenceSummary": { ... }
}
```

---

### `GET /api/v1/disputes/:id`
Get dispute detail (filer or resolution staff only).

**Response `200`:**
```json
{
  "dispute": {
    "id": "uuid",
    "agreementId": "uuid",
    "reason": "string",
    "description": "string",
    "status": "open | evidence_collected | under_review | decided | appealed",
    "resolution": null,
    "appealStatus": "none",
    "filedAt": "timestamp",
    "decidedAt": null,
    "evidence": [
      { "id": "uuid", "type": "message", "content": "string", "caption": "string", "submittedAt": "timestamp" }
    ]
  }
}
```

---

### `POST /api/v1/disputes/:id/evidence`
Submit evidence to a dispute.

**Body:**
```json
{
  "evidenceType": "message | photo | document | check_in_out | payment_record | other",
  "content": "string (url or text)",
  "caption": "string | null"
}
```

**Response `201`:** `{ "evidence": { ... } }`

---

## Reviews

### `POST /api/v1/agreements/:id/review`
Submit a review after gig completion (worker or employer).

**Body:**
```json
{
  "reviewType": "employer_to_worker | worker_to_employer",
  "ratings": {
    "reliability": 5,
    "quality": 4,
    "communication": 5,
    "professionalism": 4
  },
  "writtenFeedback": "Great worker, very punctual...",
  "wouldWorkAgain": true
}
```

**Response `201`:** `{ "review": { ... } }`

**Notes:** Coworker reviews use `reviewType: coworker` and are held until both parties submit.

---

### `GET /api/v1/workers/:id/reviews`
Get published reviews for a worker.

**Response `200`:**
```json
{
  "reviews": [
    {
      "id": "uuid",
      "reviewType": "employer_to_worker",
      "ratings": { "reliability": 5, "quality": 4, "communication": 5, "professionalism": 4 },
      "writtenFeedback": "string",
      "reviewer": { "id", "displayName", "avatarUrl" },
      "gigCategory": { "id", "name" },
      "publishedAt": "timestamp"
    }
  ],
  "summary": { "avgReliability": 4.8, "avgQuality": 4.5, "avgCommunication": 4.9, "avgProfessionalism": 4.7 }
}
```

---

## Team Relationships

### `GET /api/v1/workers/me/team`
Get the authenticated worker's coworker list.

**Response `200`:**
```json
{
  "coworkers": [
    {
      "user": { "id", "displayName", "avatarUrl", "reputationTier" },
      "rating": 4.5,
      "privateNotes": "string",
      "lastWorkedTogether": "timestamp",
      "gigId": "uuid | null"
    }
  ]
}
```

---

### `PUT /api/v1/workers/me/team/:coworkerId`
Add or update a coworker relationship.

**Body:**
```json
{
  "yourRatingOfCoworker": 5,
  "privateNotes": "Best coworker ever",
  "gigId": "uuid | null"
}
```

---

## Payment Methods

### `GET /api/v1/users/me/payment-methods`
Get the authenticated user's stored payment methods.

**Response `200`:**
```json
{
  "paymentMethods": [
    { "id": "uuid", "method": "venmo", "handle": "@username", "label": "Personal Venmo", "isDefault": true, "isVerified": false }
  ]
}
```

---

### `POST /api/v1/users/me/payment-methods`
Add a payment method.

**Body:**
```json
{
  "method": "venmo | zelle | paypal | cash | in_app",
  "handle": "@username or phone number",
  "label": "Personal Venmo",
  "isDefault": true
}
```

**Response `201`:** `{ "paymentMethod": { ... } }`

---

### `DELETE /api/v1/users/me/payment-methods/:id`
Remove a payment method.

**Response `204`:** No content

---

## Feed / Home

### `GET /api/v1/feed`
Personalized gig feed for the authenticated worker.

**Query params:** Same as `GET /api/v1/gigs` plus `radius` (miles, default 25)

**Logic:**
1. Get worker's service areas + skills
2. Filter gigs within service area radius
3. Score by skill match + availability + reliability + distance
4. Return sorted by score descending

**Response `200`:**
```json
{
  "gigs": [ ...same shape as GET /gigs... ],
  "total": 31,
  "matchScores": { "gigId": 87.5, ... }
}
```

---

## Admin

### `GET /api/v1/admin/disputes`
List disputes (admin/resolution_staff only).

**Query params:** `status`, `page`, `limit`

---

### `PATCH /api/v1/admin/disputes/:id/decision`
Resolution staff resolves a dispute.

**Body:**
```json
{
  "resolution": "Refund issued to worker. Employer warned for no-show.",
  "status": "decided"
}
```

---

## Error Response Format

All errors follow this shape:

```json
{
  "error": {
    "code": "VALIDATION_ERROR | NOT_FOUND | FORBIDDEN | UNAUTHORIZED | CONFLICT | GONE",
    "message": "Human-readable description",
    "details": { ... } // optional, field-level validation errors
  }
}
```

**Common HTTP status codes:**
| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 204 | No content (delete success) |
| 400 | Bad request / validation error |
| 401 | Not authenticated |
| 403 | Not authorized (no permission) |
| 404 | Resource not found |
| 409 | Conflict (e.g., already applied) |
| 410 | Gone (e.g., deadline passed) |
| 500 | Server error |
