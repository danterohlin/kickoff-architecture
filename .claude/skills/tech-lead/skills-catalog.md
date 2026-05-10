# Skills Catalog

Reference for the tech lead during planning. Match the project's needs to
available community skills and suggest relevant ones to the user.

Source: https://github.com/spencerpauly/awesome-cursor-skills
Local copy: `handy-skills/` in the workspace root.
Install: copy the skill folder from `handy-skills/resources/<name>/` to `.cursor/skills/<name>/`

---

## "We need to verify things actually work"

| Skill | What it does |
|---|---|
| `visual-qa-testing` | Screenshot, console errors, network audit after changes |
| `verifying-in-browser` | Start dev server, open app, verify rendering side-by-side |
| `form-testing` | Submit every form with valid/invalid data, verify validation and error states |
| `responsive-testing` | Screenshot at mobile, tablet, desktop — flag layout breakage |
| `dark-mode-testing` | Toggle light/dark, screenshot both, flag missing tokens |
| `accessibility-auditing` | Audit labels, tab order, ARIA, contrast issues |
| `grinding-until-pass` | Auto-iterate: fix, run, check, repeat until tests pass |

## "We need good test coverage"

| Skill | What it does |
|---|---|
| `adding-e2e-tests` | Playwright setup with page objects, fixtures, and CI |
| `writing-tests` | Analyze code, generate unit/integration tests with edge cases |
| `parallel-test-fixing` | Fix multiple failing tests in parallel via subagents |
| `api-smoke-testing` | Discover API routes, hit every endpoint, report errors |

## "We need authentication"

| Skill | What it does |
|---|---|
| `adding-auth` | OAuth login, session management, protected routes (Auth.js) |

## "We need payments"

| Skill | What it does |
|---|---|
| `adding-stripe` | Checkout, subscriptions, webhooks, customer portal |

## "We want analytics or feature flags"

| Skill | What it does |
|---|---|
| `adding-analytics` | PostHog events, page views, feature flags, session replay |
| `adding-feature-flags` | Gradual rollouts and A/B testing |
| `posthog-llm-analytics` | LLM call instrumentation: tokens, latency, cost tracking |

## "We need error monitoring"

| Skill | What it does |
|---|---|
| `adding-error-tracking` | Sentry crash reporting, performance monitoring, source maps |

## "We care about UI quality"

| Skill | What it does |
|---|---|
| `shadcn-ui` | Add, search, debug, style, compose shadcn components |
| `anthropic-frontend-design` | Polished, production-ready UI with consistent styling |
| `using-ui-stack` | Design system enforcement: 8px grid, tokens, dark mode |
| `vercel-react-best-practices` | 40+ rules for React/Next.js performance |
| `vercel-web-design-guidelines` | UI code auditing for accessibility, UX, performance |
| `vercel-composition-patterns` | Component composition, code splitting, server/client boundaries |
| `converting-css-to-tailwind` | Convert CSS stylesheets to Tailwind utility classes |

## "We need clean PRs and CI"

| Skill | What it does |
|---|---|
| `babysitting-pr` | Monitor PR for CI failures and review comments, auto-fix |
| `creating-pr` | Clean PRs with conventional titles and structured descriptions |
| `setting-up-ci` | GitHub Actions pipeline: lint, test, type-check, deploy |
| `parallel-ci-triage` | Fetch failing CI logs, fix each job in parallel |

## "We need infrastructure"

| Skill | What it does |
|---|---|
| `adding-docker` | Dockerfile, docker-compose, .dockerignore |
| `setting-up-terraform` | IaC with modules, remote state, CI integration |
| `kubernetes-deploying` | Deployments, Services, Ingress, autoscaling |

## "We need code quality and security"

| Skill | What it does |
|---|---|
| `reviewing-code` | Code review: correctness, performance, best practices |
| `auditing-security` | OWASP Top 10, secrets exposure, insecure patterns |
| `auditing-performance` | Bundle size, rendering, DB queries, Core Web Vitals |

## "We need documentation"

| Skill | What it does |
|---|---|
| `adding-api-docs` | OpenAPI/Swagger docs with interactive UI |
| `architecture-decision-records` | Document technical decisions as ADRs |

## "We want the agent to improve itself"

| Skill | What it does |
|---|---|
| `suggesting-cursor-rules` | Auto-suggest rules when you keep correcting the agent |
| `suggesting-cursor-hooks` | Auto-suggest hooks for repeated checks |
| `building-skills-from-patterns` | Turn repeated workflows into reusable skills |

## "We need database design help"

| Skill | What it does |
|---|---|
| `database-design` | Schema design: tables, relationships, indexes, ORM setup |

## "We need SEO"

| Skill | What it does |
|---|---|
| `seo-auditing` | Meta tags, structured data, Open Graph, sitemaps |
| `seo-analysis` | Full SEO audit with prioritized 30-day action plan |

## "We need debugging help"

| Skill | What it does |
|---|---|
| `systematic-debugging` | Structured debugging: reproduce, isolate, hypothesize, verify |
| `monitoring-terminal-errors` | Watch for crashes, navigate to failing file, auto-fix |
| `detecting-port-conflicts` | Detect EADDRINUSE, find what's using the port, resolve |
