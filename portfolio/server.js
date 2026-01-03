#!/usr/bin/env node

/**
 * Simple static file server for Astro portfolio
 * Serves the dist/ directory on port 3000
 */

import express from 'express';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { existsSync } from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;
// Serve from current directory (dist files are synced directly here)
const DIST_DIR = __dirname;

// Check if index.html exists (verifies files were synced)
if (!existsSync(join(DIST_DIR, 'index.html'))) {
  console.error(`ERROR: index.html not found at ${join(DIST_DIR, 'index.html')}`);
  console.error('Please ensure deployment synced files correctly.');
  process.exit(1);
}

// Serve static files from current directory
app.use(express.static(DIST_DIR, {
  maxAge: '1y', // Cache static assets for 1 year
  etag: true,
  lastModified: true
}));

// Handle SPA routing - serve index.html for all routes EXCEPT static files
// Static files (images, CSS, JS, PDFs) are already handled by express.static above
app.get('*', (req, res, next) => {
  // Skip if it's a request for a static file (already handled)
  const ext = req.path.split('.').pop().toLowerCase();
  const staticExtensions = ['html', 'css', 'js', 'png', 'jpg', 'jpeg', 'gif', 'svg', 'ico', 'woff', 'woff2', 'ttf', 'eot', 'webp', 'pdf'];
  
  if (staticExtensions.includes(ext)) {
    // Let express.static handle it (or 404 if file doesn't exist)
    return next();
  }
  
  // For all other routes, serve index.html (SPA routing)
  res.sendFile(join(DIST_DIR, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Portfolio server running on port ${PORT}`);
  console.log(`Serving files from: ${DIST_DIR}`);
});

