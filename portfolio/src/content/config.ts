// NOTE: If using for linting/Dev, you may get 'Cannot find module astro:content...' in VSCode or non-Astro JS environments. 
// This error does NOT affect Astro project builds if packages are properly installed. 
// To resolve for dev: run `npm install astro@latest` in your project root OR add a `tsconfig.json` with "types": ["astro/client"].

import { z, defineCollection } from 'astro:content';

// 1. Journalism Collection
// Supports: Articles, Instagram Reels, Videos
// Note: Journalism articles don't need modes - they're content pieces shown in all modes
const journalism = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    publication: z.string(), // e.g., "The Chimes", "Instagram"
    date: z.date(),
    url: z.string().url().optional(), // Link to live artifact
    type: z.enum(['Article', 'Social', 'Video', 'Multimedia']),
    impact: z.string().optional(), // e.g., "15k+ views", "Resulted in inquiry"
    summary: z.string(),
  })
});

// 2. Research Collection
// Supports: Posters, Lab Work, Abstracts
const research = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    role: z.string(), // e.g., "First Author", "Research Assistant"
    conference: z.string().optional(), // e.g., "WPA 2025"
    date: z.date(),
    tools: z.array(z.string()), // e.g., ["E-Prime", "SPSS"]
    posterUrl: z.string().optional(), // Path to PDF in /public/assets/pdfs/
    methodology: z.string().optional(), // For the accordion expansion
    findings: z.array(z.string()).optional(), // Bullet points for findings
    modes: z.array(z.enum(['research', 'aba', 'business', 'journalism'])).default(['research']),
  })
});

// 3. Leadership & Operations Collection
// Supports: Management Roles, Team Leadership
const leadership = defineCollection({
  type: 'content',
  schema: z.object({
    organization: z.string(), // e.g., "The Chimes"
    role: z.string(), // e.g., "Business Manager"
    dateStart: z.date(),
    dateEnd: z.date().optional(), // If empty, UI displays "Present"
    metrics: z.array(z.object({
      value: z.string(), // "35%"
      label: z.string(), // "Reduced Costs"
    })).optional(),
    tags: z.array(z.string()).optional(), // e.g., ["Finances", "Payroll"]
    summary: z.string(),
    modes: z.array(z.enum(['research', 'aba', 'business', 'journalism'])).default(['business']),
  })
});

// 4. Business Collection
// Supports: Business Ventures, E-Commerce Operations
const business = defineCollection({
  type: 'content',
  schema: z.object({
    organization: z.string(), // e.g., "Spezz LLC"
    role: z.string(), // e.g., "Founder & Operator"
    dateStart: z.date(),
    dateEnd: z.date().optional(), // If empty, UI displays "Present"
    metrics: z.array(z.object({
      value: z.string(), // "$500k+"
      label: z.string(), // "Gross Revenue"
    })).optional(),
    tags: z.array(z.string()).optional(), // e.g., ["E-Commerce", "P&L Management"]
    summary: z.string(),
    modes: z.array(z.enum(['research', 'aba', 'business', 'journalism'])).default(['business']),
  })
});

// 5. Skills Collection
// Supports: Technical Skills, Tools, Certifications
// Note: Category is now derived from which experience files reference this skill
const skills = defineCollection({
  type: 'content',
  schema: z.object({
    name: z.string(),
    icon: z.string(),
    shortDesc: z.string(),
    level: z.enum(['Beginner', 'Intermediate', 'Advanced', 'Certified']),
    since: z.number(),
    order: z.number().optional(), // For manual sorting
    featured: z.boolean().default(false), // Determines if skill appears in "Top Skills" section
    modes: z.array(z.enum(['research', 'aba', 'business', 'journalism'])).optional(), // Optional: if not set, derived from experience files
  }),
});

// 6. Modes Collection
// Supports: Hero content for each portfolio mode (research, aba, business, journalism)
const modes = defineCollection({
  type: 'content',
  schema: z.object({
    badgeText: z.string(), // e.g., "Specializing in Experimental Design & Data"
    badgeColor: z.string(), // e.g., "bg-blue-500"
    title: z.string(), // Can contain HTML like <br class="hidden md:block"/>
    description: z.string(),
  })
});

// Export the collections to be registered by Astro
export const collections = { journalism, research, leadership, business, skills, modes };