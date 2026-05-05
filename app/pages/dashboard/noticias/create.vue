<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Nueva noticia' })

const form = reactive({ title: '', slug: '', body: '', excerpt: '', image: '', published_at: '' })
const saving = ref(false)
const error = ref('')

function generateSlug() {
  if (!form.slug) {
    form.slug = form.title.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '')
  }
}

async function save() {
  error.value = ''
  saving.value = true
  try {
    const body: Record<string, unknown> = { title: form.title, slug: form.slug, body: form.body, excerpt: form.excerpt, image: form.image }
    if (form.published_at) body.published_at = form.published_at
    await $fetch('/api/news', { method: 'POST', body })
    await navigateTo('/dashboard/noticias')
  } catch (e: any) {
    error.value = e.data?.message || e.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="form-page">
    <h1 class="page-title">Nueva noticia</h1>
    <form @submit.prevent="save" class="cms-form">
      <div class="field">
        <label>Título</label>
        <input v-model="form.title" required @blur="generateSlug" />
      </div>
      <div class="field">
        <label>Slug</label>
        <input v-model="form.slug" required />
      </div>
      <div class="field">
        <label>Imagen destacada</label>
        <ImageUploader v-model="form.image" />
      </div>
      <div class="field">
        <label>Extracto</label>
        <textarea v-model="form.excerpt" rows="3"></textarea>
      </div>
      <div class="field">
        <label>Cuerpo</label>
        <RichEditor v-model="form.body" placeholder="Escribe el contenido de la noticia..." />
      </div>
      <div class="field">
        <label>Fecha de publicación</label>
        <input v-model="form.published_at" type="date" />
      </div>
      <p v-if="error" class="form-error">{{ error }}</p>
      <div class="form-actions">
        <NuxtLink to="/dashboard/noticias" class="btn-cancel">Cancelar</NuxtLink>
        <button type="submit" class="btn-primary" :disabled="saving">{{ saving ? 'Guardando...' : 'Publicar' }}</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
.page-title { font-size: 22px; font-weight: 600; color: #1d2327; margin: 0 0 24px; }
.cms-form { max-width: 640px; display: flex; flex-direction: column; gap: 18px; }
.field { display: flex; flex-direction: column; gap: 4px; }
.field label { font-size: 13px; font-weight: 600; color: #1d2327; }
.field input, .field textarea { padding: 10px 12px; border: 1px solid #8c8f94; border-radius: 4px; font-size: 14px; outline: none; font-family: inherit; }
.field input:focus, .field textarea:focus { border-color: #2271b1; box-shadow: 0 0 0 1px #2271b1; }
.form-error { color: #d63638; font-size: 13px; margin: 0; }
.form-actions { display: flex; gap: 12px; align-items: center; }
.btn-primary { padding: 8px 18px; background: #2271b1; color: #fff; border: none; border-radius: 4px; font-size: 13px; font-weight: 600; cursor: pointer; }
.btn-primary:hover { background: #135e96; }
.btn-primary:disabled { opacity: 0.6; cursor: not-allowed; }
.btn-cancel { padding: 8px 18px; color: #646970; text-decoration: none; font-size: 13px; }
.btn-cancel:hover { color: #1d2327; }
</style>
