# Portfolio Website

A professional portfolio website built with Astro, featuring a mode-based system that allows content to be reordered and presented differently based on URL parameters.

## Getting Started

### Prerequisites

- **Node.js** (v18 or higher recommended)
- **npm** (comes with Node.js) or **yarn**

### Installation

1. **Navigate to the project directory:**
   ```bash
   cd portfolio
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

### Running the Project

#### Development Server

Start the development server with hot-reload:

```bash
npm run dev
```

Or use the alternative command:

```bash
npm start
```

The site will be available at `http://localhost:4321` (Astro's default port).

**Note:** The dev server automatically reloads when you make changes to files.

#### Building for Production

Build the static site for production:

```bash
npm run build
```

This generates optimized static files in the `dist/` directory.

#### Preview Production Build

Preview the production build locally:

```bash
npm run preview
```

This serves the built site from the `dist/` directory, allowing you to test the production build before deploying.

### Available Scripts

- `npm run dev` / `npm start` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run astro` - Run Astro CLI commands

---

## Overview

This portfolio website uses a **mode-based system** that allows the same content to be reordered and presented differently based on URL parameters. The system is designed to showcase different aspects of your professional profile (Research, ABA, Business, Journalism) while maintaining all content visible at all times.

## Mode System Overview

The portfolio supports four modes:

- **Research** (`?r`) - Emphasizes research and psychology work
- **ABA** (`?a`) - Emphasizes Applied Behavior Analysis and clinical support roles
- **Business** (`?b`) - Emphasizes business operations and leadership
- **Journalism** (`?j`) - Emphasizes journalism and media work

**Default Mode**: ABA (when no URL parameter is present)

## URL Parameters

URL parameters control the mode and affect:

1. **Hero Section** - Badge text, title, and description change
2. **Top Skills** - Skills are filtered and reordered based on relevance to the mode
3. **Section Order** - Experience sections are reordered to prioritize relevant content
4. **Content Display** - All experiences remain visible; nothing is hidden

### Usage Examples

- `/?r` - Research mode
- `/?a` - ABA mode (default)
- `/?b` - Business mode
- `/?j` - Journalism mode

## Content Collections

### Experience Collections

All experience collections support a `modes` field that determines:
- Which skills appear in "Top Skills" for that mode
- Section ordering priority
- **NOT** which experiences are displayed (all experiences always show)

#### Research Collection (`src/content/research/`)

```yaml
---
title: "Project Title"
role: "First Author"
conference: "Conference Name"
date: 2025-04-15
tools: ["eprime-design", "spss-analysis"]  # Skill slugs
posterUrl: "/assets/pdfs/poster.pdf"
methodology: "Description of methodology"
findings:
  - "Finding 1"
  - "Finding 2"
modes: ["research", "aba"]  # Affects Top Skills and section order
---
```

#### Leadership Collection (`src/content/leadership/`)

```yaml
---
organization: "Organization Name"
role: "Role Title"
dateStart: 2024-05-01
dateEnd: 2025-01-01  # Optional
metrics:
  - value: "35%"
    label: "Metric Label"
tags: ["Tag1", "Tag2"]  # Skill slugs (optional)
summary: "Summary text"
modes: ["business"]  # Affects Top Skills and section order
---
```

#### Business Collection (`src/content/business/`)

```yaml
---
organization: "Company Name"
role: "Founder & Operator"
dateStart: 2020-05-30
dateEnd: 2025-05-01  # Optional
metrics:
  - value: "$500k+"
    label: "Gross Revenue"
tags: ["E-Commerce", "Supply Chain"]  # Skill slugs (optional)
summary: "Summary text"
modes: ["business"]  # Affects Top Skills and section order
---
```

#### Journalism Collection (`src/content/journalism/`)

**Note**: Journalism articles do NOT have a `modes` field. They are content pieces shown in all modes.

```yaml
---
title: "Article Title"
publication: "The Chimes"
date: 2025-11-19
type: "Article"  # Article, Social, Video, Multimedia
url: "https://example.com/article"
impact: "15k+ views"
summary: "Article summary"
---
```

### Skills Collection (`src/content/skills/`)

Skills represent your technical abilities, tools, and certifications. They can be explicitly assigned to modes or automatically derived from experience files.

#### Creating a New Skill

1. **Create a markdown file** in `src/content/skills/`
   - File name should be lowercase with hyphens (e.g., `spss-analysis.md`, `ap-style.md`)
   - The file name becomes the skill's **slug** (used for matching)

2. **Add frontmatter** with required fields:

```yaml
---
name: "SPSS Analysis"              # Display name (required)
icon: "bar-chart-3"                # Lucide icon name (required)
shortDesc: "Statistical analysis & data visualization"  # Brief description (required)
level: "Advanced"                  # Beginner, Intermediate, Advanced, or Certified (required)
since: 2023                        # Year you started using this skill (required)
order: 1                           # Optional: Manual sort order (lower = first)
featured: false                    # Optional: Show in Top Skills section (default: false)
modes: ["research", "aba"]         # Optional: Explicit mode assignment
---
```

3. **Add description** below the frontmatter (optional but recommended):

```markdown
Experience with SPSS for statistical analysis, including regression models, ANOVA, and data visualization. Applied in psychology research contexts requiring rigorous statistical validation.
```

#### Skill Fields Explained

- **`name`** (required): The display name shown on the portfolio
- **`icon`** (required): Lucide icon name (see [Lucide Icons](https://lucide.dev/icons/))
- **`shortDesc`** (required): Brief one-line description shown in skill cards
- **`level`** (required): One of: `Beginner`, `Intermediate`, `Advanced`, `Certified`
- **`since`** (required): Year (number) when you started using this skill
- **`order`** (optional): Number for manual sorting (lower numbers appear first)
- **`featured`** (optional): Boolean - if `true`, appears in Top Skills section
- **`modes`** (optional): Array of modes (`research`, `aba`, `business`, `journalism`)

#### Linking Skills to Experience Files

Skills can be linked to experiences in two ways:

**Method 1: Explicit Mode Assignment**
Set `modes` in the skill file to explicitly assign it to specific portfolio modes:

```yaml
---
name: "SPSS Analysis"
modes: ["research", "aba"]  # Appears in Research and ABA modes
---
```

**Method 2: Relational Matching (Automatic)**
If `modes` is not set, the skill will automatically appear in Top Skills when:
- It's referenced in the `tools` array of research experiences
- It's referenced in the `tags` array of leadership/business experiences
- The skill slug (filename) matches the tool/tag name

**Example - Research Experience:**
```yaml
---
title: "Research Project"
tools: ["spss-analysis", "eprime-design"]  # These match skill file names
modes: ["research"]
---
```

**Example - Business Experience:**
```yaml
---
organization: "Spezz LLC"
tags: ["e-commerce", "supply-chain"]  # These match skill file names
modes: ["business"]
---
```

**Matching Rules:**
- Exact match: `tools: ["spss-analysis"]` matches `spss-analysis.md`
- Normalized matching: Spaces and special characters are converted to hyphens
- Partial matching: "SPSS Analysis" matches "spss-analysis"

### Modes Collection (`src/content/modes/`)

Each mode has its own markdown file that defines the hero section content.

#### File Structure

- `src/content/modes/research.md`
- `src/content/modes/aba.md`
- `src/content/modes/business.md`
- `src/content/modes/journalism.md`

#### Schema

```yaml
---
badgeText: "Specializing in Experimental Design & Data"
badgeColor: "bg-blue-500"  # Tailwind CSS color class
title: "Data-Driven Researcher & <br class=\"hidden md:block\"/> Psychology Graduate."
description: "Leveraging E-Prime and SPSS to analyze behavioral patterns..."
---
```

**Note**: The `title` field can contain HTML (like `<br>` tags) for responsive formatting.

## Skills System

### Understanding Top Skills vs. Technical Toolkit

The portfolio has two skill display areas:

1. **Top Skills Section** - Featured skills shown prominently at the top
2. **Technical Toolkit Section** - Complete list of all skills organized by category

### Top Skills Section

The "Top Skills" section displays skills that are:
1. **Explicitly assigned** to the current mode via the `modes` field in the skill file, OR
2. **Derived relationally** from experience files (if `modes` is not set in the skill file)

**To control which skills appear in Top Skills:**

- **Option A**: Set `featured: true` in the skill file (appears in all modes where skill is relevant)
- **Option B**: Set `modes` array in the skill file (appears only in specified modes)
- **Option C**: Link skill to experience files via `tools`/`tags` (appears when that experience is relevant to current mode)

### Relational Derivation (Automatic Matching)

If a skill's `modes` field is **not set**, it will automatically appear in Top Skills when:

1. **For Research/ABA modes:**
   - The skill slug matches a tool name in research experiences
   - Example: `spss-analysis.md` matches `tools: ["spss-analysis"]` in a research entry

2. **For Business mode:**
   - The skill slug matches a tag name in leadership/business experiences
   - Example: `e-commerce.md` matches `tags: ["e-commerce"]` in a business entry

3. **For Journalism mode:**
   - Skills with `modes: ["journalism"]` appear
   - Skills linked via tags in journalism-related leadership roles

**Matching is flexible:**
- Case-insensitive: "SPSS Analysis" matches "spss-analysis"
- Normalized: Spaces and special characters are converted to hyphens
- Partial matching: "spss" matches "spss-analysis"

### Skill Prioritization & Sorting

Skills are sorted in this order:

1. **Featured skills first** (`featured: true`)
2. **Then by order field** (lower numbers = higher priority)
3. **Then alphabetically** by name

**Example:**
```yaml
# This skill appears first (featured + low order)
---
name: "SPSS Analysis"
featured: true
order: 1
---

# This appears second (featured but higher order)
---
name: "E-Prime Design"
featured: true
order: 2
---

# This appears last (not featured)
---
name: "R Programming"
featured: false
---
```

### Icon Selection

Skills use [Lucide Icons](https://lucide.dev/icons/). Choose an icon that represents the skill:

**Common Icons:**
- `bar-chart-3` - Data analysis, statistics
- `microscope` - Research, science
- `code` - Programming
- `file-text` - Writing, documentation
- `briefcase` - Business, operations
- `users` - Leadership, team management
- `wrench` - Technical tools
- `database` - Data management
- `cloud` - Cloud services
- `server` - Server management

**To find icons:**
1. Visit [lucide.dev/icons](https://lucide.dev/icons/)
2. Search for your skill type
3. Use the icon name (kebab-case) in your skill file

### Complete Skill Example

```yaml
---
name: "SPSS Analysis"
icon: "bar-chart-3"
shortDesc: "Statistical analysis & data visualization"
level: "Advanced"
since: 2023
order: 1
featured: true
modes: ["research", "aba"]
---

Experience with SPSS for statistical analysis, including regression models, ANOVA, and data visualization. Applied in psychology research contexts requiring rigorous statistical validation. Proficient in creating publication-ready charts and tables.
```

### Troubleshooting Skills

**Skill not appearing in Top Skills:**
- Check that `featured: true` OR `modes` array is set
- Verify skill slug matches tool/tag name in experience files
- Ensure experience file has the current mode in its `modes` field
- Restart dev server after making changes

**Skill appearing in wrong mode:**
- Check `modes` array in skill file
- Verify tool/tag names match skill slug exactly
- Check experience file's `modes` field

**Skill order incorrect:**
- Set `order` field (lower = first)
- Ensure `featured: true` for priority skills
- Check for duplicate order values

## Section Ordering

Sections are reordered based on the current mode:

### Research Mode (`?r`)
1. Research & Psychology
2. Business & Leadership
3. Journalism & Media
4. Technical Toolkit & Certifications
5. Let's Connect

### ABA Mode (`?a`) - Default
1. Research & Psychology
2. Business & Leadership
3. Journalism & Media
4. Technical Toolkit & Certifications
5. Let's Connect

### Business Mode (`?b`)
1. Business & Leadership
2. Journalism & Media
3. Research & Psychology
4. Technical Toolkit & Certifications
5. Let's Connect

### Journalism Mode (`?j`)
1. Journalism & Media
2. Research & Psychology
3. Business & Leadership
4. Technical Toolkit & Certifications
5. Let's Connect

**Note**: "Technical Toolkit & Certifications" and "Let's Connect" always appear at the end, in that order.

## Development Guide

### Adding a New Experience

1. Create a markdown file in the appropriate collection directory
2. Add frontmatter with required fields
3. Set `modes` field to indicate which modes this experience is relevant to
4. For research: Add skill slugs to `tools` array
5. For leadership/business: Add skill slugs to `tags` array (optional)

### Editing Hero Content (Title, Badge, Description)

The hero section content (title, badge text, badge color, and description) is stored in markdown files for easy editing. Each mode has its own file.

#### Step-by-Step Guide

1. **Navigate to the modes directory**: `src/content/modes/`

2. **Open the mode file you want to edit**:
   - `research.md` - For Research mode (`?r`)
   - `aba.md` - For ABA mode (`?a`, default)
   - `business.md` - For Business mode (`?b`)
   - `journalism.md` - For Journalism mode (`?j`)

3. **Edit the frontmatter fields**:
   ```yaml
   ---
   badgeText: "Your badge text here"  # Text shown in the small badge above title
   badgeColor: "bg-blue-500"          # Tailwind CSS color class (e.g., bg-blue-500, bg-green-500, bg-orange-500, bg-purple-500)
   title: "Your Title Here"            # Main hero title (can include HTML like <br> tags)
   description: "Your description here" # Subtitle/description text below the title
   ---
   ```

4. **Save the file** - Changes will appear automatically in dev mode, or after rebuilding

#### Field Details

- **`badgeText`**: Short text displayed in the small badge above the title (e.g., "Specializing in Experimental Design & Data")
- **`badgeColor`**: Tailwind CSS color class for the badge dot. Common options:
  - `bg-blue-500` - Blue (Research)
  - `bg-green-500` - Green (ABA)
  - `bg-orange-500` - Orange (Business)
  - `bg-purple-500` - Purple (Journalism)
- **`title`**: Main hero title. Can include HTML for responsive formatting:
  - Use `<br class="hidden md:block"/>` to add line breaks that only show on desktop
  - Example: `"Data-Driven Researcher & <br class="hidden md:block"/> Psychology Graduate."`
- **`description`**: Paragraph text below the title describing your role/focus

#### Example: Changing Research Mode Title

1. Open `src/content/modes/research.md`
2. Change the `title` field:
   ```yaml
   title: "Your New Title Here"
   ```
3. Save the file
4. Visit `/?r` to see the changes

#### Tips

- Use HTML in titles sparingly - only for responsive line breaks
- Keep badge text short (under 50 characters recommended)
- Description should be 1-2 sentences, max 200 characters
- Badge colors should match the mode's theme for consistency

### Adding a New Skill

See the [Skills System](#skills-system) section above for complete documentation.

**Quick Steps:**
1. Create a markdown file in `src/content/skills/` (e.g., `my-skill.md`)
2. Add required frontmatter fields: `name`, `icon`, `shortDesc`, `level`, `since`
3. Optionally set `featured: true` to show in Top Skills
4. Optionally set `modes` array to assign to specific portfolio modes
5. Optionally set `order` for manual sorting
6. Link to experience files via `tools` (research) or `tags` (leadership/business) for automatic mode matching

**For detailed instructions, field explanations, icon selection, and examples, see the [Skills System](#skills-system) section.**

### Testing Modes

1. Start dev server: `npm run dev`
2. Navigate to `http://localhost:4321/?r` for research mode
3. Test other modes: `/?a`, `/?b`, `/?j`
4. Verify:
   - Hero content changes
   - Top Skills change
   - Sections reorder
   - All experiences remain visible

## Key Principles

1. **No Content Filtering**: URL parameters reorder and change emphasis, but never hide content
2. **Relational Skills**: Skills can be derived from experience files, making the system more maintainable
3. **Editable Hero Content**: Hero section content is stored in markdown files for easy editing
4. **Consistent Structure**: All modes show the same sections, just in different orders

## File Structure

```
portfolio/
├── src/
│   ├── content/
│   │   ├── config.ts          # Collection schemas
│   │   ├── research/          # Research experiences
│   │   ├── leadership/        # Leadership experiences
│   │   ├── business/          # Business experiences
│   │   ├── journalism/        # Journalism articles
│   │   ├── skills/            # Skill definitions
│   │   └── modes/             # Hero content per mode
│   │       ├── research.md
│   │       ├── aba.md
│   │       ├── business.md
│   │       └── journalism.md
│   └── pages/
│       └── index.astro        # Main page with mode logic
└── README.md                  # This file
```

## Troubleshooting

### Skills Not Appearing in Top Skills

- Check that the skill slug matches the tool/tag name in experience files
- Verify the experience file has the current mode in its `modes` field
- Or explicitly set `modes` in the skill file

### Hero Content Not Changing

- Verify the mode file exists in `src/content/modes/`
- Check that the file name matches the mode name (e.g., `research.md` for research mode)
- Ensure the frontmatter fields match the schema

### Sections Not Reordering

- Check that `getSectionOrder()` function includes all sections
- Verify CSS `order` values are set correctly on section elements
- Ensure contact section has `data-section-order` attribute

