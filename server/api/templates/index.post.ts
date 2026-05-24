import { getClient, getUser, requireAuth } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const user = await getUser(event)
  requireAuth(user)
  const client = await getClient(event)
  const body = await readBody(event)
  if (!body.slug || !body.slug.startsWith('tpl-')) {
    body.slug = 'tpl-' + (body.slug || body.title.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, ''))
  }
  const { data, error } = await client.from('pages').insert(body).select().single()
  if (error) throw createError({ statusCode: 400, message: error.message })
  return data
})
