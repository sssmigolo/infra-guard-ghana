// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        ghana: {
          gold: '#FCD116',
          green: '#006B3F',
          red: '#CE1126',
          black: '#000000',
        },
        surface: {
          dark: '#0A0E1A',
          'dark-card': '#141929',
          'dark-border': '#2A3050',
          light: '#F8F9FC',
          'light-card': '#FFFFFF',
          'light-border': '#E2E8F0',
        },
      },
      fontFamily: {
        outfit: ['Outfit', 'sans-serif'],
      },
      borderRadius: {
        xl: '16px',
        '2xl': '20px',
      },
      backdropBlur: {
        glass: '10px',
      },
    },
  },
  plugins: [],
};
