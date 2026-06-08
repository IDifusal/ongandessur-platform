<script setup lang="ts">
const props = defineProps<{ modelValue: any[] }>()
const emit = defineEmits<{ 'update:modelValue': [value: any[]] }>()

const { data: templates } = await useFetch('/api/templates', { key: 'pb-templates' })

function defaultRowSettings() {
  return {
    background: { image: '', color: '', overlay: 0, position: 'center', repeat: 'no-repeat', size: 'cover' },
    alignment: { vertical: 'flex-start', horizontal: 'flex-start' },
    padding: 'md',
    fullWidth: false,
  }
}

const rows = ref<any[]>(props.modelValue?.length ? JSON.parse(JSON.stringify(props.modelValue)).map((r: any) => ({
  ...defaultRowSettings(),
  ...r,
})) : [])
const editingWidget = ref<{ row: number; col: number; widget: number } | null>(null)
const editingFlashcardItem = ref<{ row: number; col: number; widget: number; item: number } | null>(null)
const widgetMenuOpen = ref('')
const rowSettingsOpen = ref<number | null>(null)

function toggleRowSettings(ri: number) { rowSettingsOpen.value = rowSettingsOpen.value === ri ? null : ri }
function openWidgetMenu(ri: number, ci: number) { const key = `${ri}-${ci}`; widgetMenuOpen.value = widgetMenuOpen.value === key ? '' : key }
function toggleWidgetEditor(ri: number, ci: number, wi: number) {
  const current = editingWidget.value
  editingWidget.value = current?.row === ri && current?.col === ci && current?.widget === wi
    ? null
    : { row: ri, col: ci, widget: wi }
}

function toggleFlashcardItemEditor(ri: number, ci: number, wi: number, idx: number) {
  const current = editingFlashcardItem.value
  editingFlashcardItem.value = current?.row === ri && current?.col === ci && current?.widget === wi && current?.item === idx
    ? null
    : { row: ri, col: ci, widget: wi, item: idx }
}

const widgetTypes = [
  { value: 'title', label: 'Título', icon: 'T' },
  { value: 'text', label: 'Texto', icon: '¶' },
  { value: 'image', label: 'Imagen', icon: '🖼' },
  { value: 'button', label: 'Botón', icon: '🔘' },
  { value: 'flashcard', label: 'Flashcard', icon: '📇' }, // <-- NUEVO WIDGET AÑADIDO
  { value: 'services', label: 'Servicios', icon: '⚙️' },
  { value: 'products', label: 'Productos', icon: '🛒' },
  { value: 'news', label: 'Noticias', icon: '📰' },
  { value: 'hero', label: 'Hero Slider', icon: '🎞' },
  { value: 'divider', label: 'Divisor', icon: '➖' },
  { value: 'hero_banner', label: 'Hero Banner', icon: '🏠' },
  { value: 'institutional_message', label: 'Mensaje Inst.', icon: '💬' },
  { value: 'quick_links', label: 'Accesos rápidos', icon: '🔗' },
  { value: 'strategic_axes', label: 'Ejes estratégicos', icon: '🎯' },
  { value: 'projects_grid', label: 'Proyectos', icon: '📋' },
  { value: 'stats', label: 'Indicadores', icon: '📊' },
  { value: 'cta_collaborate', label: 'CTA Colaborar', icon: '🤝' },
]

const bgPositions = [
  { value: 'center', label: 'Centro' }, { value: 'top', label: 'Arriba' }, { value: 'bottom', label: 'Abajo' },
  { value: 'left', label: 'Izquierda' }, { value: 'right', label: 'Derecha' }, { value: 'top left', label: 'Arriba Izq.' },
  { value: 'top right', label: 'Arriba Der.' }, { value: 'bottom left', label: 'Abajo Izq.' }, { value: 'bottom right', label: 'Abajo Der.' },
]

const bgSizes = [{ value: 'cover', label: 'Cubrir' }, { value: 'contain', label: 'Contener' }, { value: 'auto', label: 'Auto' }]
const bgRepeats = [{ value: 'no-repeat', label: 'No repetir' }, { value: 'repeat', label: 'Repetir' }, { value: 'repeat-x', label: 'Horizontal' }, { value: 'repeat-y', label: 'Vertical' }]

const presetColors = [
  { value: '', label: 'Ninguno', swatch: 'transparent' }, { value: '#2F6B4F', label: 'Verde brand', swatch: '#2F6B4F' },
  { value: '#1F4635', label: 'Verde oscuro', swatch: '#1F4635' }, { value: '#FEE0AA', label: 'Crema', swatch: '#FEE0AA' },
  { value: '#FFF8ED', label: 'Fondo cálido', swatch: '#FFF8ED' }, { value: '#C96B3C', label: 'Terracota', swatch: '#C96B3C' },
  { value: '#F4B942', label: 'Dorado', swatch: '#F4B942' }, { value: '#ffffff', label: 'Blanco', swatch: '#ffffff' },
  { value: '#f8f9fa', label: 'Gris claro', swatch: '#f8f9fa' }, { value: '#343a40', label: 'Gris oscuro', swatch: '#343a40' },
  { value: '#000000', label: 'Negro', swatch: '#000000' },
]

const verticalAlignments = [{ value: 'flex-start', label: 'Arriba' }, { value: 'center', label: 'Centro' }, { value: 'flex-end', label: 'Abajo' }, { value: 'stretch', label: 'Estirar' }]
const horizontalAlignments = [{ value: 'flex-start', label: 'Izquierda' }, { value: 'center', label: 'Centro' }, { value: 'flex-end', label: 'Derecha' }]

watch(rows, (val) => { emit('update:modelValue', val) }, { deep: true })

onMounted(() => {
  document.addEventListener('click', (e) => {
    const target = e.target as HTMLElement
    if (!target.closest('.widget-menu-trigger, .widget-menu') && !target.closest('.row-settings-trigger, .row-settings-panel')) {
      widgetMenuOpen.value = ''
    }
  })
})

function addRow() { rows.value.push({ ...defaultRowSettings(), columns: [{ widgets: [] }] }) }
function removeRow(ri: number) { rows.value.splice(ri, 1) }
function moveRow(ri: number, dir: -1 | 1) {
  const to = ri + dir
  if (to < 0 || to >= rows.value.length) return
  ;[rows.value[ri], rows.value[to]] = [rows.value[to], rows.value[ri]]
}
function setColumns(ri: number, layout: string) {
  const cols = parseInt(layout) || 1
  const widths = layout === '2-70-30' ? ['70', '30'] : layout === '2-80-20' ? ['80', '20'] : []
  rows.value[ri].columns = Array.from({ length: cols }, (_, i) => ({ widgets: [], width: widths[i] || '' }))
}

function addWidget(ri: number, ci: number, type: string) {
  const widget: any = { type }
  if (type === 'title') { widget.content = 'Nuevo título'; widget.tag = 'h2'; widget.textAlign = 'left'; widget.fontFamily = ''; widget.fontSize = ''; widget.color = ''; widget.italic = false }
  else if (type === 'text') { widget.content = '<p>Escribe aquí...</p>'; widget.textAlign = 'left' }
  else if (type === 'image') {
    widget.src = ''
    widget.link = ''
    widget.alt = ''
    widget.imageSize = 'cover'
    widget.imageHeight = '300px'
    widget.imageFit = 'cover'
    widget.cropPreset = 'original'
  }
  else if (type === 'button') { widget.text = 'Botón'; widget.link = '#'; widget.textAlign = 'left' }
  else if (type === 'flashcard') {
    widget.items = [{
      icon: '🎯',
      title: 'Título de la tarjeta',
      content: '<p>Descripción de la tarjeta...</p>',
      bgColor: '#ffffff',
      textColor: '#1e293b',
      titleColor: '#2563eb',
      shadow: 'shadow-md',
      borderWidth: 1,
      borderStyle: 'solid',
      borderColor: '#e2e8f0',
      borderRadius: 12,
      width: '100%',
      height: 'auto',
      image: '',
      imagePosition: 'top',
      imageHeight: '200px',
      imageWidth: '40%',
      imageObjectFit: 'cover',
      imageShape: 'square',
      imageAlign: 'center',
    }]
    widget.bgColor = '#ffffff'
    widget.textColor = '#1e293b'
    widget.titleColor = '#2563eb'
    widget.shadow = 'shadow-md'
    widget.borderWidth = 1
    widget.borderStyle = 'solid'
    widget.borderColor = '#e2e8f0'
    widget.borderRadius = 12
    widget.width = '100%'
    widget.height = 'auto'
    widget.cardsPerRow = 3
  }



  else if (type === 'hero') { widget.slides = [{ image: '', title: 'Título del slide', subtitle: 'Subtítulo del slide', button: { text: 'Botón', link: '#' } }] }
  else if (type === 'divider') { widget.style = 'wave' }
  else if (['services', 'products', 'news'].includes(type)) { widget.templateId = '' }
  else if (type === 'hero_banner') {
    widget.heading = 'Desarrollo con esperanza'
    widget.description = 'ONG Andes Sur trabaja por el desarrollo económico, social y cultural de comunidades y poblaciones vulnerables.'
    widget.tags = ['Educación', 'Formación', 'Proyectos sociales']
    widget.primaryText = 'Conócenos'; widget.primaryLink = '/nosotros'
    widget.secondaryText = 'Ver proyectos'; widget.secondaryLink = '/nuestro-trabajo'
    widget.tertiaryText = 'Colabora'; widget.tertiaryLink = '/colabora'
    widget.image = 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800&h=600&fit=crop'
  }
  else if (type === 'institutional_message') { widget.text = 'Trabajamos junto a jóvenes, estudiantes y profesionales.' }
  else if (type === 'quick_links') { widget.items = [{ icon: 'users', title: 'Nosotros', desc: 'Conoce quiénes somos', link: '/nosotros' }] }
  else if (type === 'strategic_axes') { widget.title = 'Nuestros ejes'; widget.items = [{ icon: 'lightbulb', title: 'Investigación', desc: 'Cursos y webinars' }] }
  else if (type === 'projects_grid') { widget.title = 'Proyectos'; widget.items = [{ title: 'Tableta para tu carpeta', category: 'Educación', image: '', link: '/proyectos' }] }
  else if (type === 'stats') { widget.items = [{ number: '+500', label: 'Personas beneficiadas' }] }
  else if (type === 'cta_collaborate') {
    widget.title = 'Tu tiempo puede convertirse en oportunidades reales'
    widget.primaryText = 'Quiero colaborar'; widget.primaryLink = '/colabora'
    widget.secondaryText = 'Sé voluntario'; widget.secondaryLink = '/colabora'
  }
  rows.value[ri].columns[ci].widgets.push(widget)
}

function removeWidget(ri: number, ci: number, wi: number) { rows.value[ri].columns[ci].widgets.splice(wi, 1); editingWidget.value = null }
function moveWidget(ri: number, ci: number, wi: number, dir: -1 | 1) {
  const ws = rows.value[ri].columns[ci].widgets; const to = wi + dir;
  if (to >= 0 && to < ws.length) [ws[wi], ws[to]] = [ws[to], ws[wi]]
}

function getWidgetIcon(type: string) { return widgetTypes.find((w) => w.value === type)?.icon || '•' }
function getWidgetLabel(type: string) { return widgetTypes.find((w) => w.value === type)?.label || type }

function syncFlashcardItems(widget: any, count: number) {
  const safeCount = Math.max(1, Math.min(8, Number.isFinite(count) ? count : 1))
  const base = Array.isArray(widget.items) && widget.items.length ? widget.items : [
    { icon: '🎯', title: 'Título de la tarjeta', content: '<p>Descripción de la tarjeta...</p>', bgColor: widget.bgColor || '#ffffff', textColor: widget.textColor || '#1e293b', titleColor: widget.titleColor || '#2563eb', shadow: widget.shadow || 'shadow-md', borderWidth: widget.borderWidth ?? 1, borderStyle: widget.borderStyle || 'solid', borderColor: widget.borderColor || '#e2e8f0', borderRadius: widget.borderRadius ?? 12, width: widget.width || '100%', height: widget.height || 'auto' },
  ]

  if (base.length < safeCount) {
    while (base.length < safeCount) {
      base.push({
        icon: '✨',
        title: `Tarjeta ${base.length + 1}`,
        content: '<p>Nueva tarjeta...</p>',
        bgColor: widget.bgColor || '#ffffff',
        textColor: widget.textColor || '#1e293b',
        titleColor: widget.titleColor || '#2563eb',
        shadow: widget.shadow || 'shadow-md',
        borderWidth: widget.borderWidth ?? 1,
        borderStyle: widget.borderStyle || 'solid',
        borderColor: widget.borderColor || '#e2e8f0',
        borderRadius: widget.borderRadius ?? 12,
        width: widget.width || '100%',
        height: widget.height || 'auto',
        image: '',
        imagePosition: 'top',
        imageHeight: '200px',
        imageWidth: '40%',
        imageObjectFit: 'cover',
        imageShape: 'square',
        imageAlign: 'center',
      })
    }
  } else if (base.length > safeCount) {
    base.splice(safeCount)
  }

  widget.items = base
}

function widgetPreview(widget: any) {
  if (widget.type === 'title') return widget.content || '(vacío)'
  if (widget.type === 'text') return (widget.content || '').replace(/<[^>]*>/g, '').slice(0, 60) || '(vacío)'
  if (widget.type === 'image') return widget.src || '(sin imagen)'
  if (widget.type === 'button') return widget.text || '(botón)'
  if (widget.type === 'flashcard') return `(Flashcard) ${(widget.items?.length || 1)} tarjeta(s)`
  if (['services', 'products', 'news'].includes(widget.type)) return `(Listado dinámico: ${widget.type})`
  if (widget.type === 'hero') return `(Slider: ${widget.slides?.length || 0} slides)`
  if (widget.type === 'divider') return `(Divisor: ${widget.style || 'wave'})`
  if (widget.type === 'hero_banner') return `(Hero: "${widget.heading || ''}")`
  if (widget.type === 'institutional_message') return (widget.text || '').slice(0, 60) + '...'
  if (widget.type === 'quick_links') return `(Accesos rápidos: ${widget.items?.length || 0} tarjetas)`
  if (widget.type === 'strategic_axes') return `(Ejes: ${widget.items?.length || 0} ejes)`
  if (widget.type === 'projects_grid') return `(Proyectos: ${widget.items?.length || 0} proyectos)`
  if (widget.type === 'stats') return `(Indicadores: ${widget.items?.length || 0} cifras)`
  if (widget.type === 'cta_collaborate') return `(CTA: ${widget.primaryText || 'Colaborar'})`
  return '(widget)'
}

function getPreviewStyle(widget: any) {
  const styles: any = { lineHeight: '1.2', wordBreak: 'break-word' }
  if (['title', 'text', 'button', 'flashcard'].includes(widget.type)) {
    if (widget.color) styles.color = widget.color
    if (widget.textAlign) styles.textAlign = widget.textAlign
    if (widget.italic) styles.fontStyle = 'italic'
    if (widget.fontFamily) styles.fontFamily = widget.fontFamily
    if (widget.fontSize) styles.fontSize = widget.fontSize
    else if (widget.type === 'title' && widget.tag) {
      const sizes = { h1: '32px', h2: '24px', h3: '20px', h4: '16px' }
      styles.fontSize = sizes[widget.tag as keyof typeof sizes] || '16px'
    }
    if (widget.type === 'title') styles.fontWeight = 'bold'
  }
  return styles
}
</script>

<template>
  <div class="page-builder overflow-x-hidden theme-aware">
    <div v-if="!rows.length" class="empty-state border-2 border-dashed rounded-lg py-16 text-center">
      <p class="mb-4 text-muted">No hay filas. Agrega una para empezar a construir.</p>
      <button type="button" class="btn-add px-6 py-2 rounded-lg font-semibold text-sm transition-colors" @click="addRow">+ Añadir fila</button>
    </div>

    <div v-for="(row, ri) in rows" :key="ri" class="row-container border rounded-lg mb-4 shadow-sm">
      <div class="row-header flex items-center justify-between px-4 py-2 border-b rounded-t-lg">
        <div class="flex items-center gap-2">
          <button type="button" class="btn-icon px-1" @click="moveRow(Number(ri), -1)" :disabled="Number(ri) === 0">↑</button>
          <button type="button" class="btn-icon px-1" @click="moveRow(Number(ri), 1)" :disabled="Number(ri) === rows.length - 1">↓</button>
          <span class="text-xs font-semibold uppercase">Fila {{ ri + 1 }}</span>
          <select class="input-theme text-xs border rounded px-2 py-1" @change="(e) => setColumns(Number(ri), (e.target as HTMLSelectElement).value)">
            <option value="1" :selected="row.columns?.length === 1">1 columna</option>
            <option value="2" :selected="row.columns?.length === 2">2 columnas</option>
            <option value="3" :selected="row.columns?.length === 3">3 columnas</option>
            <option value="2-70-30" :selected="row.columns?.[0]?.width === '70'">70% / 30%</option>
            <option value="2-80-20" :selected="row.columns?.[0]?.width === '80'">80% / 20%</option>
          </select>
          <button type="button" class="btn-settings text-xs px-2 py-1 rounded border transition-colors flex items-center gap-1" @click.stop="toggleRowSettings(Number(ri))">
            <span class="text-xs">&#9881;</span> Ajustes
          </button>
        </div>
        <button type="button" class="btn-delete-row text-xs" @click="removeRow(Number(ri))">× Eliminar fila</button>
      </div>

      <div v-if="rowSettingsOpen === ri" class="row-settings-panel border-b p-4" @click.stop>
        <fieldset class="border-theme rounded-lg p-3 mb-3">
          <legend class="text-xs font-semibold px-1">Fondo</legend>
          <div class="mb-3">
            <label class="text-xs font-semibold block mb-1">Imagen de fondo</label>
            <ImageUploader :model-value="row.background?.image || ''" @update:model-value="(val) => { if (!row.background) row.background = defaultRowSettings().background; row.background.image = val }" />
          </div>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-2 mb-3">
            <div>
              <label class="text-xs font-semibold block mb-1">Posición</label>
              <select class="input-theme w-full text-xs border rounded px-2 py-1" :value="row.background?.position || 'center'" @change="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.position = (e.target as HTMLSelectElement).value }">
                <option v-for="bp in bgPositions" :key="bp.value" :value="bp.value">{{ bp.label }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold block mb-1">Tamaño</label>
              <select class="input-theme w-full text-xs border rounded px-2 py-1" :value="row.background?.size || 'cover'" @change="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.size = (e.target as HTMLSelectElement).value }">
                <option v-for="bs in bgSizes" :key="bs.value" :value="bs.value">{{ bs.label }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold block mb-1">Repetición</label>
              <select class="input-theme w-full text-xs border rounded px-2 py-1" :value="row.background?.repeat || 'no-repeat'" @change="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.repeat = (e.target as HTMLSelectElement).value }">
                <option v-for="br in bgRepeats" :key="br.value" :value="br.value">{{ br.label }}</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold block mb-1">Overlay (opacidad)</label>
              <div class="flex items-center gap-2">
                <input type="range" min="0" max="100" :value="(row.background?.overlay || 0) * 100" class="flex-1" @input="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.overlay = parseInt((e.target as HTMLInputElement).value) / 100 }" />
                <span class="text-xs w-8">{{ Math.round((row.background?.overlay || 0) * 100) }}%</span>
              </div>
            </div>
          </div>
          <div>
            <label class="text-xs font-semibold block mb-1">Color de fondo</label>
            <div class="flex flex-wrap gap-1 mb-2">
              <button v-for="c in presetColors" :key="c.value" type="button" class="w-6 h-6 rounded-full border-2 transition-colors border-theme-color" :class="(row.background?.color === c.value) ? 'border-active scale-110' : ''" :style="{ background: c.swatch }" :title="c.label" @click="() => { if (!row.background) row.background = defaultRowSettings().background; row.background.color = c.value }"></button>
            </div>
            <input type="color" :value="row.background?.color || '#ffffff'" class="w-8 h-8 border rounded cursor-pointer border-theme" @input="(e) => { if (!row.background) row.background = defaultRowSettings().background; row.background.color = (e.target as HTMLInputElement).value }" />
          </div>
        </fieldset>

        <fieldset class="border-theme rounded-lg p-3">
          <legend class="text-xs font-semibold px-1">Alineación del contenido</legend>
          <div class="flex items-center gap-4">
            <div>
              <label class="text-xs font-semibold block mb-1">Vertical</label>
              <div class="flex gap-1">
                <button v-for="va in verticalAlignments" :key="va.value" type="button" class="btn-align text-xs px-3 py-1.5 rounded border transition-colors" :class="(row.alignment?.vertical === va.value) ? 'active' : ''" @click="() => { if (!row.alignment) row.alignment = defaultRowSettings().alignment; row.alignment.vertical = va.value }">{{ va.label }}</button>
              </div>
            </div>
            <div>
              <label class="text-xs font-semibold block mb-1">Horizontal</label>
              <div class="flex gap-1">
                <button v-for="ha in horizontalAlignments" :key="ha.value" type="button" class="btn-align text-xs px-3 py-1.5 rounded border transition-colors" :class="(row.alignment?.horizontal === ha.value) ? 'active' : ''" @click="() => { if (!row.alignment) row.alignment = defaultRowSettings().alignment; row.alignment.horizontal = ha.value }">{{ ha.label }}</button>
              </div>
            </div>
            <div>
              <label class="text-xs font-semibold block mb-1">Padding interior</label>
              <select class="input-theme text-xs border rounded px-2 py-1" :value="row.padding || 'md'" @change="(e) => { row.padding = (e.target as HTMLSelectElement).value }">
                <option value="none">Ninguno</option>
                <option value="sm">Pequeño</option>
                <option value="md">Mediano</option>
                <option value="lg">Grande</option>
                <option value="xl">Extra grande</option>
              </select>
            </div>
            <div>
              <label class="text-xs font-semibold block mb-1">Ancho completo</label>
              <button type="button" class="btn-align text-xs px-3 py-1.5 rounded border transition-colors" :class="row.fullWidth ? 'active' : ''" @click="row.fullWidth = !row.fullWidth">{{ row.fullWidth ? '100%' : 'Contenedor' }}</button>
            </div>
          </div>
        </fieldset>
      </div>

      <div class="flex flex-col md:flex-row p-3 gap-3 min-w-0">
         <div v-for="(col, ci) in row.columns" :key="Number(ci)" class="col-container flex-1 min-h-[120px] min-w-0 border border-dashed rounded-lg p-3" :class="{ 'md:w-7/12': col.width === '70', 'md:w-5/12': col.width === '30', 'md:w-8/12': col.width === '80', 'md:w-4/12': col.width === '20' }">
          <div class="col-title text-xs mb-2 font-semibold">Columna {{ Number(ci) + 1 }}</div>

          <div v-for="(widget, wi) in col.widgets" :key="Number(wi)" class="widget-container border rounded mb-2">
            <div class="widget-header flex items-center justify-between px-3 py-2 text-xs">
              <div class="flex items-center gap-1.5">
                <span class="font-semibold">{{ getWidgetIcon(widget.type) }} {{ getWidgetLabel(widget.type) }}</span>
              </div>
              <div class="flex items-center gap-1">
                <button type="button" class="btn-icon px-1" @click="moveWidget(Number(ri), Number(ci), Number(wi), -1)" :disabled="Number(wi) === 0">↑</button>
                <button type="button" class="btn-icon px-1" @click="moveWidget(Number(ri), Number(ci), Number(wi), 1)" :disabled="Number(wi) === col.widgets.length - 1">↓</button>
                <button type="button" class="btn-delete px-1" @click="removeWidget(Number(ri), Number(ci), Number(wi))">×</button>
              </div>
            </div>

            <div class="widget-preview px-4 py-3 text-sm cursor-pointer border-t border-theme-color" 
                 @click.stop="toggleWidgetEditor(Number(ri), Number(ci), Number(wi))"
                 :style="getPreviewStyle(widget)">
              {{ widgetPreview(widget) }}
            </div>

            <div v-if="editingWidget?.row === ri && editingWidget?.col === ci && editingWidget?.widget === wi"
                :key="`editor-${ri}-${ci}-${wi}`"
                class="widget-editor border-t border-theme-color p-4"
                @click.stop>
              
              <template v-if="widget.type === 'title'">
                <label class="text-xs font-semibold block mb-1">Contenido</label>
                <input v-model="widget.content" class="input-theme mb-3" />
                <div class="grid grid-cols-2 gap-3 mb-3">
                  <div>
                    <label class="text-xs font-semibold block mb-1">Etiqueta HTML</label>
                    <select v-model="widget.tag" class="input-theme">
                      <option value="h1">H1</option>
                      <option value="h2">H2</option>
                      <option value="h3">H3</option>
                      <option value="h4">H4</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold block mb-1">Alineación</label>
                    <select v-model="widget.textAlign" class="input-theme">
                      <option value="left">Izquierda</option>
                      <option value="center">Centro</option>
                      <option value="right">Derecha</option>
                      <option value="justify">Justificado</option>
                    </select>
                  </div>
                </div>
                <div class="grid grid-cols-2 gap-3 mb-3">
                  <div>
                    <label class="text-xs font-semibold block mb-1">Fuente</label>
                    <select v-model="widget.fontFamily" class="input-theme">
                      <option value="">Predeterminada</option>
                      <option value="kadwa">Kadwa (serif)</option>
                      <option value="open-sans">Open Sans</option>
                      <option value="nanum">Nanum Pen Script</option>
                      <option value="serif">Serif</option>
                      <option value="sans">Sans-serif</option>
                      <option value="mono">Monoespacio</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold block mb-1">Color</label>
                    <div class="flex items-center gap-2">
                      <input type="color" v-model="widget.color" class="w-10 h-10 border rounded cursor-pointer border-theme shrink-0" />
                      <input v-model="widget.color" placeholder="#000000" class="input-theme flex-1" />
                      <button 
                        type="button" 
                        @click="widget.color = ''" 
                        class="text-xs px-3 py-2 border rounded border-theme-color hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition-all"
                        title="Restablecer color por defecto"
                      >
                        Borrar
                      </button>
                    </div>
                  </div>
                </div>
                <div class="grid grid-cols-2 gap-3 mb-2">
                  <div>
                    <label class="text-xs font-semibold block mb-1">Tamaño de fuente</label>
                    <select v-model="widget.fontSize" class="input-theme">
                      <option value="">Predeterminado</option>
                      <option value="12px">12px</option>
                      <option value="14px">14px</option>
                      <option value="16px">16px</option>
                      <option value="18px">18px</option>
                      <option value="20px">20px</option>
                      <option value="24px">24px</option>
                      <option value="28px">28px</option>
                      <option value="32px">32px</option>
                      <option value="36px">36px</option>
                      <option value="40px">40px</option>
                      <option value="48px">48px</option>
                      <option value="56px">56px</option>
                      <option value="64px">64px</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold block mb-1">Estilo</label>
                    <label class="flex items-center gap-2 mt-2">
                      <input type="checkbox" v-model="widget.italic" class="rounded input-theme w-4 h-4" />
                      <span class="text-sm">Itálica</span>
                    </label>
                  </div>
                </div>
              </template>

              <template v-else-if="widget.type === 'text'">
                <label class="text-xs font-semibold block mb-1">Contenido</label>
                <RichEditor v-model="widget.content" placeholder="Escribe aquí..." class="mb-3" />
                <label class="text-xs font-semibold block mb-1">Alineación</label>
                <select v-model="widget.textAlign" class="input-theme">
                  <option value="left">Izquierda</option>
                  <option value="center">Centro</option>
                  <option value="right">Derecha</option>
                  <option value="justify">Justificado</option>
                </select>
              </template>

              <template v-else-if="widget.type === 'image'">
                <label class="text-xs font-semibold block mb-1">Imagen</label>
                <ImageUploader
                  :model-value="widget.src || ''"
                  :fit-mode="widget.imageFit || 'cover'"
                  :crop-preset="widget.cropPreset || 'original'"
                  @update:model-value="(val) => widget.src = val"
                  class="mb-3"
                />
                <label class="text-xs font-semibold block mb-1">Enlace</label>
                <input v-model="widget.link" class="input-theme mb-3" placeholder="/ruta-o-url" />
                <label class="text-xs font-semibold block mb-1">Texto alternativo</label>
                <input v-model="widget.alt" class="input-theme mb-3" placeholder="Descripción de la imagen" />
                <div class="grid grid-cols-2 gap-3 mb-3">
                  <div>
                    <label class="text-xs font-semibold block mb-1">Ajuste</label>
                    <select v-model="widget.imageSize" class="input-theme">
                      <option value="cover">Cubrir</option>
                      <option value="contain">Contener</option>
                      <option value="fill">Rellenar</option>
                      <option value="auto">Auto</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold block mb-1">Alto</label>
                    <input v-model="widget.imageHeight" class="input-theme" placeholder="300px" />
                  </div>
                </div>
                <div class="grid grid-cols-2 gap-3">
                  <div>
                    <label class="text-xs font-semibold block mb-1">Ajuste visual</label>
                    <select v-model="widget.imageFit" class="input-theme">
                      <option value="cover">Cover</option>
                      <option value="contain">Contain</option>
                      <option value="fill">Fill</option>
                      <option value="none">None</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold block mb-1">Recorte</label>
                    <select v-model="widget.cropPreset" class="input-theme">
                      <option value="original">Sin recorte</option>
                      <option value="square">Cuadrado</option>
                      <option value="landscape">16:9</option>
                      <option value="portrait">4:3</option>
                    </select>
                  </div>
                </div>
              </template>

              <template v-else-if="widget.type === 'flashcard'">
                <div class="mb-4">
                  <h4 class="text-sm font-bold border-b border-theme-color pb-1 mb-3 text-main">1. Contenido</h4>
                  <div class="grid grid-cols-2 gap-3 mb-3">
                    <div>
                      <label class="text-xs font-semibold block mb-1">Cantidad de tarjetas</label>
                      <input type="number" min="1" max="8" :value="(widget.items || []).length" class="input-theme" @change="(e) => syncFlashcardItems(widget, Number((e.target as HTMLInputElement).value))" />
                    </div>
                    <div>
                      <label class="text-xs font-semibold block mb-1">Tarjetas por fila</label>
                      <input type="number" min="1" max="6" v-model.number="widget.cardsPerRow" class="input-theme" />
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="text-xs font-semibold block mb-1">Agregar</label>
                    <button type="button" class="btn-action text-xs w-full" @click="syncFlashcardItems(widget, (widget.items || []).length + 1)">+ Añadir tarjeta</button>
                  </div>

                  <div v-for="(item, idx) in (widget.items || [])" :key="`fc-item-${wi}-${idx}`" class="border rounded p-3 mb-3">
                    <div class="flashcard-item-header flex items-center justify-between mb-2 rounded-md px-1 py-1">
                      <span class="flashcard-item-badge text-xs font-semibold uppercase tracking-wide">Tarjeta {{ Number(idx) + 1 }}</span>
                      <div class="flex items-center gap-2">
                        <button type="button" class="btn-action text-xs rounded-full border border-white/20 bg-white/10 px-2 py-1" @click="toggleFlashcardItemEditor(Number(ri), Number(ci), Number(wi), Number(idx))">Editar</button>
                        <button type="button" class="btn-delete text-xs" @click="widget.items.splice(idx, 1); syncFlashcardItems(widget, (widget.items || []).length)">×</button>
                      </div>
                    </div>

                    <div v-if="editingFlashcardItem?.row === ri && editingFlashcardItem?.col === ci && editingFlashcardItem?.widget === wi && editingFlashcardItem?.item === idx" class="space-y-3 border-t border-theme-color pt-3">
                        <div class="grid grid-cols-12 gap-3 mb-3">
                          <div class="col-span-3">
                            <label class="text-xs font-semibold block mb-1">Ícono</label>
                            <input v-model="item.icon" class="input-theme" placeholder="(Vacío para ocultar)" />
                          </div>
                          <div class="col-span-9">
                            <label class="text-xs font-semibold block mb-1">Título</label>
                            <input v-model="item.title" class="input-theme" placeholder="(Vacío para ocultar)" />
                          </div>
                        </div>
                        <div class="grid grid-cols-2 gap-3 mb-3">
                          <div>
                            <label class="text-xs font-semibold block mb-1">Tamaño del Título</label>
                            <select v-model="item.titleSize" class="input-theme">
                              <option value="text-lg">Pequeño (18px)</option>
                              <option value="text-xl">Mediano (20px)</option>
                              <option value="text-2xl">Grande (24px)</option>
                              <option value="text-3xl">Extra Grande (30px)</option>
                              <option value="text-4xl">Gigante (36px)</option>
                            </select>
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Alineación del Título</label>
                            <select v-model="item.titleAlign" class="input-theme">
                              <option value="left">Izquierda</option>
                              <option value="center">Centro</option>
                              <option value="right">Derecha</option>
                              <option value="justify">Justificado</option>
                            </select>
                          </div>
                        </div>
                      <label class="text-xs font-semibold block mb-1">Cuerpo</label>
                      <RichEditor v-model="item.content" placeholder="Escribe la descripción aquí..." class="mb-3" />
                      <label class="text-xs font-semibold block mb-1">Imagen</label>
                      <ImageUploader :model-value="item.image || ''" @update:model-value="(val) => item.image = val" class="mb-2" />
                      <template v-if="item.image">
                        <div class="grid grid-cols-3 gap-2 mt-1">
                          <div>
                            <label class="text-xs font-semibold block mb-1">Posición</label>
                            <select v-model="item.imagePosition" class="input-theme">
                              <option value="top">Arriba</option>
                              <option value="bottom">Abajo</option>
                              <option value="left">Izquierda</option>
                              <option value="right">Derecha</option>
                              <option value="center">Centro</option>
                            </select>
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Alineación</label>
                            <select v-model="item.imageAlign" class="input-theme">
                              <option value="left">Izquierda</option>
                              <option value="center">Centro</option>
                              <option value="right">Derecha</option>
                            </select>
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">{{ ['left', 'right'].includes(item.imagePosition || 'top') ? 'Ancho' : 'Alto' }}</label>
                            <input v-if="['left', 'right'].includes(item.imagePosition || 'top')" v-model="item.imageWidth" class="input-theme" placeholder="40%" />
                            <input v-else v-model="item.imageHeight" class="input-theme" placeholder="200px" />
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Ajuste</label>
                            <select v-model="item.imageObjectFit" class="input-theme">
                              <option value="cover">Cubrir</option>
                              <option value="contain">Contener</option>
                              <option value="fill">Rellenar</option>
                            </select>
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Forma</label>
                            <select v-model="item.imageShape" class="input-theme">
                              <option value="square">Cuadrada</option>
                              <option value="circle">Circular</option>
                            </select>
                          </div>
                        </div>
                      </template>
                      <div class="mt-3">
                        <h5 class="text-xs font-bold uppercase tracking-wide text-main mb-2">2. Estilos y Diseño</h5>
                        <div class="grid grid-cols-3 gap-3 mb-3">
                          <div>
                            <label class="text-xs font-semibold block mb-1">Fondo</label>
                            <input type="color" v-model="item.bgColor" class="w-full h-8 border rounded cursor-pointer border-theme-color" />
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Texto</label>
                            <input type="color" v-model="item.textColor" class="w-full h-8 border rounded cursor-pointer border-theme-color" />
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Título</label>
                            <input type="color" v-model="item.titleColor" class="w-full h-8 border rounded cursor-pointer border-theme-color" />
                          </div>
                        </div>

                        <div class="grid grid-cols-2 gap-3 mb-3">
                          <div>
                            <label class="text-xs font-semibold block mb-1">Sombra</label>
                            <select v-model="item.shadow" class="input-theme">
                              <option value="shadow-none">Sin sombra</option>
                              <option value="shadow-sm">Pequeña</option>
                              <option value="shadow">Normal</option>
                              <option value="shadow-md">Mediana</option>
                              <option value="shadow-lg">Grande</option>
                              <option value="shadow-xl">Extra Grande</option>
                            </select>
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Redondeo (px)</label>
                            <input type="number" v-model="item.borderRadius" class="input-theme" placeholder="12" />
                          </div>
                        </div>

                        <div class="grid grid-cols-3 gap-3 mb-3">
                          <div>
                            <label class="text-xs font-semibold block mb-1">Borde (px)</label>
                            <input type="number" v-model="item.borderWidth" class="input-theme" min="0" placeholder="1" />
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Estilo</label>
                            <select v-model="item.borderStyle" class="input-theme">
                              <option value="solid">Sólido</option>
                              <option value="dashed">Rayas</option>
                              <option value="dotted">Puntos</option>
                            </select>
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Color Borde</label>
                            <input type="color" v-model="item.borderColor" class="w-full h-8 border rounded cursor-pointer border-theme-color" />
                          </div>
                        </div>

                        <div class="grid grid-cols-2 gap-3">
                          <div>
                            <label class="text-xs font-semibold block mb-1">Ancho (ej: 100%, 300px)</label>
                            <input v-model="item.width" class="input-theme" placeholder="100%" />
                          </div>
                          <div>
                            <label class="text-xs font-semibold block mb-1">Alto (ej: auto, 250px)</label>
                            <input v-model="item.height" class="input-theme" placeholder="auto" />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

              </template>
              <template v-else-if="widget.type === 'button'">
                <label class="text-xs font-semibold block mb-1">Texto</label>
                <input v-model="widget.text" class="input-theme mb-3" />
                <label class="text-xs font-semibold block mb-1">Enlace</label>
                <input v-model="widget.link" class="input-theme mb-3" />
                <div class="grid grid-cols-2 gap-3 mb-2">
                  <div>
                    <label class="text-xs font-semibold block mb-1">Estilo</label>
                    <select v-model="widget.style" class="input-theme">
                      <option value="primary">Primario (verde)</option>
                      <option value="secondary">Secundario (dorado)</option>
                    </select>
                  </div>
                  <div>
                    <label class="text-xs font-semibold block mb-1">Alineación</label>
                    <select v-model="widget.textAlign" class="input-theme">
                      <option value="left">Izquierda</option>
                      <option value="center">Centro</option>
                      <option value="right">Derecha</option>
                    </select>
                  </div>
                </div>
              </template>

              <template v-else-if="['services', 'products', 'news'].includes(widget.type)">
                <label class="text-xs font-semibold block mb-1">Template (opcional)</label>
                <select v-model="widget.templateId" class="input-theme mb-1">
                  <option value="">Diseño por defecto</option>
                  <option v-for="tpl in (templates || [])" :key="tpl.id" :value="tpl.id">{{ tpl.title }}</option>
                </select>
              </template>

              <template v-else-if="widget.type === 'hero'">
                <label class="text-xs font-semibold block mb-1">Slides</label>
                <div v-for="(slide, si) in widget.slides" :key="si" class="widget-container border rounded p-2 mb-2">
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-xs font-semibold">Slide {{ Number(si) + 1 }}</span>
                    <button type="button" class="btn-delete" @click="widget.slides.splice(si, 1)">×</button>
                  </div>
                  <label class="text-xs block">Imagen</label>
                  <ImageUploader :model-value="slide.image || ''" @update:model-value="(val) => slide.image = val" class="mb-1" />
                  <label class="text-xs block mt-2">Título</label>
                  <input v-model="slide.title" class="input-theme mb-1" />
                  <label class="text-xs block mt-2">Subtítulo</label>
                  <input v-model="slide.subtitle" class="input-theme mb-1" />
                  <label class="text-xs block mt-2">Texto del botón</label>
                  <input v-model="slide.button.text" class="input-theme mb-1" />
                  <label class="text-xs block mt-2">Enlace del botón</label>
                  <input v-model="slide.button.link" class="input-theme" />
                </div>
                <button type="button" class="btn-action text-xs" @click="widget.slides.push({ image: '', title: 'Nuevo slide', subtitle: '', button: { text: 'Botón', link: '#' } })">+ Añadir slide</button>
              </template>

              <template v-else-if="widget.type === 'divider'">
                <label class="text-xs font-semibold block mb-1">Estilo</label>
                <select v-model="widget.style" class="input-theme">
                  <option value="wave">Onda SVG</option>
                  <option value="line">Línea horizontal</option>
                  <option value="vertical">Línea vertical</option>
                  <option value="spacer">Espacio</option>
                </select>
              </template>

              <template v-else-if="widget.type === 'hero_banner'">
                <label class="text-xs font-semibold block mb-1">Título principal</label>
                <input v-model="widget.heading" class="input-theme mb-2" />
                <label class="text-xs font-semibold block mb-1">Descripción</label>
                <textarea v-model="widget.description" rows="3" class="input-theme mb-2"></textarea>
                <label class="text-xs font-semibold block mb-1">Tags (separados por coma)</label>
                <input :value="(widget.tags || []).join(', ')" @input="(e) => widget.tags = (e.target as HTMLInputElement).value.split(',').map((t: string) => t.trim()).filter(Boolean)" class="input-theme mb-2" placeholder="Educación, Formación, Voluntariado" />
                <div class="grid grid-cols-2 gap-3 mb-2">
                  <div><label class="text-xs block">Botón 1 texto</label><input v-model="widget.primaryText" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón 1 enlace</label><input v-model="widget.primaryLink" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón 2 texto</label><input v-model="widget.secondaryText" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón 2 enlace</label><input v-model="widget.secondaryLink" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón 3 texto</label><input v-model="widget.tertiaryText" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón 3 enlace</label><input v-model="widget.tertiaryLink" class="input-theme" /></div>
                </div>
                <label class="text-xs font-semibold block mb-1">Imagen</label>
                <ImageUploader :model-value="widget.image || ''" @update:model-value="(val) => widget.image = val" class="mb-1" />
                <label class="text-xs block mt-2">Alt de imagen</label>
                <input v-model="widget.imageAlt" class="input-theme" />
              </template>

              <template v-else-if="widget.type === 'institutional_message'">
                <label class="text-xs font-semibold block mb-1">Mensaje</label>
                <textarea v-model="widget.text" rows="3" class="input-theme"></textarea>
              </template>

              <template v-else-if="widget.type === 'quick_links'">
                <div v-for="(item, idx) in widget.items" :key="idx" class="widget-container border rounded p-2 mb-2">
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-xs font-semibold">Tarjeta {{ Number(idx) + 1 }}</span>
                    <button type="button" class="btn-delete" @click="widget.items.splice(idx, 1)">×</button>
                  </div>
                  <label class="text-xs block">Título</label><input v-model="item.title" class="input-theme mb-1" />
                  <label class="text-xs block">Descripción</label><input v-model="item.desc" class="input-theme mb-1" />
                  <label class="text-xs block">Enlace</label><input v-model="item.link" class="input-theme mb-1" />
                  <label class="text-xs block">Ícono</label><input v-model="item.icon" class="input-theme" />
                </div>
                <button type="button" class="btn-action text-xs" @click="widget.items.push({ icon: 'users', title: 'Nuevo enlace', desc: '', link: '/' })">+ Añadir tarjeta</button>
              </template>

              <template v-else-if="widget.type === 'strategic_axes'">
                <label class="text-xs font-semibold block mb-1">Título de sección</label><input v-model="widget.title" class="input-theme mb-2" />
                <div v-for="(item, idx) in widget.items" :key="idx" class="widget-container border rounded p-2 mb-2">
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-xs font-semibold">Eje {{ Number(idx) + 1 }}</span>
                    <button type="button" class="btn-delete" @click="widget.items.splice(idx, 1)">×</button>
                  </div>
                  <label class="text-xs block">Título</label><input v-model="item.title" class="input-theme mb-1" />
                  <label class="text-xs block">Descripción</label><input v-model="item.desc" class="input-theme mb-1" />
                  <label class="text-xs block">Ícono</label><input v-model="item.icon" class="input-theme" />
                </div>
                <button type="button" class="btn-action text-xs" @click="widget.items.push({ icon: 'heart', title: 'Nuevo eje', desc: '' })">+ Añadir eje</button>
              </template>

              <template v-else-if="widget.type === 'projects_grid'">
                <label class="text-xs font-semibold block mb-1">Título de sección</label><input v-model="widget.title" class="input-theme mb-2" />
                <div v-for="(item, idx) in widget.items" :key="idx" class="widget-container border rounded p-2 mb-2">
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-xs font-semibold">Proyecto {{ Number(idx) + 1 }}</span>
                    <button type="button" class="btn-delete" @click="widget.items.splice(idx, 1)">×</button>
                  </div>
                  <label class="text-xs block">Título</label><input v-model="item.title" class="input-theme mb-1" />
                  <label class="text-xs block">Categoría</label><input v-model="item.category" class="input-theme mb-1" />
                  <label class="text-xs block">Imagen URL</label><input v-model="item.image" class="input-theme mb-1" />
                  <label class="text-xs block">Enlace</label><input v-model="item.link" class="input-theme" />
                </div>
                <button type="button" class="btn-action text-xs" @click="widget.items.push({ title: 'Nuevo proyecto', category: '', image: '', link: '/proyectos' })">+ Añadir proyecto</button>
              </template>

              <template v-else-if="widget.type === 'stats'">
                <div v-for="(item, idx) in widget.items" :key="idx" class="flex gap-2 mb-2 items-center">
                  <input v-model="item.number" placeholder="+100" class="input-theme w-24" />
                  <input v-model="item.label" placeholder="Etiqueta" class="input-theme flex-1" />
                  <button type="button" class="btn-delete" @click="widget.items.splice(idx, 1)">×</button>
                </div>
                <button type="button" class="btn-action text-xs" @click="widget.items.push({ number: '+0', label: 'Nueva cifra' })">+ Añadir cifra</button>
              </template>

              <template v-else-if="widget.type === 'cta_collaborate'">
                <label class="text-xs font-semibold block mb-1">Título</label>
                <textarea v-model="widget.title" rows="2" class="input-theme mb-2"></textarea>
                <div class="grid grid-cols-2 gap-3 mb-2">
                  <div><label class="text-xs block">Botón principal (texto)</label><input v-model="widget.primaryText" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón principal (enlace)</label><input v-model="widget.primaryLink" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón secundario (texto)</label><input v-model="widget.secondaryText" class="input-theme" /></div>
                  <div><label class="text-xs block">Botón secundario (enlace)</label><input v-model="widget.secondaryLink" class="input-theme" /></div>
                </div>
              </template>

              <button type="button" class="mt-4 text-xs font-semibold text-muted hover:text-main" @click.stop="editingWidget = null">Cerrar Ajustes</button>
            </div>
          </div>

          <div>
            <button type="button" class="widget-menu-trigger w-full py-2 text-xs border border-dashed rounded transition-colors mt-2" @click.stop="openWidgetMenu(Number(ri), Number(ci))">+ Añadir widget</button>
            <div v-if="widgetMenuOpen === `${ri}-${ci}`" class="widget-menu mt-1 border rounded-lg shadow-lg p-2" @click.stop>
              <div class="grid grid-cols-2 gap-1">
                <button type="button" v-for="wt in widgetTypes" :key="wt.value" class="btn-widget-option text-xs text-left px-2 py-1.5 rounded transition-colors" @click="addWidget(Number(ri), Number(ci), wt.value); widgetMenuOpen = ''">
                  <span class="mr-1">{{ wt.icon }}</span> {{ wt.label }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <button type="button" v-if="rows.length" class="btn-add-main w-full py-3 border-2 border-dashed rounded-lg text-sm transition-colors" @click="addRow">+ Añadir fila</button>
  </div>
</template>

<style scoped>
/* CSS PURO PARA HEREDAR EL MODO OSCURO DE LA PÁGINA PRINCIPAL */

.theme-aware {
  --pb-bg: var(--bg-card, #ffffff);
  --pb-bg-alt: var(--bg-input, #f8fafc);
  --pb-border: var(--border-color, #e2e8f0);
  --pb-text: var(--text-main, #1e293b);
  --pb-text-muted: var(--text-muted, #64748b);
  --pb-primary: var(--border-focus, #3b82f6);
  --pb-danger: #ef4444;
  color: var(--pb-text);
}

.theme-aware .border,
.theme-aware .border-t,
.theme-aware .border-b {
  border-color: var(--pb-border) !important;
}

.theme-aware label,
.theme-aware .font-semibold,
.theme-aware .text-main {
  color: var(--pb-text);
}

.theme-aware .text-muted,
.theme-aware .text-gray-400,
.theme-aware .text-gray-500 {
  color: var(--pb-text-muted);
}

/* ====================================================
   NUEVOS ESTILOS DE INPUTS (Profundidad y visibilidad)
   ==================================================== */
.input-theme {
  background-color: var(--pb-bg) !important;
  color: var(--pb-text) !important;
  border: 1px solid var(--pb-border) !important;
  border-radius: 6px !important;
  padding: 8px 12px !important;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.06) !important;
  transition: all 0.2s ease;
  width: 100%;
}
.input-theme:focus {
  border-color: var(--pb-primary) !important;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.06), 0 0 0 3px rgba(59, 130, 246, 0.15) !important;
  outline: none !important;
  background-color: var(--pb-bg) !important;
}

.row-container, .widget-container, .widget-menu {
  background-color: var(--pb-bg);
  border-color: var(--pb-border);
}

.row-header, .row-settings-panel, .col-container, .widget-header, .widget-editor {
  background-color: var(--pb-bg-alt);
  border-color: var(--pb-border);
}

.widget-preview {
  color: var(--pb-text-muted);
  transition: opacity 0.2s ease;
}
.widget-preview:hover {
  opacity: 0.6;
}

.btn-settings {
  color: var(--pb-text-muted);
  border-color: var(--pb-border);
}
.btn-settings:hover {
  background-color: var(--pb-bg);
  color: var(--pb-primary);
  border-color: var(--pb-primary);
}

.btn-delete-row {
  color: var(--pb-danger);
  opacity: 0.8;
  font-size: 14px !important;
  font-weight: 600;
  padding: 6px 10px;
  border-radius: 4px;
}
.btn-delete-row:hover {
  opacity: 1;
  background-color: rgba(239, 68, 68, 0.1);
}

.btn-delete {
  color: var(--pb-danger);
  opacity: 0.8;
  font-size: 22px !important; 
  font-weight: bold;
  padding: 4px 10px;
  border-radius: 4px;
}
.btn-delete:hover {
  opacity: 1;
  background-color: rgba(239, 68, 68, 0.1);
}

.btn-align {
  color: var(--pb-text);
  border-color: var(--pb-border);
}
.btn-align:hover {
  border-color: var(--pb-text-muted);
}
.btn-align.active {
  background-color: var(--pb-primary);
  color: #fff;
  border-color: var(--pb-primary);
}

.btn-icon {
  color: var(--pb-text-muted);
  font-size: 18px !important;
  font-weight: bold;
  padding: 4px 10px;
  border-radius: 4px;
}
.btn-icon:hover:not(:disabled) {
  color: var(--pb-text);
  background-color: var(--pb-bg-alt);
}

.btn-action {
  color: var(--pb-primary);
}
.btn-action:hover {
  opacity: 0.8;
}

.flashcard-item-header {
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.98), rgba(241, 245, 249, 0.98));
  border: 1px solid rgba(148, 163, 184, 0.35);
  border-radius: 10px;
  padding: 6px;
}

.flashcard-item-badge {
  display: inline-flex;
  align-items: center;
  border-radius: 9999px;
  padding: 4px 8px;
  background: linear-gradient(135deg, #f8fafc, #e2e8f0);
  color: #0f172a;
  border: 1px solid #cbd5e1;
  box-shadow: 0 3px 8px rgba(15, 23, 42, 0.08);
}

.flashcard-item-header .btn-action {
  color: #0f172a;
  background: #ffffff;
  border-color: #cbd5e1;
}

.flashcard-item-header .btn-delete {
  color: #991b1b;
  background: rgba(254, 242, 242, 0.92);
  border-color: #fecaca;
}

.btn-clear-color {
  font-size: 12px;
  padding: 8px 12px;
  border: 1px solid var(--pb-border);
  border-radius: 6px;
  background: var(--pb-bg);
  color: var(--pb-text);
  transition: all 0.2s ease;
}
.btn-clear-color:hover {
  background: #fef2f2;
  color: var(--pb-danger);
  border-color: #fecaca;
}

.widget-menu-trigger, .btn-add-main {
  color: var(--pb-text-muted);
  border-color: var(--pb-border);
}
.widget-menu-trigger:hover, .btn-add-main:hover {
  color: var(--pb-primary);
  border-color: var(--pb-primary);
}

.btn-widget-option {
  color: var(--pb-text);
}
.btn-widget-option:hover {
  background-color: var(--pb-bg-alt);
}

.empty-state {
  border-color: var(--pb-border);
}
.btn-add {
  background-color: var(--pb-primary);
  color: #fff;
}
.btn-add:hover {
  opacity: 0.9;
}

.border-active {
  border-color: var(--pb-primary) !important;
}
.border-theme-color {
  border-color: var(--pb-border);
}
.border-theme-color:hover {
  border-color: var(--pb-text-muted);
}
</style>