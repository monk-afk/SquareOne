# MARKDOWN TO HTML WITH LUAMARK

___

## Installation

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

___

## PREPARE FILES

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

  - Markdown files must be formatted in this way:

      1. The markdown file name will be used as the markup file name.
          - `myfile.md` -> `myfile.html`
      2. The very first line containing a header will be used as the page title.
          - `# Some Title!` -> `<h1>Some Title!</h1>`
      3. The side menu must be configured manually in `macro_nav.lua`.

  - Template `master.html` contains keywords to be substituted with the content of a given markdown file:

      1. `$nav` -> navigation side-menu built using `macro_nav.lua`

      2. `$body` -> from the converted markdown content

      3. `$title` -> Extracted from the markdown file's first header line

      4. `$time` -> Footer element for last-updated time.

      5. `$hitmark` -> Used to inject partial html into the output

  - Substitution methods are found within `inject.lua`.

  - Navigation menu is constructed with `macro_nav.lua`

  - Partial html can be injected by adding `$hitmark`


## CONVERT

  1. Using terminal. This will *only* print to stdout. You can redirect the output to wherever, maybe in the future it'll write out to file.

```bash
# print only
webroot/templates/ $ lua init.lua markdown/index.md
# redirect output
webroot/templates/ $ lua init.lua markdown/index.md > /path/to/where_ever/index.html
```

  2. Optionally, not recommended until this application complete:

```bash
for FILE in `ls markdown/ | sed -E 's/(\w+).md/\1/g'` ;\
  do lua init.lua markdown/${FILE}.md > ~/tmp/html/${FILE}.html ; done
```


___

# Lunamark is released under the MIT license.

Most of the library is written by John MacFarlane.  Hans Hagen
made some major performance improvements.  Khaled Hosny added the
original ConTeXt writer.

The [dzslides] HTML, CSS, and javascript code is by Paul Rouget, released under
the DWTFYWT Public License.

# Links

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
