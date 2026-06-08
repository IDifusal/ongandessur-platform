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
const successMessage = ref('')

// LEEMOS LA COOKIE GLOBAL DEL DASHBOARD
// Esto sincroniza el editor interno con el botón de la barra superior al instante
const themeCookie = useCookie('dashboard-theme')
const isDarkMode = computed(() => themeCookie.value === 'dark')

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
  successMessage.value = ''
  saving.value = true
  try {
    const payload = JSON.parse(JSON.stringify(form))
    const { content, ...rest } = payload
    
    await $fetch(`/api/pages/${id}`, { method: 'PUT', body: { ...rest, content } })
    
    successMessage.value = '¡Cambios guardados correctamente!'
    setTimeout(() => {
      successMessage.value = ''
    }, 3000)

  } catch (e: any) {
    error.value = e.data?.message || e.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="editor-wrapper" :class="{ 'theme-dark': isDarkMode }">
    
    <div class="header-bar">
      <h1 class="page-title">Editar página: <span class="highlight">{{ form.title }}</span></h1>
    </div>

    <form @submit.prevent="save" class="editor-form">
      
      <div class="card flashcard">
        <h2 class="card-title">Datos Generales</h2>
        <div class="grid-2">
          <div class="field">
            <label>Título de la página</label>
            <input v-model="form.title" required placeholder="Ej: Nosotros" />
          </div>
          <div class="field">
            <label>Slug (URL)</label>
            <input v-model="form.slug" required placeholder="ej-nosotros" />
          </div>
        </div>
        <div class="field mt-5">
          <label>Meta descripción (SEO)</label>
          <textarea v-model="form.description" rows="2" placeholder="Un resumen breve para los buscadores (Máx 160 caracteres)" />
        </div>
      </div>

      <div class="card flashcard builder-card">
        <h2 class="card-title">Contenido Visual</h2>
        <div class="builder-container">
          <PageBuilder v-model="form.content.rows" />
        </div>
      </div>

      <div class="action-bar">
        <div class="action-messages">
          <p v-if="error" class="msg-error">{{ error }}</p>
          <p v-if="successMessage" class="msg-success">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
            {{ successMessage }}
          </p>
        </div>
        <div class="action-buttons">
          <NuxtLink to="/dashboard/paginas" class="btn-cancel">Volver a páginas</NuxtLink>
          <button type="submit" class="btn-primary" :disabled="saving">
            {{ saving ? 'Guardando...' : 'Actualizar Cambios' }}
          </button>
        </div>
      </div>

    </form>
  </div>
</template>

<style scoped>
/* SISTEMA DE COLORES Y ESTILOS */
.editor-wrapper {
  --bg-card: #ffffff;
  --bg-input: #e2e8f0; 
  --text-main: #1e293b;
  --text-muted: #64748b;
  --border-color: #e2e8f0;
  --border-focus: #3b82f6;
  --primary-color: #0f172a;
  --primary-hover: #334155;
  
  --shadow-card: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
  
  min-height: calc(100vh - 150px);
  padding: 0px 16px 120px; 
}

/* Aplicamos las variables directamente cuando la clase theme-dark está presente */
.editor-wrapper.theme-dark {
  --bg-card: #0f172a; 
  --bg-input: #1e293b; 
  --text-main: #f8fafc;
  --text-muted: #94a3b8;
  --border-color: #1e293b;
  --border-focus: #60a5fa;
  --primary-color: #3b82f6;
  --primary-hover: #2563eb;
  
  --shadow-card: 0 4px 6px -1px rgba(0, 0, 0, 0.2);
}

/* Header */
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
}
.page-title {
  font-size: 28px;
  font-weight: 800;
  color: var(--text-main);
  margin: 0;
  letter-spacing: -0.5px;
}
.page-title .highlight {
  color: var(--primary-color);
}

/* Tarjetas (Flashcards Estáticas) */
.flashcard {
  background: var(--bg-card);
  border-radius: 16px; 
  padding: 32px;
  margin-bottom: 32px;
  box-shadow: var(--shadow-card);
  border: 1px solid var(--border-color);
}

.builder-card {
  min-height: 500px;
}
.card-title {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-main);
  margin: 0 0 24px 0;
  padding-bottom: 16px;
  border-bottom: 2px solid var(--border-color);
}

/* Layout de Inputs */
.grid-2 {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 28px;
}
.field {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.field label {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-main);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Inputs y Textareas */
.field input, .field textarea {
  background-color: var(--bg-input);
  color: var(--text-main);
  padding: 14px 18px;
  border: 1px solid var(--border-color);
  border-radius: 10px; 
  font-size: 15px;
  outline: none;
  font-family: inherit;
  transition: all 0.2s ease;
}
.field input::placeholder, .field textarea::placeholder {
  color: var(--text-muted);
  opacity: 0.7;
}
.field input:focus, .field textarea:focus {
  border-color: var(--border-focus);
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
  background-color: var(--bg-card);
}

/* Barra Flotante Inferior */
.action-bar {
  position: fixed;
  bottom: 0;
  left: 250px;
  right: 0;
  background: var(--bg-card);
  border-top: 1px solid var(--border-color);
  padding: 20px 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 100;
  box-shadow: 0 -10px 25px -5px rgba(0, 0, 0, 0.05);
}
.action-messages {
  flex: 1;
}
.msg-error {
  color: #ef4444;
  font-weight: 600;
  margin: 0;
  font-size: 15px;
}
.msg-success {
  color: #10b981;
  font-weight: 700;
  margin: 0;
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(16, 185, 129, 0.1);
  padding: 8px 16px;
  border-radius: 30px;
  display: inline-flex;
}
.action-buttons {
  display: flex;
  gap: 20px;
  align-items: center;
}

/* Botones Principales */
.btn-primary {
  padding: 14px 28px;
  background: var(--primary-color);
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}
.btn-primary:hover:not(:disabled) {
  background: var(--primary-hover);
  transform: translateY(-2px);
  box-shadow: 0 6px 8px -1px rgba(0, 0, 0, 0.15);
}
.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}
.btn-cancel {
  color: var(--text-muted);
  text-decoration: none;
  font-size: 15px;
  font-weight: 600;
  transition: color 0.2s;
}
.btn-cancel:hover {
  color: var(--text-main);
}
</style>