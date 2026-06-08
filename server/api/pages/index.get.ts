import { getClient } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const client = await getClient(event)
  
  // Hacemos la consulta directamente forzando el orden ascendente
  const { data, error } = await client
    .from('pages')
    .select('*')
    .order('order', { ascending: true })

  if (error) {
    throw createError({ statusCode: 500, message: error.message })
  }
  
  return data
})