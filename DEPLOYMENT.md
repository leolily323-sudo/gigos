# GigOS — Deployment Guide

**Stack:** Next.js (App Router) + Supabase (PostgreSQL) + Prisma ORM
**Hosting:** Vercel (frontend) + Supabase (database)

---

## Prerequisites

- Node.js 20+
- npm or pnpm
- A [Supabase](https://supabase.com) account (free tier works)
- A [Vercel](https://vercel.com) account (free tier works)

---

## Step 1 — Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Name it `gigos` or similar
3. Choose a region closest to your users (San Diego → `us-west-2` or `us-east-1`)
4. Save the **database password** somewhere safe
5. Wait for the project to provision (2–3 minutes)

Once ready, open the **SQL Editor** in the Supabase dashboard and run the schema:

1. Click **SQL Editor** → **New Query**
2. Paste the contents of `schema.sql` (from this project)
3. Click **Run**

This creates all 18 tables with indexes, triggers, and seed data.

---

## Step 2 — Get Your Supabase Connection String

In Supabase, go to **Settings → Database**.

Under **Connection String**, copy the **URI** format:

```
postgresql://postgres.[PROJECT_ID]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
```

Example:
```
postgresql://postgres.abc123:mysecretpassword@aws-0-us-west-2.pooler.supabase.com:6543/postgres
```

You'll need this for the environment variables below.

---

## Step 3 — Set Up Environment Variables

Create a `.env.local` file in the project root:

```bash
# Supabase
DATABASE_URL="postgresql://postgres.abc123:mysecretpassword@aws-0-us-west-2.pooler.supabase.com:6543/postgres"
DIRECT_URL="postgresql://postgres.abc123:mysecretpassword@db.[PROJECT_REF].supabase.com:5432/postgres"

# Supabase Auth (from Settings → API)
NEXT_PUBLIC_SUPABASE_URL="https://[PROJECT_REF].supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
SUPABASE_SERVICE_ROLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# App
NEXT_PUBLIC_APP_URL="https://your-app.vercel.app"
```

Find your Supabase keys in **Settings → API**.

---

## Step 4 — Install Dependencies

```bash
npm install
```

---

## Step 5 — Push the Prisma Schema

Make sure your `DATABASE_URL` is set, then:

```bash
npx prisma db push
```

This syncs the Prisma schema with your Supabase database. It's safe to run multiple times.

To view your database in a GUI:

```bash
npx prisma studio
```

---

## Step 6 — Run Locally

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

---

## Step 7 — Deploy to Vercel

### Option A — Via Vercel CLI

```bash
npm i -g vercel
vercel login
vercel
```

Follow the prompts. Vercel will auto-detect Next.js.

### Option B — Via GitHub (recommended)

1. Push the project to a GitHub repo
2. Go to [vercel.com](https://vercel.com) → **Add New Project**
3. Import your GitHub repo
4. Vercel auto-detects Next.js — add your environment variables under **Environment Variables**
5. Click **Deploy**

---

## Environment Variables on Vercel

Add these in Vercel dashboard → Project → **Settings → Environment Variables**:

| Name | Value |
|------|-------|
| `DATABASE_URL` | Your Supabase connection URI |
| `DIRECT_URL` | Your Supabase direct connection URI |
| `NEXT_PUBLIC_SUPABASE_URL` | `https://[ref].supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Your Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Your Supabase service role key |
| `NEXT_PUBLIC_APP_URL` | Your Vercel deployment URL |

---

## Database Migrations (after schema changes)

When you update `schema.prisma`:

```bash
# Create a migration
npx prisma migrate dev --name add_new_field

# Apply migrations in production
npx prisma migrate deploy
```

---

## Row Level Security (RLS)

Supabase enables RLS by default. Key policies to set up in the SQL Editor:

```sql
-- Enable RLS on a table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Users can read their own row
CREATE POLICY "users_select_own" ON users
  FOR SELECT USING (auth.uid() = id);

-- Workers can update their own profile
CREATE POLICY "workers_update_own" ON worker_profiles
  FOR UPDATE USING (auth.uid() = user_id);

-- Gigs are publicly readable when open
CREATE POLICY "gigs_public_read" ON gigs
  FOR SELECT USING (status = 'open' OR employer_id = auth.uid());

-- Applications visible to worker and gig owner
CREATE POLICY "applications_access" ON applications
  FOR ALL USING (
    worker_id = auth.uid() OR
    gig_id IN (SELECT id FROM gigs WHERE employer_id = auth.uid())
  );
```

Run RLS policies via the Supabase SQL Editor or add them to a migration file.

---

## Custom Domain (optional)

In Vercel → **Settings → Domains**, add your custom domain. DNS changes are guided by Vercel.

---

## Monitoring

- **Vercel**: Built-in analytics + logs under **Deployments**
- **Supabase**: Dashboard → **Logs** for database queries
- **Error tracking**: Consider adding [Sentry](https://sentry.io) (`npm install @sentry/nextjs`)

---

## Performance Tips

1. **Connection pooling**: Supabase uses PgBouncer. Use port `6543` (not `5432`) in your `DATABASE_URL` for pooled connections.
2. **Prisma Accelerate**: For production, add Prisma Accelerate as a proxy layer for connection pooling and caching. (Supabase also offers this.)
3. **Image optimization**: Use `next/image` and host images in Supabase Storage.
4. **Static generation**: Pre-render the skill taxonomy and public pages at build time.

---

## Quick Reference

| Task | Command |
|------|---------|
| Start dev server | `npm run dev` |
| Push schema to DB | `npx prisma db push` |
| Open Prisma Studio | `npx prisma studio` |
| Create migration | `npx prisma migrate dev --name description` |
| Deploy | `vercel --prod` |
| View logs | `vercel logs` |
