import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { list } = defineCrudHandlers('pages')
  return await list(event)
})
