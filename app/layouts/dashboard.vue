<script setup lang="ts">
const user = useSupabaseUser()
const route = useRoute()

const isLoginPage = computed(() => route.path === '/dashboard/login')

onMounted(() => {
  if (!user.value && !isLoginPage.value) {
    navigateTo('/dashboard/login')
  }
})

watch(user, (val) => {
  if (!val && !isLoginPage.value) {
    navigateTo('/dashboard/login')
  }
})

const navItems = [
  { label: 'Dashboard', icon: '📊', to: '/dashboard' },
  { label: 'Páginas',   icon: '📄', to: '/dashboard/paginas' },
  { label: 'Noticias',  icon: '📰', to: '/dashboard/noticias' },
  { label: 'Productos', icon: '🛒', to: '/dashboard/productos' },
  { label: 'Servicios', icon: '⚙️', to: '/dashboard/servicios' },
]

async function logout() {
  const { signOut } = useAuth()
  await signOut()
}
</script>

<template>
  <div class="cms-wrapper">
    <aside v-if="!isLoginPage" class="cms-sidebar">
      <div class="sidebar-header">
        <NuxtLink to="/dashboard" class="sidebar-home">Dashboard</NuxtLink>
      </div>
      <nav class="sidebar-nav">
        <NuxtLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="nav-item"
          :class="{ active: route.path === item.to || route.path.startsWith(item.to + '/') }"
        >
          <span class="nav-icon">{{ item.icon }}</span>
          <span class="nav-label">{{ item.label }}</span>
        </NuxtLink>
      </nav>
    </aside>

    <div class="cms-main" :class="{ 'cms-main--full': isLoginPage }">
      <header v-if="!isLoginPage" class="cms-topbar">
        <span class="topbar-title">{{ route.meta.title || 'Dashboard' }}</span>
        <div class="topbar-right">
          <span class="topbar-user">{{ user?.email }}</span>
          <button class="btn-logout" @click="logout">Cerrar sesión</button>
        </div>
      </header>

      <main class="cms-content">
        <slot />
      </main>
    </div>
  </div>
</template>

<style scoped>
.cms-wrapper {
  display: flex;
  min-height: 100vh;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: #f0f0f1;
}

.cms-sidebar {
  width: 220px;
  background: #1e1e1e;
  color: #fff;
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 100;
}

.sidebar-header {
  padding: 20px;
  font-size: 20px;
  font-weight: 700;
  border-bottom: 1px solid #2c2c2c;
}

.sidebar-home {
  color: #fff;
  text-decoration: none;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  padding: 8px 0;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 20px;
  color: #b4b4b4;
  text-decoration: none;
  font-size: 14px;
  transition: background 0.15s;
}

.nav-item:hover {
  background: #2c2c2c;
  color: #fff;
}

.nav-item.active {
  background: #2271b1;
  color: #fff;
}

.nav-icon {
  font-size: 16px;
  width: 20px;
  text-align: center;
}

.cms-main {
  flex: 1;
  margin-left: 220px;
  display: flex;
  flex-direction: column;
}

.cms-main--full {
  margin-left: 0;
}

.cms-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 24px;
  background: #fff;
  border-bottom: 1px solid #dcdcde;
  position: sticky;
  top: 0;
  z-index: 50;
}

.topbar-title {
  font-size: 16px;
  font-weight: 600;
  color: #1d2327;
}

.topbar-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.topbar-user {
  font-size: 13px;
  color: #646970;
}

.btn-logout {
  padding: 6px 14px;
  background: #2271b1;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
}

.btn-logout:hover {
  background: #135e96;
}

.cms-content {
  padding: 24px;
}
</style>
