<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Editar página' })

const route = useRoute()
const id = route.params.id as string

const { data: item } = await useFetch(`/api/pages/${id}`, { key: `dash-page-${id}` })

const form = reactive({
  title: '',
  slug: '',
  description: '',
  body: '',
  content: { rows: [] } as any,
})
const saving = ref(false)
const error = ref('')

watch(item, (val) => {
  if (val) {
    form.title = val.title
    form.slug = val.slug
    form.description = val.description || ''
    form.body = val.body || ''
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
      const { content, ...rest } = form
      await $fetch(`/api/pages/${id}`, { method: 'PUT', body: { ...rest, content } })
    await navigateTo('/dashboard/paginas')
  } catch (e: any) {
    error.value = e.data?.message || e.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="form-page">
    <h1 class="page-title">Editar página: {{ form.title }}</h1>
    <form @submit.prevent="save" class="max-w-3xl">
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
          <label>Meta descripción (SEO)</label>
          <textarea v-model="form.description" rows="2" placeholder="Máximo 160 caracteres" class="w-full text-sm border border-gray-300 rounded px-2 py-1.5" />
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
        <h2 class="text-lg font-semibold text-gray-800 mb-4">Contenido</h2>
        <PageBuilder v-model="form.content.rows" />
      </div>

      <p v-if="error" class="form-error">{{ error }}</p>
      <div class="form-actions">
        <NuxtLink to="/dashboard/paginas" class="btn-cancel">Cancelar</NuxtLink>
        <button type="submit" class="btn-primary" :disabled="saving">{{ saving ? 'Guardando...' : 'Actualizar' }}</button>
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
