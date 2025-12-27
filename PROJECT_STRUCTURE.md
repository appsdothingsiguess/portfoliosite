# Work Portfolio - Project Structure

## Overview
Professional portfolio website built with **Astro** (static site generator) using **Tailwind CSS** for styling. The project follows a content-driven architecture with markdown-based content collections.

---

## Root Directory Structure

```
Work Portfolio/
│
├── docs/                          # 📚 Documentation & Design Guides
│   └── branding-guide-professional.html
│
├── portfolio/                     # 🚀 Main Astro Application
│   ├── astro.config.mjs          # Astro configuration (Vite, Tailwind, build settings)
│   ├── package.json              # Dependencies & npm scripts
│   ├── package-lock.json         # Locked dependency versions
│   ├── postcss.config.mjs        # PostCSS configuration (Tailwind processing)
│   ├── tailwind.config.mjs       # Tailwind CSS theme & design tokens
│   │
│   ├── src/                      # ✅ PRIMARY SOURCE DIRECTORY (Active)
│   │   ├── content/              # Content collections (Astro Content Collections)
│   │   │   ├── config.ts         # Collection schemas (journalism, research, leadership, business)
│   │   │   ├── journalism/       # Journalism work samples
│   │   │   │   ├── biola_sex_update.md
│   │   │   │   ├── Closure of Dwelling.md
│   │   │   │   ├── Dwelling_Investgation.md
│   │   │   │   ├── instagram-example.md
│   │   │   │   ├── SGA_Senate_recap.md
│   │   │   │   └── Visa_revoked copy 2.md
│   │   │   ├── research/         # Research projects & posters
│   │   │   │   └── wpa25.md
│   │   │   ├── leadership/       # Leadership roles
│   │   │   │   └── thechimes.md
│   │   │   └── Business/         # Business ventures
│   │   │       └── spezzllc.md
│   │   │
│   │   ├── layouts/              # Astro layout components
│   │   │   └── BaseLayout.astro  # Base page layout wrapper
│   │   │
│   │   ├── pages/                # Astro pages (file-based routing)
│   │   │   └── index.astro       # Homepage/landing page (446 lines - refactoring planned)
│   │   │
│   │   ├── styles/               # Global stylesheets
│   │   │   └── global.css        # CSS custom properties, Tailwind directives (156 lines)
│   │   │
│   │   └── env.d.ts              # TypeScript environment definitions
│   │
│   └── node_modules/             # Dependencies (gitignored)
│
├── .cursor/                       # 🤖 Cursor IDE Configuration
│   ├── rules/                    # Workspace rules & guidelines
│   │   ├── architecture.mdc      # Architecture patterns
│   │   ├── branding-guide.mdc    # Design system rules
│   │   ├── branding.mdc          # Brand guidelines
│   │   ├── coding-standards.mdc  # Code style & conventions
│   │   ├── debug.mdc             # Debugging practices
│   │   ├── defensive-programming.mdc  # Safety patterns
│   │   ├── logging.mdc           # Logging standards
│   │   ├── project-structure.mdc # Project structure & tech stack constraints
│   │   └── server-access.mdc     # Server deployment procedures
│   └── refactoring-analysis.md   # 📋 Refactoring plan & component breakdown
│
└── features.mdc                   # Feature documentation
```

---

## Key Directories Explained

### `/portfolio/src/` - Primary Source Directory
**Status:** ✅ Active (Astro standard structure)

This is the main working directory where all active development occurs. Astro automatically processes files in this directory.

#### `/portfolio/src/content/`
- **Purpose:** Content Collections (Astro's content management system)
- **Format:** Markdown files with frontmatter
- **Schema:** Defined in `config.ts` using Zod validation
- **Collections:**
  - `journalism/` - Articles, social media content, videos
  - `research/` - Research projects, posters, abstracts
  - `leadership/` - Leadership roles and positions
  - `Business/` - Business ventures and operations

#### `/portfolio/src/components/` 🆕
- **Purpose:** Reusable Astro components (planned refactoring)
- **Status:** Directory to be created during refactoring
- **Components:**
  - `Navigation.astro` - Site navigation bar (~20 lines)
  - `Hero.astro` - Hero section with dynamic content (~70 lines)
  - `TechnicalSkills.astro` - Technical skills display (~15 lines)
  - `ResearchSection.astro` - Research projects section (~80 lines)
  - `LeadershipSection.astro` - Operations & leadership section (~60 lines)
  - `JournalismSection.astro` - Journalism & media section (~75 lines)
  - `ContactSection.astro` - Contact and footer section (~20 lines)
  - `PosterModal.astro` - Research poster modal dialog (~20 lines)

#### `/portfolio/src/scripts/` 🆕
- **Purpose:** Client-side JavaScript files (planned refactoring)
- **Status:** Directory to be created during refactoring
- **Files:**
  - `sticky-chameleon.js` - Dynamic hero content script (~65 lines)

#### `/portfolio/src/layouts/`
- **Purpose:** Reusable page layout components
- **Files:** `BaseLayout.astro` (51 lines) - Wraps pages with common HTML structure, meta tags, navigation

#### `/portfolio/src/pages/`
- **Purpose:** File-based routing (Astro convention)
- **Files:** `index.astro` (446 lines) - Homepage route (`/`)
  - **Status:** ⚠️ Close to 500-line limit, refactoring planned
  - **Plan:** Extract sections into components, reduce to ~80 lines
- **Note:** Each `.astro` file in this directory becomes a route

#### `/portfolio/src/styles/`
- **Purpose:** Global CSS styles
- **Files:** `global.css` (156 lines) - CSS custom properties (design tokens), Tailwind directives

---

### `/docs/` - Documentation
- **Purpose:** Project documentation and design references
- **Files:** `branding-guide-professional.html` - Design system reference (color tokens, typography, components)

---

---

## Configuration Files

### `/portfolio/astro.config.mjs`
- **Purpose:** Astro framework configuration
- **Key Settings:**
  - Output: `static` (generates static HTML/CSS/JS)
  - Integration: Tailwind CSS
  - Build format: `directory` (SEO-friendly URLs)
  - HTML compression: Enabled

### `/portfolio/tailwind.config.mjs`
- **Purpose:** Tailwind CSS theme configuration
- **Features:**
  - Custom color tokens mapped to CSS variables
  - Custom font families (Newsreader serif, Inter sans)
  - Custom animations (sweep, flash-focus)
  - Content paths: `./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}`

### `/portfolio/postcss.config.mjs`
- **Purpose:** PostCSS processing pipeline
- **Plugins:** Tailwind CSS, Autoprefixer

### `/portfolio/package.json`
- **Name:** `joseph-abboud-portfolio`
- **Type:** ES Module
- **Scripts:**
  - `npm run dev` - Development server
  - `npm run build` - Production build
  - `npm run preview` - Preview production build locally
- **Dependencies:**
  - `astro` - Framework
  - `@astrojs/tailwind` - Tailwind integration
  - `tailwindcss` - CSS framework
  - `lucide` - Icon library
  - `typescript` - Type checking
  - `@astrojs/check` - Astro type checking

---

## Content Collections Schema

### Journalism Collection
```typescript
{
  title: string
  publication: string
  date: Date
  url?: string (URL)
  type: 'Article' | 'Social' | 'Video' | 'Multimedia'
  impact?: string
  summary: string
}
```

### Research Collection
```typescript
{
  title: string
  role: string
  conference?: string
  date: Date
  tools: string[]
  posterUrl?: string
  methodology?: string
  findings?: string[]
}
```

### Leadership Collection
```typescript
{
  organization: string
  role: string
  dateStart: Date
  dateEnd?: Date
  metrics?: Array<{ value: string, label: string }>
  tags?: string[]
  summary: string
}
```

### Business Collection
```typescript
{
  organization: string
  role: string
  dateStart: Date
  dateEnd?: Date
  metrics?: Array<{ value: string, label: string }>
  tags?: string[]
  summary: string
}
```

---

## Build Output

When running `npm run build`, Astro generates:
- **Location:** `/portfolio/dist/` (created during build)
- **Contents:** Static HTML, CSS, and JavaScript files
- **Format:** Directory-based routing (e.g., `/about/` → `/dist/about/index.html`)

---

## Technology Stack

- **Framework:** Astro 5.16.6
- **Styling:** Tailwind CSS 3.4.0
- **Icons:** Lucide 0.469.0
- **Language:** TypeScript 5.3.3
- **Build Tool:** Vite (via Astro)
- **CSS Processing:** PostCSS + Autoprefixer

---

## Development Workflow

1. **Development:** `npm run dev` - Starts local dev server
2. **Content:** Add markdown files to `/portfolio/src/content/{collection}/`
3. **Pages:** Create `.astro` files in `/portfolio/src/pages/`
4. **Styles:** Edit `/portfolio/src/styles/global.css` or use Tailwind classes
5. **Build:** `npm run build` - Generates static site in `/portfolio/dist/`
6. **Preview:** `npm run preview` - Test production build locally

---

## Design System Reference

**Source of Truth:** `/docs/branding-guide-professional.html`

- **Colors:** CSS custom properties (`--brand`, `--surface`, `--text`, etc.)
- **Typography:** Newsreader (serif headings), Inter (sans body)
- **Components:** Buttons, cards, pills/tags, form fields
- **Accessibility:** WCAG 1.4.3 contrast minimums, visible focus indicators

---

## Code Organization & Refactoring

### File Size Standards
- **Maximum file size:** 500 lines
- **Current status:**
  - `index.astro`: 446 lines ⚠️ (close to limit, refactoring planned)
  - `global.css`: 156 lines ✅
  - `BaseLayout.astro`: 51 lines ✅
  - `config.ts`: 74 lines ✅

### Planned Refactoring
The `index.astro` file will be refactored into smaller, reusable components:

**Phase 1 (High Priority):**
- Extract `Navigation.astro`, `ContactSection.astro`, `PosterModal.astro`, `TechnicalSkills.astro`

**Phase 2 (Medium Priority):**
- Extract `ResearchSection.astro`, `LeadershipSection.astro`, `JournalismSection.astro`

**Phase 3 (Lower Priority):**
- Extract `Hero.astro`, `sticky-chameleon.js`

**Result:** `index.astro` reduced from 446 → ~80 lines

See `.cursor/refactoring-analysis.md` for detailed breakdown.

## Notes & Warnings

✅ **Active Structure:** All development should occur in `/portfolio/src/` directory.

📝 **Content Collections:** Use the schemas defined in `/portfolio/src/content/config.ts` when creating new content files.

🔄 **Refactoring:** Components directory (`/portfolio/src/components/`) and scripts directory (`/portfolio/src/scripts/`) will be created during the planned refactoring to improve code organization and maintainability.


