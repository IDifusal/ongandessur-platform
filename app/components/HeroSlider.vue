<script setup lang="ts">
const props = defineProps<{
  slides: any[]
}>()

const current = ref(0)
let timer: any = null

function next() {
  current.value = (current.value + 1) % props.slides.length
  resetTimer()
}

function prev() {
  current.value = (current.value - 1 + props.slides.length) % props.slides.length
  resetTimer()
}

function goTo(i: number) {
  current.value = i
  resetTimer()
}

function resetTimer() {
  if (timer) clearInterval(timer)
  if (props.slides.length > 1) {
    timer = setInterval(next, 6000)
  }
}

onMounted(() => resetTimer())
onUnmounted(() => { if (timer) clearInterval(timer) })
</script>

<template>
  <div class="relative w-full h-[60vh] min-h-[400px] max-h-[700px] overflow-hidden">
    <!-- Backgrounds with Ken Burns -->
    <div v-for="(slide, i) in slides" :key="i" class="absolute inset-0 transition-opacity duration-700" :class="i === current ? 'opacity-100' : 'opacity-0'">
      <div class="absolute inset-0 bg-cover bg-center ken-burns" :style="{ backgroundImage: `url(${slide.image})` }" :class="i % 2 === 0 ? 'ken-zoom-in' : 'ken-zoom-out'" />
      <div class="absolute inset-0 bg-black/40" />
    </div>

    <!-- Prev Arrow -->
    <button v-if="slides.length > 1" class="absolute left-4 top-1/2 -translate-y-1/2 z-20 w-10 h-10 md:w-12 md:h-12 rounded-full bg-white/20 hover:bg-white/40 backdrop-blur-sm text-white text-xl md:text-2xl flex items-center justify-center transition-all border border-white/30" @click="prev" aria-label="Anterior">
      &#10094;
    </button>

    <!-- Next Arrow -->
    <button v-if="slides.length > 1" class="absolute right-4 top-1/2 -translate-y-1/2 z-20 w-10 h-10 md:w-12 md:h-12 rounded-full bg-white/20 hover:bg-white/40 backdrop-blur-sm text-white text-xl md:text-2xl flex items-center justify-center transition-all border border-white/30" @click="next" aria-label="Siguiente">
      &#10095;
    </button>

    <!-- Content -->
    <div class="relative z-10 h-full flex items-center justify-center text-center px-16 max-w-5xl mx-auto">
      <div v-for="(slide, i) in slides" :key="'c-'+i" class="absolute inset-0 flex items-center justify-center px-4 transition-opacity duration-700" :class="i === current ? 'opacity-100' : 'opacity-0'">
        <div>
          <h1 class="text-3xl md:text-6xl font-bold font-kadwa text-white mb-3" :style="slide.titleStyle || 'text-shadow: 2px 2px 8px rgba(0,0,0,0.6);'">{{ slide.title }}</h1>
          <p v-if="slide.subtitle" class="text-base md:text-xl text-white/90 mb-6 max-w-2xl mx-auto">{{ slide.subtitle }}</p>
          <NuxtLink v-if="slide.button?.link" :to="slide.button.link" class="inline-block px-8 py-3 bg-brand-teal text-white font-semibold rounded-lg hover:bg-teal-700 transition-colors no-underline text-lg">
            {{ slide.button.text || 'Conoce más' }}
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- Dots -->
    <div v-if="slides.length > 1" class="absolute bottom-4 left-0 right-0 z-20 flex justify-center gap-2">
      <button v-for="(_, i) in slides" :key="'d-'+i" class="w-3 h-3 rounded-full transition-all duration-300" :class="i === current ? 'bg-white scale-125' : 'bg-white/40 hover:bg-white/70'" @click="goTo(i)" />
    </div>
  </div>
</template>

<style scoped>
.ken-burns {
  animation-duration: 12s;
  animation-fill-mode: forwards;
  animation-timing-function: ease-in-out;
  animation-iteration-count: infinite;
}

.ken-zoom-in {
  animation-name: kenZoomIn;
}

.ken-zoom-out {
  animation-name: kenZoomOut;
}

@keyframes kenZoomIn {
  0%   { transform: scale(1); }
  100% { transform: scale(1.12); }
}

@keyframes kenZoomOut {
  0%   { transform: scale(1.12); }
  100% { transform: scale(1); }
}
</style>
