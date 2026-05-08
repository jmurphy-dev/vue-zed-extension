; <script>
((script_element
  (start_tag
    (attribute
      (attribute_name) @_attr_name)*)
  (raw_text) @content)
  (#not-any-of? @_attr_name "lang")
  (#set! "language" "javascript"))

; <script lang="js">
; <script lang=js>
((script_element
  (start_tag
    (attribute
      (attribute_name) @_lang
      [
        (quoted_attribute_value
          (attribute_value) @_js)
        (attribute_value) @_js
      ]))
  (raw_text) @content)
  (#eq? @_lang "lang")
  (#any-of? @_js "js" "javascript" "mjs" "cjs")
  (#set! "language" "javascript"))

; <script lang="ts">
; <script lang=ts>
((script_element
  (start_tag
    (attribute
      (attribute_name) @_lang
      [
        (quoted_attribute_value
          (attribute_value) @_ts)
        (attribute_value) @_ts
      ]))
  (raw_text) @content)
  (#eq? @_lang "lang")
  (#any-of? @_ts "ts" "typescript" "mts" "cts")
  (#set! "language" "typescript"))

; <script lang="tsx">
; <script lang="jsx">
; <script lang=tsx>
; <script lang=jsx>
; Zed built-in tsx, we mark it as tsx ^:)
(script_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      [
        (quoted_attribute_value
          (attribute_value) @language)
        (attribute_value) @language
      ]))
  (#eq? @_attr "lang")
  (#any-of? @language "tsx" "jsx")
  (raw_text) @content)

; {{ }}
((interpolation
  (raw_text) @content)
  (#set! "language" "typescript"))

; :[dynamic], @[dynamic], #[dynamic]
((directive_dynamic_argument
  (directive_dynamic_argument_value) @content)
  (#set! "language" "typescript"))

; v-
(directive_attribute
  (quoted_attribute_value
    (attribute_value) @content
    (#set! "language" "typescript")))

; Vue <style lang="css"> injections
; Vue <style lang=css> injections
(style_element
  (start_tag
    (attribute
      (attribute_name) @_attr_name
      (#eq? @_attr_name "lang")
      [
        (quoted_attribute_value
          (attribute_value) @language)
        (attribute_value) @language
      ]))
  (raw_text) @content)

; Vue <style> css injections (no lang attribute)
(style_element
  (start_tag
    (attribute
      (attribute_name) @_attr_name)*)
  (raw_text) @content
  (#not-any-of? @_attr_name "lang")
  (#set! language "css"))

; <template lang="pug">
; <template lang=pug>
((template_element
  (start_tag
    (attribute
      (attribute_name) @_lang
      [
        (quoted_attribute_value
          (attribute_value) @_pug)
        (attribute_value) @_pug
      ]))
  (text) @content)
  (#eq? @_lang "lang")
  (#eq? @_pug "pug")
  (#set! language "pug"))

; <i18n lang="json">, <docs lang="md">, and other Vue custom blocks
(custom_block_element
  (start_tag
    (attribute
      (attribute_name) @_attr_name
      (#eq? @_attr_name "lang")
      [
        (quoted_attribute_value
          (attribute_value) @language)
        (attribute_value) @language
      ]))
  (raw_text) @content)

; <!-- -->
; Make comment as html
((comment) @content
  (#set! language "html"))
