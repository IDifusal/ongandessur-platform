<script setup lang="ts">
definePageMeta({
  layout: 'dashboard',
})

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

async function handleLogin() {
  error.value = ''
  loading.value = true
  try {
    const { signIn } = useAuth()
    await signIn(email.value, password.value)
  } catch (e: any) {
    error.value = e.message || 'Error al iniciar sesión'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-card">
      <h1 class="login-title">Dashboard</h1>
      <p class="login-subtitle">Iniciar sesión</p>

      <form @submit.prevent="handleLogin" class="login-form">
        <div class="field">
          <label for="email">Email</label>
          <input id="email" v-model="email" type="email" required autocomplete="email" />
        </div>

        <div class="field">
          <label for="password">Contraseña</label>
          <input id="password" v-model="password" type="password" required autocomplete="current-password" />
        </div>

        <p v-if="error" class="login-error">{{ error }}</p>

        <button type="submit" class="btn-login" :disabled="loading">
          {{ loading ? 'Ingresando...' : 'Ingresar' }}
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: #f0f0f1;
}

.login-card {
  background: #fff;
  padding: 40px 36px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12);
  width: 100%;
  max-width: 380px;
}

.login-title {
  font-size: 28px;
  font-weight: 700;
  color: #1d2327;
  margin: 0 0 4px;
}

.login-subtitle {
  color: #646970;
  margin: 0 0 28px;
  font-size: 14px;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.field label {
  font-size: 13px;
  font-weight: 600;
  color: #1d2327;
}

.field input {
  padding: 10px 12px;
  border: 1px solid #8c8f94;
  border-radius: 4px;
  font-size: 14px;
  outline: none;
}

.field input:focus {
  border-color: #2271b1;
  box-shadow: 0 0 0 1px #2271b1;
}

.btn-login {
  padding: 10px;
  background: #2271b1;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
}

.btn-login:hover {
  background: #135e96;
}

.btn-login:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.login-error {
  color: #d63638;
  font-size: 13px;
  margin: 0;
}
</style>
