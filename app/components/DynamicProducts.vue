<script setup lang="ts">
const { data: products } = await useFetch('/api/products', { key: 'public-products' })
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-16">
    <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-center text-gray-800 mb-12">Productos</h1>
    <div v-if="products?.length" class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="prod in products" :key="prod.id" class="bg-white rounded-xl shadow-md overflow-hidden flex flex-col">
        <img v-if="prod.images?.[0]" :src="prod.images[0]" :alt="prod.name" class="w-full h-48 object-cover" />
        <div class="p-4 flex flex-col flex-1">
          <h3 class="font-bold font-kadwa text-lg text-gray-800 mb-2">{{ prod.name }}</h3>
          <p class="text-sm text-gray-600 leading-relaxed flex-1">{{ prod.description?.replace(/<[^>]*>/g, '').slice(0, 150) || '' }}</p>
          <div class="flex items-center justify-between mt-4 pt-3 border-t border-gray-100">
            <span class="text-lg font-bold text-brand-teal">${{ Number(prod.price).toLocaleString() }}</span>
            <NuxtLink :to="`/productos/${prod.slug}`" class="text-sm text-brand-gold font-semibold hover:text-amber-700 transition-colors no-underline">
              Ver más →
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    <p v-else class="text-center text-gray-400 py-12">No hay productos disponibles.</p>
  </div>
</template>
