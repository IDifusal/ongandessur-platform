import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { update } = defineCrudHandlers('products')
  const id = getRouterParam(event, 'id')!
  return await update(event, id)
})
