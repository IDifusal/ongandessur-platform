<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  widget: any
}>()

const SHADOW_MAP: Record<string, string> = {
  'shadow-none': 'none',
  'shadow-sm':   '0 1px 2px 0 rgb(0 0 0 / 0.05)',
  'shadow':      '0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)',
  'shadow-md':   '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
  'shadow-lg':   '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
  'shadow-xl':   '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
}

function normalizeCards() {
  if (Array.isArray(props.widget?.items) && props.widget.items.length) {
    return props.widget.items
  }
  return [
    {
      icon: '✨',
      title: 'Título de la tarjeta',
      content: '<p>Descripción de la tarjeta...</p>',
      image: '',
      imagePosition: 'top',
      imageHeight: '200px',
      imageWidth: '40%',
      imageObjectFit: 'cover',
      imageShape: 'square',
      imageAlign: 'center',
    },
  ]
}

const cards = computed(() => normalizeCards())

const cardsPerRow = computed(() => {
  const value = Number(props.widget?.cardsPerRow || props.widget?.itemsPerRow || 3)
  return Math.min(6, Math.max(1, Number.isFinite(value) ? value : 3))
})

const gridClass = computed(() => {
  const cols = cardsPerRow.value
  if (cols === 1) return 'grid-cols-1'
  if (cols === 2) return 'grid-cols-1 md:grid-cols-2'
  if (cols === 3) return 'grid-cols-1 md:grid-cols-3'
  if (cols === 4) return 'grid-cols-1 md:grid-cols-2 lg:grid-cols-4'
  if (cols === 5) return 'grid-cols-1 md:grid-cols-3 lg:grid-cols-5'
  if (cols === 6) return 'grid-cols-1 md:grid-cols-3 lg:grid-cols-6'
  return 'grid-cols-1 md:grid-cols-3'
})

function sanitizeRichHtml(value: string) {
  return String(value || '')
    .replace(/<img\b[^>]*src=(['"])(?:\s*\1|[^'">]+)?[^>]*>/gi, '')
    .replace(/<img\b[^>]*src=(['"])undefined\1[^>]*>/gi, '')
    .replace(/<img\b[^>]*src=(['"])\s*\1[^>]*>/gi, '')
}

function cardStyle(item: any) {
  const w = props.widget || {}
  const shadowValue = (item?.shadow || w.shadow || 'shadow-md') === 'shadow-none'
    ? 'none'
    : (item?.shadow && SHADOW_MAP[item.shadow]) || (w.shadow && SHADOW_MAP[w.shadow]) || '0px 0px 15px rgba(0,0,0,0.2)'

  return {
    backgroundColor: item?.bgColor || w.bgColor || '#ffffff',
    color: item?.textColor || w.textColor || '#1e293b',
    borderWidth: `${Number(item?.borderWidth ?? w.borderWidth ?? 1)}px`,
    borderStyle: item?.borderStyle || w.borderStyle || 'solid',
    borderColor: item?.borderColor || w.borderColor || '#e2e8f0',
    borderRadius: `${Number(item?.borderRadius ?? w.borderRadius ?? 12)}px`,
    boxShadow: shadowValue,
    width: item?.width || w.width || '100%',
    minHeight: (item?.height || w.height) && (item?.height || w.height) !== 'auto' ? (item?.height || w.height) : 'min-content',
    height: (item?.height || w.height) && (item?.height || w.height) !== 'auto' ? (item?.height || w.height) : 'auto',
    overflow: 'hidden',
  }
}

function articleFlexClass(item: any): string {
  const pos = item.imagePosition || 'top'
  if (item.image && (pos === 'left' || pos === 'right')) return 'flex-row'
  return 'flex-col'
}

function imageContainerStyle(item: any) {
  const isCircle = item.imageShape === 'circle'
  const base: Record<string, any> = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: item.imageAlign || 'center',
    overflow: 'hidden',
    borderRadius: isCircle ? '9999px' : 'inherit',
    margin: isCircle ? '0 auto' : undefined,
  }

  if (isCircle) {
    base.width = '100%'
    base.maxWidth = item.imageHeight || '180px'
    base.minHeight = item.imageHeight || '180px'
    base.aspectRatio = '1 / 1'
    base.height = item.imageHeight || '180px'
  } else {
    base.height = item.imageHeight || '200px'
  }

  if (item.imagePosition === 'left' || item.imagePosition === 'right') {
    base.width = isCircle ? '100%' : (item.imageWidth || '40%')
    base.height = isCircle ? 'auto' : '100%'
    base.maxWidth = isCircle ? (item.imageHeight || '180px') : undefined
  }

  return base
}

function imageStyle(item: any) {
  const isCircle = item.imageShape === 'circle'
  return {
    width: '100%',
    height: '100%',
    objectFit: item.imageObjectFit || 'cover',
    objectPosition: 'center',
    borderRadius: isCircle ? '9999px' : 'inherit',
    aspectRatio: isCircle ? '1 / 1' : undefined,
    clipPath: isCircle ? 'circle(50%)' : undefined,
    WebkitClipPath: isCircle ? 'circle(50%)' : undefined,
    display: 'block',
  }
}

function centerImageStyle(item: any) {
  const isCircle = item.imageShape === 'circle'
  return {
    maxHeight: item.imageHeight || '160px',
    maxWidth: item.imageWidth || '100%',
    objectFit: item.imageObjectFit || 'contain',
    objectPosition: 'center',
    borderRadius: isCircle ? '9999px' : `${Number(props.widget?.borderRadius ?? 12)}px`,
    aspectRatio: isCircle ? '1 / 1' : undefined,
    clipPath: isCircle ? 'circle(50%)' : undefined,
    WebkitClipPath: isCircle ? 'circle(50%)' : undefined,
    display: 'block',
  }
}
</script>

<template>
  <section class="flashcard-widget w-full">
    <div class="grid gap-6" :class="gridClass">
      <article
        v-for="(item, index) in cards"
        :key="`${item.title || 'card'}-${index}`"
        class="flashcard-card flex transition-all duration-200"
        :class="articleFlexClass(item)"
        :style="cardStyle(item)"
      >
        <div
          v-if="item.image && (item.imagePosition === 'top' || !item.imagePosition)"
          class="w-full flex-shrink-0"
          :style="imageContainerStyle(item)"
        >
          <img :src="item.image" :alt="item.title" class="w-full h-full block" :style="imageStyle(item)" />
        </div>

        <div
          v-if="item.image && item.imagePosition === 'left'"
          class="flex-shrink-0 self-stretch"
          :style="imageContainerStyle(item)"
        >
          <img :src="item.image" :alt="item.title" class="w-full h-full block" :style="imageStyle(item)" />
        </div>

        <div
          class="flex flex-col p-6 md:p-8"
          :class="item.image && ['left', 'right'].includes(item.imagePosition) ? 'flex-1 min-w-0' : 'w-full'"
        >
          <div v-if="item.image && item.imagePosition === 'center'" class="flex justify-center mb-4">
            <img :src="item.image" :alt="item.title" :style="centerImageStyle(item)" />
          </div>

          <div
            v-if="(item.icon && item.icon.trim() !== '') || (item.title && item.title.trim() !== '')"
            class="flex items-center gap-3 mb-4 w-full"
            :style="{ justifyContent: item.titleAlign === 'center' ? 'center' : (item.titleAlign === 'right' ? 'flex-end' : 'flex-start') }"
          >
            <span v-if="item.icon && item.icon.trim() !== ''" class="text-3xl leading-none flex-shrink-0">{{ item.icon }}</span>

            <h3
              v-if="item.title && item.title.trim() !== ''"
              class="m-0 font-bold leading-tight w-full"
              :class="item.titleSize || 'text-2xl'"
              :style="{
                color: item.titleColor || item.textColor || props.widget?.titleColor || props.widget?.textColor || '#2563eb',
                textAlign: item.titleAlign || 'left'
              }"
            >
              {{ item.title }}
            </h3>
          </div>

          <div
            class="texto-enriquecido text-sm md:text-base leading-relaxed"
            v-html="sanitizeRichHtml(item.content || '')"
          />
        </div>

        <div
          v-if="item.image && item.imagePosition === 'right'"
          class="flex-shrink-0 self-stretch"
          :style="imageContainerStyle(item)"
        >
          <img :src="item.image" :alt="item.title" class="w-full h-full block" :style="imageStyle(item)" />
        </div>

        <div
          v-if="item.image && item.imagePosition === 'bottom'"
          class="w-full flex-shrink-0"
          :style="imageContainerStyle(item)"
        >
          <img :src="item.image" :alt="item.title" class="w-full h-full block" :style="imageStyle(item)" />
        </div>
      </article>
    </div>
  </section>
</template>