<script setup lang="ts">
const props = defineProps<{
  modelValue: string
  fitMode?: 'cover' | 'contain' | 'fill' | 'none'
  cropPreset?: 'original' | 'square' | 'landscape' | 'portrait'
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const showLibrary = ref(false)
const uploading = ref(false)
const error = ref('')
const fitMode = ref(props.fitMode || 'cover')
const cropPreset = ref(props.cropPreset || 'original')

function getCropRatio(mode: string) {
  if (mode === 'square') return 1
  if (mode === 'landscape') return 16 / 9
  if (mode === 'portrait') return 4 / 3
  return null
}

function loadImage(file: File): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image()
    img.onload = () => resolve(img)
    img.onerror = () => reject(new Error('No se pudo leer la imagen'))
    img.src = URL.createObjectURL(file)
  })
}

async function createCroppedDataUrl(file: File) {
  const img = await loadImage(file)
  const ratio = getCropRatio(cropPreset.value)

  const canvas = document.createElement('canvas')
  const sourceWidth = img.naturalWidth
  const sourceHeight = img.naturalHeight

  let sx = 0
  let sy = 0
  let sw = sourceWidth
  let sh = sourceHeight

  if (ratio) {
    const sourceRatio = sourceWidth / sourceHeight
    if (sourceRatio > ratio) {
      sw = Math.floor(sourceHeight * ratio)
      sx = Math.floor((sourceWidth - sw) / 2)
    } else if (sourceRatio < ratio) {
      sh = Math.floor(sourceWidth / ratio)
      sy = Math.floor((sourceHeight - sh) / 2)
    }
  }

  const maxSide = 1600
  const scale = Math.min(1, maxSide / Math.max(sw, sh))
  canvas.width = Math.max(1, Math.round(sw * scale))
  canvas.height = Math.max(1, Math.round(sh * scale))

  const ctx = canvas.getContext('2d')
  if (!ctx) throw new Error('Tu navegador no soporta recorte de imagen')

  ctx.drawImage(img, sx, sy, sw, sh, 0, 0, canvas.width, canvas.height)
  return canvas.toDataURL('image/webp', 0.92)
}

async function upload(file: File) {
  error.value = ''
  uploading.value = true

  try {
    const croppedDataUrl = await createCroppedDataUrl(file)
    const blob = await fetch(croppedDataUrl).then((res) => res.blob())

    const client = useSupabaseClient()
    const path = `${Date.now()}-${Math.random().toString(36).slice(2)}.${blob.type.includes('png') ? 'png' : 'webp'}`

    try {
      const { error: uploadError } = await client.storage.from('images').upload(path, blob, {
        contentType: blob.type || 'image/webp',
        upsert: false,
      })

      if (uploadError) throw uploadError

      const { data: urlData } = client.storage.from('images').getPublicUrl(path)
      emit('update:modelValue', urlData.publicUrl)
    } catch (storageError: any) {
      emit('update:modelValue', croppedDataUrl)
      error.value = storageError?.message || 'La subida al almacenamiento falló; se usó una versión en memoria.'
    }
  } catch (e: any) {
    error.value = e?.message || 'Error al subir imagen'
  } finally {
    uploading.value = false
  }
}

function handleFile(e: Event) {
  const input = e.target as HTMLInputElement
  if (input.files?.[0]) upload(input.files[0])
}

function selectFromLibrary(url: string) {
  emit('update:modelValue', url)
  showLibrary.value = false
}

function remove() {
  emit('update:modelValue', '')
}
</script>

<template>
  <div class="image-uploader">
    <div v-if="modelValue" class="mb-2 relative group">
      <img :src="modelValue" class="max-h-40 rounded-lg border border-gray-200" :style="{ objectFit: fitMode }" />
      <button type="button" class="absolute top-1 right-1 bg-red-500 text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity" @click="remove">Eliminar</button>
    </div>

    <div class="flex flex-wrap items-center gap-2 mb-2">
      <label class="cursor-pointer inline-flex items-center gap-1 px-3 py-1.5 bg-gray-100 text-sm text-gray-700 rounded-lg hover:bg-gray-200 transition-colors border border-gray-300">
        <span class="text-base leading-none">📁</span> {{ uploading ? 'Subiendo...' : 'Subir' }}
        <input type="file" accept="image/*" class="hidden" @change="handleFile" :disabled="uploading" />
      </label>

      <button type="button" class="inline-flex items-center gap-1 px-3 py-1.5 bg-gray-100 text-sm text-gray-700 rounded-lg hover:bg-gray-200 transition-colors border border-gray-300" @click="showLibrary = true">
        <span class="text-base leading-none">🖼</span> Biblioteca
      </button>

      <input
        :value="modelValue"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        type="text"
        placeholder="URL"
        class="flex-1 min-w-[120px] text-sm border border-gray-300 rounded px-2 py-1.5"
      />
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-2 text-xs mb-2">
      <label class="flex flex-col gap-1">
        <span class="font-semibold text-gray-700">Ajuste</span>
        <select v-model="fitMode" class="border border-gray-300 rounded px-2 py-1.5 bg-white text-gray-700">
          <option value="cover">Cubrir</option>
          <option value="contain">Contener</option>
          <option value="fill">Rellenar</option>
          <option value="none">Original</option>
        </select>
      </label>

      <label class="flex flex-col gap-1">
        <span class="font-semibold text-gray-700">Recorte</span>
        <select v-model="cropPreset" class="border border-gray-300 rounded px-2 py-1.5 bg-white text-gray-700">
          <option value="original">Sin recorte</option>
          <option value="square">Cuadrado</option>
          <option value="landscape">16:9</option>
          <option value="portrait">4:3</option>
        </select>
      </label>
    </div>

    <p v-if="error" class="text-xs text-red-500 mt-1">{{ error }}</p>

    <MediaLibrary v-if="showLibrary" @select="selectFromLibrary" @close="showLibrary = false" />
  </div>
</template>
