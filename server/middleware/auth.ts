export default defineEventHandler(async (event) => {
  const path = getRequestURL(event).pathname

  const dashboardRoutes = ['/api/pages', '/api/products', '/api/news', '/api/seo', '/api/services', '/api/seed']

  const isDashboardRoute = dashboardRoutes.some((route) => path.startsWith(route))
  if (!isDashboardRoute) return

  if (event.method === 'GET') return

  const { serverSupabaseUser } = await import('#supabase/server')
  const user = await serverSupabaseUser(event)
  if (!user) {
    throw createError({ statusCode: 401, message: 'Unauthorized' })
  }
})
