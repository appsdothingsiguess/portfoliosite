import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

// Astro uses Vite under the hood. This file handles the build optimization.
export default defineConfig({
  output: 'static', // Generates pure HTML/CSS/JS for your server
  integrations: [
    tailwind({
      applyBaseStyles: false, // We're importing global.css with @tailwind directives
      configFile: './tailwind.config.mjs',
    })
  ],
  compressHTML: true,
  build: {
    format: 'directory' // Outputs index.html inside folders (better for SEO)
  },
  // Vite-specific optimizations can go here if needed later
  vite: {
    build: {
      assetsInlineLimit: 0, // Ensures assets are handled correctly
    },
    // Improve content collection watching
    server: {
      watch: {
        // Watch content directory for changes
        ignored: ['!**/src/content/**']
      }
    }
  }
});