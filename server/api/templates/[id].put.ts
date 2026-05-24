import { getClient, getUser, requireAuth } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const user = await getUser(event)
  requireAuth(user)
  const id = getRouterParam(event, 'id')!
  const client = await getClient(event)
  const body = await readBody(event)
  const { data, error } = await client.from('pages').update(body).eq('id', id).select().single()
  if (error) throw createError({ statusCode: 400, message: error.message })
  return data
})
