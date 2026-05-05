import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { remove } = defineCrudHandlers('news')
  const id = getRouterParam(event, 'id')!
  return await remove(event, id)
})
