/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,jsx,ts,tsx}", "./components/**/*.{js,jsx,ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        ranger: {
          50: "#f7f8f3",
          100: "#eef1e6",
          200: "#dbe1c4",
          300: "#c2ca9c",
          400: "#9fb06b",
          500: "#7f964c",
          600: "#62763a",
          700: "#4e5d2f",
          800: "#394324",
          900: "#29341b"
        },
        night: {
          50: "#f3f5f7",
          100: "#e5eaef",
          200: "#c7d0db",
          300: "#a1afc1",
          400: "#6f829a",
          500: "#4a5a70",
          600: "#344153",
          700: "#252f3b",
          800: "#181f28",
          900: "#0f141a"
        },
        accent: {
          500: "#ffd166"
        }
      },
    },
  },
  plugins: [],
};
