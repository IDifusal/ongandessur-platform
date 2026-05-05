<script setup lang="ts">
import { useEditor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Link from '@tiptap/extension-link'
import Placeholder from '@tiptap/extension-placeholder'
import Image from '@tiptap/extension-image'

const props = defineProps<{
  modelValue: string
  placeholder?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const editor = useEditor({
  content: props.modelValue,
  extensions: [
    StarterKit.configure({
      heading: { levels: [2, 3] },
    }),
    Link.configure({ openOnClick: false }),
    Placeholder.configure({ placeholder: props.placeholder ?? 'Escribe aquí...' }),
    Image,
  ],
  onUpdate: ({ editor }) => {
    emit('update:modelValue', editor.getHTML())
  },
})

watch(
  () => props.modelValue,
  (val) => {
    if (editor.value && val !== editor.value.getHTML()) {
      editor.value.commands.setContent(val, false)
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

      <button type="button" @click="editor.chain().focus().toggleHeading({ level: 2 }).run()" :class="{ active: editor.isActive('heading', { level: 2 }) }" title="Título">H2</button>
      <button type="button" @click="editor.chain().focus().toggleHeading({ level: 3 }).run()" :class="{ active: editor.isActive('heading', { level: 3 }) }" title="Subtítulo">H3</button>

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
  border: 1px solid #8c8f94;
  border-radius: 4px;
  overflow: hidden;
}

.toolbar {
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 6px 8px;
  border-bottom: 1px solid #dcdcde;
  background: #f6f7f7;
  flex-wrap: wrap;
}

.toolbar button {
  padding: 4px 10px;
  background: none;
  border: 1px solid transparent;
  border-radius: 3px;
  font-size: 13px;
  cursor: pointer;
  color: #1d2327;
  line-height: 1.4;
}

.toolbar button:hover {
  background: #dcdcde;
}

.toolbar button.active {
  background: #2271b1;
  color: #fff;
}

.sep {
  width: 1px;
  height: 20px;
  background: #dcdcde;
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
}

.editor-content :deep(.ProseMirror p) {
  margin: 0 0 8px;
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

.editor-content :deep(.ProseMirror ul),
.editor-content :deep(.ProseMirror ol) {
  padding-left: 20px;
  margin: 0 0 8px;
}

.editor-content :deep(.ProseMirror blockquote) {
  border-left: 3px solid #2271b1;
  padding-left: 12px;
  color: #646970;
  margin: 0 0 8px;
}

.editor-content :deep(.ProseMirror a) {
  color: #2271b1;
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
  color: #a7aaad;
  pointer-events: none;
  height: 0;
}
</style>
