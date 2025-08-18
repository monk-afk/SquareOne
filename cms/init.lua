local markdown_file = arg[1]
local open_markdown_file = io.open(markdown_file, "r") or error("BAD MARKDOWN FILE (ARG[1])")

-- get and strip title before requiring lpeg
local markdown_content = open_markdown_file:read("a")

-- title is the first pound header: # TITLE
local title = markdown_content:gsub("^#%s+([%g ]+).+$", "%1")

-- explicit save path after the title will be placed in /pages/file_path/:
-- # TITLE /file_path/
local file_path = title:match("%b//")

if file_path and file_path ~= "" and file_path ~= "//" then
  title = title:gsub(file_path, "")
else
  file_path = nil
end

markdown_content = markdown_content:gsub("^#%s+[%a%s%p]-\n", "", 1)

-- make sure the file name is included in the macro_nav.lua
local filename = markdown_file:gsub("^.+/([%a%d_]+)%.md", "%1")

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

-- for when lunamark doesn't capture elements or whatever, use $htmlsup
local function add_supplement_markup(syntax)
  local marker = lpeg.C(lpeg.P("$htmlsup"))
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
  link_attributes = true,
  definition_lists = true,
  mark = true,
  superscript = true,
  raw_attribute = true,
  bracketed_spans = true,
  fenced_code_attributes = true,
  table_captions = true,
})

local result, metadata = parse(markdown_content)


local function write_out(html_file, html_output)
  local output_file = io.open(html_file, "w") or error("Cannot open HTML file!")
  output_file:write(html_output, "\n")
  output_file:close()

  io.write("Converted ", markdown_file, " to ", html_file, "\n"); io.stdout:flush()
  return true
end

-- if not write_to_file then
  -- io.write(html_output, "\n"); io.stdout:flush()
-- else


  local root_dir = io.popen("dirname ${PWD}", "r"):read("l") .. "/"
  local pages_dir = root_dir .. "pages"

  -- all menu pages get put into /pages/*.html
  local html_file = string.format("%s/%s.html", pages_dir, filename)

  -- index.md is written into project root
  if filename == "index" then
    html_file = string.format("%s%s.html", root_dir, filename)
  end

  local sub_dir_index = filename:match("([%a_]+)_index")
  -- sub-directory indexes, eg; archive_index.md -> /archive/index.html
  if sub_dir_index or file_path then
    -- first create a path if it doesn't exist
    local sub_dir = sub_dir_index and ("%s/%s/"):format(pages_dir, sub_dir_index)
        or file_path and ("%s%s"):format(pages_dir, file_path)
        or error("Something wrong with the sub-directory path")
    os.execute("mkdir -p " .. sub_dir)

    html_file = sub_dir_index and sub_dir .. "index.html" or
        sub_dir .. filename .. ".html"
  end

  local html_output = dofile("lua/inject.lua")(markdown_content, result, title, filename--[[ , html_file ]])
  -- print(html_file)
  -- local output_file = io.open(html_file, "w") or error("Cannot open HTML file!")
  -- output_file:write(html_output, "\n")
  -- output_file:close()
  local out = write_to_file and write_out(html_file, html_output) or
      io.write(html_output, "\n"); io.stdout:flush()
-- end


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