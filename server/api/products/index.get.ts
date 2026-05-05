import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { list } = defineCrudHandlers('products')
  return await list(event)
})
