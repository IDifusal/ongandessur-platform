import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { list } = defineCrudHandlers('services')
  return await list(event)
})
