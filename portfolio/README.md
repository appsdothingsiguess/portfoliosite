# Portfolio Website - Mode System Documentation

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

Skills can be explicitly assigned to modes or derived relationally from experience files.

```yaml
---
name: "SPSS Analysis"
icon: "bar-chart-3"
shortDesc: "Statistical analysis & data visualization"
level: "Advanced"
since: 2023
order: 1  # Optional: for manual sorting
featured: true  # Appears in Top Skills section
modes: ["research", "aba"]  # Optional: if not set, derived from experience files
---
```

**Relational Logic**: If a skill's `modes` field is not set, it will appear in Top Skills if:
- It's referenced in the `tools` array of research experiences for that mode
- It's referenced in the `tags` array of leadership/business experiences for that mode

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

### Top Skills Section

The "Top Skills" section displays skills that are:
1. **Explicitly assigned** to the current mode via the `modes` field in the skill file, OR
2. **Derived relationally** from experience files (if `modes` is not set in the skill file)

### Relational Derivation

A skill appears in Top Skills if:
- It's listed in the `tools` array of research experiences that have the current mode in their `modes` field
- It's listed in the `tags` array of leadership/business experiences that have the current mode in their `modes` field
- The skill slug matches or is similar to the tool/tag name

### Skill Prioritization

Skills are sorted by:
1. `featured: true` skills first
2. Then by `order` field (if set)
3. Then alphabetically

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

### Editing Hero Content

1. Navigate to `src/content/modes/`
2. Edit the markdown file for the mode you want to change (e.g., `research.md`)
3. Update `badgeText`, `badgeColor`, `title`, or `description`
4. Save the file - changes will appear on the next build

### Adding a New Skill

1. Create a markdown file in `src/content/skills/`
2. Add frontmatter with skill details
3. Optionally set `modes` field to explicitly assign to modes
4. Optionally set `featured: true` to prioritize in Top Skills
5. If `modes` is not set, the skill will be derived from experience files

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

