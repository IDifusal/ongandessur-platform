import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { create } = defineCrudHandlers('news')
  return await create(event)
})
