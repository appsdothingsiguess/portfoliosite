/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: 'var(--brand)',
          ink: 'var(--brand-ink)',
        },
        bg: 'var(--bg)',
        surface: {
          DEFAULT: 'var(--surface)',
          2: 'var(--surface-2)',
        },
        text: {
          DEFAULT: 'var(--text)',
          muted: 'var(--muted)',
        },
        border: 'var(--border)',
        muted: 'var(--muted)',
        info: 'var(--info)',
        success: 'var(--success)',
        warning: 'var(--warning)',
        danger: 'var(--danger)',
      },
      fontFamily: {
        serif: ['Newsreader', 'Georgia', 'serif'],
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
      },
      animation: {
        'sweep': 'sweep 0.2s ease-in-out',
        'flash-focus': 'flash-focus 2s ease-out',
      },
      keyframes: {
        sweep: {
          '0%': { opacity: '0', transform: 'translateY(-10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        'flash-focus': {
          '0%': { backgroundColor: 'rgba(255, 214, 112, 0.2)' },
          '100%': { backgroundColor: 'transparent' },
        }
      }
    },
  },
  plugins: [],
};