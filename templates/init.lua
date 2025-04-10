local markdown_file = arg[1]
local open_markdown_file = io.open(markdown_file, "r") or error("BAD MARKDOWN FILE (ARG[1])")

-- get and strip title before requiring lpeg
local markdown_content = open_markdown_file:read("a")

-- title is the first pound header: # TITLE
local title = markdown_content:gsub("^#%s+([%g ]+).+$", "%1")
markdown_content = markdown_content:gsub("^#%s+[%a%s]-\n", "", 1)

-- make sure the file name is included in the macro_nav.lua
local filename = markdown_file:gsub("^.+/(%a+)%.md", "%1")

-- second argument is '-o' to write output to file
local write_to_file = arg[2] and arg[2]:match("%-+o")

package.path = package.path .. ";./lua/?.lua;./lua/lunamark/?.lua;./lua/lunamark/lunamark/?.lua"
local lpeg = require("lpeg")
local lunamark = require("lunamark")
local writer = lunamark.writer.html5.new()

--[[ matches '!!!' for summary and details tags, ex:
!!! The details
    are on a single line below the summary
]]
local function add_details_block(syntax)
  local details_pattern = lpeg.P("!!!") * lpeg.S(" \t")^1 * lpeg.C((1 - lpeg.S("\n"))^1) * lpeg.P("\n") * lpeg.C((1 - lpeg.S("\n"))^1)
  syntax.Block = details_pattern / function(summary, details)
    return string.format("<p><details>\n<summary>%s</summary>\n%s\n</details></p>", summary, details)
  end + syntax.Block
  return syntax
end

-- for when lunamark doesn't capture elements or whatever, use $hitmark
local function add_supplement_markup(syntax)
  local marker = lpeg.C(lpeg.P("$hitmark"))
  syntax.Block = marker / function(marker)
    local supplement_file = "hypertext/" .. filename .. ".html"
    local file = io.open(supplement_file, "r") or error("SUPPLEMENT FILE NOT FOUND: " .. supplement_file)
    local markup = file:read("a")
    file:close()
    return markup
  end + syntax.Block
  return syntax
end


local function add_horizontal_ruler(syntax)
  local hr = lpeg.C(lpeg.P("___"))
  syntax.Block = hr / function(hr)
    return '<hr class="header-hr">'
  end + syntax.Block
  return syntax
end


local function alter_syntax(syntax)
  syntax = add_details_block(syntax)
  syntax = add_supplement_markup(syntax)
  syntax = add_horizontal_ruler(syntax)
  return syntax
end

local parse = lunamark.reader.markdown.new(writer, {
  alter_syntax = alter_syntax,
  pipe_tables = true,
  header_attributes = true,
  fenced_divs = true,
  link_attributes = true
})

local result, metadata = parse(markdown_content)

local html_output = dofile("lua/inject.lua")(markdown_content, result, title, filename)


if not write_to_file then
  io.write(html_output, "\n"); io.stdout:flush()

else
  local dir = io.popen("dirname ${PWD}", "r"):read("l")
  local html_file = string.format("%s/pages/%s.html", dir, filename)

  if filename == "index" then -- index is written into project root
    html_file = string.format("%s/%s.html", dir, filename)
  end

  local output_file = io.open(html_file, "w") or error("Cannot open HTML file!")
  output_file:write(html_output, "\n")
  output_file:close()

  io.write("Converted ", markdown_file, " to ", html_file, "\n"); io.stdout:flush()
end


------------------------------------------------------------------------------------
-- MIT License                                                                    --
--                                                                                --
-- Copyright © 2025 monk (Discord ID: 699370563235479624)                         --
--                                                                                --
-- Permission is hereby granted, free of charge, to any person obtaining a copy   --
-- of this software and associated documentation files (the "Software"), to deal  --
-- in the Software without restriction, including without limitation the rights   --
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      --
-- copies of the Software, and to permit persons to whom the Software is          --
-- furnished to do so, subject to the following conditions:                       --
--                                                                                --
-- The above copyright notice and this permission notice shall be included in all --
-- copies or substantial portions of the Software.                                --
--                                                                                --
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     --
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       --
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    --
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         --
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  --
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  --
-- SOFTWARE.                                                                      --
------------------------------------------------------------------------------------