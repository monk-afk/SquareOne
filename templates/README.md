# MARKDOWN TO HTML WITH LUAMARK

___

| Contents |
|:---------|
| [Install](#install) |
| [File Structure](#file-structure) |
| [Markdown Injection](#markdown-injection) |
| [Convert](#convert) |
| [Lunamark Attribution](#lunamark) |
| [Writer dot lua Parameters](#writer-dot-lua-parameters) |
| [Writer Quick Reference](#writer-quick-reference) |
| [Known Issues](#known-issues) |

___

## Install

A couple things had to be done to get this up and running properly.

  1. Could only get it running with Lua 5.4
    - Uninstall Lua 5.3, 5.2, 5.1, and LuaJIT
    - Apt install lua-lpeg, lua-lpeg-dev, lua-lpeg-patters

  2. Get Cosmo: https://github.com/mascarenhas/cosmo
    - add it to the lunamark root:

```
lunamark-0.6.0-1/
  ├ bin/
  ├ LICENSE
  ├ lunamark.lua
  ├─> lunamark/
  │     ├─> cosmo.lua
  │     ├─> cosmo/
  │     ├ entities.lua
  │     ├ reader.lua
  │     ├ reader/
  │     ├ util.lua
  │     ├ writer.lua
  │     └ writer/
  ├ standalone/
  ├ tests/
  └ templates/
```

  3. Patch `lunamark-0.6.0-1/lunamark/entities.lua`

```diff
@@ -5,22 +5,8 @@
 
 local M = {}
 
-local utf8_char do
-  if utf8 then
-    utf8_char = utf8.char
-  elseif pcall(require, "compat53.module") then
-    local utf8 = require "compat53.module".utf8
-    utf8_char = utf8.char
-  elseif pcall(require, "lua-utf8") then -- try luautf8
-    local luautf8 = require("lua-utf8")
-    utf8_char = luautf8.char
-  elseif pcall(require, "unicode") then -- try slnunicode
-    local slnunicode = require "unicode"
-    utf8_char = slnunicode.utf8.char
-  else
-    error "no unicode library found"
-  end
-end
+local utf8 = utf8 or require("lua-utf8")
+utf8_char = utf8.char

 local character_entities = {
   ["Tab"] = 9,
```

  4. Patch `lunamark-0.6.0.1-1/lunamark/reader/markdown.lua`

```diff
@@ -11,16 +11,16 @@ local P, R, S, V, C, Cg, Cb, Cmt, Cc, Ct, B, Cs, Cf =
   lpeg.Cmt, lpeg.Cc, lpeg.Ct, lpeg.B, lpeg.Cs, lpeg.Cf
 local lpegmatch = lpeg.match
 local expand_tabs_in_line = util.expand_tabs_in_line
-local utf8_lower do
-  if pcall(require, "lua-utf8") then -- try luautf8
-    local luautf8 = require("lua-utf8")
-    utf8_lower = luautf8.lower
-  elseif pcall(require, "unicode") then -- try slnunicode
-    local slnunicde = require "unicode"
-    utf8_lower = slnunicde.utf8.lower
-  else
-    error "no unicode library found"
-  end
+
+local utf8_lower
+if utf8 and utf8.lower then
+  utf8_lower = utf8.lower
+elseif pcall(require, "lua-utf8") then
+  local luautf8 = require("lua-utf8")
+  utf8_lower = luautf8.lower
+else
+  -- string.lower only works for ASCII
+  utf8_lower = function(s) return string.lower(s) end
 end
 
 local load = load -- lua 5.2/5.3 style `load` function
```

  5. Grab the test script from API docs: https://jgm.github.io/lunamark/doc/

```lua
  local lunamark = require("lunamark")
  local writer = lunamark.writer.html.new()
  local parse = lunamark.reader.markdown.new(writer, { smart = true })
  local result, metadata = parse("Here's 'my *text*'...")
  print(result)
  assert(result == 'Here’s ‘my <em>text</em>’…')
```

  6. That's all. If it still doesn't work after this, keep trying.


+ [Top](#markdown-to-html-with-luamark)

___

## File Structure

Relevant Directies:

```
webroot/
  ├─index.html?       -- index.html will be created in the root
  ├─pages/*           -- public facing html files
  └─templates/        -- MD-HTML conversion workspace
    ├─lunamark/
    │ ├─lunamark.lua  -- lunamark does most of the conversion
    │ └─lunamark/*
    ├─hypertext/      -- html templates
    │ ├─master.html   -- master contains head/body substitutes
    │ └─index.html?   -- partials (not yet implemented)
    ├─markdown/*
    │ └─index.md      -- markdown files for conversion
    ├─init.lua        -- initializer for conversion
    ├─nav_macro.lua   -- navigation menu macro
    └─inject.lua      -- keyword substituted injections
```

## Markdown Injection

  - Markdown files must be formatted in this way:

      1. The markdown file name will be used as the markup file name.
          - `myfile.md` -> `myfile.html`
      2. The very first line containing a header will be used as the page title.
          - `# Some Title!` -> `<h1>Some Title!</h1>`
      3. The side menu must be configured manually (ie: add page to menu) in `macro_nav.lua`.

  - Template `master.html` contains keywords to be substituted with the content of a given markdown file:

      1. `$nav` -> navigation side-menu built using `macro_nav.lua`

      2. `$body` -> from the converted markdown content

      3. `$title` -> Extracted from the markdown file's first header line

      4. `$time` -> Footer element for last-updated time.

      5. `$hitmark` -> Used to inject partial html into the output

  - Substitution methods are found within `inject.lua`.

  - Navigation menu is constructed with `macro_nav.lua`

  - Partial html can be injected by adding `$hitmark`


+ [Top](#markdown-to-html-with-luamark)


## Convert

  1. Using terminal. This will *only* print to stdout. You can redirect the output to wherever, maybe in the future it'll write out to file.

```bash
# print only
webroot/templates/ $ lua init.lua markdown/index.md
# redirect output
webroot/templates/ $ lua init.lua markdown/index.md > /path/to/where_ever/index.html
```

  2. Optionally, until I'm comfortable writing to file automatically:

```bash
# from within the templates dir
for FILE in `ls markdown/ | sed -E 's/(\w+).md/\1/g'` ;\
  do lua init.lua markdown/${FILE}.md > ../pages/${FILE}.html ; done
```


+ [Top](#markdown-to-html-with-luamark)

___

## Lunamark

**Released under the MIT license.**

https://github.com/jgm/lunamark

Most of the library is written by John MacFarlane.  Hans Hagen
made some major performance improvements.  Khaled Hosny added the
original ConTeXt writer.

The [dzslides] HTML, CSS, and javascript code is by Paul Rouget, released under
the DWTFYWT Public License.

**Links**

+ [Source code repository]
+ [Issue tracker]
+ [Website]
+ [API documentation]
+ [lunamark(1)]
+ [lunadoc(1)]
+ [lpeg]

[Source code repository]: https://github.com/jgm/lunamark
[Issue tracker]: https://github.com/jgm/lunamark/issues
[Website]: https://jgm.github.io/lunamark
[API documentation]: https://jgm.github.io/lunamark/doc/
[lunamark(1)]: https://jgm.github.io/lunamark/lunamark.1.html
[lunadoc(1)]: https://jgm.github.io/lunamark/lunadoc.1.html
[dzslides]: https://paulrouget.com/dzslides/
[lpeg]: https://www.inf.puc-rio.br/~roberto/lpeg/#ex


+ [Top](#markdown-to-html-with-luamark)

___

## Writer dot lua Parameters

 *   `writer` is a writer table (see [lunamark.writer.generic]).

 *   `options` is a table with parsing options.
     The following fields are significant:

     `alter_syntax`
     :   Function from syntax table to syntax table,
         allowing the user to change or extend the markdown syntax.
         For an example, see the documentation for `lunamark`.

     `references`
     :   A table of references to be used in resolving links
         in the document.  The keys should be all lowercase, with
         spaces and newlines collapsed into single spaces.
         Example:

             { foo: { url = "/url", title = "my title" },
               bar: { url = "http://fsf.org" } }

     `preserve_tabs`
     :   Preserve tabs instead of converting to spaces.

     `smart`
     :   Parse quotation marks, dashes, ellipses intelligently.

     `startnum`
     :   Make the opening number in an ordered list significant.

     `notes`
     :   Enable footnotes as in pandoc.

     `inline_notes`
     :  Inline footnotes. An inline footnote is like a markdown bracketed
        reference, but preceded with a circumflex (`^`).

     `definition_lists`
     :   Enable definition lists as in pandoc.

     `citations`
     :   Enable citations as in pandoc.

     `fenced_code_blocks`
     :   Enable fenced code blocks.

     `pandoc_title_blocks`
     :   Parse pandoc-style title block at the beginning of document:

             % Title
             % Author1; Author2
             % Date

     `lua_metadata`
     :   Enable lua metadata.  This is an HTML comment block
         that starts with `<!--@` and contains lua code.
         The lua code is interpreted in a sandbox, and
         any variables defined are added to the metadata.
         The function `markdown` (also `m`) is defined and can
         be used to ensure that string fields are parsed
         as markdown; otherwise, they will be read literally.

     `require_blank_before_blockquote`
     :   Require a blank line between a paragraph and a following
         block quote.

     `require_blank_before_header`
     :   Require a blank line between a paragraph and a following
         header.

     `require_blank_before_fenced_code_block`
     :   Require a blank line between a paragraph and a following
         fenced code block.

     `hash_enumerators`
     :   Allow `#` instead of a digit for an ordered list enumerator
         (equivalent to `1`).

     `task_list`
     :   GitHub-Flavored Markdown (GFM) task list extension to standard
         bullet lists. Items starting with `[ ]`, `[x]` or `[X]` after the
         bullet are processed as first-class structures by the Markdown reader
         when this option is enabled, possibly allowing writers to handle
         them more efficiently with a finer-grain logic.

     `fancy_lists`
     :   Allow ordered list items to use a roman number or a letter
         as anumerator, instead of a digit, and to use a closing parenthesis
         as end delimiter, instead of a period.

         Depending on the selected writer, the numbering scheme and delimeter
         may be honored or just ignored.

         If the `startnum` option is enabled, the starting value is converted
         to decimal, when necessary, so that the list at least starts at the
         appropriate value.

         So in the minimal case, this option allows such lists to be processed,
         albeit rendered as regular ordered lists.

         Compared to the Pandoc option by the same name, the implementation
         does not support currently list markers enclosed in parentheses.

     `strikeout`
     :   Enable strike-through support for a text enclosed within double
         tildes, as in `~~deleted~~`.

     `mark`
     :   Enable highlighting support for a text enclosed within double
         equals, as in `==marked==`.

     `superscript`
     :   Enable superscript support. Superscripts may be written by surrounding
         the superscripted text by `^` characters, as in `2^10^.

         The text thus marked may not contain spaces or newlines.
         If the superscripted text contains spaces, these spaces must be escaped
         with backslashes.

     `subscript`
     :   Enable superscript support. Superscripts may be written by surrounding
         the subscripted text by `~` characters, as in `2~10~`.

         The text thus marked may not contain spaces or newlines.
         If the supbscripted text contains spaces, these spaces must be escaped
         with backslashes.

     `bracketed_spans`
     :   When enabled, a bracketed sequence of inlines (as one would use to
         begin a link), is treated as a Span with attributes if it is
         followed immediately by attributes, e.g. `[text]{.class key=value}`.

     `fenced_divs`
     :   Allow special fenced syntax for native Div blocks. A Div starts with a
         fence containing at least three consecutive colons plus some attributes.

         The Div ends with another line containing a string of at least
         three consecutive colons. The fenced Div should be separated by blank
         lines from preceding and following blocks.

         Current implementation restrictions and differences with the Pandoc
         option by the same name: fenced Divs cannot be nested, the attributes
         cannot be followed by another optional string of consecutive colons,
         attributes have to be in curly braces (and cannot be a single unbraced
         word.

     `raw_attribute`
     :   When enabled, inline code and fenced code blocks with a special kind
         of attribute will be parsed as raw content with the designated format,
         e.g. `{=format}`. Writers may pass relevant raw content to the
         target formatter.

         To use a raw attribute with fenced code blocks, `fenced_code_blocks`
         must be enabled.

         As opposed to the Pandoc option going by the same name, raw
         attributes can be continued with key=value pairs.

         How these constructs are honored depends on the writer. In the
         minimal case, they are ignored, as if they were stripped from
         the input.

     `fenced_code_attributes`
     :   Allow attaching attributes to fenced code blocks, if the latter.
         are enabled.

         Current implementation restrictions and differences with the Pandoc
         option by the same name: attributes can only be set on fenced
         code blocks.

     `link_attributes`
     :   Allow attaching attributes to direct images.

         Current implementation restrictions and differences with the Pandoc
         option by the same name: attributes cannot be set on links
         and indirect images (i.e. only direct images support them).

     `pipe_tables`
     :   Support "Pipe Tables", as with Pandoc's option by the same name,
         following the syntax introduced in PHP Markdown Extra.

     `table_captions`
     :   Enable the Pandoc `table_captions` syntax extension for
         tables.

     `header_attributes`
     :   Headings can be assigned attributes at the end of the line containing
         the heading text.

     `line_blocks`
     :   A line block is a sequence of lines beginning with a vertical bar
         followed by a space. The division into lines will be preserved in the
         output, as will any leading spaces; otherwise, the lines will be
         formatted as Markdown.

         Inline formatting (such as emphasis) is allowed
         in the content, but not block-level formatting (such as block quotes or
         lists).

         The lines can be hard-wrapped if needed, but the continuation line must
         begin with a space.

     `escaped_line_breaks`
     :   When enabled, a backslash followed by a newline is also a hard line
         break. This is a nice alternative to Markdown's "invisible" way of
         indicating hard line breaks using two trailing spaces at the end of
         a line.

 *   Returns a converter function that converts a markdown string
     using `writer`, returning the parsed document as first result,
     and a table containing any extracted metadata as the second
     result. The converter assumes that the input has unix
     line endings (newline).  If the input might have DOS
     line endings, a simple `gsub("\r","")` should take care of them.


+ [Top](#markdown-to-html-with-luamark)

___

## Writer Quick Reference

### Element Class and ID

```md
# header 1 {.header-class}
## header 2 {#header-id}

::: notice info
This is a div block as  a md notice box
:::

<!-- Also link attributes -->
![with attributes](image.png){width=150 height=100}
```

+ [Top](#markdown-to-html-with-luamark)

___

## Known Issues

1. > lua: lua/inject.lua:4: invalid use of '%' in replacement string
    - **Workaround**: Escape `%%` in the markdown file.

2. > index.html is not created in the web root

+ [Top](#markdown-to-html-with-luamark)