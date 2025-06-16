local worldmods = "/path/to/luantiserver/world/worldmods/"
local webroot = "/path/to/webroot/"

  -- get the file names containing the tools we want to extract
local grep_string = [[ grep -lrE '^[a-z]+\\.register_tool.+%s' %s | grep .lua | grep -v clothing ]]

local tool_pieces = {
  "sword", "axe", "pick", "shovel", "staff", "hoe", "staff"
}


local function extract_blobs(tool_blobs)
  for _, tool in ipairs(tool_pieces) do
    local blob = io.popen(string.format(grep_string, tool, worldmods), "r")
    for line in blob:lines() do
      local tool_file = io.open(line, "r") or error("COULD NOT OPEN TOOL FILE!")
      -- %G: represents all non-printable characters including space
      local tool_blob = tool_file:read("a"):gsub("%G", "")
      table.insert(tool_blobs, tool_blob)
    end
  end
  return table.concat(tool_blobs) -- returned as a single line of escaped text
end

local tool_blob = extract_blobs({})

local stat_groups = {
  {["inventory_image"]     = "image"},
  {["uses"]                = "Durability"},
  {["times"] = "Swing Speed"},
  {["fleshy"] = "Attack"},
  {["full_punch_interval"] = "Full Punch Int."},
  {["short_description"] = "Ability"},
}

local tool_data = {}

  -- groupcaps = {snappy = {times = {[1] = 2.5, [2] = 1.20, [3] = 1.35}, uses = 30, maxlevel = 2},},
  -- damage_groups = {fleshy = 6},},
for _,tool in ipairs(tool_pieces) do
  tool_blob:gsub("%a+.register_tool%(\"([%d%a:_]*" .. tool .. "[%d%a:_]*)(.-}%))", function(piece, def)
    local class = piece:match(":?[%a%d_]*:([%a_]+)"):gsub("_?" .. tool .. "_?", "")

    tool_data[class] = tool_data[class] or {}
    tool_data[class][tool] = {}

    for n = 1, #stat_groups do
      for group, desc in pairs(stat_groups[n]) do
        if type(desc) == "string" then -- type check incase desc is a table
          def:gsub("(" .. group .. ')="?(%-?[%a%d._]*)"?', function(g, v)
              if group == "tool_use" then
                v = math.floor(65535/v)
              end
              tool_data[class][tool][desc] = v
            end)
        else
          for attribute, data in pairs(desc) do
            def:gsub("(" .. attribute .. ")[%s%p]+([%d._]+)", function(g, v)
              print(g, v)
            end)
          end
        end
      end
    end
  end)
end

local o = {}

for tool_class, data in pairs(tool_data) do
  local tool_class = tool_class:
      gsub("^%a", function(a) return a:upper() end, 1):
      gsub("_(%a)", function(a) return " " .. a:upper() end, 1)
  o[#o+1] = string.format(" | %10s |", tool_class)

  local n = 1
  for tool_piece, stats in pairs(data) do
    for attribute, value in pairs(stats) do
      if attribute ~= "image" then
        n = n + 1
        o[#o+1] = string.format(" %10s |", attribute)
      end
    end
    o[#o+1] = "\n"
    o[#o+1] = " |:" .. string.rep(string.rep("-", 13) .. ":|", n)
    break
  end
  o[#o+1] = "\n"

  for tool_piece, stats in pairs(data) do
    o[#o+1] = string.format(" | ![%s](/images/textures/tool/%s) |", tool_piece, stats.image)
    for attribute, value in pairs(stats) do
      if attribute ~= "image" then
        o[#o+1] = string.format(" %10s |", value)
      end
    end
    o[#o+1] = "\n"
  end
  o[#o+1] = "\n"
end


print(
  table.concat(o) -- ,
)

-- this was used to copy the textures into the web service folder
-- local image_files = {}
-- local new_path = webroot .. "SquareOne/images/textures/tools/"
-- for tool_class, data in pairs(tool_data) do
--   for tool_piece, stats in pairs(data) do
--     for attribute, value in pairs(stats) do
--       if attribute == "image" then
--         local image_file = io.popen("find " .. worldmods .. " -type f -name '" .. value .. "'"):read("a"):gsub("%G", "")
--         if image_file ~= "" then
--           os.execute("cp " .. image_file .. " " .. new_path)
--           table.insert(image_files, image_file)
--         end
--       end
--     end
--   end
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