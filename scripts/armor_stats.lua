local worldmods_path = "/path/to/luantiserver/world/worldmods/"

local grepper = [[ grep -lrE "^\s+armor:register_armor" ]] .. worldmods_path  .. [[ | grep .lua | grep -v clothing ]]

local blob = io.popen(grepper, "r")

local armor_blobs = {}

for line in blob:lines() do
  local armor_file = io.open(line, "r") or error("COULD NOT OPEN ARMOR FILE!")
  local armor_blob = armor_file:read("a"):gsub("%G", "")
  table.insert(armor_blobs, armor_blob)
end

local armor_blob = table.concat(armor_blobs)

local armor_pieces = {
  "helmet",
  "chestplate",
  "leggings",
  "boots",
  "shield",
}

local stat_groups = {
  {["inventory_image"] = "image"},
  {["fleshy"]          = "Defense"},
  {["armor_heal"]      = "Block Chance"},
  {["armor_use"]       = "Durability"},
  {["armor_fire"]      = "Fire Resist"},
  {["physics_jump"]    = "Jump"},
  {["physics_speed"]   = "Speed"},
  {["physics_gravity"] = "Gravity"},
}

local armor_data = {}

for _,armor in ipairs(armor_pieces) do
  armor_blob:gsub("armor:register_armor%(\"([%d%a:_]*" .. armor .. "[%d%a:_]*)(.-}%))", function(piece, def)
      local class = piece:match(":?[%a%d_]*:([%a_]+)"):gsub("_?" .. armor .. "_?", "")

      armor_data[class] = armor_data[class] or {}
      armor_data[class][armor] = {}
    for n = 1, #stat_groups do
      for group, desc in pairs(stat_groups[n]) do
        def:gsub(
            "(" .. group .. ')="?(%-?[%a%d._]*)"?', function(g, v)
              if group == "armor_use" then 
                v = math.floor(65535/v)
              end
              armor_data[class][armor][desc] = v
            end
          )
        end
      end
    end
  )
end

local o = {}

for armor_class, data in pairs(armor_data) do
  local armor_class = armor_class:
      gsub("^%a", function(a) return a:upper() end, 1):
      gsub("_(%a)", function(a) return " " .. a:upper() end, 1)
  o[#o+1] = string.format(" | %10s |", armor_class)

  local n = 1
  for armor_piece, stats in pairs(data) do
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

  for armor_piece, stats in pairs(data) do
    o[#o+1] = string.format(" | ![%s](/images/textures/armor/%s) |", armor_piece, stats.image)
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
-- local new_path = "/SquareOne/images/textures/armor/"
-- for armor_class, data in pairs(armor_data) do
--   for armor_piece, stats in pairs(data) do
--     for attribute, value in pairs(stats) do
--       if attribute == "image" then
--         local image_file = io.popen("find " .. worldmods_path .. " -type f -name '" .. value .. "'"):read("a"):gsub("%G", "")
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