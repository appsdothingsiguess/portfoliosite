# How to Edit Top Skills

The "Top Skills" section on your portfolio homepage is **dynamically generated** from markdown files. There is **no separate "top skills" document** to edit.

## To Add/Remove Skills from Top Skills:

1. **Open any skill file** in `src/content/skills/`
   - Example: `src/content/skills/spss-analysis.md`
   - Example: `src/content/skills/rbt-aba.md`

2. **Edit the frontmatter** (the YAML section at the top between `---`)

3. **Set `featured: true`** to make it appear in Top Skills
   - Set `featured: false` to remove it from Top Skills (it will still appear in the full Technical Toolkit section)

4. **Set `category`** to match the skill type:
   - `category: "research"` - For Psychology/Research tools (SPSS, E-Prime, RBT)
   - `category: "business"` - For business/operations skills
   - `category: "journalism"` - For journalism/writing skills
   - `category: "technical"` - For general technical skills

5. **⚠️ IMPORTANT: Restart your dev server** after editing content files
   - Stop the server (Ctrl+C) and run `npm run dev` again
   - Astro's content collections cache changes and require a restart to refresh

## Example:

```yaml
---
name: "SPSS Analysis"
icon: "bar-chart-3"
shortDesc: "Statistical analysis & data visualization"
level: "Advanced"
since: 2023
order: 1
category: "research"
featured: true    # ← Set to true to show in Top Skills
---
```

## Current Featured Skills:

These skills are currently set to `featured: true`:
- `spss-analysis.md` - Research category
- `rbt-aba.md` - Research category  
- `eprime-design.md` - Research category

To add more, just edit any skill file and set `featured: true`!

