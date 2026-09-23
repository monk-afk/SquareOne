-- SquareOne Armor Stats
-- Copyright © 2026 monk (https://github.com/monk-afk)
-- SPDX-License-Identifier: MIT
local home = os.getenv("HOME")
local luanti_root = home .. "/luanti"
local website_root = home .. "/SquareOne"

local worldmods_path = luanti_root .. "/worlds/world/worldmods/"
local server_config_path = luanti_root .. "/minetest.conf"

local calculator_data_path = website_root .. "/js/armor-data.js"
local website_images_path =  website_root .. "/images/textures/armor/"
local armor_api_path = worldmods_path .. "3d_armor/3d_armor/api.lua"

os.setlocale("C", "numeric")

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return ""
  end
  local content = file:read("a")
  file:close()
  return content
end

local api_blob = read_file(armor_api_path)
local config_blob = api_blob:match("armor%.config%s*=%s*{(.-)\n}") or ""
local calculator_config = {
  level_multiplier = tonumber(config_blob:match("level_multiplier%s*=%s*([%d.-]+)")) or 1,
  heal_multiplier = tonumber(config_blob:match("heal_multiplier%s*=%s*([%d.-]+)")) or 1,
  set_multiplier = tonumber(config_blob:match("set_multiplier%s*=%s*([%d.-]+)")) or 1,
  set_elements = config_blob:match('set_elements%s*=%s*"([^"]+)"')
      or "head torso legs feet shield",
  material_enabled = {},
}

for material, enabled in config_blob:gmatch("material_([%w_]+)%s*=%s*(%a+)") do
  calculator_config.material_enabled[material] = enabled == "true"
end

local server_config = io.open(server_config_path, "r")
if server_config then
  for line in server_config:lines() do
    local setting, value = line:match("^%s*(armor_[%w_]+)%s*=%s*(.-)%s*$")
    if setting then
      value = value:gsub("%s+#.*$", "")
      if setting == "armor_level_multiplier" then
        calculator_config.level_multiplier = tonumber(value) or calculator_config.level_multiplier
      elseif setting == "armor_heal_multiplier" then
        calculator_config.heal_multiplier = tonumber(value) or calculator_config.heal_multiplier
      elseif setting == "armor_set_multiplier" then
        calculator_config.set_multiplier = tonumber(value) or calculator_config.set_multiplier
      elseif setting == "armor_set_elements" and value ~= "" then
        calculator_config.set_elements = value
      else
        local material = setting:match("^armor_material_(.+)$")
        if material and (value == "true" or value == "false") then
          calculator_config.material_enabled[material] = value == "true"
        end
      end
    end
  end
  server_config:close()
end

local grepper = [[ LC_ALL=C grep -lrE "^\s+armor:register_armor" ]] .. worldmods_path
    .. [[ | grep '\.lua$' | grep -v clothing | LC_ALL=C sort ]]

local blob = io.popen(grepper, "r")

local armor_blobs = {}

for line in blob:lines() do
  local armor_file = io.open(line, "r") or error("COULD NOT OPEN ARMOR FILE!")
  local armor_blob = armor_file:read("a")
  armor_file:close()

  armor_blob = armor_blob:
      gsub("%-%-[^\n]*", ""):
      gsub("%G", "")
  table.insert(armor_blobs, armor_blob)
end
blob:close()

local armor_blob = table.concat(armor_blobs, "\n")

local armor_pieces = {
  "helmet",
  "chestplate",
  "leggings",
  "boots",
  "shield",
}

local stat_groups = {
  {group = "inventory_image", desc = "image"},
  {group = "armor_use",       desc = "Hits to Break"},
  {group = "fleshy",          desc = "Defense"},
  {group = "armor_heal",      desc = "Block Chance"},
  {group = "armor_fire",      desc = "Fire Resist"},
  {group = "physics_jump",    desc = "Jump"},
  {group = "physics_speed",   desc = "Speed"},
  {group = "physics_gravity", desc = "Gravity"},
}

local full_set_size = #armor_pieces
local armor_data = {}

local piece_labels = {
  helmet = "Helmet",
  chestplate = "Chestplate",
  leggings = "Leggings",
  boots = "Boots",
  shield = "Shield",
}

local function display_class_name(class)
  if class == "copperpatina" then
    return "Copper Patina"
  end
  return class:
      gsub("_", " "):
      gsub("(%a)([%w']*)", function(first, rest)
        return first:upper() .. rest
      end)
end

local function hits_to_break(armor_use, equipped_count)
  if armor_use == 0 then
    return "infinite"
  end
  local wear_per_hit = math.ceil(armor_use / equipped_count)
  return math.floor(65535 / wear_per_hit) + 1
end

for _,armor in ipairs(armor_pieces) do
  armor_blob:gsub("armor:register_armor%(\"([%d%a:_]*" .. armor .. "[%d%a:_]*)(.-}%))", function(piece, def)
      local item_name = piece:gsub("^:", "")
      local short_name = item_name:match("^[^:]+:(.+)$") or item_name
      local class = short_name:
          gsub("^" .. armor .. "_", ""):
          gsub("_" .. armor .. "$", "")

      armor_data[class] = armor_data[class] or {}
      armor_data[class][armor] = {}
      local stats = armor_data[class][armor]
      stats._item = item_name
      stats._armor_use = 0
      stats._reflect = def:match("reciprocate_damage%s*=%s*true") ~= nil
      stats._description = display_class_name(class) .. " " .. piece_labels[armor]

    for _, stat in ipairs(stat_groups) do
      def:gsub(
          "(" .. stat.group .. ')="?(%-?[%a%d._]*)"?', function(_, value)
            if stat.group == "armor_use" then
              local armor_use = tonumber(value)
              stats._armor_use = armor_use
              value = hits_to_break(armor_use, full_set_size)
            elseif stat.group ~= "inventory_image" then
              value = tonumber(value) or value
            end
            stats[stat.desc] = value
          end
        )
      end
    end
  )
end

local function sorted_keys(t)
  local keys = {}
  for key in pairs(t) do
    keys[#keys+1] = key
  end
  table.sort(keys)
  return keys
end

local armor_classes = {}
for _, class in ipairs(sorted_keys(armor_data)) do
  if calculator_config.material_enabled[class] ~= false then
    armor_classes[#armor_classes+1] = class
  end
end

local function get_stat_columns(data)
  local present = {}
  for _, armor_piece in ipairs(armor_pieces) do
    local stats = data[armor_piece]
    if stats then
      for _, stat in ipairs(stat_groups) do
        if stat.desc ~= "image" and stats[stat.desc] ~= nil then
          present[stat.desc] = true
        end
      end
    end
  end

  local columns = {}
  for _, stat in ipairs(stat_groups) do
    if present[stat.desc] then
      columns[#columns+1] = stat.desc
    end
  end
  return columns
end

local o = {}

for _, armor_class in ipairs(armor_classes) do
  local data = armor_data[armor_class]
  local display_class = display_class_name(armor_class)
  local stat_columns = get_stat_columns(data)
  o[#o+1] = string.format(" | %10s |", display_class)

  for _, attribute in ipairs(stat_columns) do
    o[#o+1] = string.format(" %10s |", attribute)
  end
  o[#o+1] = "\n"
  o[#o+1] = " |:" .. string.rep(string.rep("-", 13) .. ":|", #stat_columns + 1)
  o[#o+1] = "\n"

  for _, armor_piece in ipairs(armor_pieces) do
    local stats = data[armor_piece]
    if stats then
      o[#o+1] = string.format(" | ![%s](/images/textures/armor/%s) |", armor_piece, stats.image)
      for _, attribute in ipairs(stat_columns) do
        o[#o+1] = string.format(" %10s |", stats[attribute] or "")
      end
      o[#o+1] = "\n"
    end
  end
  o[#o+1] = "\n"
end

local location_to_piece = {
  head = "helmet",
  torso = "chestplate",
  legs = "leggings",
  feet = "boots",
  shield = "shield",
}

local set_slots = {}
for location in calculator_config.set_elements:gmatch("%S+") do
  local piece = location_to_piece[location]
  if piece then
    set_slots[#set_slots+1] = piece
  end
end

local function js_quote(value)
  local escaped = tostring(value):
      gsub("\\", "\\\\"):
      gsub('"', '\\"'):
      gsub("\r", "\\r"):
      gsub("\n", "\\n")
  return '"' .. escaped .. '"'
end

local function js_number(value)
  return string.format("%.15g", tonumber(value) or 0)
end

local js = {
  "// Generated by scripts/armor_stats.lua.",
  "window.SQUAREONE_ARMOR_DATA = {",
  "  \"config\": {",
  "    \"levelMultiplier\": " .. js_number(calculator_config.level_multiplier) .. ",",
  "    \"healMultiplier\": " .. js_number(calculator_config.heal_multiplier) .. ",",
  "    \"setMultiplier\": " .. js_number(calculator_config.set_multiplier) .. ",",
  "    \"slots\": [\"helmet\", \"chestplate\", \"leggings\", \"boots\", \"shield\"],",
}

local quoted_set_slots = {}
for _, slot in ipairs(set_slots) do
  quoted_set_slots[#quoted_set_slots+1] = js_quote(slot)
end
js[#js+1] = "    \"setSlots\": [" .. table.concat(quoted_set_slots, ", ") .. "]"
js[#js+1] = "  },"
js[#js+1] = "  \"items\": ["

local calculator_items = {}
for _, armor_class in ipairs(armor_classes) do
  local set_label = display_class_name(armor_class)
  for _, armor_piece in ipairs(armor_pieces) do
    local stats = armor_data[armor_class][armor_piece]
    if stats then
      calculator_items[#calculator_items+1] = string.format(
          "    {\"item\":%s,\"set\":%s,\"setLabel\":%s,\"slot\":%s,\"label\":%s,\"image\":%s,\"armorUse\":%s,\"defense\":%s,\"block\":%s,\"fire\":%s,\"jump\":%s,\"speed\":%s,\"gravity\":%s,\"reflect\":%s}",
          js_quote(stats._item),
          js_quote(armor_class),
          js_quote(set_label),
          js_quote(armor_piece),
          js_quote(stats._description),
          js_quote(stats.image or ""),
          js_number(stats._armor_use),
          js_number(stats.Defense),
          js_number(stats["Block Chance"]),
          js_number(stats["Fire Resist"]),
          js_number(stats.Jump),
          js_number(stats.Speed),
          js_number(stats.Gravity),
          stats._reflect and "true" or "false"
        )
    end
  end
end

for index, item in ipairs(calculator_items) do
  local comma = index < #calculator_items and "," or ""
  js[#js+1] = item .. comma
end
js[#js+1] = "  ]"
js[#js+1] = "};"

local calculator_file = io.open(calculator_data_path, "w")
    or error("COULD NOT WRITE CALCULATOR DATA!")
calculator_file:write(table.concat(js, "\n"), "\n")
calculator_file:close()


print(
  table.concat(o) -- ,
)

-- this was used to copy the textures into the web service folder
local image_files = {}
for _, armor_class in ipairs(armor_classes) do
  local data = armor_data[armor_class]
  for _, armor_piece in ipairs(armor_pieces) do
    local stats = data[armor_piece]
    if stats and stats.image then
      local finder = io.popen("find " .. worldmods_path .. " -type f -name '"
          .. stats.image .. "' | LC_ALL=C sort | head -n 1")
      local image_file = finder:read("l")
      finder:close()
      if image_file and image_file ~= "" then
        os.execute("cp -n " .. image_file .. " " .. website_images_path)
        table.insert(image_files, image_file)
      end
    end
  end
end
