import { serverSupabaseClient, serverSupabaseUser } from '#supabase/server'
import type { H3Event } from 'h3'

export async function getClient(event: H3Event) {
  return await serverSupabaseClient(event)
}

export async function getUser(event: H3Event) {
  return await serverSupabaseUser(event)
}

export function requireAuth(user: Awaited<ReturnType<typeof getUser>>) {
  if (!user) {
    throw createError({ statusCode: 401, message: 'Unauthorized' })
  }
}

export function defineCrudHandlers<T extends Record<string, unknown>>(table: string) {
  return {
    async list(event: H3Event) {
      const client = await getClient(event)
      const query = getQuery(event)
      let db = client.from(table).select('*')
      if (query.orderBy) {
        db = db.order(query.orderBy as string, { ascending: query.asc !== 'false' })
      }
      if (query.limit) {
        db = db.limit(Number(query.limit))
      }
      const { data, error } = await db
      if (error) throw createError({ statusCode: 500, message: error.message })
      return data
    },

    async getOne(event: H3Event, field: string, value: string) {
      const client = await getClient(event)
      const { data, error } = await client.from(table).select('*').eq(field, value).single()
      if (error) throw createError({ statusCode: 404, message: error.message })
      return data
    },

    async create(event: H3Event) {
      const user = await getUser(event)
      requireAuth(user)
      const client = await getClient(event)
      const body = await readBody(event)
      const { data, error } = await client.from(table).insert(body).select().single()
      if (error) throw createError({ statusCode: 400, message: error.message })
      return data
    },

    async update(event: H3Event, id: string) {
      const user = await getUser(event)
      requireAuth(user)
      const client = await getClient(event)
      const body = await readBody(event)
      const { data, error } = await client.from(table).update(body).eq('id', id).select().single()
      if (error) throw createError({ statusCode: 400, message: error.message })
      return data
    },

    async remove(event: H3Event, id: string) {
      const user = await getUser(event)
      requireAuth(user)
      const client = await getClient(event)
      const { error } = await client.from(table).delete().eq('id', id)
      if (error) throw createError({ statusCode: 400, message: error.message })
      return { success: true }
    },
  }
}
