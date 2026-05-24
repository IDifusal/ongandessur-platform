<script setup lang="ts">
definePageMeta({ layout: 'dashboard', title: 'Templates' })

const { data: templates, refresh } = await useFetch('/api/templates', { key: 'dash-templates' })

async function remove(id: string) {
  if (!confirm('¿Eliminar este template?')) return
  await $fetch(`/api/templates/${id}`, { method: 'DELETE' })
  await refresh()
}
</script>

<template>
  <div class="list-page">
    <div class="list-header">
      <h1 class="page-title">Templates</h1>
      <NuxtLink to="/dashboard/templates/create" class="btn-primary">+ Nuevo template</NuxtLink>
    </div>

    <table v-if="templates?.length" class="cms-table">
      <thead>
        <tr>
          <th>Título</th>
          <th>Slug</th>
          <th>Actualizado</th>
          <th class="actions-col"></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="tpl in templates" :key="tpl.id">
          <td>
            <NuxtLink :to="`/dashboard/templates/${tpl.id}`" class="row-title">{{ tpl.title }}</NuxtLink>
          </td>
          <td class="row-meta">{{ tpl.slug }}</td>
          <td class="row-meta">{{ new Date(tpl.updated_at).toLocaleDateString() }}</td>
          <td class="row-actions">
            <NuxtLink :to="`/dashboard/templates/${tpl.id}`" class="action-link">Editar</NuxtLink>
            <button @click="remove(tpl.id)" class="action-delete">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-else class="empty-state">No hay templates. Crea uno para personalizar las tarjetas de noticias, productos y servicios.</p>
  </div>
</template>

<style scoped>
.list-page { max-width: none; }
.list-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.page-title { font-size: 22px; font-weight: 600; color: #1d2327; margin: 0; }
.btn-primary { padding: 8px 18px; background: #2271b1; color: #fff; border: none; border-radius: 4px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; }
.btn-primary:hover { background: #135e96; }
.cms-table { width: 100%; background: #fff; border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border-collapse: collapse; }
.cms-table th { text-align: left; padding: 12px 16px; font-size: 12px; font-weight: 600; color: #646970; border-bottom: 1px solid #dcdcde; text-transform: uppercase; }
.cms-table td { padding: 12px 16px; border-bottom: 1px solid #f0f0f1; font-size: 13px; }
.cms-table tr:last-child td { border-bottom: none; }
.row-title { color: #2271b1; text-decoration: none; font-weight: 500; }
.row-title:hover { color: #135e96; }
.row-meta { color: #646970; }
.actions-col { width: 120px; text-align: right; }
.row-actions { display: flex; gap: 12px; justify-content: flex-end; }
.action-link { color: #2271b1; text-decoration: none; font-size: 12px; }
.action-link:hover { color: #135e96; }
.action-delete { color: #d63638; background: none; border: none; cursor: pointer; font-size: 12px; padding: 0; }
.action-delete:hover { color: #a00; }
.empty-state { color: #646970; font-size: 14px; text-align: center; padding: 48px 0; }
</style>
