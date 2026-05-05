<script setup lang="ts">
const route = useRoute()
const slug = route.params.slug as string

const { data: service, error } = await useFetch(`/api/services/${slug}`, { key: `svc-${slug}` })

if (error.value || !service.value) {
  throw createError({ statusCode: 404, message: 'Servicio no encontrado' })
}

usePageSeo({
  title: service.value.title,
  description: service.value.description || '',
  image: service.value.image || undefined,
  jsonld: serviceJsonld(service.value.title, service.value.description),
})
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-12">
    <NuxtLink to="/" class="text-sm text-brand-teal hover:text-teal-700 transition-colors no-underline mb-6 inline-block">← Volver al inicio</NuxtLink>

    <article v-if="service">
      <img v-if="service.image" :src="service.image" :alt="service.title" class="w-full h-64 object-cover rounded-xl mb-6" />
      <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-gray-800 mb-6">{{ service.title }}</h1>
      <div v-if="service.description" class="prose max-w-none text-gray-700 leading-relaxed" v-html="service.description" />
    </article>
  </div>
</template>
