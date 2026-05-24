<script setup lang="ts">
const route = useRoute()
const slug = route.params.slug as string

const { data: page, error } = await useFetch(`/api/pages/${slug}`, { key: `page-${slug}` })

if (error.value || !page.value) {
  throw createError({ statusCode: 404, message: 'Página no encontrada' })
}

if (typeof window !== 'undefined') {
  console.log('[PageLoader] slug:', slug)
  console.log('[PageLoader] page.value:', JSON.parse(JSON.stringify(page.value)))
  console.log('[PageLoader] content.rows:', page.value?.content?.rows)
  console.log('[PageLoader] content.rows count:', page.value?.content?.rows?.length)
  if (page.value?.content?.rows) {
    page.value.content.rows.forEach((row: any, ri: number) => {
      console.log(`[PageLoader] Row ${ri}:`, { columns: row.columns?.length, widgetsPerCol: row.columns?.map((c: any) => c.widgets?.length) })
    })
  }
}

usePageSeo({
  title: page.value.title,
  description: page.value.description || '',
  url: `/${page.value.slug}`,
  jsonld: webPageJsonld(page.value.title, page.value.description, `/${page.value.slug}`),
})
</script>

<template>
  <div>
    <PageWidgets v-if="page?.content?.rows" :rows="page.content.rows" />
    <PageRenderer v-else-if="page?.content?.sections" :sections="page.content.sections" />

    <div v-else-if="page?.body" class="max-w-4xl mx-auto px-4 py-12" v-html="page.body" />

    <div v-else class="max-w-4xl mx-auto px-4 py-12">
      <h1 class="text-4xl font-bold font-kadwa text-gray-800">{{ page.title }}</h1>
    </div>
  </div>
</template>
