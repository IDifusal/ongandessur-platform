<script setup lang="ts">
const { data: news } = await useFetch('/api/news', { key: 'public-news' })
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-16">
    <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-center text-gray-800 mb-12">Noticias</h1>
    <div v-if="news?.length" class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="item in news" :key="item.id" class="bg-white rounded-xl shadow-md overflow-hidden flex flex-col">
        <img v-if="item.image" :src="item.image" :alt="item.title" class="w-full h-48 object-cover" />
        <div class="p-4 flex flex-col flex-1">
          <h3 class="font-bold font-kadwa text-lg text-gray-800 mb-2">{{ item.title }}</h3>
          <p v-if="item.excerpt" class="text-sm text-gray-600 leading-relaxed flex-1">{{ item.excerpt }}</p>
          <div class="flex items-center justify-between mt-4 pt-3 border-t border-gray-100">
            <span v-if="item.published_at" class="text-xs text-gray-400">{{ new Date(item.published_at).toLocaleDateString() }}</span>
            <NuxtLink :to="`/noticias/${item.slug}`" class="text-sm text-brand-gold font-semibold hover:text-amber-700 transition-colors no-underline">
              Leer más →
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    <p v-else class="text-center text-gray-400 py-12">No hay noticias disponibles.</p>
  </div>
</template>
