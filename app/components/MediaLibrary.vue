<script setup lang="ts">
const emit = defineEmits<{
  select: [url: string]
  close: []
}>()

const client = useSupabaseClient()
const images = ref<any[]>([])
const loading = ref(true)
const uploading = ref(false)

async function load() {
  loading.value = true
  const { data, error } = await client.storage.from('images').list()
  if (!error && data) {
    images.value = data.filter((f: any) => f.metadata?.mimetype?.startsWith('image/'))
  }
  loading.value = false
}

async function upload(file: File) {
  uploading.value = true
  const ext = file.name.split('.').pop()
  const path = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`
  const { error } = await client.storage.from('images').upload(path, file)
  if (!error) {
    const { data: urlData } = client.storage.from('images').getPublicUrl(path)
    images.value.unshift({ name: path, publicUrl: urlData.publicUrl })
  }
  uploading.value = false
}

function handleUpload(e: Event) {
  const input = e.target as HTMLInputElement
  if (input.files?.[0]) upload(input.files[0])
}

function selectImage(img: any) {
  const { data } = client.storage.from('images').getPublicUrl(img.name)
  emit('select', data.publicUrl)
}

onMounted(load)
</script>

<template>
  <div class="fixed inset-0 z-[200] flex items-center justify-center bg-black/50" @click.self="$emit('close')">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-3xl max-h-[80vh] flex flex-col m-4">
      <!-- Header -->
      <div class="flex items-center justify-between p-4 border-b border-gray-200">
        <h2 class="text-lg font-semibold text-gray-800">Biblioteca de imágenes</h2>
        <button class="text-gray-400 hover:text-gray-600 text-xl leading-none" @click="$emit('close')">&times;</button>
      </div>

      <!-- Upload bar -->
      <div class="p-4 border-b border-gray-100 bg-gray-50">
        <label class="inline-flex items-center gap-2 px-4 py-2 bg-brand-teal text-white text-sm font-semibold rounded-lg hover:bg-teal-700 cursor-pointer transition-colors">
          {{ uploading ? 'Subiendo...' : '+ Subir imagen' }}
          <input type="file" accept="image/*" class="hidden" @change="handleUpload" :disabled="uploading" />
        </label>
      </div>

      <!-- Grid -->
      <div class="flex-1 overflow-y-auto p-4">
        <div v-if="loading" class="text-center py-12 text-gray-400">Cargando...</div>

        <div v-else-if="!images.length" class="text-center py-12 text-gray-400">
          No hay imágenes. Sube una para comenzar.
        </div>

        <div v-else class="grid grid-cols-3 md:grid-cols-4 gap-3">
          <button
            v-for="img in images"
            :key="img.name"
            class="aspect-square rounded-lg overflow-hidden border-2 border-transparent hover:border-brand-teal transition-colors focus:outline-none focus:border-brand-teal cursor-pointer bg-gray-100"
            @click="selectImage(img)"
          >
            <img
              :src="client.storage.from('images').getPublicUrl(img.name).data.publicUrl"
              class="w-full h-full object-cover"
              alt=""
              loading="lazy"
            />
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
