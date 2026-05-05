import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { remove } = defineCrudHandlers('services')
  const id = getRouterParam(event, 'id')!
  return await remove(event, id)
})
