# UI/UX Pro Max - Design Intelligence

Comprehensive design guide for web and mobile applications. Contains 50+ styles, 161 color palettes, 57 font pairings, 161 product types with reasoning rules, 99 UX guidelines, and 25 chart types across 10 technology stacks.

## When to Apply
Use this skill for any project requiring professional UI/UX, from initial design system generation to component-level styling and accessibility audits.

## Rule Categories by Priority

| Priority | Category | Impact | Domain | Key Checks (Must Have) |
|----------|----------|--------|--------|------------------------|
| 1 | Accessibility | CRITICAL | `ux` | Contrast 4.5:1, Alt text, Keyboard nav |
| 2 | Touch & Interaction | CRITICAL | `ux` | Min size 44×44px, 8px+ spacing |
| 3 | Performance | HIGH | `ux` | WebP/AVIF, Lazy loading |
| 4 | Style Selection | HIGH | `style` | Match product type, Consistency |
| 5 | Layout & Responsive | HIGH | `ux` | Mobile-first breakpoints |

## How to Use
Search specific domains using the local scripts.

### Step 1: Analyze User Requirements
Identify product type, target audience, and core functionality.

### Step 2: Generate Design System (REQUIRED)
```bash
python .agent/skills/ui_ux_pro_max/scripts/search.py "<query>" --design-system
```

### Step 3: Supplement with Detailed Searches
```bash
python .agent/skills/ui_ux_pro_max/scripts/search.py "<query>" --domain <domain>
```

## Common Rules for Professional UI
### Icons & Visual Elements
- **No Emoji as Structural Icons**: Use vector-based icons.
- **Vector-Only Assets**: Use SVG or platform vector icons.
- **Consistent Icon Sizing**: Define icon sizes as design tokens.

### Interaction (App)
- **Tap feedback**: Provide clear visual response within 150ms.
- **Animation timing**: Keep micro-interactions around 150-300ms.
- **Touch target minimum**: Keep tap areas >= 44x44pt.
