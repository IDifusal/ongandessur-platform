<script setup lang="ts">
definePageMeta({
  layout: 'dashboard',
  title: 'Dashboard',
})

const { data: noticias } = await useFetch('/api/news', { key: 'dash-news', ...useRequestHeaders() })
const { data: productos } = await useFetch('/api/products', { key: 'dash-prods' })
const { data: servicios } = await useFetch('/api/services', { key: 'dash-serv' })

const stats = computed(() => [
  { label: 'Noticias',  count: noticias.value?.length ?? 0,  to: '/dashboard/noticias',          icon: '📰' },
  { label: 'Productos', count: productos.value?.length ?? 0, to: '/dashboard/productos',         icon: '🛒' },
  { label: 'Servicios', count: servicios.value?.length ?? 0, to: '/dashboard/servicios',         icon: '⚙️' },
])

const recentNoticias = computed(() => (noticias.value?.slice(0, 5) ?? []))
const recentProductos = computed(() => (productos.value?.slice(0, 5) ?? []))
const recentServicios = computed(() => (servicios.value?.slice(0, 5) ?? []))
</script>

<template>
  <div class="dashboard">
    <h1 class="page-title">Dashboard</h1>

    <div class="stats-row">
      <NuxtLink v-for="stat in stats" :key="stat.label" :to="stat.to" class="stat-card">
        <div class="stat-body">
          <span class="stat-icon">{{ stat.icon }}</span>
          <div class="stat-info">
            <span class="stat-count">{{ stat.count }}</span>
            <span class="stat-label">{{ stat.label }}</span>
          </div>
        </div>
        <span class="stat-link">Ver todas &rarr;</span>
      </NuxtLink>
    </div>

    <div class="widgets">
      <div class="widget">
        <div class="widget-header">
          <h2 class="widget-title">Noticias recientes</h2>
          <NuxtLink to="/dashboard/noticias/create" class="widget-action">+ Añadir nueva</NuxtLink>
        </div>
        <div class="widget-body">
          <div v-if="recentNoticias.length" class="item-list">
            <div v-for="item in recentNoticias" :key="item.id" class="item-row">
              <NuxtLink :to="`/dashboard/noticias/${item.id}`" class="item-title">{{ item.title }}</NuxtLink>
              <span class="item-date">{{ item.published_at ? new Date(item.published_at).toLocaleDateString() : 'Sin fecha' }}</span>
            </div>
          </div>
          <p v-else class="widget-empty">No hay noticias aún.</p>
        </div>
        <div class="widget-footer">
          <NuxtLink to="/dashboard/noticias">Ver todas las noticias &rarr;</NuxtLink>
        </div>
      </div>

      <div class="widget">
        <div class="widget-header">
          <h2 class="widget-title">Productos recientes</h2>
          <NuxtLink to="/dashboard/productos/create" class="widget-action">+ Añadir nuevo</NuxtLink>
        </div>
        <div class="widget-body">
          <div v-if="recentProductos.length" class="item-list">
            <div v-for="item in recentProductos" :key="item.id" class="item-row">
              <NuxtLink :to="`/dashboard/productos/${item.id}`" class="item-title">{{ item.name }}</NuxtLink>
              <span class="item-date">${{ Number(item.price).toLocaleString() }}</span>
            </div>
          </div>
          <p v-else class="widget-empty">No hay productos aún.</p>
        </div>
        <div class="widget-footer">
          <NuxtLink to="/dashboard/productos">Ver todos los productos &rarr;</NuxtLink>
        </div>
      </div>

      <div class="widget">
        <div class="widget-header">
          <h2 class="widget-title">Servicios recientes</h2>
          <NuxtLink to="/dashboard/servicios/create" class="widget-action">+ Añadir nuevo</NuxtLink>
        </div>
        <div class="widget-body">
          <div v-if="recentServicios.length" class="item-list">
            <div v-for="item in recentServicios" :key="item.id" class="item-row">
              <NuxtLink :to="`/dashboard/servicios/${item.id}`" class="item-title">{{ item.title }}</NuxtLink>
              <span class="item-date">{{ item.published_at ? new Date(item.published_at).toLocaleDateString() : 'Sin fecha' }}</span>
            </div>
          </div>
          <p v-else class="widget-empty">No hay servicios aún.</p>
        </div>
        <div class="widget-footer">
          <NuxtLink to="/dashboard/servicios">Ver todos los servicios &rarr;</NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard {
  max-width: 1100px;
}

.page-title {
  font-size: 22px;
  font-weight: 600;
  color: #1d2327;
  margin: 0 0 24px;
}

.stats-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 28px;
}

.stat-card {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  background: #fff;
  border-radius: 6px;
  padding: 20px;
  text-decoration: none;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  transition: box-shadow 0.15s;
  min-height: 90px;
}

.stat-card:hover {
  box-shadow: 0 2px 8px rgba(0,0,0,0.14);
}

.stat-body {
  display: flex;
  align-items: center;
  gap: 14px;
}

.stat-icon {
  font-size: 28px;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-count {
  font-size: 26px;
  font-weight: 700;
  color: #1d2327;
  line-height: 1.2;
}

.stat-label {
  font-size: 13px;
  color: #646970;
}

.stat-link {
  font-size: 12px;
  color: #2271b1;
  margin-top: 12px;
}

.widgets {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 20px;
}

.widget {
  background: #fff;
  border-radius: 6px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
  display: flex;
  flex-direction: column;
}

.widget-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 18px;
  border-bottom: 1px solid #f0f0f1;
}

.widget-title {
  font-size: 14px;
  font-weight: 600;
  color: #1d2327;
  margin: 0;
}

.widget-action {
  font-size: 12px;
  color: #2271b1;
  text-decoration: none;
  font-weight: 600;
}

.widget-action:hover {
  color: #135e96;
}

.widget-body {
  padding: 4px 0;
  flex: 1;
}

.item-list {
  display: flex;
  flex-direction: column;
}

.item-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 18px;
  border-bottom: 1px solid #f0f0f1;
}

.item-row:last-child {
  border-bottom: none;
}

.item-title {
  font-size: 13px;
  color: #2271b1;
  text-decoration: none;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 220px;
}

.item-title:hover {
  color: #135e96;
}

.item-date {
  font-size: 12px;
  color: #646970;
  white-space: nowrap;
  margin-left: 12px;
}

.widget-empty {
  color: #646970;
  font-size: 13px;
  text-align: center;
  padding: 24px 18px;
  margin: 0;
}

.widget-footer {
  padding: 10px 18px;
  border-top: 1px solid #f0f0f1;
}

.widget-footer a {
  font-size: 12px;
  color: #646970;
  text-decoration: none;
}

.widget-footer a:hover {
  color: #1d2327;
}
</style>
