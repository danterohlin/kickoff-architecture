---
name: generating-diagrams
description: Generate architecture diagrams, sequence diagrams, and flow charts as Excalidraw files from natural language descriptions. Outputs .excalidraw JSON that can be opened in Excalidraw or rendered to PNG.
---

# Generate Diagrams

Use this skill when the user asks for architecture diagrams, system design visuals, sequence diagrams, data flow diagrams, or any technical illustration that should live alongside the code.

## Output Format

Generate `.excalidraw` JSON files. These can be:
- Opened directly at [excalidraw.com](https://excalidraw.com) or in the VS Code Excalidraw extension
- Committed to the repo as living documentation
- Exported to PNG/SVG for docs or presentations

## Excalidraw JSON Structure

An `.excalidraw` file is JSON with this shape:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "agent-generated",
  "elements": [],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 20
  }
}
```

Every visual element lives in the `elements` array.

## Element Types

### Rectangle (services, databases, components)

```json
{
  "type": "rectangle",
  "id": "svc-api",
  "x": 100,
  "y": 100,
  "width": 200,
  "height": 80,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "#a5d8ff",
  "fillStyle": "solid",
  "roundness": { "type": 3 },
  "roughness": 1
}
```

### Text (labels)

```json
{
  "type": "text",
  "id": "label-api",
  "x": 140,
  "y": 125,
  "text": "API Gateway",
  "fontSize": 20,
  "fontFamily": 1,
  "textAlign": "center"
}
```

`fontFamily`: 1 = Virgil (hand-drawn), 2 = Helvetica, 3 = Cascadia (mono).

### Arrow (connections, data flow)

```json
{
  "type": "arrow",
  "id": "arrow-1",
  "x": 300,
  "y": 140,
  "width": 150,
  "height": 0,
  "points": [[0, 0], [150, 0]],
  "startBinding": { "elementId": "svc-api", "focus": 0, "gap": 5 },
  "endBinding": { "elementId": "svc-auth", "focus": 0, "gap": 5 },
  "endArrowhead": "arrow"
}
```

Use `startBinding`/`endBinding` to connect arrows to shapes. The `focus` value (-1 to 1) controls where the arrow attaches on the element edge.

### Ellipse (actors, external systems)

```json
{
  "type": "ellipse",
  "id": "actor-user",
  "x": 50,
  "y": 200,
  "width": 80,
  "height": 80
}
```

### Diamond (decision points, conditionals)

```json
{
  "type": "diamond",
  "id": "decision-1",
  "x": 300,
  "y": 300,
  "width": 120,
  "height": 120
}
```

## Design Principles

When generating diagrams, follow these rules:

### Layout

- **Flow direction**: left-to-right for request flows, top-to-bottom for hierarchies.
- **Grid alignment**: snap to a 20px grid. Use consistent spacing (e.g. 60px gap between nodes).
- **Grouping**: cluster related components visually. Leave more space between groups than within them.
- **Fan-out**: use fan-out layouts for one-to-many relationships (one node at top, multiple below).

### Visual hierarchy

- **Primary nodes** (the main subject): larger rectangles, filled background color.
- **Secondary nodes** (supporting services): smaller, lighter fill or outline only.
- **External systems**: dashed borders or ellipses to distinguish from internal components.
- **Data stores**: use the cylinder convention (rectangle with rounded top) or label clearly as "DB".

### Arrows and labels

- Every arrow should have a label describing what flows through it (e.g. "REST /api/users", "gRPC", "WebSocket", "events").
- Use different arrow styles for different communication types: solid for synchronous, dashed for async/events.
- Arrow labels go on a separate text element positioned near the arrow midpoint.

### Color palette

Use a limited, intentional palette:

| Purpose | Color | Hex |
|---------|-------|-----|
| Primary service | Light blue | `#a5d8ff` |
| Database/storage | Light green | `#b2f2bb` |
| External system | Light gray | `#dee2e6` |
| Warning/attention | Light yellow | `#ffec99` |
| Error/critical path | Light red | `#ffc9c9` |
| Background | White | `#ffffff` |
| Stroke/text | Dark | `#1e1e1e` |

### Hand-drawn style

Set `roughness: 1` for a natural hand-drawn look (Excalidraw's signature style). Use `roughness: 0` only if the user explicitly wants clean/precise lines.

## Diagram Types

### Architecture diagram

Show services, databases, queues, and how they connect. Label every connection with the protocol or data type.

### Sequence diagram

Vertical lifelines for actors/services, horizontal arrows for messages. Time flows top-to-bottom. Number the steps.

### Data flow diagram

Show how data transforms as it moves through the system. Label each transformation step.

### Entity relationship diagram

Tables as rectangles with column lists. Lines for relationships with cardinality labels (1:N, M:N).

## Workflow

1. **Understand the system** — read relevant code, configs, or ask the user what to diagram.
2. **Plan the layout** — decide on diagram type, identify nodes and connections, choose flow direction.
3. **Generate the JSON** — write the `.excalidraw` file with all elements positioned on the grid.
4. **Self-validate** — review the element positions mentally: are things overlapping? Are labels readable? Are arrows connecting the right nodes?
5. **Save to repo** — place in `docs/diagrams/` or alongside the code it documents. Name descriptively: `architecture-overview.excalidraw`, `auth-flow.excalidraw`.

## Programmatic Generation (React)

For embedding or dynamic diagrams, use `@excalidraw/excalidraw`:

```bash
npm install @excalidraw/excalidraw
```

```tsx
import { convertToExcalidrawElements } from "@excalidraw/excalidraw";

const skeletons = [
  { type: "rectangle", x: 100, y: 100, width: 200, height: 80, label: { text: "API" } },
  { type: "rectangle", x: 400, y: 100, width: 200, height: 80, label: { text: "Database" } },
  { type: "arrow", x: 300, y: 140, width: 100, height: 0 },
];

const elements = convertToExcalidrawElements(skeletons);
```

The skeleton API requires only `type`, `x`, `y` at minimum — it fills in all other properties with sensible defaults.

## CLI Export

Use `excalidraw-cli` to convert `.excalidraw` files to PNG/SVG in CI:

```bash
npx excalidraw-cli export diagram.excalidraw --format png --output diagram.png
```

## Notes

- `.excalidraw` files are plain JSON — they diff well in git and are easy to review in PRs.
- Keep diagrams close to the code they document. Stale diagrams are worse than no diagrams.
- For very complex systems, split into multiple focused diagrams rather than one massive one.
- The VS Code Excalidraw extension renders `.excalidraw` files inline in the editor.
