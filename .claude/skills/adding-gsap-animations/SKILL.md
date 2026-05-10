---
name: adding-gsap-animations
description: Add GSAP (GreenSock) animations to a web project. Covers installation, ScrollTrigger, timelines, React/Next.js integration, and performance best practices.
---

# Add GSAP Animations

Use this skill when the user asks to add scroll animations, complex timeline-based animations, or specifically requests GSAP.

## When to Use GSAP vs Framer Motion

- **GSAP** — complex timelines, scroll-driven animations, SVG morphing, fine-grained control, non-React projects, or when you need ScrollTrigger.
- **Framer Motion** — React-native declarative animations, layout animations, shared layout transitions, exit animations, gesture-driven interactions.

## Steps

1. **Install GSAP**

   ```bash
   npm install gsap
   ```

   GSAP 3.12+ includes ScrollTrigger and other plugins in the main package.

2. **Register plugins once** — in your app entry point or a shared module:

   ```ts
   import { gsap } from "gsap";
   import { ScrollTrigger } from "gsap/ScrollTrigger";

   gsap.registerPlugin(ScrollTrigger);
   ```

3. **Basic tween**

   ```ts
   gsap.to(".hero-title", {
     opacity: 1,
     y: 0,
     duration: 0.8,
     ease: "power2.out",
   });
   ```

4. **Timeline for sequenced animations**

   ```ts
   const tl = gsap.timeline({ defaults: { ease: "power3.out", duration: 0.6 } });

   tl.from(".hero-title", { y: 40, opacity: 0 })
     .from(".hero-subtitle", { y: 30, opacity: 0 }, "-=0.3")
     .from(".hero-cta", { scale: 0.9, opacity: 0 }, "-=0.2");
   ```

5. **ScrollTrigger**

   ```ts
   gsap.from(".feature-card", {
     scrollTrigger: {
       trigger: ".feature-card",
       start: "top 80%",
       toggleActions: "play none none reverse",
     },
     y: 60,
     opacity: 0,
     duration: 0.8,
     stagger: 0.15,
   });
   ```

## React / Next.js Integration

GSAP is imperative, so it needs careful lifecycle management in React.

### Pattern: `useGSAP` hook (recommended)

GSAP provides an official React hook:

```bash
npm install @gsap/react
```

```tsx
import { useGSAP } from "@gsap/react";
import { gsap } from "gsap";
import { useRef } from "react";

export function HeroSection() {
  const container = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      gsap.from(".hero-title", { y: 40, opacity: 0, duration: 0.8 });
    },
    { scope: container }
  );

  return (
    <div ref={container}>
      <h1 className="hero-title">Welcome</h1>
    </div>
  );
}
```

`useGSAP` automatically handles cleanup on unmount. The `scope` option restricts selectors to the container ref, preventing conflicts with other components.

### Next.js App Router

- Register plugins in a client component (`"use client"`), not in a server component.
- For global plugin registration, create a `GSAPProvider` client component and wrap your layout.
- ScrollTrigger works with App Router — just ensure the component using it is a client component.

## Stagger Patterns

```ts
gsap.from(".grid-item", {
  y: 40,
  opacity: 0,
  duration: 0.5,
  stagger: {
    each: 0.1,
    from: "start", // "center", "end", "edges", "random"
  },
});
```

## SVG Animation

```ts
import { MorphSVGPlugin } from "gsap/MorphSVGPlugin";
gsap.registerPlugin(MorphSVGPlugin);

gsap.to("#circle", { morphSVG: "#star", duration: 1, ease: "elastic.out(1, 0.3)" });
```

Note: MorphSVGPlugin requires a GSAP Club membership (paid).

## Performance

- Animate `transform` and `opacity` only — these are GPU-composited and don't trigger layout.
- Use `will-change: transform` on animated elements sparingly.
- Use `gsap.set()` for initial states instead of CSS to avoid flash of unstyled content.
- Kill animations on unmount — `useGSAP` handles this automatically, but for manual usage call `tl.kill()` or `ScrollTrigger.getAll().forEach(t => t.kill())`.
- Use `ScrollTrigger.batch()` for large lists instead of individual triggers.

## Accessibility

- Respect `prefers-reduced-motion`:

  ```ts
  const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (prefersReducedMotion) {
    gsap.globalTimeline.timeScale(20); // effectively instant
  }
  ```

- Don't animate content that conveys meaning into/out of visibility without an accessible alternative.

## Notes

- GSAP's free tier covers most use cases. Paid plugins (MorphSVG, SplitText, DrawSVG) need a Club license.
- For scroll-based parallax, use `ScrollTrigger` with `scrub: true`.
- `gsap.context()` is the lower-level cleanup mechanism if you aren't using `@gsap/react`.
- Avoid mixing GSAP and CSS transitions on the same properties — they'll fight.
