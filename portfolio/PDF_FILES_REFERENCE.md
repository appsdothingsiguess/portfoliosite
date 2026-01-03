# PDF Files Reference

This document lists all PDF files expected in the portfolio and their locations.

## Resume PDFs (Mode-Specific)

All resume PDFs should be placed in: `public/assets/pdfs/`

**Required Files:**
- `Resume-aba.pdf` - ABA/RBT-focused resume (default mode)
- `Resume-research.pdf` - Research-focused resume
- `Resume-business.pdf` - Business-focused resume
- `Resume-journalism.pdf` - Journalism-focused resume

**Naming Convention:**
- Format: `Resume-{mode}.pdf`
- Mode names must be lowercase: `aba`, `research`, `business`, `journalism`
- Use hyphens, not underscores

**How It Works:**
- The site automatically links to the correct resume based on the current mode
- When mode changes (via dropdown or URL parameter), the resume link updates dynamically
- Server-side: Initial link uses `Resume-${currentMode}.pdf`
- Client-side: JavaScript updates the link when mode changes

## Research Poster PDFs

Poster PDFs are referenced in research content files and should be placed in: `public/assets/pdfs/`

**Current Files:**
- `wpa-2025-poster.pdf` - Referenced in `src/content/research/biola-research-assistant.md`

**How It Works:**
- Poster URLs are set in the research content file's `posterUrl` field
- Posters open in a new tab on mobile devices for better viewing
- On desktop, posters open in a modal dialog with PDF viewer

## File Structure

```
public/
└── assets/
    └── pdfs/
        ├── Resume-aba.pdf
        ├── Resume-research.pdf
        ├── Resume-business.pdf
        ├── Resume-journalism.pdf
        └── wpa-2025-poster.pdf (or other poster files)
```

## Verification Checklist

- [ ] `Resume-aba.pdf` exists in `public/assets/pdfs/`
- [ ] `Resume-research.pdf` exists in `public/assets/pdfs/`
- [ ] `Resume-business.pdf` exists in `public/assets/pdfs/`
- [ ] `Resume-journalism.pdf` exists in `public/assets/pdfs/`
- [ ] All resume PDFs are named exactly as shown (case-sensitive)
- [ ] Poster PDFs referenced in research content files exist

## Testing

To verify PDFs are working correctly:

1. **Test Resume Links:**
   - Visit `/?a` and click "Download Resume" - should link to `Resume-aba.pdf`
   - Visit `/?r` and click "Download Resume" - should link to `Resume-research.pdf`
   - Visit `/?b` and click "Download Resume" - should link to `Resume-business.pdf`
   - Visit `/?j` and click "Download Resume" - should link to `Resume-journalism.pdf`

2. **Test Mode Switching:**
   - Change mode using dropdown menu
   - Verify resume link updates in browser DevTools (check `href` attribute)
   - Click resume link to verify correct PDF opens

3. **Test Poster PDFs:**
   - Navigate to Research section
   - Click "View Poster PDF" button
   - Verify poster opens correctly (new tab on mobile, modal on desktop)

