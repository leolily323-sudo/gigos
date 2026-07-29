# GigOS — Local Gig Marketplace

**AI-powered local gig marketplace connecting workers and employers in San Diego County.**

## Tech Stack

- **Frontend**: Next.js 14 (App Router)
- **Database**: Supabase (PostgreSQL)
- **ORM**: Prisma
- **AI**: Claude 3.5 (risk assessment, matching, dispute resolution)

## Project Structure

```
├── app/                    # Next.js App Router pages
├── api/v1/                 # API routes
│   ├── auth/
│   ├── gigs/
│   ├── workers/
│   ├── employers/
│   ├── agreements/
│   ├── disputes/
│   └── reviews/
├── lib/                    # Shared utilities
├── prisma/
│   └── schema.prisma       # Database schema
├── app/                    # Next.js App Router
├── API-SPECS.md            # Full API specification
├── DEPLOYMENT.md           # Deployment guide
├── schema.sql              # Raw PostgreSQL schema
└── PRD.md                  # Product requirements document
```

## Getting Started

See [DEPLOYMENT.md](./DEPLOYMENT.md) for step-by-step setup instructions.

## Quick Setup

```bash
# Install dependencies
npm install

# Push schema to Supabase
npx prisma db push

# Start dev server
npm run dev
```

## Documentation

- [API Specs](./API-SPECS.md) — Full REST API reference
- [Deployment Guide](./DEPLOYMENT.md) — Vercel + Supabase setup
- [PRD](./PRD.md) — Product requirements
- [Design System](./design-system.md) — UI components and tokens
- [Wireframes](./wireframes.html) — Interactive screen mockups
