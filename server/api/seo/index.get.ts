import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { list } = defineCrudHandlers('seo_meta')
  return await list(event)
})
