/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './app/**/*.{vue,js,ts}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
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
