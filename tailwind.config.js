const colors = require('tailwindcss/colors');

module.exports = {
  darkMode: 'class',
  theme: {
    fontFamily: {
      sans: ["'DM Sans'", 'sans-serif'],
      serif: ["'DM Sans'", 'sans-serif'],
    },
    extend: {

      colorsDisabled: {
        cyan: '#9cdbff',
        //gray: grayColors,
      },
      colors: {
        transparent: 'transparent',
        current: 'currentColor',
        black: colors.black,
        white: colors.white,
        gray: colors.zinc,
        indigo: colors.indigo,
        red: colors.rose,
        green: colors.emerald,
        yellow: colors.amber,
        brand: {
          50:  "#fdf2f8",
          100: "#fce7f3",
          200: "#fbcfe8",
          300: "#f9a8d4",
          400: "#f472b6",
          500: "#ec4899",
          600: "#db2777",
          700: "#be185d",
          800: "#9d174d",
          900: "#831843",
          950: "#500724"
        }
      }
    }
  },
  content: [
    "./**/*.erb",
    './app/views/**/*.html.erb',
    './app/views/**/*.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
