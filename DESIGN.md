---
name: Caja de Herramientas
colors:
  surface: '#121414'
  surface-dim: '#121414'
  surface-bright: '#38393a'
  surface-container-lowest: '#0c0f0f'
  surface-container-low: '#1a1c1c'
  surface-container: '#1e2020'
  surface-container-high: '#282a2b'
  surface-container-highest: '#333535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#cfc6af'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#2f3131'
  outline: '#98907b'
  outline-variant: '#4c4635'
  surface-tint: '#e7c446'
  primary: '#ffe285'
  on-primary: '#3b2f00'
  primary-container: '#e8c547'
  on-primary-container: '#655100'
  inverse-primary: '#725c00'
  secondary: '#c7c6c6'
  on-secondary: '#303031'
  secondary-container: '#464747'
  on-secondary-container: '#b5b5b5'
  tertiary: '#cde7ff'
  on-tertiary: '#00344e'
  tertiary-container: '#8fcfff'
  on-tertiary-container: '#005982'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffe07c'
  primary-fixed-dim: '#e7c446'
  on-primary-fixed: '#231b00'
  on-primary-fixed-variant: '#564500'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#c9e6ff'
  tertiary-fixed-dim: '#8dcdfd'
  on-tertiary-fixed: '#001e2f'
  on-tertiary-fixed-variant: '#004b6f'
  background: '#121414'
  on-background: '#e2e2e2'
  surface-variant: '#333535'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-md:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  margin-mobile: 16px
  margin-desktop: 32px
  gutter: 16px
---

## Brand & Style
The design system focuses on utility and precision, stripping away visual noise to empower the user's workflow. The brand personality is disciplined, functional, and premium. It utilizes a **Minimalist** approach with subtle **Tonal Layering**, where depth is communicated through slight color shifts rather than heavy shadows. 

The emotional response should be one of "quiet confidence"—the interface stays out of the way until needed. A single golden accent is used with extreme intentionality to guide the eye toward the "Golden Path" of the user experience.

## Colors
The palette is built on a foundation of sophisticated neutrals to maintain a professional, tool-like aesthetic. 

- **Primary Accent:** Gold is reserved strictly for primary calls-to-action, active selection states, and critical progress indicators.
- **Surface Strategy:** We use three distinct levels of surface to define hierarchy: the base background, the card level for grouping, and the elevated level for interactive inputs or modals.
- **Borders:** A consistent 0.5px border is applied to cards and inputs to provide definition without adding weight, particularly in the dark mode where contrast is tighter.

## Typography
The system utilizes **Inter** for its neutral, neo-grotesque clarity and excellent legibility at small sizes. 

- **Hierarchy:** Use `display-lg` sparingly for hero sections. Headlines should use a semi-bold weight to stand out against the minimalist background.
- **Labels:** Small labels use a slight tracking increase (letter-spacing) and uppercase styling to differentiate them from body text without requiring a change in color or weight.
- **Scale:** On mobile devices, large headlines scale down to ensure content remains above the fold while maintaining the same weight and rhythmic balance.

## Layout & Spacing
The layout follows a **fluid grid** logic with a strict 8px baseline rhythm. 

- **Safe Areas:** Standard mobile margins are set at 16px. On wider screens, margins increase to 32px to prevent line lengths from becoming too long for comfortable reading.
- **Rhythm:** Elements within a card should use `sm` (12px) spacing, while the vertical distance between cards should be `md` (16px) or `lg` (24px) to create clear visual groupings.
- **Reflow:** For tablet and desktop, cards should transition from a single-column list to a multi-column masonry or grid layout depending on the complexity of the tool's data.

## Elevation & Depth
This design system avoids traditional drop shadows in favor of **Tonal Layers** and **Subtle Outlines**. 

- **Layering:** Hierarchy is achieved by moving from darker backgrounds to lighter surfaces (in dark mode) or lighter backgrounds to pure white surfaces (in light mode).
- **Outlines:** Every card and input uses a 0.5px border (`border` color token). This provides a "sharp" tactile feel that aligns with the "Toolbox" theme.
- **Interaction:** Upon press/touch, elements should not rise (shadow), but rather shift in background color to the `elevated` token or show a subtle inner-glow of the `accent` color.

## Shapes
The shape language is "Mixed Geometric." We use distinct radii to categorize UI elements:

- **Containers (16px):** Large radius for cards and modals to create a welcoming, modern frame for content.
- **Actions (12px):** Slightly tighter radius for buttons and inputs, making them feel precise and easily tappable.
- **Tags/Status (50px):** Full pill-shape for chips and tags to distinguish them clearly from interactive buttons.

## Components
Consistent component behavior is vital for a minimalist system.

- **Buttons:** Primary buttons use the `accent` background with dark text. Secondary buttons use a ghost style with a 0.5px border. Use 12px padding for vertical and 24px for horizontal.
- **Inputs:** Fields use the `elevated` background color with a 12px radius. The border color should switch to `accent` only when the field is focused.
- **Chips:** Always pill-shaped (50px). Active chips use the `accent` color with 10% opacity for the background and the full `accent` color for the label text.
- **Lists:** Use `md` (16px) vertical padding. Separators should be 0.5px using the `border` color, inset by the margin width to avoid touching the screen edges.
- **Animations:** Use "Ease-Out-Expo" for transitions. Page entries should use a subtle 20px vertical slide with a simultaneous fade-in. Micro-interactions (like checkbox toggles) should feel snappy (150ms-200ms).