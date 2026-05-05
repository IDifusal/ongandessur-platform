<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Servicios' })

const { data: items, refresh } = await useFetch('/api/services', { key: 'cms-serv-list' })

async function remove(id: string) {
  if (!confirm('¿Eliminar este servicio?')) return
  await $fetch(`/api/services/${id}`, { method: 'DELETE' })
  refresh()
}
</script>

<template>
  <div class="list-page">
    <div class="list-header">
      <h1 class="page-title">Servicios</h1>
      <NuxtLink to="/dashboard/servicios/create" class="btn-primary">+ Añadir nuevo</NuxtLink>
    </div>

    <div class="table-wrap">
      <table class="cms-table">
        <thead>
          <tr>
            <th>Título</th>
            <th>Slug</th>
            <th>Publicado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in items" :key="item.id">
            <td class="cell-title">{{ item.title }}</td>
            <td><code>{{ item.slug }}</code></td>
            <td>{{ item.published_at ? new Date(item.published_at).toLocaleDateString() : '—' }}</td>
            <td class="cell-actions">
              <NuxtLink :to="`/dashboard/servicios/${item.id}`" class="action-link">Editar</NuxtLink>
              <button class="action-delete" @click="remove(item.id)">Eliminar</button>
            </td>
          </tr>
          <tr v-if="!items?.length">
            <td colspan="4" class="cell-empty">No hay servicios aún.</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.list-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-title { font-size: 22px; font-weight: 600; color: #1d2327; margin: 0; }
.btn-primary { padding: 8px 18px; background: #2271b1; color: #fff; border: none; border-radius: 4px; font-size: 13px; font-weight: 600; text-decoration: none; cursor: pointer; }
.btn-primary:hover { background: #135e96; }
.table-wrap { background: #fff; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
.cms-table { width: 100%; border-collapse: collapse; }
.cms-table th { text-align: left; padding: 12px 16px; font-size: 12px; font-weight: 600; color: #646970; text-transform: uppercase; border-bottom: 1px solid #dcdcde; }
.cms-table td { padding: 12px 16px; font-size: 14px; border-bottom: 1px solid #f0f0f1; }
.cms-table tr:last-child td { border-bottom: none; }
.cell-title { font-weight: 500; color: #1d2327; }
.cell-empty { text-align: center; color: #646970; padding: 40px 16px !important; }
.cell-actions { display: flex; gap: 12px; }
.action-link { color: #2271b1; text-decoration: none; font-size: 13px; cursor: pointer; background: none; border: none; }
.action-link:hover { color: #135e96; }
.action-delete { color: #d63638; font-size: 13px; cursor: pointer; background: none; border: none; }
.action-delete:hover { color: #b32d2e; }
code { background: #f0f0f1; padding: 2px 6px; border-radius: 3px; font-size: 12px; }
</style>
