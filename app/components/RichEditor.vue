<script setup lang="ts">
import { ref } from 'vue'
import { useEditor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Link from '@tiptap/extension-link'
import Placeholder from '@tiptap/extension-placeholder'
import Image from '@tiptap/extension-image'
import TextAlign from '@tiptap/extension-text-align'
import { TextStyle, Color, LineHeight, FontSize } from '@tiptap/extension-text-style'

const props = defineProps<{
  modelValue: string
  placeholder?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const lineHeightOptions = ['1', '1.25', '1.5', '1.75', '2']
const customLineHeight = ref('1.5')
const fontSizeValue = ref('16')
const pendingFontSizeSelection = ref<{ from: number; to: number } | null>(null)
const colorPalette = ['#111827', '#1F2937', '#2563EB', '#0EA5E9', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#EC4899', '#F8FAFC']
const customColor = ref('#1d2327')

const editor = useEditor({
  content: props.modelValue,
  extensions: [
    StarterKit.configure({
      heading: { levels: [1, 2, 3] },
    }),
    Link.configure({ openOnClick: false }),
    Placeholder.configure({ placeholder: props.placeholder ?? 'Escribe aquí...' }),
    Image,
    TextAlign.configure({ types: ['heading', 'paragraph'] }),
    TextStyle,
    Color,
    FontSize.configure({ types: ['textStyle'] }),
    LineHeight.configure({ types: ['textStyle'] }),
  ],
  onUpdate: ({ editor }) => {
    emit('update:modelValue', editor.getHTML())
  },
})

watch(
  () => props.modelValue,
  (val) => {
    if (editor.value && val !== editor.value.getHTML()) {
      editor.value.commands.setContent(val, { emitUpdate: false })
    }
  },
)

function setLink() {
  const url = window.prompt('URL:')
  if (url) {
    editor.value?.chain().focus().setLink({ href: url }).run()
  }
}

function addImage() {
  const url = window.prompt('URL de la imagen:')
  if (url) {
    editor.value?.chain().focus().setImage({ src: url }).run()
  }
}

function applyColor(color: string) {
  const normalized = color?.trim()
  if (!normalized) return

  customColor.value = normalized
  editor.value?.chain().focus().setColor(normalized).run()
}

function applyLineHeight(value: string) {
  const normalized = value.trim().replace(',', '.')
  if (!normalized || Number.isNaN(Number(normalized))) return

  customLineHeight.value = normalized

  const nodeType = editor.value?.state.selection.$from.parent.type.name
  if (nodeType === 'paragraph' || nodeType === 'heading') {
    editor.value?.chain().focus().updateAttributes(nodeType, { lineHeight: normalized }).run()
    return
  }

  editor.value?.chain().focus().setLineHeight(normalized).run()
}

function applyPresetLineHeight(value: string) {
  customLineHeight.value = value
  applyLineHeight(value)
}

function saveFontSizeSelection() {
  const selection = editor.value?.state.selection
  if (!selection) return

  pendingFontSizeSelection.value = {
    from: selection.from,
    to: selection.to,
  }
}

function applyFontSize(value: string | number) {
  const normalized = String(value ?? '').trim()
  const size = Number(normalized)

  if (!Number.isFinite(size) || size < 1 || size > 200) return

  fontSizeValue.value = String(Math.round(size))

  const selection = pendingFontSizeSelection.value
  const chain = editor.value?.chain().focus()

  if (selection && chain) {
    chain.setTextSelection(selection).setFontSize(`${Math.round(size)}px`).run()
    return
  }

  chain?.setFontSize(`${Math.round(size)}px`).run()
}

onBeforeUnmount(() => {
  editor.value?.destroy()
})
</script>

<template>
  <div class="rich-editor" v-if="editor">
    <div class="toolbar">
      <button type="button" @click="editor.chain().focus().toggleBold().run()" :class="{ active: editor.isActive('bold') }" title="Negrita"><strong>B</strong></button>
      <button type="button" @click="editor.chain().focus().toggleItalic().run()" :class="{ active: editor.isActive('italic') }" title="Itálica"><em>I</em></button>
      <button type="button" @click="editor.chain().focus().toggleStrike().run()" :class="{ active: editor.isActive('strike') }" title="Tachado"><s>S</s></button>

      <span class="sep" />

      <button type="button" @click="editor.chain().focus().setParagraph().run()" :class="{ active: editor.isActive('paragraph') }" title="Párrafo">P</button>
      <button type="button" @click="editor.chain().focus().toggleHeading({ level: 1 }).run()" :class="{ active: editor.isActive('heading', { level: 1 }) }" title="Título grande">H1</button>
      <button type="button" @click="editor.chain().focus().toggleHeading({ level: 2 }).run()" :class="{ active: editor.isActive('heading', { level: 2 }) }" title="Título">H2</button>
      <button type="button" @click="editor.chain().focus().toggleHeading({ level: 3 }).run()" :class="{ active: editor.isActive('heading', { level: 3 }) }" title="Subtítulo">H3</button>

      <span class="sep" />

      <button type="button" @click="editor.chain().focus().setTextAlign('left').run()" :class="{ active: editor.isActive({ textAlign: 'left' }) }" title="Izquierda">⬅</button>
      <button type="button" @click="editor.chain().focus().setTextAlign('center').run()" :class="{ active: editor.isActive({ textAlign: 'center' }) }" title="Centro">⬌</button>
      <button type="button" @click="editor.chain().focus().setTextAlign('right').run()" :class="{ active: editor.isActive({ textAlign: 'right' }) }" title="Derecha">➡</button>
      <button type="button" @click="editor.chain().focus().setTextAlign('justify').run()" :class="{ active: editor.isActive({ textAlign: 'justify' }) }" title="Justificar">◫</button>

      <span class="sep" />

      <div class="color-control" title="Color de texto">
        <span class="color-label">🎨</span>
        <button v-for="color in colorPalette" :key="color" type="button" class="color-swatch" :style="{ backgroundColor: color }" :title="color" @click="applyColor(color)" />
        <input type="color" class="color-input" :value="customColor" @input="(e) => applyColor((e.target as HTMLInputElement).value)" />
        <input type="text" class="color-text-input" v-model="customColor" @change="(e) => applyColor((e.target as HTMLInputElement).value)" placeholder="#1d2327" />
      </div>

      <span class="sep" />

      <div class="font-size-control" title="Tamaño de fuente">
        <label class="font-size-label" for="font-size-input">A</label>
        <input
          id="font-size-input"
          type="number"
          min="1"
          max="200"
          step="1"
          class="font-size-input"
          v-model="fontSizeValue"
          @mousedown="saveFontSizeSelection"
          @focus="saveFontSizeSelection"
          @keydown.enter.prevent="applyFontSize(fontSizeValue)"
          @change="(e) => applyFontSize((e.target as HTMLInputElement).value)"
          placeholder="16"
        />
      </div>

      <span class="sep" />

      <div class="line-height-control" title="Interlineado">
        <label class="line-height-label" for="line-height-select">↕</label>
        <select id="line-height-select" class="line-height-select" :value="customLineHeight" @change="(e) => applyPresetLineHeight((e.target as HTMLSelectElement).value)">
          <option v-for="value in lineHeightOptions" :key="value" :value="value">{{ value }}</option>
        </select>
        <input
          type="number"
          min="0.8"
          max="4"
          step="0.1"
          class="line-height-input"
          v-model="customLineHeight"
          @change="(e) => applyLineHeight((e.target as HTMLInputElement).value)"
          placeholder="1.5"
        />
      </div>

      <span class="sep" />

      <button type="button" @click="editor.chain().focus().toggleBulletList().run()" :class="{ active: editor.isActive('bulletList') }" title="Lista">•</button>
      <button type="button" @click="editor.chain().focus().toggleOrderedList().run()" :class="{ active: editor.isActive('orderedList') }" title="Lista numerada">1.</button>
      <button type="button" @click="editor.chain().focus().toggleBlockquote().run()" :class="{ active: editor.isActive('blockquote') }" title="Cita">"</button>

      <span class="sep" />

      <button type="button" @click="setLink" :class="{ active: editor.isActive('link') }" title="Enlace">🔗</button>
      <button type="button" @click="addImage" title="Imagen">🖼</button>

      <span class="sep" />

      <button type="button" @click="editor.chain().focus().undo().run()" title="Deshacer">↩</button>
      <button type="button" @click="editor.chain().focus().redo().run()" title="Rehacer">↪</button>
    </div>

    <EditorContent :editor="editor" class="editor-content" />
  </div>
</template>

<style scoped>
.rich-editor {
  border: 1px solid var(--pb-border, #e2e8f0);
  border-radius: 6px;
  overflow: hidden;
  background: var(--pb-bg, #ffffff);
}

.toolbar {
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 6px 8px;
  border-bottom: 1px solid var(--pb-border, #e2e8f0);
  background: var(--pb-bg-alt, #f8fafc);
  flex-wrap: wrap;
}

.color-control,
.font-size-control,
.line-height-control {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 2px 4px;
  border: 1px solid transparent;
  border-radius: 4px;
}

.color-label {
  font-size: 12px;
  color: var(--pb-text-muted, #64748b);
}

.color-swatch {
  width: 16px;
  height: 16px;
  border-radius: 999px;
  border: 1px solid var(--pb-border, #e2e8f0);
  cursor: pointer;
}

.color-input {
  width: 28px;
  height: 22px;
  border: 1px solid var(--pb-border, #e2e8f0);
  border-radius: 4px;
  background: transparent;
  padding: 0;
  cursor: pointer;
}

.color-text-input {
  width: 78px;
  border: 1px solid var(--pb-border, #e2e8f0);
  border-radius: 4px;
  background: var(--pb-bg, #ffffff);
  color: var(--pb-text, #1e293b);
  font-size: 12px;
  padding: 4px 6px;
  min-height: 26px;
}

.font-size-label,
.line-height-label {
  font-size: 12px;
  color: var(--pb-text-muted, #64748b);
}

.font-size-input,
.line-height-select,
.line-height-input {
  border: 1px solid var(--pb-border, #e2e8f0);
  border-radius: 4px;
  background: var(--pb-bg, #ffffff);
  color: var(--pb-text, #1e293b);
  font-size: 12px;
  padding: 4px 6px;
  min-height: 26px;
}

.font-size-input {
  width: 58px;
}

.line-height-input {
  width: 62px;
}

.toolbar button {
  padding: 4px 10px;
  background: none;
  border: 1px solid transparent;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
  color: var(--pb-text, #1e293b);
  line-height: 1.4;
  transition: all 0.2s ease;
}

.toolbar button:hover {
  background: var(--pb-bg, #ffffff);
}

.toolbar button.active {
  background: var(--pb-primary, #3b82f6);
  color: #ffffff;
}

.sep {
  width: 1px;
  height: 20px;
  background: var(--pb-border, #e2e8f0);
  margin: 0 4px;
}

.editor-content {
  padding: 12px 14px;
  min-height: 200px;
}

.editor-content :deep(.ProseMirror) {
  outline: none;
  min-height: 180px;
  font-size: 14px;
  line-height: 1.7;
  color: var(--pb-text, #1e293b);
  /* MAGIA: Respeta espacios múltiples y saltos de línea */
  white-space: pre-wrap; 
  word-wrap: break-word;
}

.editor-content :deep(.ProseMirror p) {
  margin: 0 0 8px;
  /* MAGIA: Le da altura a los "Enters" vacíos para que no desaparezcan */
  min-height: 1.5rem; 
}

.editor-content :deep(.ProseMirror h2) {
  font-size: 20px;
  font-weight: 600;
  margin: 16px 0 8px;
}

.editor-content :deep(.ProseMirror h3) {
  font-size: 16px;
  font-weight: 600;
  margin: 12px 0 6px;
}

.editor-content :deep(.ProseMirror ul) {
  display: block !important;
  padding-left: 24px !important;
  margin: 0 0 8px !important;
  list-style: disc outside !important;
  list-style-type: disc !important;
  list-style-position: outside !important;
}

.editor-content :deep(.ProseMirror ol) {
  display: block !important;
  padding-left: 24px !important;
  margin: 0 0 8px !important;
  list-style: decimal outside !important;
  list-style-type: decimal !important;
  list-style-position: outside !important;
}

.editor-content :deep(.ProseMirror li) {
  display: list-item !important;
}

.editor-content :deep(.ProseMirror blockquote) {
  border-left: 3px solid var(--pb-primary, #3b82f6);
  padding-left: 12px;
  color: var(--pb-text-muted, #64748b);
  margin: 0 0 8px;
}

.editor-content :deep(.ProseMirror a) {
  color: var(--pb-primary, #3b82f6);
  text-decoration: underline;
}

.editor-content :deep(.ProseMirror img) {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
  margin: 8px 0;
}

.editor-content :deep(.ProseMirror p.is-editor-empty:first-child::before) {
  content: attr(data-placeholder);
  float: left;
  color: var(--pb-text-muted, #94a3b8);
  pointer-events: none;
  height: 0;
}
</style>