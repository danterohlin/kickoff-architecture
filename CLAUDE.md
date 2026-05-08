# Project Instructions

This repo is worked on by **two agents that share the same codebase**:

| Agent | Environment | How it runs |
|---|---|---|
| **Cursor IDE** | User's local machine, Cursor editor | Interactive — user is in the IDE |
| **Super Agent** | Slack bot, Claude Code SDK | Async — user messages from Slack/phone |

Both agents use this file as their instruction set. Git is the sync layer.

## Critical Rules

1. **Scaffold in repo root** — NEVER create a subfolder for the project. Install
   directly into the repo root (this IS the project).
2. **Always use feature branches** — NEVER push to `main`. Create a branch like
   `feat/initial-setup` or `feat/{feature-name}` before making changes.
3. **Create a PR after each phase** — When you finish a phase (or a significant
   batch of tasks), commit, push to your feature branch, and run
   `gh pr create --title "..." --body "..."`. Report the PR URL in your response.
   Do NOT continue to the next phase without creating the PR first.
4. **Tests from day one** — set up Playwright + Vitest in Phase 0. Every feature
   needs at least one E2E test.
5. **Create plan.md and memory.md** — these are your persistent state. Other
   sessions (and the user) rely on them.
6. **Append to devlog.md before finishing** — a running journal of what each
   session accomplished, decisions made, and test results.
7. **Update HANDOFF.md before finishing** — summarize what you did, current state,
   and next steps so the next session can pick up seamlessly.
8. **No emojis** — NEVER use emojis, checkmarks, or decorative unicode characters
   in responses or commit messages. Plain text only.

## Multi-Agent Handoff Protocol

The user switches between Cursor IDE and the Super Agent (Slack). Both agents
must read/write HANDOFF.md so the other can continue seamlessly.

### When the user says "handoff" (or "switching to super agent" / "switching to cursor")

1. Stop current work at a clean point.
2. Commit all changes (including project docs).
3. Write HANDOFF.md with the format below.
4. Push to the feature branch.
5. Confirm: "Handoff ready on `feat/branch-name`. You can continue in [target agent]."

### HANDOFF.md Format

```markdown
# Handoff

- **Date**: YYYY-MM-DD HH:MM
- **From**: cursor-ide | super-agent
- **Branch**: feat/branch-name
- **Status**: in-progress | blocked | ready-for-review

## What I did
[2-5 bullet points]

## Current state
[What works, what's partially done, what's broken]

## Next steps
[Prioritized list of what to do next]

## Watch out
[Gotchas, known issues, env vars needed, anything the next agent should know]
```

### Automatic pickup (no explicit handoff)

Even without an explicit "handoff" command, both agents should:
1. Pull latest changes before starting work (`git pull --rebase --autostash`).
2. Read HANDOFF.md, plan.md, memory.md, devlog.md.
3. Check `git log --oneline -5` to see what the other agent did.
4. Continue from where things left off — do NOT redo completed work.

The Super Agent does this automatically. In Cursor IDE, do a `git pull` if you
suspect the Super Agent pushed changes.

## Session Continuity

Before doing anything:
1. Check `git branch -a` for existing feature branches — checkout the most recent.
2. Read `HANDOFF.md`, `plan.md`, `memory.md`, and `devlog.md` if they exist.
3. Pick up where the last session left off. Do NOT restart completed work.

## Kickoff Phase (New Project)

When you receive the user's first message describing what to build:

1. Acknowledge briefly (1-2 sentences).
2. **Ask 2-3 clarifying questions** before writing code. Even if the prompt is
   detailed, ask about: auth approach, database, design preferences, integrations.
3. Read `handy-skills/` and suggest relevant skills: "I can set up auth, E2E tests,
   error tracking — any of these relevant?"
4. **Only after the user confirms** → create `plan.md` and `memory.md`, then build.

## Default Stack

| Layer | Default |
|---|---|
| Framework | Next.js 15.3.x (App Router) — pin to stable, avoid @latest |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Package manager | pnpm |
| ORM | Drizzle |
| Database | PostgreSQL (or Turso/SQLite if user prefers) |
| Email | Resend |
| Hosting | Vercel |
| Auth | Ask the user |

## Bootstrap Commands

Pin to a stable Next.js version to avoid CVEs in bleeding-edge releases.

```bash
pnpm create next-app@15.3.3 . --ts --tailwind --eslint --app --src-dir --import-alias "@/*"
pnpx shadcn@latest init
pnpm add -D @playwright/test vitest @vitejs/plugin-react @testing-library/react
npx playwright install
```

## Git Protocol

- Branch naming: `feat/{description}` or `T-{task-id}`
- Commit format: `T-{id}: {description}` or `feat: {description}`
- Before pushing: `pnpm build` MUST pass. Fix errors before pushing.
- After pushing: create a PR via `gh pr create` with a structured description (Summary, Changes, Test Plan). Report the PR URL to the user.

## Available Skills (in `handy-skills/`)

When you consult a skill file, mention it in your response so the user knows
what guidance you followed. The user can also ask you to use specific skills.

Read these when relevant to the project:
- `adding-auth` — OAuth, sessions, protected routes
- `adding-e2e-tests` — Playwright setup with page objects
- `writing-tests` — unit/integration test generation
- `database-design` — schema design patterns
- `adding-docker` — containerization
- `adding-stripe` — payments
- `adding-error-tracking` — Sentry setup
- `setting-up-ci` — GitHub Actions CI/CD

## Database (Drizzle + Turso)

Schema lives in `src/lib/db/schema.ts` (or similar). When you modify it:

1. Make your schema changes in `schema.ts`.
2. Run `pnpm db:push` to apply changes to the database — **NOT optional**.
3. If `db:push` needs env vars, load them: `source .env.local && pnpm db:push`
4. Verify with `pnpm build` that the app compiles against the updated schema.
5. Document new tables/columns in `memory.md`.

**NEVER push code with schema changes without running db:push first.**
A schema change without a migration is a guaranteed runtime crash.

- Never modify the database directly — always go through the ORM.
- Add indexes for columns used in WHERE clauses and JOIN conditions.
- Use transactions for operations that modify multiple tables.

## Building

1. Follow the plan. Update `plan.md` as you complete tasks.
2. Test your work — run builds, run tests.
3. **Follow memory.md for all design defaults** — theme, font, mode, border
   radius, and color palette are specified there. Do not deviate.
4. Use shadcn/ui components. Apply the theme from memory.md (not zinc unless
   that's what's specified).
5. **No box-shadow** — do not use `box-shadow` or `shadow-*` utilities by default.
   Use borders (`border`, `ring`) for elevation and separation instead.
6. Components should be in separate files (one responsibility per component).
7. Use TypeScript strictly — proper types, no `any`.

## plan.md Format

```markdown
# Plan

> Project: [Name]
> Last updated: [date]

## Phase 0 — Bootstrap
- [ ] Project scaffolding + test infrastructure
- [ ] Playwright + Vitest configured with smoke tests

## Phase 1 — [Core Feature]
- [ ] T-1.1: [Task]
- [ ] T-1.2: [Task]
```

## memory.md Format

```markdown
# Memory

## Defaults
- Framework: Next.js 15 (App Router)
- Styling: Tailwind CSS
- Components: shadcn/ui
- Theme: dark, zinc palette
- ORM: Drizzle
- Database: Turso (SQLite)
- Auth: NextAuth v5 + GitHub OAuth
- Hosting: Vercel
- Package manager: pnpm

## Tests
- E2E: Playwright (smoke, auth flow, project CRUD)
- Unit: Vitest (utils, API routes)
- CI: GitHub Actions on push

## Design
[Design decisions — layout, colors, typography, component patterns]

## Env Vars
| Variable | Purpose |
|---|---|

## Decisions Log
[Dated entries for architectural choices]
```

The `## Defaults` and `## Tests` sections are parsed by the dashboard sync
pipeline. Use the `key: value` list format so the parser can extract them.
Update these sections whenever the stack or test setup changes.

## devlog.md Format

Append a new entry at the end of each session. Never overwrite existing entries.

```markdown
# Devlog

## YYYY-MM-DD — Session N
- Summary of what was built or changed
- Key decisions and reasoning
- Tests: X E2E passing, Y unit tests added
- Cost: $Z.ZZ (if available)
- Next: what should happen next
```

Before finishing each session:
1. Append a new dated entry to `devlog.md` (create it if missing).
2. Include: what you did, decisions made, test status, and next steps.
3. Commit it with your other changes.

## Communication Style

- Be direct. No filler, no hedging.
- If something won't work, say so.
- Push back on bad ideas.
- One question at a time when clarifying.
- **Super Agent (Slack)**: user reads on phone — keep it SHORT.
- **Cursor IDE**: user is at their desk — more detail is fine, but stay focused.
