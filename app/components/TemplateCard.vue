<script setup lang="ts">
const props = defineProps<{
  template: any
  data: Record<string, string>
}>()

function getContent(template: any) {
  if (!template) return null
  let content = template.content
  if (!content) return null
  if (typeof content === 'string') {
    try { content = JSON.parse(content) } catch { return null }
  }
  return content
}

const processedRows = computed(() => {
  const content = getContent(props.template)
  if (!content?.rows?.length) {
    console.log('[TemplateCard] No content/rows', { template: props.template, content })
    return []
  }

  try {
    const rawStr = JSON.stringify(content.rows)
    console.log('[TemplateCard] raw rows JSON (first 500 chars):', rawStr.slice(0, 500))
    const result = JSON.parse(rawStr, (_key, value) => {
      if (typeof value === 'string' && value.includes('{{')) {
        console.log('[TemplateCard] substituting:', value, 'data:', props.data)
        return value.replace(/\{\{(\w+)\}\}/g, (_, k: string) => {
          const replacement = props.data[k] !== undefined ? props.data[k] : `{{${k}}}`
          console.log('[TemplateCard]   var', k, '->', replacement)
          return replacement
        })
      }
      return value
    })
    console.log('[TemplateCard] processedRows:', result?.length, 'rows')
    result?.forEach((r: any, ri: number) => {
      r.columns?.forEach((c: any, ci: number) => {
        c.widgets?.forEach((w: any, wi: number) => {
          console.log(`[TemplateCard] R${ri}C${ci}W${wi}: type=${w.type}, content="${w.content}", text="${w.text}"`)
        })
      })
    })
    return result
  } catch (e) {
    console.error('[TemplateCard] Error processing rows:', e)
    return content.rows
  }
})
</script>

<template>
  <div v-if="processedRows.length" class="template-card">
    <div v-for="(row, ri) in processedRows" :key="ri" class="template-row">
      <div v-for="(col, ci) in row.columns" :key="ci" class="template-col">
        <div v-for="(widget, wi) in col.widgets" :key="wi">
          <component
            v-if="widget.type === 'title'"
            :is="widget.tag || 'h3'"
            class="font-bold"
            :style="{ color: widget.color || '', fontSize: widget.fontSize || '', fontStyle: widget.italic ? 'italic' : '' }"
            v-html="widget.content"
          />
          <div v-else-if="widget.type === 'text'" :style="{ textAlign: widget.textAlign || 'left' }" v-html="widget.content" />
          <a v-else-if="widget.type === 'image' && widget.link" :href="widget.link" target="_blank" rel="noopener">
            <img :src="widget.src" :alt="widget.alt || ''" class="rounded-lg max-w-full h-auto" />
          </a>
          <img v-else-if="widget.type === 'image'" :src="widget.src" :alt="widget.alt || ''" class="rounded-lg max-w-full h-auto" />
          <NuxtLink v-else-if="widget.type === 'button'" :to="widget.link || '#'" class="inline-block px-4 py-2 rounded-lg text-sm font-semibold no-underline" :class="widget.style === 'secondary' ? 'bg-brand-gold text-white' : 'bg-brand-teal text-white'">
            {{ widget.text }}
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>
