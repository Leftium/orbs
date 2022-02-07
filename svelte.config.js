import coffee from "vite-plugin-coffee";
import plainTextPlugin from 'vite-plugin-plain-text';
let plainText = plainTextPlugin.default

import preprocess from "svelte-preprocess";
import adapter from "@sveltejs/adapter-auto";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter(),

    vite: {
      plugins: [
        coffee({
          jsx: false,
        }),
        plainText(/\.(txt|md)$/),
      ],
    },
  },

  preprocess: [
    preprocess({
      coffeescript: {
        bare: true,
      },
    }),
  ],
};

export default config;
