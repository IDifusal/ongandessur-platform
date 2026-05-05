import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { list } = defineCrudHandlers('news')
  return await list(event)
})
