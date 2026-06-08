<script setup lang="ts">
const props = defineProps<{
  rows: any[]
}>()

// Mantenemos la variable pero dejamos el bloque vacío para que no ensucie tu consola
const isClient = typeof window !== 'undefined'

if (isClient) {
  // Los console.log de depuración fueron eliminados de aquí
}

function rowStyle(row: any) {
  const style: Record<string, string> = {}
  const bg = row.background
  if (bg?.image) {
    style.backgroundImage = `url(${bg.image})`
    style.backgroundPosition = bg.position || 'center'
    style.backgroundSize = bg.size || 'cover'
    style.backgroundRepeat = bg.repeat || 'no-repeat'
  }
  if (bg?.color) {
    style.backgroundColor = bg.color
  }
  return style
}

function rowClasses(row: any) {
  const classes: string[] = []
  const bg = row.background
  if (bg?.image || bg?.color) {
    classes.push('relative')
  }
  return classes.join(' ')
}

function overlayStyle(row: any) {
  const bg = row.background
  if (bg?.overlay && bg.overlay > 0) {
    return { opacity: bg.overlay }
  }
  return {}
}

function alignmentClass(row: any) {
  const align = row.alignment
  const vert = align?.vertical || 'flex-start'
  const horz = align?.horizontal || 'flex-start'
  const vMap: Record<string, string> = { 'flex-start': 'items-start', 'center': 'items-center', 'flex-end': 'items-end', 'stretch': 'items-stretch' }
  const hMap: Record<string, string> = { 'flex-start': 'justify-start', 'center': 'justify-center', 'flex-end': 'justify-end' }
  return `${vMap[vert] || 'items-start'} ${hMap[horz] || 'justify-start'}`
}

const paddingMap: Record<string, string> = { none: 'py-0', sm: 'py-3', md: 'py-6', lg: 'py-12', xl: 'py-20' }

function textAlignClass(widget: any) {
  const a = (widget.textAlign || 'left') as string
  const alignMap: Record<string, string> = {
    left: 'text-left',
    center: 'text-center',
    right: 'text-right',
    justify: 'text-justify',
  }
  return alignMap[a] || 'text-left'
}

const fontFamilyMap: Record<string, string> = {
  kadwa: 'font-kadwa',
  'open-sans': 'font-open-sans',
  nanum: 'font-nanum',
  serif: 'font-serif',
  sans: 'font-sans',
  mono: 'font-mono',
}

function paddingClass(row: any) {
  const p: string = row.padding || 'md'
  return paddingMap[p] || 'py-6'
}

function sanitizeHtml(value: string) {
  return String(value || '')
    .replace(/<img\b[^>]*src=(['"])(?:\s*\1|[^'">]+)?[^>]*>/gi, '')
    .replace(/<img\b[^>]*src=(['"])undefined\1[^>]*>/gi, '')
    .replace(/<img\b[^>]*src=(['"])\s*\1[^>]*>/gi, '')
}

function getImageStyle(widget: any) {
  const height = widget.imageHeight || '300px'
  const fit = String(widget.imageFit || widget.imageSize || 'cover')

  const base: Record<string, string> = {
    width: '100%',
    height,
  }

  if (fit === 'contain') {
    base.objectFit = 'contain'
    base.objectPosition = 'center'
    base.backgroundColor = '#f8fafc'
    return base
  }

  if (fit === 'fill') {
    base.objectFit = 'fill'
    return base
  }

  base.objectFit = 'cover'
  base.objectPosition = 'center'
  return base
}
</script>

<template>
  <div>
    <div
      v-for="(row, ri) in rows"
      :key="ri"
      :class="[rowClasses(row), paddingClass(row)]"
      :style="rowStyle(row)"
    >
      <div v-if="row.background?.overlay && row.background.overlay > 0" class="absolute inset-0 bg-black" :style="overlayStyle(row)" />

      <div :class="row.fullWidth ? 'px-0' : 'max-w-6xl mx-auto px-4'" class="relative z-10">
        <div class="flex flex-wrap -mx-3" :class="{
          'md:flex-nowrap': row.columns?.length === 2 || row.columns?.length === 3,
          [alignmentClass(row)]: true,
        }">
          <div
            v-for="(col, ci) in row.columns"
            :key="ci"
            class="px-3"
            :class="{
              'w-full': row.columns?.length === 1 || !row.columns,
              'md:w-1/2': row.columns?.length === 2,
              'md:w-1/3': row.columns?.length === 3,
              'md:w-7/12': row.columns?.length === 2 && ci === 0 && col.width === '70',
              'md:w-5/12': row.columns?.length === 2 && ci === 1 && col.width === '30',
              'md:w-8/12': row.columns?.length === 2 && ci === 0 && col.width === '80',
              'md:w-4/12': row.columns?.length === 2 && ci === 1 && col.width === '20',
            }"
          >
            <div v-for="(widget, wi) in col.widgets" :key="wi" class="mb-4">
              <component
                v-if="widget.type === 'title'"
                :is="widget.tag || 'h2'"
                :class="textAlignClass(widget)"
                :style="{
                  color: widget.color || '',
                  fontSize: widget.fontSize || '',
                  fontStyle: widget.italic ? 'italic' : '',
                  fontFamily: widget.fontFamily || '',
                }"
                class="font-bold font-kadwa text-gray-800"
                v-html="sanitizeHtml(widget.content)"
              />

              <div
                v-if="widget.type === 'text'"
                class="texto-enriquecido text-gray-600 leading-relaxed"
                :class="textAlignClass(widget)"
                :style="{ textAlign: widget.textAlign === 'justify' ? 'justify' : undefined }"
                v-html="sanitizeHtml(widget.content)"
              />

              <a v-if="widget.type === 'image' && widget.link" :href="widget.link" target="_blank" rel="noopener" class="block w-full">
                <img :src="widget.src" :alt="widget.alt || ''" class="rounded-lg w-full" :class="widget.imageClass || 'max-w-full h-auto'" :style="getImageStyle(widget)" />
              </a>
              <img v-else-if="widget.type === 'image'" :src="widget.src" :alt="widget.alt || ''" class="rounded-lg w-full" :class="widget.imageClass || 'max-w-full h-auto'" :style="getImageStyle(widget)" />

              <div v-if="widget.type === 'button'" :class="textAlignClass(widget)">
                <NuxtLink :to="widget.link || '#'" class="inline-block px-6 py-3 font-semibold rounded-lg transition-colors no-underline" :class="widget.style === 'secondary' ? 'bg-brand-gold text-white hover:bg-amber-700' : 'bg-brand-teal text-white hover:bg-teal-700'">
                  {{ widget.text || 'Botón' }}
                </NuxtLink>
              </div>

              <Flashcard v-if="widget.type === 'flashcard'" :widget="widget" />

              <DynamicServices v-if="widget.type === 'services'" :template-id="widget.templateId" />
              <DynamicProducts v-if="widget.type === 'products'" :template-id="widget.templateId" />
              <DynamicNews v-if="widget.type === 'news'" :template-id="widget.templateId" />

              <HeroSlider v-if="widget.type === 'hero'" :slides="widget.slides || []" />

              <svg v-if="widget.type === 'divider' && widget.style === 'wave'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320" class="-my-4">
                <path fill="#1fa185" fill-opacity="1" d="M0,256L48,240C96,224,192,192,288,176C384,160,480,160,576,186.7C672,213,768,267,864,261.3C960,256,1056,192,1152,160C1248,128,1344,128,1392,128L1440,128L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z" />
              </svg>
              <hr v-if="widget.type === 'divider' && widget.style === 'line'" class="border-gray-200 my-4" />
              <div v-if="widget.type === 'divider' && widget.style === 'spacer'" class="h-8" />
              <div v-if="widget.type === 'divider' && widget.style === 'vertical'" class="flex justify-center my-2">
                <div class="w-px h-16 md:h-24 bg-gray-300"></div>
              </div>

              <div v-if="widget.type === 'hero_banner'" class="-mx-3 -my-4">
                <div style="background: linear-gradient(135deg, #FFF8ED 0%, #FEE0AA 100%);">
                  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-20">
                    <div class="grid lg:grid-cols-2 gap-12 items-center">
                      <div>
                        <h1 class="text-4xl lg:text-5xl font-bold font-kadwa leading-tight mb-6" style="color: #1F4635;">
                          {{ widget.heading || 'Desarrollo con esperanza' }}
                        </h1>
                        <p class="text-lg leading-relaxed mb-8" style="color: #667085;">
                          {{ widget.description }}
                        </p>
                        <div v-if="widget.tags && widget.tags.length" class="flex flex-wrap gap-2 mb-8">
                          <span
                            v-for="tag in widget.tags"
                            :key="tag"
                            class="px-4 py-2 rounded-full text-sm font-medium"
                            style="background-color: #FEE0AA; color: #33251A;"
                          >{{ tag }}</span>
                        </div>
                        <div class="flex flex-wrap gap-4">
                          <NuxtLink v-if="widget.primaryText" :to="widget.primaryLink || '#'" class="px-6 py-3 rounded-lg font-semibold text-white inline-flex items-center gap-2 no-underline transition-colors" style="background-color: #2F6B4F;" onmouseover="this.style.backgroundColor='#1F4635'" onmouseout="this.style.backgroundColor='#2F6B4F'">
                            {{ widget.primaryText }}
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                          </NuxtLink>
                          <NuxtLink v-if="widget.secondaryText" :to="widget.secondaryLink || '#'" class="px-6 py-3 rounded-lg font-semibold no-underline transition-colors border" style="background-color: #fff; color: #2F6B4F; border-color: #2F6B4F;">
                            {{ widget.secondaryText }}
                          </NuxtLink>
                          <NuxtLink v-if="widget.tertiaryText" :to="widget.tertiaryLink || '#'" class="px-6 py-3 rounded-lg font-semibold text-white no-underline transition-colors" style="background-color: #C96B3C;" onmouseover="this.style.backgroundColor='#b15e33'" onmouseout="this.style.backgroundColor='#C96B3C'">
                            {{ widget.tertiaryText }}
                          </NuxtLink>
                        </div>
                      </div>
                      <div v-if="widget.image" class="relative">
                        <img
                          :src="widget.image"
                          :alt="widget.imageAlt || ''"
                          class="rounded-2xl shadow-2xl w-full object-cover"
                          style="height: 500px;"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div v-if="widget.type === 'institutional_message'" class="py-8 text-center">
                <p class="text-xl text-brand-brown-text leading-relaxed max-w-3xl mx-auto">{{ widget.text }}</p>
              </div>

              <div v-if="widget.type === 'quick_links'" class="py-4">
                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                  <NuxtLink
                    v-for="item in (widget.items || [])"
                    :key="item.title"
                    :to="item.link || '#'"
                    class="bg-white p-6 rounded-xl shadow-sm hover:shadow-lg transition-all group no-underline block"
                  >
                    <div class="w-12 h-12 bg-brand-cream rounded-lg flex items-center justify-center mb-4 group-hover:bg-brand-green transition-colors">
                      <svg v-if="item.icon === 'users'" class="w-6 h-6 text-brand-green group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                      <svg v-else-if="item.icon === 'target'" class="w-6 h-6 text-brand-green group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/><circle cx="12" cy="12" r="6" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/><circle cx="12" cy="12" r="2" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/></svg>
                      <svg v-else-if="item.icon === 'book'" class="w-6 h-6 text-brand-green group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                      <svg v-else-if="item.icon === 'bag'" class="w-6 h-6 text-brand-green group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                      <svg v-else class="w-6 h-6 text-brand-green group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                    </div>
                    <h3 class="font-bold text-brand-brown-text mb-2">{{ item.title }}</h3>
                    <p class="text-sm text-brand-gray-text mb-3">{{ item.desc }}</p>
                    <span class="text-brand-green text-sm flex items-center gap-1 group-hover:gap-2 transition-all">
                      Ver más
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                    </span>
                  </NuxtLink>
                </div>
              </div>

              <div v-if="widget.type === 'strategic_axes'" class="py-4">
                <h2 v-if="widget.title" class="text-3xl font-bold text-brand-green-dark mb-12 text-center font-kadwa">{{ widget.title }}</h2>
                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                  <div v-for="item in (widget.items || [])" :key="item.title" class="bg-white p-6 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                    <div class="w-14 h-14 rounded-xl flex items-center justify-center mb-4" style="background: linear-gradient(135deg, #2F6B4F, #1F4635)">
                      <svg v-if="item.icon === 'lightbulb'" class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m1.636-6.364l.707.707M12 21a9 9 0 110-18 9 9 0 010 18z"/></svg>
                      <svg v-else-if="item.icon === 'building'" class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                      <svg v-else-if="item.icon === 'trending'" class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/></svg>
                      <svg v-else-if="item.icon === 'heart'" class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/></svg>
                      <svg v-else class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                    </div>
                    <h3 class="font-bold text-brand-brown-text mb-3">{{ item.title }}</h3>
                    <p class="text-sm text-brand-gray-text">{{ item.desc }}</p>
                  </div>
                </div>
              </div>

              <div v-if="widget.type === 'projects_grid'" class="py-4">
                <h2 v-if="widget.title" class="text-3xl font-bold text-brand-green-dark mb-12 text-center font-kadwa">{{ widget.title }}</h2>
                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                  <NuxtLink
                    v-for="item in (widget.items || [])"
                    :key="item.title"
                    :to="item.link || '#'"
                    class="group no-underline block"
                  >
                    <div class="bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-lg transition-all">
                      <div class="relative h-48 overflow-hidden">
                        <img :src="item.image" :alt="item.title" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300" />
                        <div v-if="item.category" class="absolute top-3 left-3">
                          <span class="px-3 py-1 bg-brand-cream text-brand-brown-text rounded-full text-xs font-medium">{{ item.category }}</span>
                        </div>
                      </div>
                      <div class="p-5">
                        <h3 class="font-bold text-brand-brown-text mb-2">{{ item.title }}</h3>
                        <span class="text-brand-green text-sm flex items-center gap-1 group-hover:gap-2 transition-all">
                          Ver proyecto
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                        </span>
                      </div>
                    </div>
                  </NuxtLink>
                </div>
              </div>

              <div v-if="widget.type === 'stats'" class="py-4">
                <div class="grid grid-cols-2 md:grid-cols-5 gap-8 text-center">
                  <div v-for="item in (widget.items || [])" :key="item.label">
                    <div class="text-4xl font-bold text-brand-gold-new mb-2">{{ item.number }}</div>
                    <div class="text-sm text-brand-cream">{{ item.label }}</div>
                  </div>
                </div>
              </div>

              <div v-if="widget.type === 'cta_collaborate'" class="py-4 text-center max-w-4xl mx-auto">
                <h2 v-if="widget.title" class="text-3xl font-bold text-brand-green-dark mb-8 font-kadwa">{{ widget.title }}</h2>
                <div class="flex flex-wrap justify-center gap-4">
                  <NuxtLink v-if="widget.primaryText" :to="widget.primaryLink || '#'" class="px-8 py-4 bg-brand-green text-white rounded-lg hover:bg-brand-green-dark transition-colors inline-flex items-center gap-2 no-underline">
                    {{ widget.primaryText }}
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                  </NuxtLink>
                  <NuxtLink v-if="widget.secondaryText" :to="widget.secondaryLink || '#'" class="px-8 py-4 bg-white text-brand-green rounded-lg hover:bg-gray-50 transition-colors border border-brand-green no-underline">
                    {{ widget.secondaryText }}
                  </NuxtLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    </div>
</template>

<style scoped>
.texto-enriquecido :deep(ul) {
  list-style: disc outside !important;
  list-style-type: disc !important;
  list-style-position: outside !important;
  display: block !important;
  padding-left: 1.25rem !important;
  margin: 0 0 1rem 1.25rem !important;
}

.texto-enriquecido :deep(ol) {
  list-style: decimal outside !important;
  list-style-type: decimal !important;
  list-style-position: outside !important;
  display: block !important;
  padding-left: 1.25rem !important;
  margin: 0 0 1rem 1.25rem !important;
}

.texto-enriquecido :deep(li) {
  display: list-item !important;
  margin-bottom: 0.25rem !important;
}

.texto-enriquecido :deep(ul li::marker),
.texto-enriquecido :deep(ol li::marker) {
  color: inherit !important;
}
</style>