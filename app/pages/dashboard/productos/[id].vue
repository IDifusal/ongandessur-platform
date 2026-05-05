<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Editar producto' })

const route = useRoute()
const id = route.params.id as string

const { data: item } = await useFetch(`/api/products/${id}`, { key: `cms-prod-${id}` })

const form = reactive({ name: '', slug: '', description: '', price: 0, contact_phone: '', image: '', published_at: '' })
const saving = ref(false)
const error = ref('')

watch(item, (val) => {
  if (val) {
    form.name = val.name
    form.slug = val.slug
    form.description = val.description || ''
    form.price = Number(val.price)
    form.contact_phone = val.contact_phone || ''
    form.image = val.images?.[0] || ''
    form.published_at = val.published_at ? val.published_at.slice(0, 10) : ''
  }
}, { immediate: true })

async function save() {
  error.value = ''
  saving.value = true
  try {
    const body: Record<string, unknown> = { name: form.name, slug: form.slug, description: form.description, price: form.price, contact_phone: form.contact_phone, images: form.image ? [form.image] : [] }
    if (form.published_at) body.published_at = form.published_at
    else body.published_at = null
    await $fetch(`/api/products/${id}`, { method: 'PUT', body })
    await navigateTo('/dashboard/productos')
  } catch (e: any) {
    error.value = e.data?.message || e.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="form-page">
    <h1 class="page-title">Editar producto</h1>
    <form @submit.prevent="save" class="cms-form">
      <div class="field">
        <label>Nombre</label>
        <input v-model="form.name" required />
      </div>
      <div class="field">
        <label>Slug</label>
        <input v-model="form.slug" required />
      </div>
      <div class="field">
        <label>Descripción</label>
        <RichEditor v-model="form.description" placeholder="Describe el producto..." />
      </div>
      <div class="field">
        <label>Imagen destacada</label>
        <ImageUploader v-model="form.image" />
      </div>
      <div class="field">
        <label>Precio ($)</label>
        <input v-model="form.price" type="number" step="0.01" min="0" required />
      </div>
      <div class="field">
        <label>Teléfono de contacto</label>
        <input v-model="form.contact_phone" type="tel" required placeholder="+54 9 11 1234-5678" />
      </div>
      <div class="field">
        <label>Fecha de publicación</label>
        <input v-model="form.published_at" type="date" />
      </div>
      <p v-if="error" class="form-error">{{ error }}</p>
      <div class="form-actions">
        <NuxtLink to="/dashboard/productos" class="btn-cancel">Cancelar</NuxtLink>
        <button type="submit" class="btn-primary" :disabled="saving">{{ saving ? 'Guardando...' : 'Actualizar' }}</button>
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
