# Development Notes

## Content Collections Hot Reload

**Important:** Astro's content collections are cached during development. When you edit files in `src/content/`, changes may not appear until you **restart the dev server**.

### To see changes to content files:

1. **Stop the dev server** (Ctrl+C)
2. **Restart it** with `npm run dev`
3. Refresh your browser

### Why this happens:

Astro's content collections use a build-time cache for performance. While component files (`.astro`, `.tsx`) hot-reload fine, content markdown files require a server restart to refresh the collection cache.

### Files that require restart:

- `src/content/skills/*.md` - Skill definitions
- `src/content/research/*.md` - Research projects
- `src/content/journalism/*.md` - Journalism samples
- `src/content/leadership/*.md` - Leadership roles
- `src/content/business/*.md` - Business ventures
- `src/content/config.ts` - Collection schemas

### Files that hot-reload:

- `src/pages/*.astro` - Page components
- `src/components/*.astro` - UI components
- `src/styles/*.css` - Stylesheets
- `tailwind.config.mjs` - Tailwind config

## Quick Reference

**Edit Top Skills:**
1. Open `src/content/skills/[skill-name].md`
2. Set `featured: true` in frontmatter
3. **Restart dev server** to see changes

**Edit Research Projects:**
1. Open `src/content/research/[project-name].md`
2. Edit frontmatter or content
3. **Restart dev server** to see changes

