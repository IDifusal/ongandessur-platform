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
    <header class="bg-white shadow-md sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 flex items-center justify-between h-16">
        <NuxtLink to="/" class="flex items-center gap-2 no-underline">
          <span class="text-xl font-bold font-kadwa text-brand-teal">ONG Andes Sur</span>
        </NuxtLink>

        <nav class="hidden md:flex items-center gap-6">
          <NuxtLink to="/" class="text-sm font-semibold text-gray-700 hover:text-brand-teal transition-colors no-underline">Inicio</NuxtLink>
          <NuxtLink
            v-for="p in navPages"
            :key="p.slug"
            :to="`/${p.slug}`"
            class="text-sm font-semibold text-gray-700 hover:text-brand-teal transition-colors no-underline"
          >
            {{ p.title }}
          </NuxtLink>
        </nav>

        <button class="md:hidden p-2" @click="mobileOpen = !mobileOpen">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path v-if="!mobileOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div v-if="mobileOpen" class="md:hidden border-t bg-white px-4 py-4 flex flex-col gap-3">
        <NuxtLink to="/" class="text-sm font-semibold text-gray-700" @click="mobileOpen = false">Inicio</NuxtLink>
        <NuxtLink
          v-for="p in navPages"
          :key="p.slug"
          :to="`/${p.slug}`"
          class="text-sm font-semibold text-gray-700"
          @click="mobileOpen = false"
        >
          {{ p.title }}
        </NuxtLink>
      </div>
    </header>

    <!-- Page content -->
    <main class="flex-1">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 text-gray-400 py-12">
      <div class="max-w-7xl mx-auto px-4 grid grid-cols-1 md:grid-cols-3 gap-8">
        <div>
          <h4 class="text-white font-bold font-kadwa text-lg mb-3">ONG Andes Sur</h4>
          <p class="text-sm leading-relaxed">
            Trabajando en biodiversidad y ayuda solidaria a niños y jóvenes que nos necesitan.
          </p>
        </div>
        <div>
          <h4 class="text-white font-bold font-kadwa text-lg mb-3">Enlaces</h4>
          <div class="flex flex-col gap-2 text-sm">
            <NuxtLink
              v-for="p in navPages"
              :key="p.slug"
              :to="`/${p.slug}`"
              class="hover:text-white transition-colors no-underline"
            >
              {{ p.title }}
            </NuxtLink>
          </div>
        </div>
        <div>
          <h4 class="text-white font-bold font-kadwa text-lg mb-3">Contacto</h4>
          <p class="text-sm">Arequipa, Perú</p>
          <p class="text-sm">ongandessur@gmail.com</p>
          <NuxtLink to="/dashboard" class="text-sm text-gray-400 hover:text-white transition-colors no-underline mt-4 inline-block">Acceso Interno</NuxtLink>
        </div>
      </div>
      <div class="max-w-7xl mx-auto px-4 mt-8 pt-8 border-t border-gray-800 text-center text-sm">
        &copy; {{ new Date().getFullYear() }} ONG Andes Sur. Todos los derechos reservados.
      </div>
    </footer>
  </div>
</template>
