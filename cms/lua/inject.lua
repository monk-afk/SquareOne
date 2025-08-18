local function render_template(template, title, date, body, nav--[[ , slug ]])
  template = template:gsub("$title", title)
  template = template:gsub("$nav", nav)
  template = template:gsub("$body", body)
  -- template = template:gsub("$slug", slug)
  -- print(slug)
  template = template:gsub("$time", date)
  return template
end


local function inject_template(markdown_content, body, title, filename--[[ , slug ]])
  local open_template = io.open("hypertext/master.html", "r") or error("BAD TEMPLATE FILE (ARG[2])")
  local template = open_template:read("a")

  local date = os.date("%Y-%m-%d %H:%M:%S", os.time())
  local nav = dofile("lua/macro_nav.lua")(filename)

  local html_output = render_template(template, title, date, body, nav--[[ , slug ]])

  return html_output
end

return inject_template


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