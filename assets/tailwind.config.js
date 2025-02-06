// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/vozio_web.ex",
    "../lib/vozio_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
        "vozio-primary": "rgb(61, 135, 161)",
        "vozio-primary-dark": "rgb(48, 103, 129)",
        "vozio-bacground-light": "rgb(246, 241, 225)",
        "vozio-background-dark": "rgb(30, 30, 30)",
        "vozio-text-light": "rgb(62, 62, 62)",
        "vozio-text-dark": "rgb(240, 240, 240)",
        "vozio-border-light": "rgb(185, 185, 185)",
        "vozio-border-dark": "rgb(130, 130, 130)",
        "vozio-surface-light": "rgb(241, 230, 212)",
        "vozio-surface-dark": "rgb(56, 56, 56)",
        "vozio-error-dark": "rgb(212, 106, 106)",
        "vozio-error-light": "rgb(212, 106, 106)",
        "vozio-color-pink-light": "rgb(223, 96, 143)",
        "vozio-color-red-light": "rgb(184, 56, 71)",
        "vozio-color-green-light": "rgb(95, 163, 126)",
        "vozio-color-blue-light": "rgb(60, 110, 137)",
        "vozio-color-yellow-light": "rgb(246, 222, 102)",
        "vozio-color-purple-light": "rgb(120, 75, 144)",
        "vozio-color-teal-light": "rgb(56, 142, 142)",
        "vozio-color-orange-light": "rgb(239, 115, 48)",
        "vozio-color-brown-light": "rgb(160, 106, 76)",
        "vozio-color-sky-blue-light": "rgb(180, 214, 231)",
        "vozio-color-pink-dark": "rgb(174, 56, 88)",
        "vozio-color-red-dark": "rgb(139, 36, 46)",
        "vozio-color-green-dark": "rgb(52, 110, 84)",
        "vozio-color-blue-dark": "rgb(40, 80, 102)",
        "vozio-color-yellow-dark": "rgb(194, 168, 53)",
        "vozio-color-purple-dark": "rgb(84, 47, 94)",
        "vozio-color-teal-dark": "rgb(36, 99, 99)",
        "vozio-color-orange-dark": "rgb(192, 80, 25)",
        "vozio-color-brown-dark": "rgb(107, 61, 40)",
        "vozio-color-sky-blue-dark": "rgb(137, 163, 183)"
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents({
        "hero": ({ name, fullPath }) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, { values })
    })
  ]
}
