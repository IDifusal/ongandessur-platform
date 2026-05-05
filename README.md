# ONG Andes Sur Platform

Sitio web y CMS para ONG Andes Sur — organización peruana dedicada a biodiversidad, desarrollo sostenible y ayuda solidaria en el sur del Perú.

## Stack

| Capa | Tecnología |
|------|-----------|
| Framework | [Nuxt 4](https://nuxt.com/) (Vue 3 + TypeScript) |
| Estilos | [Tailwind CSS](https://tailwindcss.com/) |
| Base de datos | [Supabase](https://supabase.com/) (PostgreSQL) |
| Auth | Supabase Auth (PKCE flow) |
| Editor de texto | [TipTap](https://tiptap.dev/) |
| Page Builder | Componente propio (filas → columnas → widgets) |
| Deploy | [Vercel](https://vercel.com/) (serverless) |

## Arquitectura

```
app/
  pages/            → Páginas públicas (SSR) + dashboard (SPA)
  components/       → PageBuilder, PageWidgets, HeroSlider, Dynamic*, etc.
  composables/      → useAuth, usePageSeo, useSupabase
  layouts/          → default.vue (público), dashboard.vue (admin)
server/
  api/              → CRUD endpoints para pages, news, products, services, seo
  utils/            → defineCrudHandlers (factory genérico de CRUD)
db/
  migrations/       → Migraciones SQL (schema + datos)
```

### Estructura de contenido (PageBuilder)

```
rows[] → columns[] → widgets[]
                        ├── title    (h1-h4, alineación)
                        ├── text     (HTML, alineación)
                        ├── image    (src, alt, class, alineación)
                        ├── button   (texto, link, estilo, alineación)
                        ├── hero     (slider con slides)
                        ├── services / products / news (dinámicos)
                        └── divider  (wave, línea, espacio)

Cada fila tiene:
  background  → imagen, color, overlay, posición, tamaño
  alignment   → vertical (top/center/bottom), horizontal (left/center/right)
  padding     → none, sm, md, lg, xl
  fullWidth   → contenedor limitado o 100% ancho
```

## SEO Strategy

### Diagnóstico actual

- **SSR puro**: `ssr: true` sin `routeRules`. Cada request pega a Supabase.
- **Sin caché**: No hay ISR, SWR ni capa de caché server-side.
- **Tabla `seo_meta` existe pero no se usa**: El API de páginas no hace JOIN con `seo_meta`. Los campos `canonical`, `og_image`, `noindex` están definidos pero nunca se renderizan.
- **Metadatos incompletos**: Faltan `canonical`, `robots`, `twitter:*`, y `og:image` en las páginas CMS.
- **Sin sitemap**.

### Estrategia recomendada (híbrida)

Este es un CMS donde el contenido cambia vía dashboard. La estrategia óptima combina SSR con caché:

#### 1. Reglas de renderizado híbrido (`nuxt.config.ts`)

```ts
routeRules: {
  // Páginas públicas: SSR con revalidación cada 5 min
  '/**': { swr: 300 },
  // API: cache más corto
  '/api/**': { swr: 120 },
  // Dashboard: SPA cliente, sin SSR
  '/dashboard/**': { ssr: false },
}
```

**Por qué**: Las páginas públicas se benefician del SSR para SEO, pero no necesitan consultar Supabase en cada request. Con SWR (stale-while-revalidate) se sirve la versión cacheada y se regenera en background. El dashboard no necesita SSR — es solo para administradores autenticados.

#### 2. Unir `seo_meta` al renderizado de páginas

Modificar `server/api/pages/[id].get.ts` para hacer JOIN:

```ts
const { data } = await client
  .from('pages')
  .select('*, seo_meta(*)')
  .eq(field, id)
  .maybeSingle()
```

#### 3. Completar `usePageSeo`

Añadir al composable:
- `<link rel="canonical">` → `seo_meta.canonical` o URL autogenerada
- `<meta name="robots">` → `noindex, nofollow` si `seo_meta.noindex`
- `og:image` → `seo_meta.og_image`
- `twitter:card`, `twitter:title`, `twitter:description`

#### 4. Sitemap dinámico

Endpoint server-side que genera XML desde la tabla `pages`:

```
GET /sitemap.xml  → lista slugs publicados con <lastmod>
```

#### 5. SEO por página desde el dashboard

Añadir en el editor de página (además del campo `description` actual):
- Título SEO (distinto del título visible)
- OG Image
- Canonical URL
- Toggle noindex

### Resumen de cambios pendientes

| Prioridad | Cambio | Archivos |
|-----------|--------|----------|
| Alta | `routeRules` híbridas | `nuxt.config.ts` |
| Alta | JOIN `seo_meta` en fetch de páginas | `server/api/pages/[id].get.ts` |
| Alta | `canonical`, `robots`, `og:image` en SEO | `app/composables/usePageSeo.ts` |
| Media | SEO por página en dashboard | `create.vue`, `[id].vue` |
| Media | Sitemap dinámico | `server/routes/sitemap.xml.ts` |
| Baja | `twitter:*` tags | `app/composables/usePageSeo.ts` |

## Desarrollo

```bash
# Instalar dependencias
npm install

# Dev server (hot reload)
npm run dev

# Type check
npm run typecheck

# Build producción
npm run build
```

### Variables de entorno

```env
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_KEY=<anon-key>
SUPABASE_SERVICE_KEY=<service-role-key>
```

### Migraciones

Las migraciones SQL están en `db/migrations/`. Para aplicarlas en Supabase, ejecutar cada archivo `.sql` en orden numérico desde el SQL Editor del dashboard de Supabase o vía `psql`.

### Seed

```bash
# Poblar contenido inicial (pages, products, news, services)
psql "$DATABASE_URL" -f db/seed.sql
```

## Widgets del PageBuilder

| Widget | Descripción | Datos |
|--------|-------------|-------|
| `title` | Título (h1-h4) | content, tag, textAlign |
| `text` | Texto enriquecido (HTML) | content, textAlign |
| `image` | Imagen | src, alt, class |
| `button` | Botón/enlace | text, link, style, textAlign |
| `hero` | Slider hero full-width | slides[] (image, title, subtitle, button) |
| `services` | Listado dinámico de servicios | — |
| `products` | Listado dinámico de productos | — |
| `news` | Listado dinámico de noticias | — |
| `divider` | Divisor visual | style (wave, line, spacer) |
