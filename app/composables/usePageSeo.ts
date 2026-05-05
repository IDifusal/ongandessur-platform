import type { MetaObject } from '@nuxt/schema'

export function usePageSeo(opts: {
  title: string
  description?: string
  image?: string
  type?: 'website' | 'article' | 'product'
  jsonld?: Record<string, any> | Record<string, any>[]
  url?: string
}) {
  const fullTitle = `ONG Andes Sur | ${opts.title}`.slice(0, 68)
  const desc = opts.description?.replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim().slice(0, 160) || ''

  const head: MetaObject = {
    title: fullTitle,
    meta: [
      { name: 'description', content: desc },
      { property: 'og:title', content: fullTitle },
      { property: 'og:description', content: desc },
      ...(opts.image ? [{ property: 'og:image', content: opts.image }] : []),
      { property: 'og:type', content: opts.type || 'website' },
    ],
  }

  if (opts.jsonld) {
    const scripts = Array.isArray(opts.jsonld) ? opts.jsonld : [opts.jsonld]
    head.script = scripts.map((s) => ({
      type: 'application/ld+json',
      children: JSON.stringify(s),
    }))
  }

  useHead(head)
}

export function orgJsonld() {
  return {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: 'ONG Andes Sur',
    url: process.env.NUXT_PUBLIC_SITE_URL || 'https://ongandessur.org',
    description: 'ONG dedicada a la biodiversidad, ayuda solidaria y desarrollo sostenible en el sur del Perú.',
    contactPoint: {
      '@type': 'ContactPoint',
      email: 'ongandessur@gmail.com',
      address: 'Arequipa, Perú',
    },
  }
}

export function webPageJsonld(title: string, description?: string, url?: string) {
  return {
    '@context': 'https://schema.org',
    '@type': 'WebPage',
    name: title,
    description: description || '',
    ...(url ? { url } : {}),
  }
}

export function productJsonld(name: string, description?: string, price?: number, image?: string) {
  return {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name,
    description: description?.replace(/<[^>]*>/g, '').slice(0, 200) || '',
    ...(price ? { offers: { '@type': 'Offer', price, priceCurrency: 'USD' } } : {}),
    ...(image ? { image } : {}),
  }
}

export function serviceJsonld(name: string, description?: string) {
  return {
    '@context': 'https://schema.org',
    '@type': 'Service',
    name,
    description: description?.replace(/<[^>]*>/g, '').slice(0, 200) || '',
    provider: { '@type': 'Organization', name: 'ONG Andes Sur' },
  }
}

export function newsJsonld(headline: string, datePublished?: string, description?: string, image?: string) {
  return {
    '@context': 'https://schema.org',
    '@type': 'NewsArticle',
    headline,
    description: description?.replace(/<[^>]*>/g, '').slice(0, 200) || '',
    ...(datePublished ? { datePublished } : {}),
    ...(image ? { image } : {}),
    author: { '@type': 'Organization', name: 'ONG Andes Sur' },
  }
}
