<script setup lang="ts">
const user = useSupabaseUser()
const route = useRoute()

const isLoginPage = computed(() => route.path === '/dashboard/login')

// 1. Configuramos la cookie para TODA la aplicación (path: '/') y que dure 1 año
const themeCookie = useCookie('dashboard-theme', { 
  default: () => 'light',
  path: '/',
  maxAge: 31536000
})

const isDarkMode = computed({
  get: () => themeCookie.value === 'dark',
  set: (val) => { themeCookie.value = val ? 'dark' : 'light' }
})

// 2. Inyectamos el color de fondo directamente al <body> del HTML nativo
// Esto pinta el fondo oscuro desde el milisegundo cero, antes de que Vue siquiera arranque.
useHead({
  bodyAttrs: {
    style: computed(() => isDarkMode.value ? 'background-color: #020617; margin: 0;' : 'background-color: #f1f5f9; margin: 0;')
  }
})

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
  { label: 'Templates', icon: '🎨', to: '/dashboard/templates' },
]

async function logout() {
  const { signOut } = useAuth()
  await signOut()
}
</script>

<template>
  <div class="cms-wrapper" :class="{ 'theme-dark': isDarkMode }">
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
          
          <button type="button" @click="isDarkMode = !isDarkMode" class="btn-theme-toggle">
            <span class="icon">{{ isDarkMode ? '☀️' : '🌙' }}</span>
            <span class="hidden sm:inline">{{ isDarkMode ? 'Modo Claro' : 'Modo Oscuro' }}</span>
          </button>
          
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
/* SISTEMA DE VARIABLES GLOBALES DEL DASHBOARD */
.cms-wrapper {
  --bg-main: #f1f5f9;
  --bg-sidebar: #1e293b;
  --border-sidebar: #334155;
  --text-sidebar: #94a3b8;
  --text-sidebar-hover: #ffffff;
  --bg-sidebar-hover: #334155;
  --bg-sidebar-active: #3b82f6;

  --bg-topbar: #ffffff;
  --border-topbar: #e2e8f0;
  --text-title: #1e293b;
  --text-user: #64748b;

  display: flex;
  min-height: 100vh;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: var(--bg-main);
  /* Se eliminó la transición de fondo para evitar animaciones al recargar la página */
}

.cms-wrapper.theme-dark {
  --bg-main: #020617; 
  --bg-sidebar: #0f172a;
  --border-sidebar: #1e293b;
  --text-sidebar: #94a3b8;
  --text-sidebar-hover: #ffffff;
  --bg-sidebar-hover: #1e293b;
  --bg-sidebar-active: #3b82f6;

  --bg-topbar: #0f172a;
  --border-topbar: #1e293b;
  --text-title: #f8fafc;
  --text-user: #94a3b8;
  
  color-scheme: dark;
}

.cms-sidebar {
  width: 180px;
  background: var(--bg-sidebar);
  color: var(--text-sidebar-hover);
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 100;
  border-right: 1px solid var(--border-sidebar);
}

.sidebar-header {
  padding: 20px;
  font-size: 20px;
  font-weight: 700;
  border-bottom: 1px solid var(--border-sidebar);
}

.sidebar-home {
  color: var(--text-sidebar-hover);
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
  color: var(--text-sidebar);
  text-decoration: none;
  font-size: 14px;
  transition: all 0.2s;
}

.nav-item:hover {
  background: var(--bg-sidebar-hover);
  color: var(--text-sidebar-hover);
}

.nav-item.active {
  background: var(--bg-sidebar-active);
  color: #fff;
}

.nav-icon {
  font-size: 16px;
  width: 20px;
  text-align: center;
}

.cms-main {
  flex: 1;
  margin-left: 180px;
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
  background: var(--bg-topbar);
  border-bottom: 1px solid var(--border-topbar);
  position: sticky;
  top: 0;
  z-index: 50;
}

.topbar-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-title);
}

.topbar-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.topbar-user {
  font-size: 13px;
  color: var(--text-user);
}

.btn-theme-toggle {
  background: transparent;
  border: 1px solid var(--border-topbar);
  color: var(--text-title);
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s;
}

.btn-theme-toggle:hover {
  background: var(--bg-main);
}

.btn-logout {
  padding: 6px 14px;
  background: #2271b1;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-logout:hover {
  background: #135e96;
}

.cms-content {
  padding: 24px;
  overflow-x: hidden;
}
</style>