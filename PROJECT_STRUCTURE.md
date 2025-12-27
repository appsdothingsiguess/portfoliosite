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
│   │   │   ├── config.ts         # Collection schemas (journalism, research, leadership)
│   │   │   ├── journalism/       # Journalism work samples
│   │   │   │   └── Example.md
│   │   │   ├── research/         # Research projects & posters
│   │   │   │   └── wpa25.md
│   │   │   └── leadership/       # Business & leadership roles
│   │   │       └── spezzllc.md
│   │   │
│   │   ├── layouts/              # Astro layout components
│   │   │   └── BaseLayout.astro  # Base page layout wrapper
│   │   │
│   │   ├── pages/                # Astro pages (file-based routing)
│   │   │   └── index.astro       # Homepage/landing page
│   │   │
│   │   ├── styles/               # Global stylesheets
│   │   │   └── global.css        # CSS custom properties, Tailwind directives
│   │   │
│   │   └── env.d.ts              # TypeScript environment definitions
│   │
│   ├── content/                  # ⚠️ LEGACY (Duplicate - may be deprecated)
│   │   ├── config.ts
│   │   ├── Business/
│   │   │   └── spezzllc.md
│   │   ├── Journalism/
│   │   │   └── Example.md
│   │   └── Research/
│   │       └── wpa25.md
│   │
│   ├── layouts/                  # ⚠️ LEGACY (Duplicate - may be deprecated)
│   │   └── BaseLayout.astro
│   │
│   ├── pages/                    # ⚠️ LEGACY (Duplicate - may be deprecated)
│   │   └── index.astro
│   │
│   ├── styles/                   # ⚠️ LEGACY (Duplicate - may be deprecated)
│   │   └── global.css
│   │
│   └── node_modules/             # Dependencies (gitignored)
│
├── .cursor/                       # 🤖 Cursor IDE Configuration
│   └── rules/                    # Workspace rules & guidelines
│       ├── architecture.mdc      # Architecture patterns
│       ├── branding-guide.mdc    # Design system rules
│       ├── branding.mdc          # Brand guidelines
│       ├── coding-standards.mdc  # Code style & conventions
│       ├── debug.mdc             # Debugging practices
│       ├── defensive-programming.mdc  # Safety patterns
│       ├── logging.mdc           # Logging standards
│       ├── project-structure.mdc # Project structure (legacy - for different project)
│       └── server-access.mdc     # Server deployment procedures
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
  - `leadership/` - Business ventures, management roles

#### `/portfolio/src/layouts/`
- **Purpose:** Reusable page layout components
- **Files:** `BaseLayout.astro` - Wraps pages with common HTML structure, meta tags, navigation

#### `/portfolio/src/pages/`
- **Purpose:** File-based routing (Astro convention)
- **Files:** `index.astro` - Homepage route (`/`)
- **Note:** Each `.astro` file in this directory becomes a route

#### `/portfolio/src/styles/`
- **Purpose:** Global CSS styles
- **Files:** `global.css` - CSS custom properties (design tokens), Tailwind directives

---

### `/docs/` - Documentation
- **Purpose:** Project documentation and design references
- **Files:** `branding-guide-professional.html` - Design system reference (color tokens, typography, components)

---

### `/portfolio/content/`, `/portfolio/layouts/`, `/portfolio/pages/`, `/portfolio/styles/`
**Status:** ⚠️ Legacy/Duplicate directories

These appear to be duplicate directories at the portfolio root level. The active structure is in `/portfolio/src/`. These may be:
- Legacy files from before migration to `src/` structure
- Backup files
- Files that should be removed or consolidated

**Recommendation:** Verify which files are actually used and consolidate to `/portfolio/src/` structure.

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

## Notes & Warnings

⚠️ **Duplicate Directories:** The portfolio root contains duplicate directories (`content/`, `layouts/`, `pages/`, `styles/`) that mirror `/portfolio/src/`. The active structure is in `/portfolio/src/`. Consider cleaning up legacy files.

✅ **Active Structure:** All development should occur in `/portfolio/src/` directory.

📝 **Content Collections:** Use the schemas defined in `/portfolio/src/content/config.ts` when creating new content files.


