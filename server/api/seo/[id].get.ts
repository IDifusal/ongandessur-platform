import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { getOne } = defineCrudHandlers('seo_meta')
  const id = getRouterParam(event, 'id')!
  return await getOne(event, 'id', id)
})
