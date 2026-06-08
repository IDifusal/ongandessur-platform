<script setup lang="ts">
// Recibimos las 'sections' (que en nuestro nuevo builder son las filas/rows)
const props = defineProps<{
  sections: any[] 
}>()

// Extraer estilos de la Fila (Fondo, Color, Imagen)
const getRowStyle = (row: any): Record<string, any> => {
  const style: Record<string, any> = {}
  if (row.background?.color) style.backgroundColor = row.background.color
  if (row.background?.image) {
    style.backgroundImage = `url(${row.background.image})`
    style.backgroundPosition = row.background.position || 'center'
    style.backgroundSize = row.background.size || 'cover'
    style.backgroundRepeat = row.background.repeat || 'no-repeat'
  }
  return style
}

// Extraer el padding interior de la Fila
const getRowPadding = (row: any) => {
  switch(row.padding) {
    case 'none': return 'py-0'
    case 'sm': return 'py-6 md:py-10'
    case 'lg': return 'py-16 md:py-24'
    case 'xl': return 'py-24 md:py-32'
    case 'md':
    default: return 'py-12 md:py-16'
  }
}

// Extraer anchos de las columnas (70/30, etc)
const getColClass = (col: any) => {
  if (col.width === '70') return 'md:w-[70%]'
  if (col.width === '30') return 'md:w-[30%]'
  if (col.width === '80') return 'md:w-[80%]'
  if (col.width === '20') return 'md:w-[20%]'
  return 'flex-1' // Si no hay ancho, se dividen equitativamente
}

// Extraer estilos básicos del widget (Color, alineación, tamaño)
// Nota: Usamos Record<string, any> para que TypeScript no se queje (la línea roja de Volar)
const getWidgetStyle = (widget: any): Record<string, any> => {
  const style: Record<string, any> = {}
  if (widget.color) style.color = widget.color
  if (widget.textAlign) style.textAlign = widget.textAlign
  if (widget.italic) style.fontStyle = 'italic'
  if (widget.fontFamily) style.fontFamily = widget.fontFamily
  if (widget.fontSize) style.fontSize = widget.fontSize
  if (widget.type === 'title') style.fontWeight = 'bold'
  return style
}

function sanitizeHtml(value: string) {
  return String(value || '')
    .replace(/<img\b[^>]*src=(['"])(?:\s*\1|[^'">]+)?[^>]*>/gi, '')
    .replace(/<img\b[^>]*src=(['"])undefined\1[^>]*>/gi, '')
    .replace(/<img\b[^>]*src=(['"])\s*\1[^>]*>/gi, '')
}

function getImageStyle(widget: any) {
  const height = String(widget.imageHeight || '320px')
  const fit = String(widget.imageFit || widget.imageSize || 'cover')

  const base: Record<string, string> = {
    width: '100%',
    height,
  }

  if (fit === 'contain') {
    base.objectFit = 'contain'
    base.objectPosition = 'center'
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
    <div v-for="(row, ri) in sections" :key="ri" class="relative" :style="getRowStyle(row)" :class="getRowPadding(row)">
      
      <div v-if="row.background?.overlay" class="absolute inset-0 bg-black" :style="{ opacity: row.background.overlay }"></div>
      
      <div class="relative z-10 mx-auto px-4" :class="row.fullWidth ? 'w-full' : 'max-w-7xl'">
        
        <div class="flex flex-col md:flex-row gap-6 md:gap-10" 
             :class="{
               'items-start': row.alignment?.vertical === 'flex-start',
               'items-center': row.alignment?.vertical === 'center',
               'items-end': row.alignment?.vertical === 'flex-end',
               'justify-start': row.alignment?.horizontal === 'flex-start',
               'justify-center': row.alignment?.horizontal === 'center',
               'justify-end': row.alignment?.horizontal === 'flex-end',
             }">
          
          <div v-for="(col, ci) in row.columns" :key="ci" class="w-full flex flex-col gap-4" :class="getColClass(col)">
            
            <div v-for="(widget, wi) in col.widgets" :key="wi">
              
              <component v-if="widget.type === 'title'" :is="widget.tag || 'h2'" :style="getWidgetStyle(widget)">
                {{ widget.content }}
              </component>

              <div v-else-if="widget.type === 'text'" 
                  class="texto-enriquecido" 
                  :style="getWidgetStyle(widget)" 
                  v-html="sanitizeHtml(widget.content)">
              </div>
              <Flashcard v-else-if="widget.type === 'flashcard'" :widget="widget" />


              <div v-else-if="widget.type === 'button'" :style="{ textAlign: widget.textAlign || 'left' }">
                <a :href="widget.link" class="inline-block px-6 py-3 rounded-lg font-semibold transition-colors"
                   :class="widget.style === 'secondary' ? 'bg-amber-500 hover:bg-amber-600 text-white' : 'bg-teal-600 hover:bg-teal-700 text-white'">
                  {{ widget.text }}
                </a>
              </div>

              <div v-else-if="widget.type === 'image'" class="w-full overflow-hidden rounded-xl shadow-sm">
                 <a v-if="widget.link" :href="widget.link" class="block w-full h-full">
                   <img :src="widget.src" :alt="widget.alt || ''" class="w-full rounded-xl" :style="getImageStyle(widget)" />
                 </a>
                 <img v-else :src="widget.src" :alt="widget.alt || ''" class="w-full rounded-xl" :style="getImageStyle(widget)" />
              </div>

              <div v-else-if="widget.type === 'divider'" class="py-4">
                 <hr v-if="widget.style === 'line'" class="border-t border-gray-300" />
                 <div v-else-if="widget.style === 'spacer'" class="h-8 md:h-16"></div>
                 <svg v-else-if="widget.style === 'wave'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320" class="w-full">
                    <path fill="#1fa185" fill-opacity="1" d="M0,256L48,240C96,224,192,192,288,176C384,160,480,160,576,186.7C672,213,768,267,864,261.3C960,256,1056,192,1152,160C1248,128,1344,128,1392,128L1440,128L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z" />
                 </svg>
              </div>

              <div v-else-if="widget.type === 'hero_banner'" class="bg-white rounded-2xl shadow-xl overflow-hidden flex flex-col md:flex-row my-6">
                <div class="p-8 md:p-12 md:w-1/2 flex flex-col justify-center">
                   <div class="flex flex-wrap gap-2 mb-4">
                     <span v-for="tag in widget.tags" :key="tag" class="text-xs font-bold px-3 py-1 bg-gray-100 text-gray-600 rounded-full uppercase tracking-wider">{{ tag }}</span>
                   </div>
                   <h2 class="text-4xl md:text-5xl font-extrabold text-gray-900 mb-6 leading-tight">{{ widget.heading }}</h2>
                   <p class="text-lg text-gray-600 mb-8">{{ widget.description }}</p>
                   <div class="flex flex-wrap gap-4">
                     <a v-if="widget.primaryText" :href="widget.primaryLink" class="px-6 py-3 bg-teal-600 hover:bg-teal-700 text-white rounded-lg font-semibold transition">{{ widget.primaryText }}</a>
                     <a v-if="widget.secondaryText" :href="widget.secondaryLink" class="px-6 py-3 bg-white border-2 border-gray-200 hover:border-gray-300 text-gray-800 rounded-lg font-semibold transition">{{ widget.secondaryText }}</a>
                   </div>
                </div>
                <div class="md:w-1/2 h-64 md:h-auto bg-cover bg-center" :style="{ backgroundImage: `url(${widget.image})` }"></div>
              </div>

              <div v-else-if="widget.type === 'strategic_axes'" class="py-8">
                 <h2 class="text-3xl font-bold text-center mb-10">{{ widget.title }}</h2>
                 <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div v-for="(item, idx) in widget.items" :key="idx" class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 text-center hover:shadow-md transition">
                       <div class="w-16 h-16 mx-auto bg-teal-50 text-teal-600 rounded-full flex items-center justify-center mb-4 text-2xl font-bold">
                          {{ item.icon?.charAt(0).toUpperCase() || '✨' }}
                       </div>
                       <h3 class="font-bold text-lg mb-2 text-gray-800">{{ item.title }}</h3>
                       <p class="text-gray-600 text-sm">{{ item.desc }}</p>
                    </div>
                 </div>
              </div>

              <div v-else-if="widget.type === 'quick_links'" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 py-6">
                 <a v-for="(item, idx) in widget.items" :key="idx" :href="item.link" class="bg-white p-5 rounded-lg shadow-sm border border-gray-100 hover:border-teal-500 hover:shadow-md transition group flex flex-col h-full">
                    <h3 class="font-bold text-gray-900 group-hover:text-teal-600 transition">{{ item.title }}</h3>
                    <p class="text-sm text-gray-500 mt-2">{{ item.desc }}</p>
                 </a>
              </div>

              <div v-else-if="widget.type === 'projects_grid'" class="py-8">
                 <h2 class="text-3xl font-bold text-center mb-10">{{ widget.title }}</h2>
                 <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <a v-for="(item, idx) in widget.items" :key="idx" :href="item.link" class="group bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-xl transition block border border-gray-100">
                       <div class="h-48 bg-gray-200 bg-cover bg-center" :style="{ backgroundImage: `url(${item.image})` }"></div>
                       <div class="p-6">
                          <span class="text-xs font-bold text-teal-600 uppercase tracking-wider mb-2 block">{{ item.category }}</span>
                          <h3 class="font-bold text-xl text-gray-900 group-hover:text-teal-600 transition">{{ item.title }}</h3>
                       </div>
                    </a>
                 </div>
              </div>

              <div v-else-if="widget.type === 'stats'" class="flex flex-wrap justify-center gap-8 md:gap-16 py-8">
                 <div v-for="(item, idx) in widget.items" :key="idx" class="text-center">
                    <div class="text-4xl md:text-5xl font-extrabold text-amber-500 mb-2">{{ item.number }}</div>
                    <div class="text-sm md:text-base font-semibold text-gray-600 uppercase tracking-wide">{{ item.label }}</div>
                 </div>
              </div>

              <div v-else-if="widget.type === 'cta_collaborate'" class="bg-teal-900 text-white rounded-2xl p-8 md:p-12 text-center shadow-2xl my-8">
                 <h2 class="text-2xl md:text-4xl font-bold mb-8 max-w-3xl mx-auto leading-tight">{{ widget.title }}</h2>
                 <div class="flex flex-wrap justify-center gap-4">
                    <a v-if="widget.primaryText" :href="widget.primaryLink" class="px-8 py-4 bg-amber-500 hover:bg-amber-400 text-white rounded-full font-bold text-lg transition shadow-lg">{{ widget.primaryText }}</a>
                    <a v-if="widget.secondaryText" :href="widget.secondaryLink" class="px-8 py-4 bg-transparent border-2 border-white/30 hover:border-white text-white rounded-full font-bold text-lg transition">{{ widget.secondaryText }}</a>
                 </div>
              </div>

              <div v-else-if="widget.type === 'institutional_message'" class="text-center py-10 max-w-4xl mx-auto">
                 <p class="text-xl md:text-3xl font-serif text-gray-800 italic leading-relaxed">"{{ widget.text }}"</p>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Estilos vacíos encapsulados (Si necesitas estilos para el diseño general van aquí) */
</style>

<style>
/* CSS GLOBAL EXCLUSIVO PARA V-HTML (Sin la etiqueta 'scoped') */
/* Esto le da la orden directa al navegador de ignorar el reseteo de Tailwind en este contenedor específico */
.texto-enriquecido ul {
  list-style: disc outside !important;
  list-style-type: disc !important;
  list-style-position: outside !important;
  padding-left: 1.25rem !important;
  margin: 0 0 1rem 1.25rem !important;
  display: block !important;
}

.texto-enriquecido ol {
  list-style: decimal outside !important;
  list-style-type: decimal !important;
  list-style-position: outside !important;
  padding-left: 1.25rem !important;
  margin: 0 0 1rem 1.25rem !important;
  display: block !important;
}

.texto-enriquecido li {
  display: list-item !important;
  margin-bottom: 0.25rem !important;
}

.texto-enriquecido ul li::marker,
.texto-enriquecido ol li::marker {
  color: inherit !important;
}

.texto-enriquecido p {
  margin-bottom: 0.75rem !important;
  line-height: 1.7 !important;
}

.texto-enriquecido strong,
.texto-enriquecido b {
  font-weight: 700 !important;
}

.texto-enriquecido em,
.texto-enriquecido i {
  font-style: italic !important;
}

.texto-enriquecido a {
  color: #3b82f6 !important;
  text-decoration: underline !important;
}

.texto-enriquecido h1,
.texto-enriquecido h2,
.texto-enriquecido h3 {
  font-weight: 700 !important;
  margin-top: 1.5rem !important;
  margin-bottom: 0.75rem !important;
  color: inherit;
}
.texto-enriquecido h1 { font-size: 2.25rem !important; line-height: 1.2; }
.texto-enriquecido h2 { font-size: 1.875rem !important; line-height: 1.3; }
.texto-enriquecido h3 { font-size: 1.5rem !important; line-height: 1.4; }

/* 1. Obliga a HTML a respetar múltiples espacios seguidos y saltos de línea */
.texto-enriquecido {
  white-space: pre-wrap !important;
  word-wrap: break-word !important;
}

/* 2. Truco mágico: Si un párrafo está vacío (un "Enter"), le inyecta un espacio invisible para forzar su altura */
.texto-enriquecido p:empty::before,
.texto-enriquecido p:has(br):empty::before {
  content: "\00A0" !important;
  display: block !important;
}
</style>