<script setup lang="ts">
const route = useRoute()
const slug = route.params.slug as string

const { data: article, error } = await useFetch(`/api/news/${slug}`, { key: `news-${slug}` })

if (error.value || !article.value) {
  throw createError({ statusCode: 404, message: 'Noticia no encontrada' })
}

usePageSeo({
  title: article.value.title,
  description: article.value.excerpt || '',
  image: article.value.image || undefined,
  type: 'article',
  jsonld: newsJsonld(article.value.title, article.value.published_at, article.value.excerpt, article.value.image),
})
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-12">
    <NuxtLink to="/" class="text-sm text-brand-teal hover:text-teal-700 transition-colors no-underline mb-6 inline-block">← Volver al inicio</NuxtLink>

    <article v-if="article">
      <img v-if="article.image" :src="article.image" :alt="article.title" class="w-full h-64 object-cover rounded-xl mb-6" />
      <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-gray-800 mb-3">{{ article.title }}</h1>

      <p v-if="article.published_at" class="text-sm text-gray-400 mb-8">
        {{ new Date(article.published_at).toLocaleDateString('es-ES', { year: 'numeric', month: 'long', day: 'numeric' }) }}
      </p>

      <p v-if="article.excerpt" class="text-lg text-gray-500 italic mb-6">{{ article.excerpt }}</p>

      <div v-if="article.body" class="prose max-w-none text-gray-700 leading-relaxed" v-html="article.body" />
    </article>
  </div>
</template>
