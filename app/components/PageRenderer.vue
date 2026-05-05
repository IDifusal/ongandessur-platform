<script setup lang="ts">
defineProps<{
  sections: any[]
}>()
</script>

<template>
  <div>
    <template v-for="(section, i) in sections" :key="i">
      <!-- Hero Slider -->
      <HeroSlider v-if="section.type === 'hero'" :slides="section.slides || [section]" />

      <!-- Carousel -->
      <div v-if="section.type === 'carousel'" class="relative overflow-hidden h-[200px] md:h-[500px]">
        <div class="flex h-full">
          <img v-for="(src, j) in section.images" :key="j" :src="src" class="min-w-full h-full object-cover" alt="" />
        </div>
      </div>

      <!-- SVG Wave -->
      <svg v-if="section.type === 'wave'" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320" class="-mt-20 md:-mt-10" v-bind="section.props || {}">
        <path fill="#1fa185" fill-opacity="1" d="M0,256L48,240C96,224,192,192,288,176C384,160,480,160,576,186.7C672,213,768,267,864,261.3C960,256,1056,192,1152,160C1248,128,1344,128,1392,128L1440,128L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z" />
      </svg>

      <!-- Welcome text -->
      <div v-if="section.type === 'welcome'" class="max-w-5xl mx-auto px-4 text-center" :class="section.class || '-mt-16 md:-mt-8'">
        <h1 class="text-3xl md:text-5xl font-bold font-kadwa text-gray-800 py-3">{{ section.title }}</h1>
        <h2 class="text-base md:text-lg text-gray-600 py-3 px-3 leading-relaxed">{{ section.text }}</h2>
        <NuxtLink v-if="section.button" :to="section.button.link" class="inline-block mt-4 px-8 py-3 bg-brand-gold text-white font-semibold rounded-lg hover:bg-amber-700 transition-colors no-underline text-lg">
          {{ section.button.text }}
        </NuxtLink>
      </div>

      <!-- Cards Grid with hover -->
      <div v-if="section.type === 'cards_grid'" class="max-w-6xl mx-auto px-4 mt-16 grid grid-cols-1 md:grid-cols-3 gap-6">
        <div v-for="(card, ci) in section.cards" :key="ci" class="relative rounded-xl overflow-hidden shadow-lg min-h-[320px] group">
          <img :src="card.image" alt="" class="absolute inset-0 w-full h-full object-cover" />
          <div class="absolute inset-0 bg-brand-teal/85" />
          <div class="relative z-10 flex flex-col items-center justify-center h-full text-white p-6 text-center">
            <hr class="w-1/2 border-gray-300 mb-4" />
            <p class="text-xl md:text-2xl font-bold font-kadwa">{{ card.title }}</p>
            <h3 class="text-sm mt-1 font-kadwa">ANDES SUR</h3>
            <p class="mt-4 text-sm leading-relaxed px-2 opacity-0 group-hover:opacity-100 transition-opacity">{{ card.content }}</p>
          </div>
        </div>
      </div>

      <!-- Text + Image section -->
      <div v-if="section.type === 'text_image'" class="py-12 md:py-16" :style="section.style || ''">
        <div class="max-w-6xl mx-auto px-4 flex flex-col md:flex-row items-center gap-8" :class="section.reverse ? 'md:flex-row-reverse' : ''">
          <img v-if="section.image" :src="section.image" alt="" class="w-64 rounded-lg shadow-lg" :class="section.imageClass || ''" />
          <div class="text-center md:text-left">
            <h3 v-if="section.title" class="text-2xl md:text-3xl font-bold font-kadwa text-gray-800 my-4">{{ section.title }}</h3>
            <p v-if="section.text" class="text-gray-600 leading-relaxed mb-4">{{ section.text }}</p>
            <NuxtLink v-if="section.button" :to="section.button.link" class="inline-block px-8 py-3 bg-brand-gold text-white font-semibold rounded-lg hover:bg-amber-700 transition-colors no-underline">
              {{ section.button.text }}
            </NuxtLink>
          </div>
        </div>
      </div>

      <!-- Dynamic Products -->
      <div v-if="section.type === 'dynamic_products'">
        <DynamicProducts />
      </div>

      <!-- Dynamic Services -->
      <div v-if="section.type === 'dynamic_services'">
        <DynamicServices />
      </div>

      <!-- Dynamic News -->
      <div v-if="section.type === 'dynamic_news'">
        <DynamicNews />
      </div>

      <!-- Banner -->
      <div v-if="section.type === 'banner'" class="text-center py-8">
        <img :src="section.image" alt="" class="mx-auto rounded-lg max-w-full" />
      </div>

      <!-- CTA Banner -->
      <div v-if="section.type === 'cta_banner'" class="h-72 flex items-center justify-center bg-cover bg-center text-white" :style="section.backgroundStyle || ''">
        <h1 class="text-3xl md:text-4xl font-bold font-kadwa text-center px-4">{{ section.text }}</h1>
      </div>

      <!-- CTA with image -->
      <div v-if="section.type === 'cta_image'" class="relative py-16 mt-12" :style="section.backgroundStyle || ''">
        <div class="max-w-6xl mx-auto px-4 flex flex-col md:flex-row items-center justify-center gap-8">
          <div class="text-center">
            <h2 v-if="section.title" class="text-4xl md:text-5xl font-nanum text-gray-800 mb-4">{{ section.title }}</h2>
            <NuxtLink v-if="section.button" :to="section.button.link" class="inline-block px-8 py-3 bg-brand-blue text-white font-semibold rounded-full hover:bg-blue-600 transition-colors no-underline text-lg">
              {{ section.button.text }}
            </NuxtLink>
          </div>
          <img v-if="section.image" :src="section.image" alt="" class="w-48 md:w-64 scale-x-[-1] rounded-lg shadow-lg" />
        </div>
      </div>

      <!-- Mission / Vision -->
      <div v-if="section.type === 'mission_vision'" class="max-w-5xl mx-auto px-4 py-8">
        <div class="flex flex-wrap justify-center gap-6">
          <div v-for="(mv, mi) in section.items" :key="mi" class="w-full md:w-[calc(50%-12px)] bg-emerald-200/60 text-center p-6 rounded-xl shadow-md">
            <h3 class="text-2xl font-bold font-kadwa text-gray-800 mb-3">{{ mv.title }}</h3>
            <p class="text-gray-700 text-justify leading-relaxed">{{ mv.text }}</p>
          </div>
        </div>
      </div>

      <!-- Team Members -->
      <div v-if="section.type === 'team'" class="max-w-5xl mx-auto px-4 py-8">
        <h1 v-if="section.title" class="text-4xl md:text-5xl font-extrabold font-kadwa text-center text-gray-800 mb-4">{{ section.title }}</h1>
        <h3 v-if="section.subtitle" class="text-center text-gray-600 mb-8" v-html="section.subtitle" />
        <div class="flex flex-col gap-6">
          <div v-for="(member, mi) in section.members" :key="mi" class="bg-white rounded-3xl shadow-lg p-6 flex flex-col md:flex-row md:flex-row-reverse items-center gap-6">
            <div class="w-32 h-32 rounded-full bg-cover bg-center flex-shrink-0" :style="{ backgroundImage: `url(${member.image})` }" />
            <div class="text-center md:text-left">
              <h2 class="font-bold text-xl text-gray-800 mb-2">{{ member.name }}</h2>
              <p class="text-gray-600 leading-relaxed">{{ member.bio }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Project Cards -->
      <div v-if="section.type === 'project_cards'" class="max-w-6xl mx-auto px-4 py-8">
        <h1 v-if="section.title" class="text-3xl md:text-4xl font-bold font-kadwa text-center text-gray-800 mb-8">{{ section.title }}</h1>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div v-for="(proj, pi) in section.items" :key="pi" class="bg-white rounded-xl shadow-md p-6 flex flex-col items-center text-center">
            <div v-if="proj.image" class="w-20 h-20 rounded-lg bg-contain bg-center mb-4" :style="{ backgroundImage: `url(${proj.image})` }" />
            <h3 class="font-bold font-kadwa text-lg text-gray-800 mb-3">{{ proj.title }}</h3>
            <p class="text-sm text-gray-600 leading-relaxed text-justify">{{ proj.description }}</p>
          </div>
        </div>
      </div>

      <!-- Project Detail -->
      <div v-if="section.type === 'project_detail'" class="max-w-6xl mx-auto px-4 py-8">
        <div class="bg-white rounded-xl shadow-md p-8 flex flex-col md:flex-row gap-8 items-start">
          <div v-if="section.images?.length" class="flex gap-2 flex-shrink-0">
            <div class="flex flex-col gap-2">
              <img v-for="(img, ii) in section.images.slice(0, 2)" :key="ii" :src="img" class="w-32 rounded-lg" alt="" />
            </div>
            <div v-if="section.images.length > 2" class="flex flex-col gap-2">
              <img v-for="(img, ii) in section.images.slice(2)" :key="ii" :src="img" class="w-32 rounded-lg" alt="" />
            </div>
          </div>
          <div>
            <h3 class="text-2xl font-bold font-kadwa text-gray-800 text-center mb-4">{{ section.title }}</h3>
            <p class="text-gray-600 leading-relaxed text-justify">{{ section.description }}</p>
            <div v-if="section.button" class="mt-6 text-center">
              <button class="px-8 py-3 bg-brand-gold text-white font-semibold rounded-lg hover:bg-amber-700 transition-colors">{{ section.button.text }}</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Raw HTML -->
      <div v-if="section.type === 'raw_html'" class="max-w-6xl mx-auto px-4 py-8" v-html="section.html" />

      <!-- Cover -->
      <div v-if="section.type === 'cover'" class="h-20 md:h-64 bg-cover bg-center flex items-center justify-center" :style="{ backgroundImage: `url(${section.image})` }">
        <h2 class="text-5xl md:text-7xl font-bold font-kadwa text-white" :style="section.titleStyle || ''">{{ section.title }}</h2>
      </div>
    </template>
  </div>
</template>
