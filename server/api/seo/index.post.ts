import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { create } = defineCrudHandlers('seo_meta')
  return await create(event)
})
