<script setup lang="ts">
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const showLibrary = ref(false)
const uploading = ref(false)
const error = ref('')

async function upload(file: File) {
  error.value = ''
  uploading.value = true
  try {
    const ext = file.name.split('.').pop()
    const path = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`
    const client = useSupabaseClient()
    const { error: uploadError } = await client.storage.from('images').upload(path, file)
    if (uploadError) throw uploadError
    const { data: urlData } = client.storage.from('images').getPublicUrl(path)
    emit('update:modelValue', urlData.publicUrl)
  } catch (e: any) {
    error.value = e.message || 'Error al subir imagen'
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
      <img :src="modelValue" class="max-h-40 rounded-lg border border-gray-200" />
      <button type="button" class="absolute top-1 right-1 bg-red-500 text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity" @click="remove">Eliminar</button>
    </div>

    <div class="flex flex-wrap items-center gap-2">
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

    <p v-if="error" class="text-xs text-red-500 mt-1">{{ error }}</p>

    <MediaLibrary v-if="showLibrary" @select="selectFromLibrary" @close="showLibrary = false" />
  </div>
</template>
