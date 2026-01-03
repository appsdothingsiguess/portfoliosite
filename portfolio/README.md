# Portfolio Website

A professional, employer-facing portfolio website built with **Astro** that dynamically adapts content presentation based on visitor context. The site features a persistent mode system that remembers visitor preferences, intelligent content reordering, and comprehensive filtering capabilities.

---

## 📝 How to Update Content

All content is stored in Markdown files in the `src/content/` directory. Here's how to update each type of content:

### **Hero Section & About Me** (`src/content/modes/`)

Edit the mode-specific files to change hero content and About Me sections:
- `research.md` - Research mode hero and About Me
- `aba.md` - ABA mode hero and About Me  
- `business.md` - Business mode hero and About Me
- `journalism.md` - Journalism mode hero and About Me

**Fields:**
- `badgeText` - Badge text shown in hero
- `badgeColor` - Tailwind color class (e.g., `bg-blue-500`)
- `title` - Hero title (can include HTML like `<br class="hidden md:block"/>`)
- `description` - Hero description (one sentence)
- `aboutMe` - About Me section content (optional, shown below Top Skills)

### **Experience Cards** (`src/content/research/`, `src/content/business/`, `src/content/leadership/`)

Each experience card is a Markdown file. Edit the frontmatter (YAML at the top) to update:

**Research Cards** (`src/content/research/`):
- `title` - Project title
- `role` - Your role (e.g., "Research Assistant")
- `organization` - Institution name
- `date` or `dateStart`/`dateEnd` - Dates
- `tools` - Array of tools/skills used
- `findings` - Array of key findings (shown in "Key Findings" section)
- `methodology` - Methodology description
- `metrics` - Array of `{value: "75+", label: "Participants"}` objects
- `posterUrl` - Path to PDF poster (optional)

**Business Cards** (`src/content/business/`):
- `organization` - Company name
- `role` - Your role
- `dateStart`/`dateEnd` - Dates
- `summary` - Summary text
- `tags` - Array of relevant skills
- `keyDetails` - Array of key details/achievements (shown in "Key Details" section)
- `metrics` - Array of metric objects
- `modes` - Array of modes where this appears

**Leadership Cards** (`src/content/leadership/`):
- Same fields as Business cards
- `keyDetails` - Array of key details/achievements (shown in "Key Details" section)

**Journalism Cards** (`src/content/journalism/`):
- `title` - Article/post title
- `publication` - Publication name
- `date` - Publication date
- `url` - Link to article
- `type` - `Article`, `Social`, `Video`, or `Multimedia`
- `summary` - Summary text

### **Skills** (`src/content/skills/`)

Edit skill files to update:
- `name` - Skill name
- `icon` - Lucide icon name
- `shortDesc` - Short description
- `level` - `Beginner`, `Intermediate`, `Advanced`, or `Certified`
- `since` - Year you started using this skill
- `order` - Display order (lower numbers appear first)
- `featured` - `true` to show in Top Skills section

### **Resume Files** (`public/assets/pdfs/`)

Place mode-specific resume PDFs with the exact naming convention:
- `Resume-aba.pdf` - ABA/RBT-focused resume (default mode)
- `Resume-research.pdf` - Research-focused resume
- `Resume-business.pdf` - Business-focused resume
- `Resume-journalism.pdf` - Journalism-focused resume

**Important:** File names must match exactly (lowercase mode name with hyphen). The site automatically links to the correct resume based on the current mode. If a mode-specific resume doesn't exist, the link will point to a non-existent file.

---

## Quick Reference

| Content Type | Location | Key Fields |
|-------------|----------|------------|
| Hero/About Me | `src/content/modes/*.md` | `badgeText`, `title`, `description`, `aboutMe` |
| Research | `src/content/research/*.md` | `title`, `findings[]`, `methodology`, `tools[]` |
| Business | `src/content/business/*.md` | `organization`, `role`, `keyDetails[]`, `summary` |
| Leadership | `src/content/leadership/*.md` | `organization`, `role`, `keyDetails[]`, `summary` |
| Journalism | `src/content/journalism/*.md` | `title`, `publication`, `url`, `type` |
| Skills | `src/content/skills/*.md` | `name`, `icon`, `level`, `featured` |

**Note:** After editing Markdown files, the dev server will automatically reload. For production, run `npm run build`.

## What This Site Does

This portfolio website serves as a **credibility artifact** for employers and recruiters, showcasing professional work across multiple domains:

- **Research & Psychology** - Experimental design, data analysis, and academic research
- **Applied Behavior Analysis (ABA)** - Clinical research and RBT qualifications
- **Business & Operations** - E-commerce operations, leadership, and business development
- **Journalism & Media** - Investigative reporting, articles, and multimedia content

The site uses a **mode-based system** that allows the same content to be reordered and emphasized differently based on the visitor's context (recruiter type), while maintaining all content visible at all times. This ensures recruiters see the most relevant information first without hiding any professional experience.

---

## Key Features

### 1. Persistent Mode System (Sticky Mode)

The site remembers visitor preferences across sessions using `localStorage`, creating a personalized experience:

- **URL Parameter Capture**: Visiting with `?a`, `?r`, `?b`, or `?j` sets and saves the mode preference
- **Automatic Recall**: On subsequent visits (without URL params), the site automatically applies the saved mode
- **Clean URLs**: Query parameters are removed after capture for cleaner URLs
- **Default Fallback**: If no preference is saved, defaults to ABA mode

**How It Works:**
1. **Capture Phase**: URL params (`?a`, `?r`, `?j`, `?b`) are detected and saved to `localStorage`
2. **Recall Phase**: If no URL param exists, checks `localStorage` for saved preference
3. **Render Phase**: Applies the determined mode immediately to minimize FOUC (Flash of Unstyled Content)

### 2. Dynamic Navigation

- **Sticky Header**: Navigation bar stays visible while scrolling
- **Mode Dropdown**: Quick access to switch between portfolio modes (ABA, Research, Business, Journalism)
- **Visual Feedback**: Dropdown button shows current mode with icon and label
- **Keyboard Accessible**: Full keyboard navigation support with proper ARIA attributes
- **LinkedIn Integration**: Direct link to LinkedIn profile in navigation

### 3. Adaptive Hero Section

The hero section dynamically updates based on the current mode:

- **Mode-Specific Content**: Badge text, title, and description change per mode
- **Editable via Markdown**: Hero content is stored in `src/content/modes/` for easy editing
- **Responsive Design**: Title includes responsive line breaks for optimal mobile/desktop display
- **Call-to-Action Buttons**: Resume download and LinkedIn connection links
- **Profile Image**: Professional headshot with "Open to Work" badge

### 4. Top Skills Section

A featured skills section that adapts to the current mode:

- **Mode-Filtered Display**: Shows 5 most relevant skills for the current mode
- **Dual Assignment Methods**:
  - **Explicit**: Skills can be assigned to modes via `modes` field
  - **Relational**: Skills automatically appear when linked to experience files via `tools`/`tags`
- **Skill Cards**: Each skill displays:
  - Icon (Lucide icons)
  - Name and short description
  - Proficiency level (Beginner, Intermediate, Advanced, Certified)
  - Featured badge (if applicable)
- **Client-Side Filtering**: Skills update instantly when mode changes without page reload

### 5. Research & Psychology Section

Comprehensive display of research projects and academic work:

- **Expandable Cards**: Each research entry uses `<details>` for collapsible full content
- **Key Information Display**:
  - Project title and organization
  - Date range or publication date
  - Methodology summary
  - Key findings (bulleted list)
  - Relevant tools/skills (as pills)
  - Metrics (if available)
- **Poster Modal**: Click to view research posters in a full-screen modal with PDF viewer
- **Sorting**: Automatically sorted by date (newest first)
- **No Filtering**: All research entries are always visible (reordering only)

### 6. Business Ventures Section

Showcases business operations and entrepreneurial experience:

- **Expandable Details**: Full information available via collapsible sections
- **Key Metrics Display**: Business metrics (revenue, growth, etc.) shown prominently
- **Tags & Skills**: Relevant skills displayed as pills
- **Date Ranges**: Clear start/end dates for each role
- **Summary Headlines**: First sentence of summary shown in collapsed view

### 7. Leadership Section

Displays leadership roles and operational positions:

- **Mode-Specific Display**: Some leadership roles appear in journalism section when relevant
- **Expandable Cards**: Full details available on click
- **Metrics**: Key performance indicators displayed when available
- **Tags**: Skills and competencies shown as pills
- **Date Tracking**: Start and end dates for each position

### 8. Journalism & Media Section

Comprehensive journalism portfolio with advanced filtering:

- **Featured Display**: First 3 journalism items always visible
- **Expandable Section**: Remaining items in collapsible "View X More Items" section
- **Content Filtering**: Filter buttons for:
  - All Content
  - Articles only
  - Social Media only
- **Dynamic Filtering**: Filter updates both featured and remaining sections
- **Item Types**: Supports Articles, Social Media posts, Videos, and Multimedia
- **External Links**: Direct links to published articles and posts
- **Publication Badges**: Visual indicators for article vs. social media content
- **Year Display**: Publication year shown on each card

### 9. Technical Toolkit Section

Complete skills inventory:

- **Comprehensive List**: All skills displayed regardless of mode
- **Categorized Display**: Skills organized by type and proficiency
- **Icon-Based**: Visual icons for quick scanning
- **Level Indicators**: Clear proficiency levels (Beginner, Intermediate, Advanced, Certified)
- **Featured Badges**: Highlights skills marked as featured
- **Sortable**: Skills can be manually ordered via `order` field

### 10. Contact Section

Professional contact and connection options:

- **Clear CTA**: "Let's Connect" messaging
- **LinkedIn Integration**: Direct link to LinkedIn profile
- **Resume Download**: Link to downloadable PDF resume
- **Footer**: Copyright and technology credits

### 11. Research Poster Modal

Full-screen modal for viewing research posters:

- **PDF Viewer**: Embedded PDF viewer for research posters
- **Download Option**: Direct download link for PDFs
- **Responsive Design**: Adapts to different screen sizes
- **Keyboard Accessible**: Can be closed with Escape key
- **Loading State**: Shows placeholder while PDF loads

### 12. Responsive Design & Mobile Optimization

Fully responsive across all device sizes with comprehensive mobile optimizations:

- **Mobile-First**: Optimized for mobile viewing with hamburger menu navigation
- **Breakpoints**: Tailwind CSS breakpoints (sm, md, lg) for adaptive layouts
- **Flexible Grids**: Content grids adapt from 1 to 3 columns based on screen size
- **Touch-Friendly**: All interactive elements meet WCAG 2.5.5 minimum 44x44px touch targets
- **Readable Typography**: Fluid typography scaling (e.g., `text-2xl md:text-3xl`) for optimal readability
- **Mobile Navigation**: Hamburger menu with dropdown overlay for mobile devices
- **Responsive Filter Buttons**: Filter button groups stack vertically on mobile, horizontal on desktop
- **Mobile Poster Viewing**: Research posters open in new tab on mobile for better viewing experience
- **No Horizontal Overflow**: All layouts tested and fixed to prevent horizontal scrolling on < 390px screens

### 13. Accessibility Features

Built with accessibility as a priority:

- **Semantic HTML**: Proper use of HTML5 semantic elements
- **Keyboard Navigation**: Full keyboard support throughout
- **Focus Indicators**: Visible focus states for all interactive elements
- **ARIA Labels**: Proper ARIA attributes for screen readers
- **Skip Links**: Skip-to-content link for keyboard users
- **Alt Text**: All images include descriptive alt text
- **Heading Hierarchy**: Proper h1 → h2 → h3 structure

### 14. Performance Optimizations

Fast loading and efficient rendering:

- **Static Site Generation**: Pre-rendered HTML for instant loading
- **Minimal JavaScript**: Only essential client-side scripts
- **Lazy Loading**: Images loaded on demand
- **CSS Optimization**: Tailwind CSS purged for production
- **No Blocking Scripts**: All scripts are non-blocking

### 15. Content Management

Easy content editing via Markdown:

- **Content Collections**: Astro's type-safe content collections
- **Markdown-Based**: All content in easy-to-edit Markdown files
- **Schema Validation**: Zod schemas ensure content consistency
- **Type Safety**: TypeScript types generated from content schemas
- **Hot Reload**: Changes appear immediately in development

---

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

## Mode System Overview

The portfolio supports four modes, each emphasizing different aspects of professional experience:

- **Research** (`?r`) - Emphasizes research and psychology work
- **ABA** (`?a`) - Emphasizes Applied Behavior Analysis and clinical support roles (default)
- **Business** (`?b`) - Emphasizes business operations and leadership
- **Journalism** (`?j`) - Emphasizes journalism and media work

**Default Mode**: ABA (when no URL parameter is present and no preference is saved)

### How Modes Work

URL parameters control the mode and affect:

1. **Hero Section** - Badge text, title, and description change
2. **Top Skills** - Skills are filtered and reordered based on relevance to the mode
3. **Section Order** - Experience sections are reordered to prioritize relevant content
4. **Content Display** - All experiences remain visible; nothing is hidden

### Usage Examples

- `/?a` - ABA mode (default)
- `/?r` - Research mode
- `/?b` - Business mode
- `/?j` - Journalism mode

### Persistent Mode (Sticky Mode)

When a visitor uses a URL parameter (e.g., `/?r`), the site:
1. Sets the mode to Research
2. Saves the preference to `localStorage`
3. Removes the query parameter from the URL (clean URL)
4. On future visits (without params), automatically applies the saved mode

This creates a personalized experience where recruiters see their preferred view automatically.

---

## Content Collections

### Experience Collections

All experience collections support a `modes` field that determines:
- Which skills appear in "Top Skills" for that mode
- Section ordering priority
- **NOT** which experiences are displayed (all experiences always show)**

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

---

## Skills System

### Understanding Top Skills vs. Technical Toolkit

The portfolio has two skill display areas:

1. **Top Skills Section** - Featured skills shown prominently at the top (mode-filtered, 5 skills)
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

---

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

---

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
   - Mode preference is saved (check `localStorage` in browser DevTools)

### Testing Persistent Mode

1. Visit `/?r` - Should set Research mode and save to localStorage
2. Refresh page (without URL param) - Should automatically show Research mode
3. Visit `/?b` - Should override and save Business mode
4. Clear localStorage and visit without params - Should default to ABA mode

---

## Key Principles

1. **No Content Filtering**: URL parameters reorder and change emphasis, but never hide content
2. **Relational Skills**: Skills can be derived from experience files, making the system more maintainable
3. **Editable Hero Content**: Hero section content is stored in markdown files for easy editing
4. **Consistent Structure**: All modes show the same sections, just in different orders
5. **Persistent Preferences**: Visitor mode preferences are remembered across sessions
6. **Accessibility First**: Built with semantic HTML, keyboard navigation, and proper ARIA attributes
7. **Performance Optimized**: Static generation, minimal JavaScript, lazy loading

---

## File Structure

```
portfolio/
├── src/
│   ├── content/
│   │   ├── config.ts          # Collection schemas
│   │   ├── research/          # Research experiences
│   │   ├── leadership/        # Leadership experiences
│   │   ├── business/          # Business experiences
│   │   ├── journalism/       # Journalism articles
│   │   ├── skills/            # Skill definitions
│   │   └── modes/             # Hero content per mode
│   │       ├── research.md
│   │       ├── aba.md
│   │       ├── business.md
│   │       └── journalism.md
│   ├── components/
│   │   ├── TechnicalSkills.astro
│   │   └── TopSkills.astro
│   ├── layouts/
│   │   └── BaseLayout.astro   # Base page layout
│   └── pages/
│       └── index.astro        # Main page with mode logic
├── public/
│   ├── assets/
│   │   └── pdfs/              # Resume and research posters
│   └── Images/                 # Profile images
├── astro.config.mjs            # Astro configuration
├── tailwind.config.mjs         # Tailwind CSS configuration
├── package.json                # Dependencies
└── README.md                   # This file
```

---

## Troubleshooting

### Skills Not Appearing in Top Skills

- Check that the skill slug matches the tool/tag name in experience files
- Verify the experience file has the current mode in its `modes` field
- Or explicitly set `modes` in the skill file
- Ensure `featured: true` is set if you want it to appear in all relevant modes

### Hero Content Not Changing

- Verify the mode file exists in `src/content/modes/`
- Check that the file name matches the mode name (e.g., `research.md` for research mode)
- Ensure the frontmatter fields match the schema
- Clear browser cache and localStorage if testing persistent mode

### Sections Not Reordering

- Check that `getSectionOrder()` function includes all sections
- Verify CSS `order` values are set correctly on section elements
- Ensure contact section has `data-section-order` attribute

### Persistent Mode Not Working

- Check browser console for JavaScript errors
- Verify `localStorage` is enabled in browser settings
- Clear localStorage and test again: `localStorage.clear()` in browser console
- Ensure URL parameters are being captured correctly (check network tab)

### Journalism Filter Not Working

- Verify journalism items have `data-type` attribute set correctly
- Check that filter buttons have `data-filter` attributes
- Ensure JavaScript is enabled in browser
- Check browser console for errors

---

## Technology Stack

- **Framework**: [Astro](https://astro.build/) 5.16.6 - Static site generator
- **Styling**: [Tailwind CSS](https://tailwindcss.com/) 3.4.0 - Utility-first CSS framework
- **Icons**: [Lucide Icons](https://lucide.dev/) - Icon library
- **Content**: Markdown with frontmatter (Astro Content Collections)
- **Type Safety**: TypeScript with Zod schema validation
- **Build Tool**: Vite (via Astro)

---

## License

This project is a personal portfolio website. All content and code are proprietary.

---

## Support

For questions or issues:
1. Check the [Troubleshooting](#troubleshooting) section above
2. Review the relevant feature documentation
3. Check browser console for JavaScript errors
4. Verify content file schemas match the examples provided

---

**Last Updated**: 2025
