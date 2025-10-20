--[[ when updating colors.txt, after running generate_colorstxt.py,
      all colored_meselamps nodes are white in new colors.txt.
    this will replace the lines in the new_colors.txt with the colored_meselamps
      color values from the correct colors.txt
  ]]
local colors = {}
for line in io.lines("colors.txt") do
  local name = line:match("^(colored_meselamps:[%w_]+)")

  if name then
    colors[name] = line
  end
end

local output = {}
for line in io.lines("new_colors.txt") do
  local name = line:match("^(colored_meselamps:[%w_]+)")

  if name and colors[name] then
    table.insert(output, colors[name])
  else
    table.insert(output, line)
  end
end

local f = io.open("new_colors.txt", "w")
f:write(table.concat(output, "\n"))
f:close()
------------------------------------------------------------------------------------
-- MIT License                                                                    --
--                                                                                --
-- Copyright © 2025 monk (https://github.com/monk-afk/)                           --
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