---
name: frontend-design
description: Generate distinctive, production-quality UI that avoids the generic AI look. Opinionated creative direction for typography, color, layout, and motion. Complements using-ui-stack (which enforces system rules) — this skill is about making bold aesthetic choices.
user-invocable: true
---

# Frontend Design

Use this skill when building any user-facing UI. It overrides the default "safe" aesthetic that AI-generated code tends to produce — Inter font, purple gradient, white background, grid of cards — and pushes toward distinctive, intentional design.

This skill is about **creative direction**. For design system enforcement (spacing grids, interaction states, z-index scales), use the `using-ui-stack` skill. These two skills complement each other: this one decides *what it looks like*, that one ensures *it's consistent*.

## The Problem

AI models converge on the statistical center of design decisions. Without guidance, every generated landing page looks the same: safe typography, predictable colors, minimal personality. Users now recognize this as "AI-generated."

## Design Philosophy

### 1. Typography is the design

Don't default to Inter/system fonts. Make a deliberate typography choice that sets the tone:

| Mood | Font pairing | Example |
|------|-------------|---------|
| Technical/modern | Space Grotesk + JetBrains Mono | Developer tools, dashboards |
| Editorial/premium | Playfair Display + Source Sans 3 | Content platforms, portfolios |
| Friendly/approachable | DM Sans + DM Mono | Consumer SaaS, onboarding |
| Bold/startup | Satoshi + Inter | Landing pages, pitch decks |
| Minimal/luxury | Cormorant Garamond + Work Sans | E-commerce, brand sites |

Rules:
- Maximum 2 font families per project (one for headings, one for body).
- Use font size contrast aggressively. Hero text at 48–72px, body at 16–18px. The gap creates visual hierarchy.
- Letter-spacing: tighten headings (`-0.02em` to `-0.04em`), loosen small caps and labels (`0.05em` to `0.1em`).
- Line-height: tighter for headings (1.1–1.2), looser for body (1.5–1.75).

### 2. Color with intent

Don't pick colors that "look nice." Pick colors that communicate something.

**Dark backgrounds are not mandatory.** Evaluate whether dark or light serves the content better:
- Dark works for: dashboards, media, developer tools, evening-use apps.
- Light works for: content-heavy pages, documentation, forms, professional tools.

**Build from one anchor color:**
1. Pick one bold primary color that reflects the product's personality.
2. Derive 2–3 supporting tones (lighter/darker variants, one complementary accent).
3. Everything else is neutral (slate/zinc/stone scale).

**Avoid:**
- Rainbow gradients (screams "template").
- Purple-to-blue gradients (the #1 AI-generated design tell).
- More than 3 distinct hues on a page.
- Neon/saturated colors for large surfaces. Reserve high saturation for small accents (badges, CTAs, indicators).

### 3. Layout that breathes

**Generous whitespace.** The most common AI design mistake is cramming too much into too little space. When in doubt, add more padding.

- Hero sections: at least `py-24` / `py-32`. Let the headline breathe.
- Card grids: `gap-6` minimum. Cards need room between them.
- Section spacing: `py-16` to `py-24` between major sections.
- Max content width: `max-w-3xl` for text-heavy content, `max-w-6xl` for mixed layouts.

**Break the grid intentionally.** Not everything needs to be a 3-column card grid:
- Offset layouts (text left, image right offset upward).
- Overlapping elements with negative margins.
- Full-bleed sections alternating with contained sections.
- Asymmetric columns (2/3 + 1/3 instead of 1/2 + 1/2).

### 4. Motion with purpose

Animation should communicate state changes and guide attention, not decorate.

**Entry animations:**
- Fade + slight translate (8–20px) for content entering the viewport.
- Stagger children by 50–100ms for lists and grids.
- Duration: 300–500ms for section reveals, 150–200ms for micro-interactions.

**Interaction feedback:**
- Buttons: subtle scale (1.02–1.05) or background shift on hover. Not both.
- Cards: lift with shadow on hover, or subtle border color change.
- Links: underline animation (width from 0 to 100%) instead of simple color change.

**What NOT to animate:**
- Don't animate everything on scroll. Pick 2–3 key moments per page.
- Don't use bounce/elastic easing on UI elements (feels toy-like). Reserve for playful/game contexts.
- Don't animate layout shifts that cause content reflow.

### 5. Visual texture

Flat design is safe but forgettable. Add subtle texture:

- **Subtle gradients**: not rainbow, but slight gradients on backgrounds (e.g. `from-slate-950 to-slate-900` for dark, `from-white to-slate-50` for light).
- **Grain/noise overlay**: a CSS noise texture at 2–5% opacity adds warmth. Use a pseudo-element with a noise SVG background.
- **Border treatments**: `border-border/50` (semi-transparent borders) feel more refined than solid borders.
- **Shadows with color**: instead of gray box-shadows, tint shadows with the element's color at low opacity.
- **Backdrop blur**: `backdrop-blur-sm` on overlays, nav bars, and floating elements.

### 6. Component personality

Specific guidance for common components:

**Hero sections:**
- One clear CTA. Two max (primary + secondary).
- Headline should be specific and benefit-focused, not generic.
- If using an image/illustration, make it large and intentional, not a small decorative element.

**Navigation:**
- Sticky with backdrop blur. Not fixed-solid.
- Logo + 4–6 links max. Collapse to hamburger early (at `md` breakpoint, not just `sm`).
- Current page indicator: bottom border or background highlight, not just bold text.

**Cards:**
- Consistent border-radius across the project (pick one: `rounded-lg`, `rounded-xl`, or `rounded-2xl`).
- Don't put too much in a card. If it needs more than a title, description, and one action — it's not a card.
- Hover state is mandatory for interactive cards.

**Forms:**
- Labels above inputs, not beside (better for mobile and scanning).
- Input height: at least 44px (touch target).
- Error states: red border + message below the field, not toast/alert.
- Success feedback: inline, near the action that triggered it.

**Footers:**
- Keep it minimal. Logo, key links in columns, legal/copyright.
- Don't repeat the entire navigation in the footer.

## Workflow

1. **Before writing any UI code**, decide:
   - Light or dark base?
   - Font pairing (heading + body)?
   - Primary color + one accent?
   - Overall mood (technical, playful, premium, minimal)?

2. **Build the hero first.** It sets the tone for everything else. Get it right before building other sections.

3. **Review your own output.** After generating a page, ask:
   - Does this look like every other AI-generated page? If yes, what's the distinctive element?
   - Is there enough whitespace?
   - Are there more than 3 colors? Simplify.
   - Would a real designer ship this? What would they change?

4. **Reference real sites** for the target aesthetic. Mention specific design references when discussing direction with the user.

## Anti-Patterns

These are the tells that scream "AI-generated":

- Inter font + purple/violet gradient on white background.
- 3-column card grid with icons as the only layout pattern.
- "Get Started" and "Learn More" as every CTA.
- Identical padding on every section.
- No personality — looks like it could be for any product.
- Gradient text on headings (overused to the point of cliche).
- Decorative SVG blobs in the background.

## Notes

- This skill is opinionated by design. The point is to push away from defaults, not to be neutral.
- When the user has a brand guide or existing design system, follow that instead of these defaults.
- For design system consistency rules (spacing grid, interaction states, z-index), use the `using-ui-stack` skill alongside this one.
- Import fonts via `next/font` in Next.js projects for optimal loading, or Google Fonts CDN otherwise.
