<script setup lang="ts">
const props = defineProps<{
  modelValue: any[]
}>()

const emit = defineEmits<{
  'update:modelValue': [value: any[]]
}>()

function defaultRowSettings() {
  return {
    background: { image: '', color: '', overlay: 0, position: 'center', repeat: 'no-repeat', size: 'cover' },
    alignment: { vertical: 'flex-start', horizontal: 'flex-start' },
    padding: 'md',
    fullWidth: false,
  }
}

const rows = ref(props.modelValue?.length ? JSON.parse(JSON.stringify(props.modelValue)).map((r: any) => ({
  ...defaultRowSettings(),
  ...r,
})) : [])
const editingWidget = ref<{ row: number; col: number; widget: number } | null>(null)
const widgetMenuOpen = ref('')
const rowSettingsOpen = ref<number | null>(null)

function toggleRowSettings(ri: number) {
  rowSettingsOpen.value = rowSettingsOpen.value === ri ? null : ri
}

function openWidgetMenu(ri: number, ci: number) {
  const key = `${ri}-${ci}`
  widgetMenuOpen.value = widgetMenuOpen.value === key ? '' : key
}

const widgetTypes = [
  { value: 'title',    label: 'Título',     icon: 'T' },
  { value: 'text',     label: 'Texto',      icon: '¶' },
  { value: 'image',    label: 'Imagen',     icon: '🖼' },
  { value: 'button',   label: 'Botón',      icon: '🔘' },
  { value: 'services', label: 'Servicios',   icon: '⚙️' },
  { value: 'products', label: 'Productos',   icon: '🛒' },
  { value: 'news',     label: 'Noticias',    icon: '📰' },
  { value: 'hero',     label: 'Hero Slider', icon: '🎞' },
{ value: 'divider',  label: 'Divisor',     icon: '➖' },
]

const columnLayouts = [
  { value: '1',  label: '1 columna' },
  { value: '2',  label: '2 columnas' },
  { value: '3',  label: '3 columnas' },
  { value: '2-70-30', label: '70% / 30%' },
  { value: '2-80-20', label: '80% / 20%' },
]

const bgPositions = [
  { value: 'center', label: 'Centro' },
  { value: 'top', label: 'Arriba' },
  { value: 'bottom', label: 'Abajo' },
  { value: 'left', label: 'Izquierda' },
  { value: 'right', label: 'Derecha' },
  { value: 'top left', label: 'Arriba Izq.' },
  { value: 'top right', label: 'Arriba Der.' },
  { value: 'bottom left', label: 'Abajo Izq.' },
  { value: 'bottom right', label: 'Abajo Der.' },
]

const bgSizes = [
  { value: 'cover', label: 'Cubrir' },
  { value: 'contain', label: 'Contener' },
  { value: 'auto', label: 'Auto' },
]

const bgRepeats = [
  { value: 'no-repeat', label: 'No repetir' },
  { value: 'repeat', label: 'Repetir' },
  { value: 'repeat-x', label: 'Horizontal' },
  { value: 'repeat-y', label: 'Vertical' },
]

const presetColors = [
  { value: '', label: 'Ninguno', swatch: 'transparent' },
  { value: '#1a1a2e', label: 'Azul oscuro', swatch: '#1a1a2e' },
  { value: '#16213e', label: 'Azul marino', swatch: '#16213e' },
  { value: '#0f3460', label: 'Azul', swatch: '#0f3460' },
  { value: '#1fa185', label: 'Verde brand', swatch: '#1fa185' },
  { value: '#ba9774', label: 'Dorado brand', swatch: '#ba9774' },
  { value: '#f8f9fa', label: 'Gris claro', swatch: '#f8f9fa' },
  { value: '#343a40', label: 'Gris oscuro', swatch: '#343a40' },
  { value: '#000000', label: 'Negro', swatch: '#000000' },
  { value: '#ffffff', label: 'Blanco', swatch: '#ffffff' },
]

const verticalAlignments = [
  { value: 'flex-start', label: 'Arriba' },
  { value: 'center', label: 'Centro' },
  { value: 'flex-end', label: 'Abajo' },
  { value: 'stretch', label: 'Estirar' },
]

const horizontalAlignments = [
  { value: 'flex-start', label: 'Izquierda' },
  { value: 'center', label: 'Centro' },
  { value: 'flex-end', label: 'Derecha' },
]

watch(rows, (val) => {
  emit('update:modelValue', val)
}, { deep: true })

onMounted(() => {
  document.addEventListener('click', (e) => {
    const target = e.target as HTMLElement
    if (!target.closest('.widget-menu-trigger, .widget-menu') && !target.closest('.row-settings-trigger, .row-settings')) {
      widgetMenuOpen.value = ''
    }
  })
})

function addRow() {
  rows.value.push({ ...defaultRowSettings(), columns: [{ widgets: [] }] })
}

function removeRow(ri: number) {
  rows.value.splice(ri, 1)
}

function setColumns(ri: number, layout: string) {
  const cols = parseInt(layout) || 1
  const widths = layout === '2-70-30' ? ['70', '30'] : layout === '2-80-20' ? ['80', '20'] : []
  const row = rows.value[ri]
  row.columns = Array.from({ length: cols }, (_, i) => ({
    widgets: [],
    width: widths[i] || '',
  }))
}

function addWidget(ri: number, ci: number, type: string) {
  const widget: any = { type }
  if (type === 'title') { widget.content = 'Nuevo título'; widget.tag = 'h2'; widget.textAlign = 'left' }
  if (type === 'text') { widget.content = '<p>Escribe aquí...</p>'; widget.textAlign = 'left' }
  if (type === 'image') widget.src = ''
  if (type === 'button') { widget.text = 'Botón'; widget.link = '#'; widget.textAlign = 'left' }
  if (type === 'hero') {
    widget.slides = [
      { image: '', title: 'Título del slide', subtitle: 'Subtítulo del slide', button: { text: 'Botón', link: '#' } },
    ]
  }
  if (type === 'divider') { widget.style = 'wave' }
  rows.value[ri].columns[ci].widgets.push(widget)
}

function removeWidget(ri: number, ci: number, wi: number) {
  rows.value[ri].columns[ci].widgets.splice(wi, 1)
  editingWidget.value = null
}

function moveWidget(ri: number, ci: number, wi: number, dir: -1 | 1) {
  const ws = rows.value[ri].columns[ci].widgets
  const to = wi + dir
  if (to < 0 || to >= ws.length) return
  ;[ws[wi], ws[to]] = [ws[to], ws[wi]]
}

function getWidgetIcon(type: string) {
  return widgetTypes.find((w) => w.value === type)?.icon || '•'
}

function getWidgetLabel(type: string) {
  return widgetTypes.find((w) => w.value === type)?.label || type
}

function widgetPreview(widget: any) {
  if (widget.type === 'title') return widget.content || '(vacío)'
  if (widget.type === 'text') return (widget.content || '').replace(/<[^>]*>/g, '').slice(0, 60) || '(vacío)'
  if (widget.type === 'image') return widget.src || '(sin imagen)'
  if (widget.type === 'button') return widget.text || '(botón)'
  if (['services', 'products', 'news'].includes(widget.type)) return `(Listado dinámico: ${widget.type})`
  if (widget.type === 'hero') return `(Slider: ${widget.slides?.length || 0} slides)`
  if (widget.type === 'divider') return `(Divisor: ${widget.style || 'wave'})`
  return '(widget)'
}
</script>

<template>
  <div class="page-builder">
    <!-- Empty state -->
    <div v-if="!rows.length" class="border-2 border-dashed border-gray-300 rounded-lg py-16 text-center">
      <p class="text-gray-400 mb-4">No hay filas. Agrega una para empezar a construir.</p>
      <button type="button" class="px-6 py-2 bg-brand-teal text-white rounded-lg font-semibold text-sm hover:bg-teal-700 transition-colors" @click="addRow">+ Añadir fila</button>
    </div>

    <!-- Rows -->
    <div v-for="(row, ri) in rows" :key="ri" class="border border-gray-200 rounded-lg mb-4 bg-white shadow-sm">
      <!-- Row header -->
      <div class="flex items-center justify-between px-4 py-2 bg-gray-50 border-b border-gray-200 rounded-t-lg">
        <div class="flex items-center gap-2">
          <span class="text-xs font-semibold text-gray-500 uppercase">Fila {{ ri + 1 }}</span>
          <select class="text-xs border border-gray-300 rounded px-2 py-1" @change="(e) => setColumns(ri, (e.target as HTMLSelectElement).value)">
            <option value="1" :selected="row.columns?.length === 1">1 columna</option>
            <option value="2" :selected="row.columns?.length === 2">2 columnas</option>
            <option value="3" :selected="row.columns?.length === 3">3 columnas</option>
            <option value="2-70-30" :selected="row.columns?.[0]?.width === '70'">70% / 30%</option>
            <option value="2-80-20" :selected="row.columns?.[0]?.width === '80'">80% / 20%</option>
          </select>
          <button type="button" class="row-settings-trigger text-xs px-2 py-1 rounded border border-gray-300 hover:bg-white hover:border-brand-teal hover:text-brand-teal transition-colors flex items-center gap-1" @click.stop="toggleRowSettings(ri)">
            <span class="text-xs">&#9881;</span> Ajustes
          </button>
        </div>
        <button type="button" class="text-xs text-red-500 hover:text-red-700" @click="removeRow(ri)">× Eliminar fila</button>
      </div>

      <!-- Row Settings Panel -->
      <div v-if="rowSettingsOpen === ri" class="row-settings border-b border-gray-200 bg-gray-50 p-4" @click.stop>
        <fieldset class="border border-gray-200 rounded-lg p-3 mb-3">
          <legend class="text-xs font-semibold text-gray-600 px-1">Fondo</legend>

          <div class="mb-3">
            <label class="text-xs font-semibold text-gray-600 block mb-1">Imagen de fondo</label>
            <ImageUploader :model-value="row.background?.image || ''" @update:model-value="(val) => { if (!row.background) row.background = defaultRowSettings().background; row.background.image = val }" />
          </div>

          <div class="grid grid-cols-2 md:grid-cols-4 gap-2 mb-3">
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Posición</label>
              <select class="w-full text-xs border border-gray-300 rounded px-2 py-1" :value="row.background?.position || 'center'" @change="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.position = (e.target as HTMLSelectElement).value }">
                <option v-for="bp in bgPositions" :key="bp.value" :value="bp.value">{{ bp.label }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Tamaño</label>
              <select class="w-full text-xs border border-gray-300 rounded px-2 py-1" :value="row.background?.size || 'cover'" @change="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.size = (e.target as HTMLSelectElement).value }">
                <option v-for="bs in bgSizes" :key="bs.value" :value="bs.value">{{ bs.label }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Repetición</label>
              <select class="w-full text-xs border border-gray-300 rounded px-2 py-1" :value="row.background?.repeat || 'no-repeat'" @change="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.repeat = (e.target as HTMLSelectElement).value }">
                <option v-for="br in bgRepeats" :key="br.value" :value="br.value">{{ br.label }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Overlay (opacidad)</label>
              <div class="flex items-center gap-2">
                <input type="range" min="0" max="100" :value="(row.background?.overlay || 0) * 100" class="flex-1" @input="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.overlay = parseInt((e.target as HTMLInputElement).value) / 100 }" />
                <span class="text-xs text-gray-500 w-8">{{ Math.round((row.background?.overlay || 0) * 100) }}%</span>
              </div>
            </div>
          </div>

          <div>
            <label class="text-xs font-semibold text-gray-600 block mb-1">Color de fondo</label>
            <div class="flex flex-wrap gap-1 mb-2">
              <button
                v-for="c in presetColors"
                :key="c.value"
                type="button"
                class="w-6 h-6 rounded-full border-2 transition-colors"
                :class="(row.background?.color === c.value) ? 'border-brand-teal scale-110' : 'border-gray-200 hover:border-gray-400'"
                :style="{ background: c.swatch }"
                :title="c.label"
                @click="() => { if (!row.background) row.background = defaultRowSettings().background; row.background.color = c.value }"
              ></button>
            </div>
            <input type="color" :value="row.background?.color || '#ffffff'" class="w-8 h-8 border border-gray-300 rounded cursor-pointer" @input="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.color = (e.target as HTMLInputElement).value }" />
          </div>
        </fieldset>

        <fieldset class="border border-gray-200 rounded-lg p-3">
          <legend class="text-xs font-semibold text-gray-600 px-1">Alineación del contenido</legend>
          <div class="flex items-center gap-4">
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Vertical</label>
              <div class="flex gap-1">
                <button
                  v-for="va in verticalAlignments"
                  :key="va.value"
                  type="button"
                  class="text-xs px-3 py-1.5 rounded border transition-colors"
                  :class="(row.alignment?.vertical === va.value) ? 'bg-brand-teal text-white border-brand-teal' : 'border-gray-300 hover:border-gray-400'"
                  @click="() => { if (!row.alignment) row.alignment = defaultRowSettings().alignment; row.alignment.vertical = va.value }"
                >{{ va.label }}</button>
              </div>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Horizontal</label>
              <div class="flex gap-1">
                <button
                  v-for="ha in horizontalAlignments"
                  :key="ha.value"
                  type="button"
                  class="text-xs px-3 py-1.5 rounded border transition-colors"
                  :class="(row.alignment?.horizontal === ha.value) ? 'bg-brand-teal text-white border-brand-teal' : 'border-gray-300 hover:border-gray-400'"
                  @click="() => { if (!row.alignment) row.alignment = defaultRowSettings().alignment; row.alignment.horizontal = ha.value }"
                >{{ ha.label }}</button>
              </div>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Padding interior</label>
              <select class="text-xs border border-gray-300 rounded px-2 py-1" :value="row.padding || 'md'" @change="(e) => { row.padding = (e.target as HTMLSelectElement).value }">
                <option value="none">Ninguno</option>
                <option value="sm">Pequeño</option>
                <option value="md">Mediano</option>
                <option value="lg">Grande</option>
                <option value="xl">Extra grande</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold text-gray-600 block mb-1">Ancho completo</label>
              <button
                type="button"
                class="text-xs px-3 py-1.5 rounded border transition-colors"
                :class="row.fullWidth ? 'bg-brand-teal text-white border-brand-teal' : 'border-gray-300 hover:border-gray-400'"
                @click="row.fullWidth = !row.fullWidth"
              >{{ row.fullWidth ? '100%' : 'Contenedor' }}</button>
            </div>
          </div>
        </fieldset>
      </div>

      <!-- Columns -->
      <div class="flex flex-col md:flex-row p-3 gap-3">
        <div v-for="(col, ci) in row.columns" :key="ci" class="flex-1 min-h-[120px] border border-dashed border-gray-300 rounded-lg p-3 bg-gray-50/50" :class="{ 'md:w-7/12': col.width === '70', 'md:w-5/12': col.width === '30', 'md:w-8/12': col.width === '80', 'md:w-4/12': col.width === '20' }">
          <div class="text-xs text-gray-400 mb-2 font-semibold">Columna {{ ci + 1 }}</div>

          <!-- Widgets in column -->
          <div v-for="(widget, wi) in col.widgets" :key="wi" class="border border-gray-200 rounded mb-2 bg-white">
            <div class="flex items-center justify-between px-3 py-1.5 bg-gray-100 text-xs">
              <div class="flex items-center gap-1.5">
                <span class="font-semibold text-gray-600">{{ getWidgetIcon(widget.type) }} {{ getWidgetLabel(widget.type) }}</span>
              </div>
              <div class="flex items-center gap-1">
                <button type="button" class="text-gray-400 hover:text-gray-600 px-1" @click="moveWidget(ri, ci, wi, -1)" :disabled="wi === 0">↑</button>
                <button type="button" class="text-gray-400 hover:text-gray-600 px-1" @click="moveWidget(ri, ci, wi, 1)" :disabled="wi === col.widgets.length - 1">↓</button>
                <button type="button" class="text-red-400 hover:text-red-600 px-1" @click="removeWidget(ri, ci, wi)">×</button>
              </div>
            </div>

            <!-- Widget content preview -->
            <div class="px-3 py-2 text-xs text-gray-500 cursor-pointer hover:bg-gray-50" @click="editingWidget = { row: ri, col: ci, widget: wi }">
              {{ widgetPreview(widget) }}
            </div>

            <!-- Inline editor -->
            <div v-if="editingWidget?.row === ri && editingWidget?.col === ci && editingWidget?.widget === wi" class="border-t border-gray-200 p-3 bg-gray-50" @click.stop>
              <template v-if="widget.type === 'title'">
                <label class="text-xs font-semibold text-gray-600 block mb-1">Contenido</label>
                <input v-model="widget.content" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-2" />
                <div class="grid grid-cols-2 gap-2 mb-2">
                  <div>
                    <label class="text-xs font-semibold text-gray-600 block mb-1">Etiqueta HTML</label>
                    <select v-model="widget.tag" class="w-full text-sm border border-gray-300 rounded px-2 py-1">
                      <option value="h1">H1</option>
                      <option value="h2">H2</option>
                      <option value="h3">H3</option>
                      <option value="h4">H4</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold text-gray-600 block mb-1">Alineación</label>
                    <select v-model="widget.textAlign" class="w-full text-sm border border-gray-300 rounded px-2 py-1">
                      <option value="left">Izquierda</option>
                      <option value="center">Centro</option>
                      <option value="right">Derecha</option>
                    </select>
                  </div>
                </div>
              </template>

              <template v-if="widget.type === 'text'">
                <label class="text-xs font-semibold text-gray-600 block mb-1">Contenido (HTML)</label>
                <textarea v-model="widget.content" class="w-full text-sm border border-gray-300 rounded px-2 py-1 font-mono mb-2" rows="4" />
                <div>
                  <label class="text-xs font-semibold text-gray-600 block mb-1">Alineación</label>
                  <select v-model="widget.textAlign" class="w-full text-sm border border-gray-300 rounded px-2 py-1">
                    <option value="left">Izquierda</option>
                    <option value="center">Centro</option>
                    <option value="right">Derecha</option>
                  </select>
                </div>
              </template>

              <template v-if="widget.type === 'image'">
                <label class="text-xs font-semibold text-gray-600 block mb-1">Imagen</label>
                <ImageUploader v-model="widget.src" />
                <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Texto alternativo</label>
                <input v-model="widget.alt" class="w-full text-sm border border-gray-300 rounded px-2 py-1" />
              </template>

              <template v-if="widget.type === 'button'">
                <label class="text-xs font-semibold text-gray-600 block mb-1">Texto</label>
                <input v-model="widget.text" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-2" />
                <label class="text-xs font-semibold text-gray-600 block mb-1">Enlace</label>
                <input v-model="widget.link" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-2" />
                <div class="grid grid-cols-2 gap-2 mb-2">
                  <div>
                    <label class="text-xs font-semibold text-gray-600 block mb-1">Estilo</label>
                    <select v-model="widget.style" class="w-full text-sm border border-gray-300 rounded px-2 py-1">
                      <option value="primary">Primario (verde)</option>
                      <option value="secondary">Secundario (dorado)</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold text-gray-600 block mb-1">Alineación</label>
                    <select v-model="widget.textAlign" class="w-full text-sm border border-gray-300 rounded px-2 py-1">
                      <option value="left">Izquierda</option>
                      <option value="center">Centro</option>
                      <option value="right">Derecha</option>
                    </select>
                  </div>
                </div>
              </template>

              <p v-if="['services', 'products', 'news', 'hero', 'divider'].includes(widget.type) && widget.type !== 'hero' && widget.type !== 'divider'" class="text-xs text-gray-500 italic">Este widget muestra contenido dinámico automáticamente.</p>

              <template v-if="widget.type === 'hero'">
                <label class="text-xs font-semibold text-gray-600 block mb-1">Slides</label>
                <div v-for="(slide, si) in widget.slides" :key="si" class="border border-gray-200 rounded p-2 mb-2 bg-white">
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-xs font-semibold text-gray-500">Slide {{ si + 1 }}</span>
                    <button type="button" class="text-xs text-red-400 hover:text-red-600" @click="widget.slides.splice(si, 1)">×</button>
                  </div>
                  <label class="text-xs text-gray-500 block">Imagen</label>
                  <ImageUploader :model-value="slide.image || ''" @update:model-value="(val) => slide.image = val" class="mb-1" />
                  <label class="text-xs text-gray-500 block">Título</label>
                  <input v-model="slide.title" class="w-full text-xs border border-gray-300 rounded px-2 py-1 mb-1" />
                  <label class="text-xs text-gray-500 block">Subtítulo</label>
                  <input v-model="slide.subtitle" class="w-full text-xs border border-gray-300 rounded px-2 py-1 mb-1" />
                  <label class="text-xs text-gray-500 block">Texto del botón</label>
                  <input v-model="slide.button.text" class="w-full text-xs border border-gray-300 rounded px-2 py-1 mb-1" />
                  <label class="text-xs text-gray-500 block">Enlace del botón</label>
                  <input v-model="slide.button.link" class="w-full text-xs border border-gray-300 rounded px-2 py-1" />
                </div>
                <button type="button" class="text-xs text-brand-teal hover:text-teal-700" @click="widget.slides.push({ image: '', title: 'Nuevo slide', subtitle: '', button: { text: 'Botón', link: '#' } })">+ Añadir slide</button>
              </template>

              <template v-if="widget.type === 'divider'">
                <label class="text-xs font-semibold text-gray-600 block mb-1">Estilo</label>
                <select v-model="widget.style" class="text-sm border border-gray-300 rounded px-2 py-1">
                  <option value="wave">Onda SVG</option>
                  <option value="line">Línea</option>
                  <option value="spacer">Espacio</option>
                </select>
              </template>

              <button type="button" class="mt-2 text-xs text-gray-500 hover:text-gray-700" @click="editingWidget = null">Cerrar</button>
            </div>
          </div>

          <!-- Add widget button -->
          <div>
            <button type="button" class="widget-menu-trigger w-full py-2 text-xs text-gray-400 border border-dashed border-gray-300 rounded hover:border-brand-teal hover:text-brand-teal transition-colors" @click.stop="openWidgetMenu(ri, ci)">+ Añadir widget</button>
            <div v-if="widgetMenuOpen === `${ri}-${ci}`" class="widget-menu mt-1 bg-white border border-gray-200 rounded-lg shadow-lg p-2" @click.stop>
              <div class="grid grid-cols-2 gap-1">
                <button type="button" v-for="wt in widgetTypes" :key="wt.value" class="text-xs text-left px-2 py-1.5 rounded hover:bg-gray-100 transition-colors" @click="addWidget(ri, ci, wt.value); widgetMenuOpen = ''">
                  <span class="mr-1">{{ wt.icon }}</span> {{ wt.label }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add row button -->
    <button type="button" v-if="rows.length" class="w-full py-3 border-2 border-dashed border-gray-300 rounded-lg text-sm text-gray-400 hover:text-brand-teal hover:border-brand-teal transition-colors" @click="addRow">+ Añadir fila</button>
  </div>
</template>
