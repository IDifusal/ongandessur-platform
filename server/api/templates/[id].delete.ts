import { getClient, getUser, requireAuth } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const user = await getUser(event)
  requireAuth(user)
  const id = getRouterParam(event, 'id')!
  const client = await getClient(event)
  const { error } = await client.from('pages').delete().eq('id', id)
  if (error) throw createError({ statusCode: 400, message: error.message })
  return { success: true }
})
