<script setup lang="ts">
const props = defineProps<{
  section: any
  index?: number
}>()

const emit = defineEmits<{
  update: [value: any]
  remove: []
}>()

const buttonTypes = ['hero', 'welcome', 'text_image', 'cta_image', 'cta_banner']

const initial = { ...props.section }
if (buttonTypes.includes(initial.type) && !initial.button) {
  initial.button = { text: '', link: '' }
}
if (initial.type === 'hero' && !initial.slides) {
  initial.slides = [{ image: initial.image || '', title: initial.title || '', subtitle: initial.subtitle || '', button: initial.button || { text: '', link: '' } }]
}
const local = ref(initial)

watch(local, (val) => {
  emit('update', val)
}, { deep: true })

watch(() => local.value.type, (type) => {
  if (buttonTypes.includes(type) && !local.value.button) {
    local.value.button = { text: '', link: '' }
  }
  if (type === 'hero' && !local.value.slides) {
    local.value.slides = [{ image: '', title: '', subtitle: '', button: { text: '', link: '' } }]
  }
})

const sectionTypes = [
  { value: 'hero', label: 'Hero (imagen + título)' },
  { value: 'carousel', label: 'Carrusel de imágenes' },
  { value: 'wave', label: 'Onda SVG decorativa' },
  { value: 'welcome', label: 'Texto de bienvenida' },
  { value: 'cards_grid', label: 'Cuadrícula de tarjetas' },
  { value: 'text_image', label: 'Texto + imagen' },
  { value: 'service_cards', label: 'Tarjetas de servicio' },
  { value: 'product_cards', label: 'Tarjetas de producto' },
  { value: 'project_cards', label: 'Tarjetas de proyecto' },
  { value: 'project_detail', label: 'Detalle de proyecto' },
  { value: 'banner', label: 'Banner de imagen' },
  { value: 'cta_banner', label: 'Banner CTA' },
  { value: 'cta_image', label: 'CTA con imagen' },
  { value: 'mission_vision', label: 'Misión y Visión' },
  { value: 'team', label: 'Equipo de trabajo' },
  { value: 'cover', label: 'Portada' },
  { value: 'raw_html', label: 'HTML personalizado' },
]

function addListItem(field: string) {
  if (!local.value[field]) local.value[field] = []
  local.value[field].push({})
}

function removeListItem(field: string, index: number) {
  local.value[field].splice(index, 1)
}

function addCard() {
  if (!local.value.cards) local.value.cards = []
  local.value.cards.push({ title: '', content: '', image: '' })
}

function addMember() {
  if (!local.value.members) local.value.members = []
  local.value.members.push({ name: '', bio: '', image: '' })
}

function addItem(field: string) {
  if (!local.value.items) local.value.items = []
  local.value.items.push({ title: '', description: '', image: '' })
}

function addImage(field: string) {
  if (!local.value[field]) local.value[field] = []
  local.value[field].push('')
}

function addSlide() {
  if (!local.value.slides) local.value.slides = []
  local.value.slides.push({ image: '', title: '', subtitle: '', button: { text: '', link: '' } })
}
</script>

<template>
  <div class="section-editor border rounded-lg p-4 mb-4 bg-white shadow-sm">
    <div class="flex items-center justify-between mb-3">
      <div class="flex items-center gap-2">
        <span class="text-xs text-gray-400 font-mono">#{{ index }}</span>
        <select v-model="local.type" class="text-sm border border-gray-300 rounded px-2 py-1">
          <option value="" disabled>Seleccionar tipo</option>
          <option v-for="t in sectionTypes" :key="t.value" :value="t.value">{{ t.label }}</option>
        </select>
      </div>
      <button class="text-red-500 text-xs hover:text-red-700" @click="$emit('remove')">Eliminar</button>
    </div>

    <template v-if="local.type">

      <!-- Field: text -->
      <div v-for="f in ['title', 'text', 'subtitle', 'description', 'content']" :key="f">
        <label v-if="local.type && $props.section[f] !== undefined || local[f]" class="text-xs font-semibold text-gray-600 block mt-2 mb-1">{{ f }}</label>
        <textarea v-if="local[f] !== undefined" v-model="local[f]" class="w-full text-sm border border-gray-300 rounded px-2 py-1" rows="2" />
      </div>

      <!-- Hero fields -->
      <div v-if="local.type === 'hero'" class="border border-brand-teal/30 rounded p-3 bg-teal-50/30">
        <p class="text-xs font-semibold text-brand-teal mb-2">Hero — slider de diapositivas</p>

        <div v-for="(slide, si) in local.slides" :key="si" class="border border-gray-200 rounded p-3 mb-3 bg-white">
          <div class="flex justify-between items-center mb-2">
            <span class="text-xs font-semibold text-gray-700">Diapositiva {{ si + 1 }}</span>
            <button class="text-red-500 text-xs hover:text-red-700" @click="local.slides.splice(si, 1)">× Eliminar</button>
          </div>
          <div class="field mb-2">
            <label class="text-xs text-gray-600 block mb-1">Imagen de fondo</label>
            <input v-model="slide.image" class="w-full text-sm border border-gray-300 rounded px-2 py-1" placeholder="https://..." />
          </div>
          <div class="field mb-2">
            <label class="text-xs text-gray-600 block mb-1">Título</label>
            <input v-model="slide.title" class="w-full text-sm border border-gray-300 rounded px-2 py-1" placeholder="Título principal" />
          </div>
          <div class="field mb-2">
            <label class="text-xs text-gray-600 block mb-1">Subtítulo</label>
            <input v-model="slide.subtitle" class="w-full text-sm border border-gray-300 rounded px-2 py-1" placeholder="Subtítulo opcional" />
          </div>
          <div class="grid grid-cols-2 gap-2">
            <div class="field">
              <label class="text-xs text-gray-600 block mb-1">Botón texto</label>
              <input v-model="slide.button.text" class="w-full text-sm border border-gray-300 rounded px-2 py-1" placeholder="Conoce más" />
            </div>
            <div class="field">
              <label class="text-xs text-gray-600 block mb-1">Botón enlace</label>
              <input v-model="slide.button.link" class="w-full text-sm border border-gray-300 rounded px-2 py-1" placeholder="/nosotros" />
            </div>
          </div>
        </div>

        <button class="text-xs text-blue-600 hover:text-blue-800 font-semibold" @click="addSlide">+ Añadir diapositiva</button>
      </div>

      <!-- Field: image (single) -->
      <div v-if="local.image !== undefined || local.type === 'banner' || local.type === 'cover'">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Imagen URL</label>
        <input v-model="local.image" class="w-full text-sm border border-gray-300 rounded px-2 py-1" placeholder="https://..." />
      </div>

      <!-- Field: images[] (carousel) -->
      <div v-if="local.type === 'carousel'">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Imágenes</label>
        <div v-for="(img, ii) in local.images" :key="ii" class="flex gap-2 mb-1">
          <input v-model="local.images[ii]" class="flex-1 text-sm border border-gray-300 rounded px-2 py-1" placeholder="https://..." />
          <button class="text-red-500 text-xs" @click="local.images.splice(ii, 1)">×</button>
        </div>
        <button class="text-xs text-blue-600 hover:text-blue-800" @click="addImage('images')">+ Añadir imagen</button>
      </div>

      <!-- Field: images[] (project_detail) -->
      <div v-if="local.type === 'project_detail'">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Descripción</label>
        <textarea v-model="local.description" class="w-full text-sm border border-gray-300 rounded px-2 py-1" rows="3" />
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Imágenes</label>
        <div v-for="(img, ii) in local.images" :key="ii" class="flex gap-2 mb-1">
          <input v-model="local.images[ii]" class="flex-1 text-sm border border-gray-300 rounded px-2 py-1" placeholder="https://..." />
          <button class="text-red-500 text-xs" @click="local.images.splice(ii, 1)">×</button>
        </div>
        <button class="text-xs text-blue-600 hover:text-blue-800" @click="addImage('images')">+ Añadir imagen</button>
      </div>

      <!-- Field: button -->
      <div v-if="local.button !== undefined || buttonTypes.includes(local.type)">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Botón texto</label>
        <input v-if="local.button" v-model="local.button.text" class="w-full text-sm border border-gray-300 rounded px-2 py-1" />
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Botón enlace</label>
        <input v-if="local.button" v-model="local.button.link" class="w-full text-sm border border-gray-300 rounded px-2 py-1" />
      </div>

      <!-- cards[] (cards_grid) -->
      <div v-if="local.type === 'cards_grid'">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-2">Tarjetas</label>
        <div v-for="(card, ci) in local.cards" :key="ci" class="border border-gray-200 rounded p-3 mb-2">
          <div class="flex justify-between mb-1">
            <span class="text-xs font-semibold">Tarjeta {{ ci + 1 }}</span>
            <button class="text-red-500 text-xs" @click="local.cards.splice(ci, 1)">×</button>
          </div>
          <input v-model="card.title" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Título" />
          <input v-model="card.image" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Imagen URL" />
          <textarea v-model="card.content" class="w-full text-sm border border-gray-300 rounded px-2 py-1" rows="2" placeholder="Contenido" />
        </div>
        <button class="text-xs text-blue-600 hover:text-blue-800" @click="addCard">+ Añadir tarjeta</button>
      </div>

      <!-- items[] (service_cards, product_cards, project_cards) -->
      <div v-if="['service_cards', 'product_cards', 'project_cards'].includes(local.type)">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-2">Items</label>
        <div v-for="(item, ii) in local.items" :key="ii" class="border border-gray-200 rounded p-3 mb-2">
          <div class="flex justify-between mb-1">
            <span class="text-xs font-semibold">Item {{ ii + 1 }}</span>
            <button class="text-red-500 text-xs" @click="local.items.splice(ii, 1)">×</button>
          </div>
          <input v-model="item.title" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Título" />
          <input v-model="item.image" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Imagen URL" />
          <textarea v-model="item.description" class="w-full text-sm border border-gray-300 rounded px-2 py-1" rows="2" placeholder="Descripción" />
        </div>
        <button class="text-xs text-blue-600 hover:text-blue-800" @click="addItem('items')">+ Añadir item</button>
        <label v-if="local.type === 'project_cards'" class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Subtítulo</label>
        <input v-if="local.type === 'project_cards'" v-model="local.subtitle" class="w-full text-sm border border-gray-300 rounded px-2 py-1" />
      </div>

      <!-- members[] (team) -->
      <div v-if="local.type === 'team'">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">Subtítulo</label>
        <input v-model="local.subtitle" class="w-full text-sm border border-gray-300 rounded px-2 py-1" />
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-2">Miembros</label>
        <div v-for="(member, mi) in local.members" :key="mi" class="border border-gray-200 rounded p-3 mb-2">
          <div class="flex justify-between mb-1">
            <span class="text-xs font-semibold">Miembro {{ mi + 1 }}</span>
            <button class="text-red-500 text-xs" @click="local.members.splice(mi, 1)">×</button>
          </div>
          <input v-model="member.name" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Nombre" />
          <input v-model="member.image" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Foto URL" />
          <textarea v-model="member.bio" class="w-full text-sm border border-gray-300 rounded px-2 py-1" rows="2" placeholder="Biografía" />
        </div>
        <button class="text-xs text-blue-600 hover:text-blue-800" @click="addMember">+ Añadir miembro</button>
      </div>

      <!-- items[] (mission_vision) -->
      <div v-if="local.type === 'mission_vision'">
        <div v-for="(mv, mi) in local.items" :key="mi" class="border border-gray-200 rounded p-3 mb-2">
          <div class="flex justify-between mb-1">
            <span class="text-xs font-semibold">{{ mv.title || 'Item ' + (mi + 1) }}</span>
            <button class="text-red-500 text-xs" @click="local.items.splice(mi, 1)">×</button>
          </div>
          <input v-model="mv.title" class="w-full text-sm border border-gray-300 rounded px-2 py-1 mb-1" placeholder="Título (Misión / Visión)" />
          <textarea v-model="mv.text" class="w-full text-sm border border-gray-300 rounded px-2 py-1" rows="2" placeholder="Texto" />
        </div>
        <button class="text-xs text-blue-600 hover:text-blue-800" @click="addListItem('items')">+ Añadir</button>
      </div>

      <!-- raw_html -->
      <div v-if="local.type === 'raw_html'">
        <label class="text-xs font-semibold text-gray-600 block mt-2 mb-1">HTML</label>
        <textarea v-model="local.html" class="w-full text-sm border border-gray-300 rounded px-2 py-1 font-mono" rows="6" placeholder="<p>HTML aquí</p>" />
      </div>

      <!-- style fields -->
      <div v-if="['text_image'].includes(local.type)">
        <label class="flex items-center gap-2 text-xs text-gray-600 mt-2">
          <input v-model="local.reverse" type="checkbox" class="rounded" />
          Invertir orden (imagen a la derecha)
        </label>
      </div>

    </template>

    <div v-else class="text-xs text-gray-400 text-center py-4">
      Selecciona un tipo de sección para configurarla
    </div>
  </div>
</template>
