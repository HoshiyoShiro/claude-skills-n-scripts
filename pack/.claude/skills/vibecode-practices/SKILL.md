---
name: vibecode-practices
description: Binding project standards for a SaaS built on Supabase, Upstash, Pinecone, Render, Vercel, Cloudflare, Clerk, Stripe, Resend, PostHog and Sentry. Use before writing, changing or reviewing code, schema, API routes, auth, payments, email, infrastructure or LLM features in such a project, and run its pre-merge self-check before saying a task is done.
---

# VibeCode practices

Project standards. Treat them as requirements, not suggestions.

- **MUST** = mandatory. **SHOULD** = default unless there is a stated reason not to. **AVOID** = do not do this.
- Before writing or changing code, check the relevant sections. Sections 3 to 5 apply to almost every task.
- If a request conflicts with a MUST rule, say so and propose a compliant alternative. Never comply silently.
- Use only the services in section 2 unless told otherwise. Respect the dependency map (`references/dependency-map.md`).
- Never invent API keys, secrets or env values. Use placeholders and read them from environment variables.
- When finishing a task, list which sections you applied and anything you could not satisfy.

## 1. Product decision filter

Before building any feature, answer these three questions. If any answer is "no", flag it before writing code.

1. Is the problem painful enough?
2. Does the solution actually remove that pain?
3. Can we deliver that experience consistently?

## 2. Tech stack (use these services only)

| Service | Role | Category |
|---|---|---|
| Supabase | Database (Postgres) | Data |
| Upstash | Redis (cache, rate limits, queues) | Data |
| Pinecone | Vector DB | Data |
| Render | Backend hosting | Compute |
| Vercel | Frontend deployment | Compute |
| Namecheap | Domain registrar | Network |
| Cloudflare | DNS | Network |
| Clerk | Authentication | Identity |
| Stripe | Payments | Business |
| Resend | Transactional email | Business |
| PostHog | Product analytics | Observability |
| Sentry | Error tracking | Observability |

How the services depend on each other, the layered view, the graph and the recommended setup order: `references/dependency-map.md`. Read it when adding a service, a domain, an email path or a webhook. The map is inferred from the standard wiring of these tools; confirm it against the real architecture if it differs.

## 3. Database rules

**MUST avoid:**
- N+1 queries
- `SELECT *` (select only the columns needed)
- Missing indexes (index every foreign key and every column used in WHERE, JOIN or ORDER BY)

**MUST use:**
- Pagination on every list endpoint (prefer cursor-based)
- Connection pooling (never open a connection per request)
- Row-Level Security (RLS) on every Supabase table with user data

## 4. Security rules

### 4.1 Core measures (MUST implement)
- Authentication
- Authorization, enforced **server-side**, never only in the UI
- Input validation (schema-validate every input)
- SQL injection prevention
- File sanitation (validate type, size and content of uploads)
- Prompt injection protection
- Environment variables for all secrets
- Data leakage protection
- `.gitignore` must include `.env*`

### 4.2 API handling (MUST)
- API-wide rate limiting
- Per-endpoint rate limiting (stricter on login, signup, password reset, email send)
- HTTPS only
- An ORM or parameterized queries

### 4.3 Extended checklist
The full list of web attacks, access control, crypto, sessions, uploads, webhooks and supply-chain topics is in `references/security-checklist.md`. Use it when designing or reviewing anything that touches auth, money, uploads or third-party input.

## 5. Engineering knowledge checklist

`references/engineering-checklist.md` groups the topics to consider when designing or reviewing: data, distributed systems, resilience, caching, messaging, networking, API design, cloud, operations, scaling, observability, deployment, containers, testing, code correctness, compliance, email deliverability and LLM features. Skim the groups that match the task. Two rules from it are mandatory:

- **AVOID** storing money as floats. Use integer minor units or decimals.
- Verify that any package an AI suggests actually exists before installing it (hallucinated packages).

## 6. Helper skills (agent tooling)

Independent of the hosted services in section 2. Use them when the situation applies.

| Skill (GitHub repo) | Purpose | Use when |
|---|---|---|
| `hardikpandya/stop-slop` | Make writing sound human | Producing user-facing copy, docs, emails |
| `yusufkaraaslan/Skill_Seekers` | Turn the agent into a specialist | A task needs deep domain expertise |
| `JuliusBrussee/caveman` | Token saver | Keeping context and output short |
| `nextlevelbuilder/ui-ux-pro-max-skill` | Web designer | Designing or reviewing UI/UX |
| `mvanhorn/last30days-skill` | Only pull last 30 days of info | Research where recency matters |

## 7. Pre-merge self-check

Run this before saying "done". Report any box you could not tick, and why.

- [ ] Passes the section 1 filter (painful problem, real fix, consistent delivery)
- [ ] No N+1, no `SELECT *`, indexes present, list endpoints paginated, connection pooling used
- [ ] RLS enabled on user-data tables
- [ ] Auth and server-side authorization on every protected route
- [ ] All inputs validated; queries parameterized; uploads sanitized
- [ ] Rate limits on the API and on sensitive endpoints; HTTPS only
- [ ] Stripe webhook signatures verified; money not stored as floats
- [ ] No secrets in code; `.env*` in `.gitignore`; secrets come from env vars
- [ ] Prompt-injection protections on any LLM input path
- [ ] Sentry and PostHog wired in for new features
- [ ] DNS, SPF/DKIM/DMARC and env vars updated if a new domain or email path was added
- [ ] Whole diff reviewed, even a very large one

Finish by applying the `work-log` skill.
