import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { create } = defineCrudHandlers('pages')
  return await create(event)
})
