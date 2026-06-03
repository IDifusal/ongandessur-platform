/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './app/**/*.{vue,js,ts}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          // New Figma design palette
          green: '#2F6B4F',
          'green-dark': '#1F4635',
          cream: '#FEE0AA',
          'bg-warm': '#FFF8ED',
          terracotta: '#C96B3C',
          'gold-new': '#F4B942',
          'brown-text': '#33251A',
          'gray-text': '#667085',
          // Legacy (kept for existing content)
          teal: '#1fa185',
          gold: '#ba9774',
          blue: '#3695eb',
        },
      },
      fontFamily: {
        kadwa: ['Kadwa', 'serif'],
        'open-sans': ['Open Sans', 'sans-serif'],
        nanum: ['"Nanum Pen Script"', 'cursive'],
      },
    },
  },
  plugins: [],
}
