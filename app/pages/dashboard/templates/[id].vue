<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Editar template' })

const route = useRoute()
const id = route.params.id as string

const { data: item } = await useFetch(`/api/templates/${id}`, { key: `dash-tpl-${id}` })

const form = reactive({
  title: '',
  slug: '',
  description: '',
  templateFor: 'news',
  content: { rows: [] } as any,
})
const saving = ref(false)
const error = ref('')

const templateVars: Record<string, { label: string; vars: { name: string; desc: string }[] }> = {
  news: {
    label: 'Noticias',
    vars: [
      { name: 'title', desc: 'Titulo de la noticia' },
      { name: 'image', desc: 'Imagen destacada' },
      { name: 'description', desc: 'Extracto/resumen' },
      { name: 'date', desc: 'Fecha de publicacion' },
      { name: 'link', desc: 'Enlace a la noticia' },
      { name: 'slug', desc: 'Slug identificador' },
    ],
  },
  products: {
    label: 'Productos',
    vars: [
      { name: 'title', desc: 'Nombre del producto' },
      { name: 'image', desc: 'Imagen principal' },
      { name: 'description', desc: 'Descripcion' },
      { name: 'price', desc: 'Precio formateado' },
      { name: 'link', desc: 'Enlace al producto' },
      { name: 'slug', desc: 'Slug identificador' },
    ],
  },
  services: {
    label: 'Servicios',
    vars: [
      { name: 'title', desc: 'Titulo del servicio' },
      { name: 'image', desc: 'Imagen destacada' },
      { name: 'description', desc: 'Descripcion' },
      { name: 'link', desc: 'Enlace al servicio' },
      { name: 'slug', desc: 'Slug identificador' },
    ],
  },
}

const currentVars = computed(() => templateVars[form.templateFor]?.vars || [])

watch(item, (val) => {
  if (val) {
    form.title = val.title
    form.slug = val.slug
    form.description = val.description || ''
    form.templateFor = val.content?.template_for || 'news'
    form.content = val.content && val.content.rows ? val.content : { rows: [] }
  }
}, { immediate: true })

function updateRows(val: any[]) {
  form.content.rows = val
}

async function save() {
  error.value = ''
  saving.value = true
  try {
    const payload = JSON.parse(JSON.stringify(form))
    const { content, templateFor, ...rest } = payload
    await $fetch(`/api/templates/${id}`, { method: 'PUT', body: { ...rest, content: { ...content, template_for: templateFor } } })
    await navigateTo('/dashboard/templates')
  } catch (e: any) {
    error.value = e.data?.message || e.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="form-page">
    <h1 class="page-title">Editar template: {{ form.title }}</h1>
    <form @submit.prevent="save" class="w-[calc(100vw-180px)] overflow-x-hidden">
      <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
        <div class="grid grid-cols-2 gap-4">
          <div class="field">
            <label>Título</label>
            <input v-model="form.title" required />
          </div>
          <div class="field">
            <label>Slug</label>
            <input v-model="form.slug" required />
          </div>
        </div>
        <div class="field mt-4">
          <label>Descripción</label>
          <textarea v-model="form.description" rows="2" class="w-full text-sm border border-gray-300 rounded px-2 py-1.5" />
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
        <h2 class="text-lg font-semibold text-gray-800 mb-4">Diseño del template</h2>
        <div class="mb-4">
          <div class="field">
            <label>Este template es para</label>
            <select v-model="form.templateFor" class="w-full p-2.5 border border-gray-300 rounded text-sm">
              <option value="news">Noticias</option>
              <option value="products">Productos</option>
              <option value="services">Servicios</option>
            </select>
          </div>
        </div>

        <div class="flex flex-col lg:flex-row gap-6">
          <div class="flex-1 min-w-0">
            <PageBuilder v-model="form.content.rows" />
          </div>

          <div class="lg:w-56 flex-shrink-0">
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 sticky top-4">
              <h3 class="text-sm font-bold text-blue-800 mb-2">Variables disponibles</h3>
              <p class="text-xs text-blue-600 mb-3">Usa <code class="bg-blue-100 px-1 rounded">&#123;&#123;variable&#125;&#125;</code> en los widgets de titulo o texto</p>
              <div v-for="v in currentVars" :key="v.name" class="mb-1.5 flex items-center gap-1">
                <button type="button" class="text-xs bg-white border border-blue-200 rounded px-1.5 py-0.5 text-blue-700 font-mono cursor-pointer hover:bg-blue-100 transition-colors" @click="navigator.clipboard.writeText('{{' + v.name + '}}')" :title="'Copiar {{' + v.name + '}}'">&#123;&#123;{{ v.name }}&#125;&#125;</button>
                <span class="text-xs text-blue-500">{{ v.desc }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <p v-if="error" class="form-error">{{ error }}</p>
      <div class="form-actions">
        <NuxtLink to="/dashboard/templates" class="btn-cancel">Cancelar</NuxtLink>
        <button type="submit" class="btn-primary" :disabled="saving">{{ saving ? 'Guardando...' : 'Actualizar template' }}</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.page-title { font-size: 22px; font-weight: 600; color: #1d2327; margin: 0 0 24px; }
.field { display: flex; flex-direction: column; gap: 4px; }
.field label { font-size: 13px; font-weight: 600; color: #1d2327; }
.field input, .field textarea { padding: 10px 12px; border: 1px solid #8c8f94; border-radius: 4px; font-size: 14px; outline: none; font-family: inherit; }
.field input:focus, .field textarea:focus { border-color: #2271b1; box-shadow: 0 0 0 1px #2271b1; }
.form-error { color: #d63638; font-size: 13px; margin: 0 0 12px; }
.form-actions { display: flex; gap: 12px; align-items: center; margin-top: 16px; }
.btn-primary { padding: 8px 18px; background: #2271b1; color: #fff; border: none; border-radius: 4px; font-size: 13px; font-weight: 600; cursor: pointer; }
.btn-primary:hover { background: #135e96; }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }
.btn-cancel { padding: 8px 18px; color: #646970; text-decoration: none; font-size: 13px; }
.btn-cancel:hover { color: #1d2327; }
</style>
