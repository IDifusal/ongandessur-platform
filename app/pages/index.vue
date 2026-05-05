<script setup lang="ts">
const { data: page } = await useFetch('/api/pages/home', { key: 'page-home' })

usePageSeo({
  title: 'Inicio',
  description: 'ONG Andes Sur — biodiversidad, ayuda solidaria a niños y jóvenes, desarrollo sostenible en el sur del Perú.',
  jsonld: [
    orgJsonld(),
    webPageJsonld('ONG Andes Sur | Inicio'),
  ],
  type: 'website',
})
</script>

<template>
  <div>
    <PageWidgets v-if="page?.content?.rows" :rows="page.content.rows" />
    <PageRenderer v-else-if="page?.content?.sections" :sections="page.content.sections" />
    <div v-else class="flex items-center justify-center min-h-[50vh] text-gray-500">
      Cargando...
    </div>
  </div>
</template>
