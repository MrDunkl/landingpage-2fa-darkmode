import type { Config } from 'tailwindcss'

const config: Config = {
  darkMode: 'class',
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'sky-200': '#b2f0ff',
        'mint-200': '#d7ffb3',
        'lime-200': '#d7ffb3',
      },
    },
  },
  plugins: [],
}
export default config
