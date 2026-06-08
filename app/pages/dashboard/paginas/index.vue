<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Páginas' })

const { data: serverItems, refresh } = await useFetch('/api/pages', { key: 'dash-pages' })

const items = ref<any[]>([])
const hasChanges = ref(false) // Usaremos esto para mostrar/ocultar el botón
const isSaving = ref(false)

// Cuando llegan los datos del servidor, llenamos nuestra lista local
watch(serverItems, (val) => {
  if (val) {
    items.value = JSON.parse(JSON.stringify(val))
    // Nos aseguramos de ordenarlos iniciales
    items.value.sort((a, b) => (a.order || 0) - (b.order || 0))
    hasChanges.value = false // Ocultamos el botón al cargar
  }
}, { immediate: true })

function move(item: any, direction: number) {
  const currentIndex = items.value.findIndex((p: any) => p.id === item.id)
  const targetIndex = currentIndex + direction
  
  // Evitamos que suba más del primero o baje más del último
  if (targetIndex < 0 || targetIndex >= items.value.length) return
  
  // 1. Intercambiamos las posiciones visuales en el array (esto lo hace ultra rápido)
  const temp = items.value[currentIndex]
  items.value[currentIndex] = items.value[targetIndex]
  items.value[targetIndex] = temp
  
  // 2. Recalculamos la propiedad 'order' de TODOS del 0 al final
  // Esto arregla el problema de si todos tenían "0" en tu base de datos
  items.value.forEach((page, index) => {
    page.order = index
  })
  
  // 3. Activamos el botón de guardar
  hasChanges.value = true
}

async function saveAllChanges() {
  isSaving.value = true
  try {
    // Guardamos todos los elementos con su nuevo order
    await Promise.all(items.value.map(item => 
      $fetch(`/api/pages/${item.id}`, { method: 'PUT', body: item })
    ))
    hasChanges.value = false // Escondemos el botón
    alert('Orden guardado correctamente')
    refresh()
  } catch (e) {
    alert('Error al guardar cambios')
  } finally {
    isSaving.value = false
  }
}

async function remove(id: string) {
  if (!confirm('¿Eliminar esta página?')) return
  await $fetch(`/api/pages/${id}`, { method: 'DELETE' })
  refresh()
}
</script>

<template>
  <div class="list-page">
    <div class="list-header">
      <h1 class="page-title">Páginas</h1>
      <div class="flex gap-3">
        <button 
          v-if="hasChanges" 
          @click="saveAllChanges" 
          class="btn-save"
          :disabled="isSaving"
        >
          {{ isSaving ? 'Guardando...' : 'Guardar cambios' }}
        </button>
        <NuxtLink to="/dashboard/paginas/create" class="btn-primary">+ Añadir nueva</NuxtLink>
      </div>
    </div>

    <div class="table-wrap">
      <table class="cms-table">
        <thead>
          <tr>
            <th>Título</th>
            <th>Slug</th>
            <th>URL</th>
            <th>Secciones</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in items" :key="item.id">
            <td class="cell-title">{{ item.title }}</td>
            <td><code>{{ item.slug }}</code></td>
            <td><a :href="`/${item.slug}`" target="_blank" class="action-link">Ver</a></td>
            <td>{{ item.content?.rows?.length ?? 0 }}</td>
            
            <td class="cell-actions">
              <NuxtLink :to="`/dashboard/paginas/${item.id}`" class="action-link">Editar</NuxtLink>
              <button class="action-delete" @click="remove(item.id)">Eliminar</button>
              
              <div class="inline-flex gap-1 ml-4 border-l pl-4 border-gray-300">
                <button @click="move(item, -1)" :disabled="index === 0" class="arrow-btn" title="Subir">↑</button>
                <button @click="move(item, 1)" :disabled="index === (items?.length || 0) - 1" class="arrow-btn" title="Bajar">↓</button>
              </div>
            </td>
          </tr>
          <tr v-if="!items?.length">
            <td colspan="5" class="cell-empty">No hay páginas aún.</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.list-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-title { font-size: 22px; font-weight: 600; color: #1d2327; margin: 0; }
.btn-primary { padding: 8px 18px; background: #2271b1; color: #fff; border-radius: 4px; font-size: 13px; font-weight: 600; text-decoration: none; display: flex; align-items: center; }
.btn-primary:hover { background: #135e96; }
.btn-save { padding: 8px 18px; background: #27ae60; color: #fff; border-radius: 4px; font-size: 13px; font-weight: 600; border: none; cursor: pointer; display: flex; align-items: center; }
.btn-save:hover { background: #219150; }
.btn-save:disabled { opacity: 0.7; cursor: wait; }
.table-wrap { background: #fff; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
.cms-table { width: 100%; border-collapse: collapse; }
.cms-table th { text-align: left; padding: 12px 16px; font-size: 12px; font-weight: 600; color: #646970; text-transform: uppercase; border-bottom: 1px solid #dcdcde; }
.cms-table td { padding: 12px 16px; font-size: 14px; border-bottom: 1px solid #f0f0f1; vertical-align: middle; }
.cell-title { font-weight: 500; color: #1d2327; }
.cell-empty { text-align: center; color: #646970; padding: 40px 16px !important; }
.cell-actions { display: flex; align-items: center; }
.action-link { color: #2271b1; text-decoration: none; font-size: 13px; margin-right: 12px; }
.action-delete { color: #d63638; font-size: 13px; cursor: pointer; background: none; border: none; margin-right: 12px; }
.arrow-btn { border: 1px solid #ccc; padding: 2px 8px; border-radius: 4px; cursor: pointer; background: #f9f9f9; font-weight: bold; }
.arrow-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.arrow-btn:hover:not(:disabled) { background: #eef0f2; border-color: #8c8f94; }
code { background: #f0f0f1; padding: 2px 6px; border-radius: 3px; font-size: 12px; }
</style>