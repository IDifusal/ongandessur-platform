import { getClient } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const client = await getClient(event)
  const query = getQuery(event)
  let db = client.from('pages').select('*').like('slug', 'tpl-%')
  if (query.orderBy) {
    db = db.order(query.orderBy as string, { ascending: query.asc !== 'false' })
  }
  if (query.limit) {
    db = db.limit(Number(query.limit))
  }
  const { data, error } = await db
  if (error) throw createError({ statusCode: 500, message: error.message })
  return data
})
