<script setup lang="ts">
const props = defineProps<{
  rows: any[]
}>()

const isClient = typeof window !== 'undefined'

if (isClient) {
  console.log('[PageWidgets] Received rows:', props.rows?.length)
  if (props.rows) {
    props.rows.forEach((row: any, ri: number) => {
      console.log(`[PageWidgets] Row ${ri}:`, {
        columns: row.columns?.length,
        fullWidth: row.fullWidth,
        padding: row.padding,
        bg: !!row.background?.image || !!row.background?.color,
      })
      row.columns?.forEach((col: any, ci: number) => {
        console.log(`[PageWidgets]   Col ${ci}: widgets=${col.widgets?.length}`, col.widgets?.map((w: any) => `${w.type}:"${String(w.content || w.text || '').slice(0, 30)}"`))
      })
    })
  }
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
  const a = widget.textAlign || 'left'
  return { left: 'text-left', center: 'text-center', right: 'text-right', justify: 'text-justify' }[a] || 'text-left'
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
                v-html="widget.content"
              />

              <!-- Text -->
              <div v-if="widget.type === 'text'" class="text-gray-600 leading-relaxed" :class="textAlignClass(widget)" :style="{ textAlign: widget.textAlign === 'justify' ? 'justify' : '' }" v-html="widget.content" />

              <!-- Image -->
              <a v-if="widget.type === 'image' && widget.link" :href="widget.link" target="_blank" rel="noopener">
                <img :src="widget.src" :alt="widget.alt || ''" class="rounded-lg" :class="widget.imageClass || 'max-w-full h-auto'" :style="widget.imageSize === 'cover' ? 'width:100%;height:' + (widget.imageHeight || '300px') + ';object-fit:cover;' : (widget.imageSize === 'contain' ? 'object-fit:contain;max-height:' + (widget.imageHeight || '400px') + ';' : '')" />
              </a>
              <img v-else-if="widget.type === 'image'" :src="widget.src" :alt="widget.alt || ''" class="rounded-lg" :class="widget.imageClass || 'max-w-full h-auto'" :style="widget.imageSize === 'cover' ? 'width:100%;height:' + (widget.imageHeight || '300px') + ';object-fit:cover;' : (widget.imageSize === 'contain' ? 'object-fit:contain;max-height:' + (widget.imageHeight || '400px') + ';' : '')" />

              <!-- Button -->
              <div v-if="widget.type === 'button'" :class="textAlignClass(widget)">
                <NuxtLink :to="widget.link || '#'" class="inline-block px-6 py-3 font-semibold rounded-lg transition-colors no-underline" :class="widget.style === 'secondary' ? 'bg-brand-gold text-white hover:bg-amber-700' : 'bg-brand-teal text-white hover:bg-teal-700'">
                  {{ widget.text || 'Botón' }}
                </NuxtLink>
              </div>

              <!-- Dynamic widgets -->
              <DynamicServices v-if="widget.type === 'services'" :template-id="widget.templateId" />
              <DynamicProducts v-if="widget.type === 'products'" :template-id="widget.templateId" />
              <DynamicNews v-if="widget.type === 'news'" :template-id="widget.templateId" />

              <!-- Hero Slider -->
              <HeroSlider v-if="widget.type === 'hero'" :slides="widget.slides || []" />

              <!-- Divider -->
              <svg v-if="widget.type === 'divider' && widget.style === 'wave'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320" class="-my-4">
                <path fill="#1fa185" fill-opacity="1" d="M0,256L48,240C96,224,192,192,288,176C384,160,480,160,576,186.7C672,213,768,267,864,261.3C960,256,1056,192,1152,160C1248,128,1344,128,1392,128L1440,128L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z" />
              </svg>
              <hr v-if="widget.type === 'divider' && widget.style === 'line'" class="border-gray-200 my-4" />
              <div v-if="widget.type === 'divider' && widget.style === 'spacer'" class="h-8" />
              <div v-if="widget.type === 'divider' && widget.style === 'vertical'" class="flex justify-center my-2">
                <div class="w-px h-16 md:h-24 bg-gray-300"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- DEBUG PANEL -->
    <div v-if="isClient" class="fixed bottom-0 right-0 z-50 bg-gray-900 text-green-400 text-xs font-mono p-3 m-2 rounded-lg max-w-md max-h-96 overflow-auto opacity-90" style="box-shadow: 0 0 20px rgba(0,0,0,0.5)">
      <div class="flex justify-between items-center mb-2 border-b border-gray-700 pb-1">
        <strong class="text-white">DEBUG PageWidgets</strong>
        <button class="text-gray-400 hover:text-white text-lg leading-none" onclick="this.parentElement.parentElement.remove()">x</button>
      </div>
      <div><span class="text-yellow-400">rows:</span> {{ rows?.length || 0 }}</div>
      <div v-if="!rows?.length" class="text-red-400 mt-1">EMPTY ROWS - nothing to render!</div>
      <template v-for="(row, ri) in (rows || [])" :key="'d-'+ri">
        <div class="mt-1 border-t border-gray-700 pt-1">
          <span class="text-cyan-400">Row {{ ri }}:</span>
          cols={{ row.columns?.length }},
          fw={{ row.fullWidth }},
          pd={{ row.padding }}
        </div>
        <div v-for="(col, ci) in (row.columns || [])" :key="'dc-'+ci" class="ml-2">
          <span class="text-purple-400">Col {{ ci }}:</span> {{ col.widgets?.length || 0 }} widgets
          [<span v-for="(w, wi) in (col.widgets || [])" :key="'dw-'+wi">{{ w.type }}{{ wi < col.widgets.length - 1 ? ', ' : '' }}</span>]
        </div>
      </template>
    </div>
  </div>
</template>
