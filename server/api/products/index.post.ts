import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { create } = defineCrudHandlers('products')
  return await create(event)
})
