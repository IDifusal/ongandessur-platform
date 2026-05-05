export function useAuth() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  async function signIn(email: string, password: string) {
    const { error } = await client.auth.signInWithPassword({ email, password })
    if (error) throw error
    await navigateTo('/dashboard')
  }

  async function signUp(email: string, password: string) {
    const { error } = await client.auth.signUp({ email, password })
    if (error) throw error
  }

  async function signOut() {
    const { error } = await client.auth.signOut()
    if (error) throw error
    await navigateTo('/')
  }

  return { user, signIn, signUp, signOut }
}
