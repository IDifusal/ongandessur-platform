import { defineCrudHandlers } from '../../utils/supabase'

export default defineEventHandler(async (event) => {
  const { create } = defineCrudHandlers('services')
  return await create(event)
})
