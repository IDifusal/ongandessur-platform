<script setup lang="ts">
const { data: services } = await useFetch('/api/services', { key: 'public-services' })
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-16">
    <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-center text-gray-800 mb-12">Servicios</h1>
    <div v-if="services?.length" class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="svc in services" :key="svc.id" class="bg-white rounded-xl shadow-md overflow-hidden flex flex-col">
        <img v-if="svc.image" :src="svc.image" :alt="svc.title" class="w-full h-48 object-cover" />
        <div class="p-4 flex flex-col flex-1">
          <h3 class="font-bold font-kadwa text-lg text-gray-800 mb-2">{{ svc.title }}</h3>
          <p class="text-sm text-gray-600 leading-relaxed flex-1">{{ svc.description?.replace(/<[^>]*>/g, '').slice(0, 200) || '' }}</p>
          <div class="mt-4 pt-3 border-t border-gray-100">
            <NuxtLink :to="`/servicios/${svc.slug}`" class="text-sm text-brand-gold font-semibold hover:text-amber-700 transition-colors no-underline">
              Ver más →
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    <p v-else class="text-center text-gray-400 py-12">No hay servicios disponibles.</p>
  </div>
</template>
