<script setup lang="ts">
const mobileOpen = ref(false)

const { data: pages } = await useFetch('/api/pages', { key: 'layout-pages' })

const navPages = computed(() => {
  if (!pages.value) return []
  return pages.value.filter((p: any) => p.slug !== 'home' && p.slug !== 'dashboard')
})
</script>

<template>
  <div class="min-h-screen flex flex-col font-open-sans">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-20">
          <NuxtLink to="/" class="flex items-center gap-3 no-underline">
            <div class="w-12 h-12 bg-brand-green rounded-lg flex items-center justify-center flex-shrink-0">
              <span class="text-white text-xl font-bold font-kadwa">AS</span>
            </div>
            <div class="flex flex-col">
              <span class="text-brand-green font-bold text-lg leading-tight font-kadwa">ONG Andes Sur</span>
              <span class="text-brand-gray-text text-xs">Desarrollo con esperanza</span>
            </div>
          </NuxtLink>

          <nav class="hidden lg:flex items-center gap-1">
            <NuxtLink to="/" class="px-3 py-2 rounded-md text-sm text-brand-brown-text hover:bg-brand-bg-warm transition-colors no-underline">Inicio</NuxtLink>
            <NuxtLink
              v-for="p in navPages"
              :key="p.slug"
              :to="`/${p.slug}`"
              class="px-3 py-2 rounded-md text-sm text-brand-brown-text hover:bg-brand-bg-warm transition-colors no-underline"
            >
              {{ p.title }}
            </NuxtLink>
            <NuxtLink to="/colabora" class="ml-4 px-5 py-2.5 bg-brand-terracotta text-white rounded-lg text-sm no-underline hover:opacity-90 transition-opacity">
              Colabora
            </NuxtLink>
          </nav>

          <button class="lg:hidden p-2 text-brand-brown-text" @click="mobileOpen = !mobileOpen">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path v-if="!mobileOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>

      <div v-if="mobileOpen" class="lg:hidden border-t border-gray-200 bg-white px-4 py-4 flex flex-col gap-2">
        <NuxtLink to="/" class="px-3 py-2 rounded-md text-sm text-brand-brown-text hover:bg-brand-bg-warm no-underline" @click="mobileOpen = false">Inicio</NuxtLink>
        <NuxtLink
          v-for="p in navPages"
          :key="p.slug"
          :to="`/${p.slug}`"
          class="px-3 py-2 rounded-md text-sm text-brand-brown-text hover:bg-brand-bg-warm no-underline"
          @click="mobileOpen = false"
        >
          {{ p.title }}
        </NuxtLink>
        <NuxtLink to="/colabora" class="mt-2 px-5 py-2.5 bg-brand-terracotta text-white rounded-lg text-sm text-center no-underline" @click="mobileOpen = false">
          Colabora
        </NuxtLink>
      </div>
    </header>

    <!-- Page content -->
    <main class="flex-1">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="bg-brand-green-dark text-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div>
            <div class="flex items-center gap-3 mb-4">
              <div class="w-10 h-10 bg-brand-green rounded-lg flex items-center justify-center flex-shrink-0">
                <span class="text-white text-base font-bold font-kadwa">AS</span>
              </div>
              <span class="font-bold font-kadwa">ONG Andes Sur</span>
            </div>
            <p class="text-brand-cream text-sm">Desarrollo con esperanza</p>
          </div>

          <div>
            <h3 class="font-semibold mb-4 text-sm uppercase tracking-wide">Enlaces rápidos</h3>
            <ul class="space-y-2 text-sm">
              <li><NuxtLink to="/" class="text-white/70 hover:text-brand-cream transition-colors no-underline">Inicio</NuxtLink></li>
              <li v-for="p in navPages" :key="p.slug">
                <NuxtLink :to="`/${p.slug}`" class="text-white/70 hover:text-brand-cream transition-colors no-underline">{{ p.title }}</NuxtLink>
              </li>
            </ul>
          </div>

          <div>
            <h3 class="font-semibold mb-4 text-sm uppercase tracking-wide">Contacto</h3>
            <ul class="space-y-3 text-sm text-white/70">
              <li class="flex items-start gap-2">
                <svg class="w-4 h-4 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                ongandessur@gmail.com
              </li>
              <li class="flex items-start gap-2">
                <svg class="w-4 h-4 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                Arequipa, Perú
              </li>
            </ul>
          </div>

          <div>
            <h3 class="font-semibold mb-4 text-sm uppercase tracking-wide">Síguenos</h3>
            <div class="flex gap-3">
              <a href="#" class="w-9 h-9 bg-brand-green rounded-lg flex items-center justify-center hover:bg-brand-cream hover:text-brand-green-dark transition-colors">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M18.77 7.46H14.5v-1.9c0-.9.6-1.1 1-1.1h3V.5h-4.33C10.24.5 9.5 3.44 9.5 5.32v2.15h-3v4h3v12h5v-12h3.85l.42-4z"/></svg>
              </a>
              <a href="#" class="w-9 h-9 bg-brand-green rounded-lg flex items-center justify-center hover:bg-brand-cream hover:text-brand-green-dark transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><rect x="2" y="2" width="20" height="20" rx="5" ry="5" stroke-width="2"/><path d="M16 11.37A4 4 0 1112.63 8 4 4 0 0116 11.37z" stroke-width="2"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5" stroke-width="2" stroke-linecap="round"/></svg>
              </a>
              <a href="#" class="w-9 h-9 bg-brand-green rounded-lg flex items-center justify-center hover:bg-brand-cream hover:text-brand-green-dark transition-colors">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6zM2 9h4v12H2z"/><circle cx="4" cy="4" r="2"/></svg>
              </a>
            </div>
            <NuxtLink to="/dashboard" class="text-xs text-white/40 hover:text-white/70 transition-colors no-underline mt-6 inline-block">Acceso Interno</NuxtLink>
          </div>
        </div>

        <div class="border-t border-brand-green mt-8 pt-6 text-center text-sm text-brand-cream/70">
          &copy; {{ new Date().getFullYear() }} ONG Andes Sur. Todos los derechos reservados.
        </div>
      </div>
    </footer>
  </div>
</template>
