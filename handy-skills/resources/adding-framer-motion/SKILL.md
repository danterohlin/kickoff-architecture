---
name: adding-framer-motion
description: Add Framer Motion animations to a React/Next.js project. Covers installation, common patterns, layout animations, exit animations, scroll-triggered animations, and performance best practices.
---

# Add Framer Motion Animations

Use this skill when the user asks to add animations to a React or Next.js project using Framer Motion (now `motion`).

## When to Use Framer Motion vs GSAP

- **Framer Motion** — declarative React animations, layout transitions, shared element transitions, AnimatePresence exit animations, gesture-driven interactions.
- **GSAP** — complex timelines, scroll-driven animations with scrub, SVG morphing, fine-grained imperative control, non-React projects.

## Steps

1. **Install**

   ```bash
   npm install motion
   ```

   The package was renamed from `framer-motion` to `motion`. Both work, but `motion` is the current name.

2. **Basic animation**

   ```tsx
   import { motion } from "motion/react";

   export function FadeIn({ children }: { children: React.ReactNode }) {
     return (
       <motion.div
         initial={{ opacity: 0, y: 20 }}
         animate={{ opacity: 1, y: 0 }}
         transition={{ duration: 0.5, ease: "easeOut" }}
       >
         {children}
       </motion.div>
     );
   }
   ```

3. **Exit animations with AnimatePresence**

   ```tsx
   import { AnimatePresence, motion } from "motion/react";

   export function Modal({ isOpen, children }: { isOpen: boolean; children: React.ReactNode }) {
     return (
       <AnimatePresence>
         {isOpen && (
           <motion.div
             key="modal"
             initial={{ opacity: 0, scale: 0.95 }}
             animate={{ opacity: 1, scale: 1 }}
             exit={{ opacity: 0, scale: 0.95 }}
             transition={{ duration: 0.2 }}
           >
             {children}
           </motion.div>
         )}
       </AnimatePresence>
     );
   }
   ```

4. **Scroll-triggered animations**

   ```tsx
   import { motion } from "motion/react";

   export function ScrollReveal({ children }: { children: React.ReactNode }) {
     return (
       <motion.div
         initial={{ opacity: 0, y: 40 }}
         whileInView={{ opacity: 1, y: 0 }}
         viewport={{ once: true, margin: "-100px" }}
         transition={{ duration: 0.6, ease: "easeOut" }}
       >
         {children}
       </motion.div>
     );
   }
   ```

5. **Staggered children**

   ```tsx
   const containerVariants = {
     hidden: {},
     visible: {
       transition: { staggerChildren: 0.1 },
     },
   };

   const itemVariants = {
     hidden: { opacity: 0, y: 20 },
     visible: { opacity: 1, y: 0, transition: { duration: 0.4 } },
   };

   export function StaggeredList({ items }: { items: string[] }) {
     return (
       <motion.ul variants={containerVariants} initial="hidden" animate="visible">
         {items.map((item) => (
           <motion.li key={item} variants={itemVariants}>
             {item}
           </motion.li>
         ))}
       </motion.ul>
     );
   }
   ```

## Layout Animations

Framer Motion's killer feature — animate between layout states automatically:

```tsx
<motion.div layout transition={{ type: "spring", stiffness: 300, damping: 30 }}>
  {isExpanded ? <ExpandedContent /> : <CollapsedContent />}
</motion.div>
```

### Shared layout animations

Use `layoutId` to animate an element between different components/positions:

```tsx
{items.map((item) => (
  <motion.div key={item.id} layoutId={item.id} onClick={() => setSelected(item)}>
    <Card item={item} />
  </motion.div>
))}

{selected && (
  <motion.div layoutId={selected.id} className="expanded-card">
    <ExpandedCard item={selected} />
  </motion.div>
)}
```

## Gestures

```tsx
<motion.button
  whileHover={{ scale: 1.05 }}
  whileTap={{ scale: 0.95 }}
  transition={{ type: "spring", stiffness: 400, damping: 17 }}
>
  Click me
</motion.button>
```

### Drag

```tsx
<motion.div
  drag
  dragConstraints={{ left: -100, right: 100, top: -50, bottom: 50 }}
  dragElastic={0.2}
/>
```

## Next.js App Router Integration

- `motion` components work in client components only — add `"use client"` to files using them.
- For page transitions, wrap your layout content in `AnimatePresence` with a key based on the route pathname.
- `layout` animations work well with Next.js parallel routes and intercepting routes.

### Page transitions pattern

```tsx
"use client";

import { AnimatePresence, motion } from "motion/react";
import { usePathname } from "next/navigation";

export function PageTransition({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={pathname}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}
```

## Reusable Animation Variants

Create a shared variants file to keep animations consistent:

```ts
export const fadeInUp = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  transition: { duration: 0.5, ease: "easeOut" },
};

export const staggerContainer = {
  animate: { transition: { staggerChildren: 0.1 } },
};

export const scaleIn = {
  initial: { opacity: 0, scale: 0.9 },
  animate: { opacity: 1, scale: 1 },
  transition: { type: "spring", stiffness: 300, damping: 25 },
};
```

## Performance

- Framer Motion animates `transform` and `opacity` by default — these are GPU-composited.
- Use `layout="position"` instead of `layout={true}` when you only need to animate position (not size) to avoid expensive layout recalculations.
- Avoid animating `width`, `height`, or `top`/`left` — use `transform` equivalents.
- For lists with many items, consider `LazyMotion` to reduce bundle size:

  ```tsx
  import { LazyMotion, domAnimation, m } from "motion/react";

  export function App() {
    return (
      <LazyMotion features={domAnimation}>
        <m.div animate={{ opacity: 1 }} />
      </LazyMotion>
    );
  }
  ```

- `LazyMotion` with `domAnimation` covers most use cases. Use `domMax` only if you need layout animations or drag.

## Accessibility

- Respect `prefers-reduced-motion`:

  ```tsx
  import { useReducedMotion } from "motion/react";

  export function AnimatedCard({ children }: { children: React.ReactNode }) {
    const shouldReduceMotion = useReducedMotion();

    return (
      <motion.div
        initial={{ opacity: 0, y: shouldReduceMotion ? 0 : 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: shouldReduceMotion ? 0 : 0.5 }}
      >
        {children}
      </motion.div>
    );
  }
  ```

- Don't use motion to hide content that screen readers need access to — animate visual properties, not DOM presence.

## Notes

- The package is `motion` (not `framer-motion`) since v11. Import from `motion/react`.
- `AnimatePresence` requires direct children to have unique `key` props.
- Spring physics (`type: "spring"`) generally feels more natural than duration-based easing for UI interactions.
- For scroll-linked animations (parallax, progress bars), use `useScroll` and `useTransform`:

  ```tsx
  const { scrollYProgress } = useScroll();
  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  ```
