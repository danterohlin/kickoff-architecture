---
name: adding-remotion
description: Create programmatic videos with React using Remotion. Covers project setup, compositions, animations with useCurrentFrame, rendering to MP4, and embedding with the Player component.
---

# Add Remotion Video Creation

Use this skill when the user asks to create videos programmatically, build product demos, animated explainers, release announcement videos, or anything involving React-based video generation.

## When to Use Remotion

- Product demo videos and feature walkthroughs
- Animated release changelogs
- Social media video content (reels, shorts)
- Data visualization videos (animated charts, dashboards)
- Onboarding explainer videos
- Animated README headers or repo previews

## Steps

1. **Scaffold a new project**

   ```bash
   npx create-video@latest my-video --template blank
   ```

   Or add to an existing project:

   ```bash
   npm install remotion @remotion/cli @remotion/player
   ```

2. **Start Remotion Studio** — a browser-based preview at `localhost:3000`:

   ```bash
   npm run dev
   ```

3. **Register compositions** in `src/Root.tsx`:

   ```tsx
   import { Composition } from "remotion";
   import { ProductDemo } from "./ProductDemo";

   export const RemotionRoot = () => {
     return (
       <Composition
         id="ProductDemo"
         component={ProductDemo}
         durationInFrames={300}
         fps={30}
         width={1920}
         height={1080}
       />
     );
   };
   ```

   Every composition needs: `width`, `height`, `durationInFrames`, and `fps`.

4. **Build a video component** using `useCurrentFrame` and `interpolate`:

   ```tsx
   import { useCurrentFrame, interpolate, Img, AbsoluteFill } from "remotion";

   export const ProductDemo = () => {
     const frame = useCurrentFrame();

     const titleOpacity = interpolate(frame, [0, 30], [0, 1], {
       extrapolateRight: "clamp",
     });

     const titleY = interpolate(frame, [0, 30], [40, 0], {
       extrapolateRight: "clamp",
     });

     return (
       <AbsoluteFill style={{ backgroundColor: "#0a0a0a" }}>
         <h1
           style={{
             color: "white",
             fontSize: 72,
             opacity: titleOpacity,
             transform: `translateY(${titleY}px)`,
           }}
         >
           Your Product
         </h1>
       </AbsoluteFill>
     );
   };
   ```

5. **Render to MP4**:

   ```bash
   npx remotion render ProductDemo out/demo.mp4
   ```

## Core API

### `useCurrentFrame()`

Returns the current frame number (0-indexed). This is the foundation of all animation — derive every visual property from the frame number.

### `interpolate(frame, inputRange, outputRange, options?)`

Maps frame numbers to values. The workhorse for animation:

```tsx
const opacity = interpolate(frame, [0, 30], [0, 1], { extrapolateRight: "clamp" });
const scale = interpolate(frame, [30, 60], [0.8, 1], { extrapolateRight: "clamp" });
const rotation = interpolate(frame, [0, 90], [0, 360]);
```

Always use `extrapolateRight: "clamp"` unless you intentionally want values to keep growing past the input range.

### `spring({ frame, fps, config? })`

Physics-based animation for natural-feeling motion:

```tsx
import { spring, useCurrentFrame, useVideoConfig } from "remotion";

const { fps } = useVideoConfig();
const scale = spring({ frame, fps, config: { damping: 12, stiffness: 200 } });
```

### `<Sequence>` — timing sections

```tsx
import { Sequence } from "remotion";

export const MyVideo = () => (
  <AbsoluteFill>
    <Sequence from={0} durationInFrames={60}>
      <TitleCard />
    </Sequence>
    <Sequence from={60} durationInFrames={120}>
      <DemoSection />
    </Sequence>
    <Sequence from={180}>
      <CallToAction />
    </Sequence>
  </AbsoluteFill>
);
```

Each `<Sequence>` resets `useCurrentFrame()` to 0 within its children, making sections composable.

### `<Series>` — sequential sections without manual offset math

```tsx
import { Series } from "remotion";

export const MyVideo = () => (
  <Series>
    <Series.Sequence durationInFrames={60}>
      <TitleCard />
    </Series.Sequence>
    <Series.Sequence durationInFrames={120}>
      <DemoSection />
    </Series.Sequence>
    <Series.Sequence durationInFrames={90}>
      <CallToAction />
    </Series.Sequence>
  </Series>
);
```

## Embedding in a Web App

Use `@remotion/player` to embed interactive video in your site:

```tsx
import { Player } from "@remotion/player";
import { ProductDemo } from "./ProductDemo";

export function VideoPlayer() {
  return (
    <Player
      component={ProductDemo}
      durationInFrames={300}
      fps={30}
      compositionWidth={1920}
      compositionHeight={1080}
      style={{ width: "100%" }}
      controls
      autoPlay
      loop
    />
  );
}
```

The Player is a regular React component — it works in Next.js, Vite, or any React app. It does not require ffmpeg or server-side rendering.

## Common Patterns

### Staggered text reveal

```tsx
const words = ["Build", "Ship", "Scale"];

return (
  <AbsoluteFill>
    {words.map((word, i) => {
      const delay = i * 15;
      const opacity = interpolate(frame, [delay, delay + 20], [0, 1], {
        extrapolateLeft: "clamp",
        extrapolateRight: "clamp",
      });
      return (
        <span key={word} style={{ opacity, fontSize: 64, color: "white" }}>
          {word}
        </span>
      );
    })}
  </AbsoluteFill>
);
```

### Screen recording overlay

```tsx
import { Video, Sequence } from "remotion";

export const DemoWithOverlay = () => (
  <AbsoluteFill>
    <Video src="https://example.com/screen-recording.mp4" />
    <Sequence from={60}>
      <div style={{ position: "absolute", bottom: 40, left: 40 }}>
        <CalloutBubble text="Click here to configure" />
      </div>
    </Sequence>
  </AbsoluteFill>
);
```

### Data-driven charts

Pass props to compositions via `defaultProps` or `calculateMetadata` for dynamic content like charts, metrics, or user-specific videos.

## Resolution Presets

| Format | Width | Height | FPS | Use case |
|--------|-------|--------|-----|----------|
| 1080p landscape | 1920 | 1080 | 30 | YouTube, product demos |
| 1080p portrait | 1080 | 1920 | 30 | Instagram Reels, TikTok |
| Square | 1080 | 1080 | 30 | Social media posts |
| 4K | 3840 | 2160 | 30 | High-quality presentations |

## Cloud Rendering

For serverless rendering at scale, use `@remotion/lambda`:

```bash
npm install @remotion/lambda
```

This renders videos on AWS Lambda, useful for generating personalized videos per user or batch rendering.

## Notes

- Remotion uses React 19. Each frame is a React render — keep components pure and deterministic.
- Don't use `useState` or `useEffect` for animation state. Derive everything from `useCurrentFrame()`.
- Use `staticFile()` to reference assets in the `public/` folder.
- Remotion requires a license for companies with revenue > $1M. Free for individuals and small companies.
- For Next.js integration, the Player works client-side only — mark it `"use client"`.
