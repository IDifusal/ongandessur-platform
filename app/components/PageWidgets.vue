<script setup lang="ts">
defineProps<{
  rows: any[]
}>()

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
  const a = widget.textAlign || 'left'
  return { left: 'text-left', center: 'text-center', right: 'text-right' }[a] || 'text-left'
}

function paddingClass(row: any) {
  const p: string = row.padding || 'md'
  return paddingMap[p] || 'py-6'
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
              <!-- Title -->
              <h1 v-if="widget.type === 'title' && widget.tag === 'h1'" class="text-4xl md:text-5xl font-bold font-kadwa text-gray-800" :class="textAlignClass(widget)" v-html="widget.content" />
              <h2 v-else-if="widget.type === 'title' && (!widget.tag || widget.tag === 'h2')" class="text-3xl md:text-4xl font-bold font-kadwa text-gray-800" :class="textAlignClass(widget)" v-html="widget.content" />
              <h3 v-else-if="widget.type === 'title' && widget.tag === 'h3'" class="text-2xl md:text-3xl font-bold font-kadwa text-gray-800" :class="textAlignClass(widget)" v-html="widget.content" />
              <h4 v-else-if="widget.type === 'title' && widget.tag === 'h4'" class="text-xl md:text-2xl font-bold font-kadwa text-gray-800" :class="textAlignClass(widget)" v-html="widget.content" />

              <!-- Text -->
              <div v-if="widget.type === 'text'" class="text-gray-600 leading-relaxed" :class="textAlignClass(widget)" v-html="widget.content" />

              <!-- Image -->
              <img v-if="widget.type === 'image'" :src="widget.src" :alt="widget.alt || ''" class="rounded-lg max-w-full h-auto" :class="widget.class || ''" />

              <!-- Button -->
              <div v-if="widget.type === 'button'" :class="textAlignClass(widget)">
                <NuxtLink :to="widget.link || '#'" class="inline-block px-6 py-3 font-semibold rounded-lg transition-colors no-underline" :class="widget.style === 'secondary' ? 'bg-brand-gold text-white hover:bg-amber-700' : 'bg-brand-teal text-white hover:bg-teal-700'">
                  {{ widget.text || 'Botón' }}
                </NuxtLink>
              </div>

              <!-- Dynamic widgets -->
              <DynamicServices v-if="widget.type === 'services'" />
              <DynamicProducts v-if="widget.type === 'products'" />
              <DynamicNews v-if="widget.type === 'news'" />

              <!-- Hero Slider -->
              <HeroSlider v-if="widget.type === 'hero'" :slides="widget.slides || []" />

              <!-- Divider -->
              <svg v-if="widget.type === 'divider' && widget.style === 'wave'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320" class="-my-4">
                <path fill="#1fa185" fill-opacity="1" d="M0,256L48,240C96,224,192,192,288,176C384,160,480,160,576,186.7C672,213,768,267,864,261.3C960,256,1056,192,1152,160C1248,128,1344,128,1392,128L1440,128L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z" />
              </svg>
              <hr v-if="widget.type === 'divider' && widget.style === 'line'" class="border-gray-200 my-4" />
              <div v-if="widget.type === 'divider' && widget.style === 'spacer'" class="h-8" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
