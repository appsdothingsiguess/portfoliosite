# File Refactoring Analysis

## Current File Sizes

| File | Lines | Status | Action Required |
|------|-------|--------|-----------------|
| `portfolio/src/pages/index.astro` | **446** | ⚠️ Close to limit | Extract components |
| `portfolio/src/styles/global.css` | 156 | ✅ OK | None |
| `portfolio/src/content/config.ts` | 74 | ✅ OK | None |
| `portfolio/src/layouts/BaseLayout.astro` | 51 | ✅ OK | None |

## Refactoring Plan for `index.astro`

### Current Structure Breakdown

The `index.astro` file (446 lines) contains:

1. **Frontmatter** (lines 1-15) - 15 lines
   - Data fetching and sorting logic
   - ✅ Keep in main file (Astro convention)

2. **Navigation** (lines 19-35) - 17 lines
   - ✅ Extract to component: `components/Navigation.astro`

3. **Hero Section** (lines 37-100) - 64 lines
   - Complex dynamic content with education block
   - ✅ Extract to component: `components/Hero.astro`
   - Props: `sortedResearch`, `sortedLeadership`, `sortedJournalism` (for mode detection)

4. **Technical Skills** (lines 104-117) - 14 lines
   - Static content
   - ✅ Extract to component: `components/TechnicalSkills.astro`

5. **Research Section** (lines 119-193) - 75 lines
   - Dynamic content with details/summary cards
   - ✅ Extract to component: `components/ResearchSection.astro`
   - Props: `sortedResearch`

6. **Operations & Leadership** (lines 195-249) - 55 lines
   - Dynamic content with stat cards and leadership items
   - ✅ Extract to component: `components/LeadershipSection.astro`
   - Props: `sortedLeadership`

7. **Journalism Section** (lines 251-320) - 70 lines
   - Dynamic content with card grid
   - ✅ Extract to component: `components/JournalismSection.astro`
   - Props: `sortedJournalism`

8. **Contact Section** (lines 322-339) - 18 lines
   - Static content
   - ✅ Extract to component: `components/ContactSection.astro`

9. **Poster Modal** (lines 343-358) - 16 lines
   - Static modal dialog
   - ✅ Extract to component: `components/PosterModal.astro`

10. **Debug Script** (lines 360-383) - 24 lines
    - ⚠️ **REMOVE** - Debug instrumentation, no longer needed

11. **Sticky Chameleon Script** (lines 385-446) - 62 lines
    - Client-side JavaScript for dynamic hero content
    - ✅ Extract to separate file: `scripts/sticky-chameleon.js`
    - Import in `BaseLayout.astro` or keep as inline in `index.astro` (small enough)

---

## Recommended Component Structure

```
portfolio/src/
├── components/
│   ├── Navigation.astro          (~20 lines)
│   ├── Hero.astro                (~70 lines)
│   ├── TechnicalSkills.astro     (~15 lines)
│   ├── ResearchSection.astro     (~80 lines)
│   ├── LeadershipSection.astro   (~60 lines)
│   ├── JournalismSection.astro   (~75 lines)
│   ├── ContactSection.astro      (~20 lines)
│   └── PosterModal.astro         (~20 lines)
├── scripts/
│   └── sticky-chameleon.js       (~65 lines)
└── pages/
    └── index.astro                (~80 lines) ✨ Reduced from 446!
```

---

## Estimated Line Counts After Refactoring

| File | Estimated Lines | Status |
|------|----------------|--------|
| `index.astro` | ~80 | ✅ Well under limit |
| `components/Navigation.astro` | ~20 | ✅ OK |
| `components/Hero.astro` | ~70 | ✅ OK |
| `components/TechnicalSkills.astro` | ~15 | ✅ OK |
| `components/ResearchSection.astro` | ~80 | ✅ OK |
| `components/LeadershipSection.astro` | ~60 | ✅ OK |
| `components/JournalismSection.astro` | ~75 | ✅ OK |
| `components/ContactSection.astro` | ~20 | ✅ OK |
| `components/PosterModal.astro` | ~20 | ✅ OK |
| `scripts/sticky-chameleon.js` | ~65 | ✅ OK |

---

## Benefits of Refactoring

1. **Maintainability**: Each section is isolated and easier to modify
2. **Reusability**: Components can be reused in other pages if needed
3. **Testability**: Smaller files are easier to test and debug
4. **Readability**: Main page becomes a clean composition of components
5. **Performance**: Astro can optimize components independently
6. **Code Organization**: Clear separation of concerns

---

## Implementation Priority

### Phase 1: High Priority (Immediate)
1. ✅ Extract `Navigation.astro` - Simple, no dependencies
2. ✅ Extract `ContactSection.astro` - Simple, no dependencies
3. ✅ Extract `PosterModal.astro` - Simple, no dependencies
4. ✅ Extract `TechnicalSkills.astro` - Simple, no dependencies

### Phase 2: Medium Priority (Next)
5. ✅ Extract `ResearchSection.astro` - Requires props
6. ✅ Extract `LeadershipSection.astro` - Requires props
7. ✅ Extract `JournalismSection.astro` - Requires props

### Phase 3: Lower Priority (Can wait)
8. ✅ Extract `Hero.astro` - Complex, has dynamic content
9. ✅ Extract `sticky-chameleon.js` - Client-side script

### Phase 4: Cleanup
10. ✅ Remove debug script (lines 360-383)

---

## Notes

- All components should follow Astro's component conventions
- Props should be typed where possible
- Keep component files focused on a single responsibility
- The main `index.astro` will become a clean composition file
- Consider creating a `components/`` directory structure if it doesn't exist

