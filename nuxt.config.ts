export default defineNuxtConfig({
  ssr: true,

  nitro: {
    preset: 'netlify',
  },

  modules: ['@nuxtjs/supabase', '@nuxtjs/tailwindcss'],

  supabase: {
    redirect: false,
    cookieOptions: {
      secure: true,
    },
    clientOptions: {
      auth: {
        flowType: 'pkce',
      },
    },
  },

  app: {
    head: {
      link: [
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Kadwa:wght@400;700&family=Open+Sans:wght@400;600;700&family=Nanum+Pen+Script&display=swap',
        },
      ],
    },
  },

  compatibilityDate: '2025-04-01',
})
