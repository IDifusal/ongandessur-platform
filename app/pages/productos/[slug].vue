<script setup lang="ts">
const route = useRoute()
const slug = route.params.slug as string

const { data: product, error } = await useFetch(`/api/products/${slug}`, { key: `prod-${slug}` })

if (error.value || !product.value) {
  throw createError({ statusCode: 404, message: 'Producto no encontrado' })
}

usePageSeo({
  title: product.value.name,
  description: product.value.description || '',
  image: product.value.images?.[0] || undefined,
  type: 'product',
  jsonld: productJsonld(product.value.name, product.value.description, product.value.price, product.value.images?.[0]),
})

const phone = product.value.contact_phone
</script>

<template>
  <div class="max-w-5xl mx-auto px-4 py-12">
    <NuxtLink to="/" class="text-sm text-brand-teal hover:text-teal-700 transition-colors no-underline mb-6 inline-block">← Volver al inicio</NuxtLink>

    <div v-if="product" class="bg-white rounded-xl shadow-md overflow-hidden">
      <img v-if="product.images?.[0]" :src="product.images[0]" :alt="product.name" class="w-full h-72 object-cover" />
      <div class="p-8">
        <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-gray-800 mb-4">{{ product.name }}</h1>

        <div class="text-3xl font-bold text-brand-teal mb-6">${{ Number(product.price).toLocaleString() }}</div>

        <div v-if="product.description" class="prose max-w-none text-gray-600 leading-relaxed mb-6" v-html="product.description" />

        <div v-if="phone" class="bg-gray-50 rounded-lg p-4 border border-gray-200">
          <span class="text-sm font-semibold text-gray-700">📞 Contacto: </span>
          <a :href="`tel:${phone}`" class="text-brand-teal font-semibold no-underline hover:underline">{{ phone }}</a>
        </div>
      </div>
    </div>
  </div>
</template>
