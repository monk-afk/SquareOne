--[[  This script will export "UnifiedDyes" dyes, their craft recipes, and the corresponding RGB and HEX colors.
  UnifiedDyes mod was released under GPL-2.0 https://github.com/mt-mods/unifieddyes , and we use specifically "color-tables.lua" and "dyes-crafting.lua"
  There may be some deviation from the RGB values of some colors, for example the greys have been hard-coded by the original mod's author. In UnifiedDyes, the hex value for "dark_grey" is #444444. In this script, the hex value for "dark_grey" is #181818.
  I don't know what license this gets since it's only a few functions of the unified dyes mod, so it's getting MIT with attribution
    - unifieddyes used the colors from here: https://procato.com/rgb+index/
]]
local output = { dye = {} }

local hues = {
	{ "red",        0xff, 0x00, 0x00 },
	{ "vermilion",  0xff, 0x40, 0x00 },
	{ "orange",     0xff, 0x80, 0x00 },
	{ "amber",      0xff, 0xbf, 0x00 },
	{ "yellow",     0xff, 0xff, 0x00 },
	{ "lime",       0xbf, 0xff, 0x00 },
	{ "chartreuse", 0x80, 0xff, 0x00 },
	{ "harlequin",  0x40, 0xff, 0x00 },
	{ "green",      0x00, 0xff, 0x00 },
	{ "malachite",  0x00, 0xff, 0x40 },
	{ "spring",     0x00, 0xff, 0x80 },
	{ "turquoise",  0x00, 0xff, 0xbf },
	{ "cyan",       0x00, 0xff, 0xff },
	{ "cerulean",   0x00, 0xbf, 0xff },
	{ "azure",      0x00, 0x80, 0xff },
	{ "sapphire",   0x00, 0x40, 0xff },
	{ "blue",       0x00, 0x00, 0xff },
	{ "indigo",     0x40, 0x00, 0xff },
	{ "violet",     0x80, 0x00, 0xff },
	{ "mulberry",   0xbf, 0x00, 0xff },
	{ "magenta",    0xff, 0x00, 0xff },
	{ "fuchsia",    0xff, 0x00, 0xbf },
	{ "rose",       0xff, 0x00, 0x80 },
	{ "crimson",    0xff, 0x00, 0x40 }
}

local values = {
	"faint_",
	"pastel_",
	"light_",
	"bright_",
	"",
	"medium_",
	"dark_"
}

local greys = {
	"white",
	"light_grey",
	"grey",
	"dark_grey",
	"black"
}

local greys_extended = {
	"white",
	"light_grey",
	"grey",
	"dark_grey",
	"black"
}


local function heximate(hex)
  local rgb = {}
  for i,c in ipairs(hex) do
    hex[i] = string.format("%02x", c)
    rgb[i] = tonumber(hex[i], 16)
  end
  return rgb, "#" .. table.concat(hex)
end


for i = 0, 15 do
  local v = ((16 - i) ^ 2) - 1  -- convert i to (0,255)
  local rgb, hex = heximate({v, v, v})

	if i ~= 0 and i ~= 4 and i ~= 8 and i ~= 11 and i ~= 15 then
    local grex = "grey_" .. i
		table.insert(greys_extended, grex)
    output.dye[grex] = output.dye[grex] or {}
    output.dye[grex].hex = hex
    output.dye[grex].rgb = rgb

  else
    local k = math.floor(1 + (i / 4) * 1.1) -- to get keys 1 to 5
    local grey = greys[k]
    output.dye[grey] = output.dye[grey] or {}
    output.dye[grey].hex = hex
    output.dye[grey].rgb = rgb
	end
end


for _, h in ipairs(hues) do
	local hue = h[1]
	local r, g, b = h[2], h[3], h[4]

  local rgb, hex = heximate({r, g, b})

  output.dye[hue] = output.dye[hue] or {}
  output.dye[hue].hex = hex
  output.dye[hue].rgb = rgb

  -- work in 0..1 floats for better math
  local function clamp01(x) return math.max(0, math.min(1, x)) end

  local function hex_to_rgb01(hex)
    hex = hex:gsub("^#", "")
    if #hex == 3 then
      hex = hex:sub(1,1)..hex:sub(1,1)..hex:sub(2,2)..hex:sub(2,2)..hex:sub(3,3)..hex:sub(3,3)
    end
    local r = tonumber(hex:sub(1,2),16) / 255
    local g = tonumber(hex:sub(3,4),16) / 255
    local b = tonumber(hex:sub(5,6),16) / 255
    return r,g,b
  end

  local function rgb01_to_hex(r,g,b)
    local function to255(x) return math.floor(clamp01(x) * 255 + 0.5) end
    return string.format("#%02x%02x%02x", to255(r), to255(g), to255(b))
  end

  -- gamma helpers
  local function srgb_to_linear(c)
    if c <= 0.04045 then return c / 12.92 end
    return ((c + 0.055) / 1.055) ^ 2.4
  end
  local function linear_to_srgb(c)
    if c <= 0.0031308 then return c * 12.92 end
    return 1.055 * (c ^ (1 / 2.4)) - 0.055
  end

  local function mix_linear(c1, c2, t)
    return c1 * (1 - t) + c2 * t
  end

  -- produce low-saturation version by mixing color towards its luminance (desaturate)
  local function desaturate_rgb_linear(lr,lg,lb, amount) -- amount 0..1 (0=no change, 1=grayscale)
    -- luminance in linear space using Rec.709 weights
    local L = 0.2126 * lr + 0.7152 * lg + 0.0722 * lb
    return mix_linear(lr, L, amount), mix_linear(lg, L, amount), mix_linear(lb, L, amount)
  end

  -- map values -> behaviors (t is mix factor toward white/black in linear space)
  local value_map = {
    ["faint_"]  = { kind = "white", t = 0.92 },
    ["pastel_"] = { kind = "white", t = 0.70 },
    ["light_"]  = { kind = "white", t = 0.40 },
    ["bright_"] = { kind = "white", t = 0.18 },
    [""]        = { kind = "none",  t = 0 },
    ["medium_"] = { kind = "black", t = 0.35 }, -- darken to 65% brightness
    ["dark_"]   = { kind = "black", t = 0.62 }, -- darken more
  }

  for v = 0, 6 do
    local val = values[v + 1]
    local vm = value_map[val] or { kind = "none", t = 0 }

    -- base sRGB 0..1
    local sr = r / 255
    local sg = g / 255
    local sb = b / 255

    -- convert to linear for blending
    local lr, lg, lb = srgb_to_linear(sr), srgb_to_linear(sg), srgb_to_linear(sb)

    local lr2, lg2, lb2
    if vm.kind == "white" then
      -- blend toward white (linear white = 1,1,1)
      lr2 = mix_linear(lr, 1, vm.t)
      lg2 = mix_linear(lg, 1, vm.t)
      lb2 = mix_linear(lb, 1, vm.t)
    elseif vm.kind == "black" then
      -- blend toward black (linear black = 0)
      lr2 = mix_linear(lr, 0, vm.t)
      lg2 = mix_linear(lg, 0, vm.t)
      lb2 = mix_linear(lb, 0, vm.t)
    else
      lr2, lg2, lb2 = lr, lg, lb
    end

    -- convert back to sRGB space for output
    local sr2, sg2, sb2 = linear_to_srgb(lr2), linear_to_srgb(lg2), linear_to_srgb(lb2)
    local hex2 = rgb01_to_hex(sr2, sg2, sb2)
    local rgb2 = { math.floor(sr2 * 255 + 0.5), math.floor(sg2 * 255 + 0.5), math.floor(sb2 * 255 + 0.5) }

    local dye_name = val .. hue
    output.dye[dye_name] = output.dye[dye_name] or {}
    output.dye[dye_name].hex = hex2
    output.dye[dye_name].rgb = rgb2

    if v > 3 then
      -- produce low-saturation (50%) version: desaturate in linear space by 50%
      local dlr, dlg, dlb = desaturate_rgb_linear(lr2, lg2, lb2, 0.5)
      local dsr, dsg, dsb = linear_to_srgb(dlr), linear_to_srgb(dlg), linear_to_srgb(dlb)
      local hex3 = rgb01_to_hex(dsr, dsg, dsb)
      local rgb3 = { math.floor(dsr * 255 + 0.5), math.floor(dsg * 255 + 0.5), math.floor(dsb * 255 + 0.5) }
      local dye_name_low_sat = dye_name .. "_s50"
      output.dye[dye_name_low_sat] = output.dye[dye_name_low_sat] or {}
      output.dye[dye_name_low_sat].hex = hex3
      output.dye[dye_name_low_sat].rgb = rgb3
    end
  end

end


local base_color_crafts = {
	{ "vermilion",  "dye:red",                  "dye:orange",     nil,         nil,        nil,        3 },
	{ "orange",     "dye:red",                  "dye:yellow",     nil,         nil,        nil,        2 },
	{ "amber",      "dye:orange",               "dye:yellow",     nil,         nil,        nil,        2 },
	{ "lime",       "dye:yellow",               "dye:chartreuse", nil,         nil,        nil,        2 },
	{ "lime",       "dye:yellow",               "dye:yellow",     "dye:green", nil,        nil,        3 },
	{ "chartreuse", "dye:yellow",               "dye:green",      nil,         nil,        nil,        2 },
	{ "harlequin",  "dye:chartreuse",           "dye:green",      nil,         nil,        nil,        2 },
	{ "harlequin",  "dye:yellow",               "dye:green",      "dye:green", nil,        nil,        3 },
	{ "green",      "dye:yellow",               "dye:blue",       nil,         nil,        nil,        2 },
	{ "malachite",  "dye:green",                "dye:spring",     nil,         nil,        nil,        2 },
	{ "malachite",  "dye:green",                "dye:green",      "dye:cyan",  nil,        nil,        3 },
	{ "malachite",  "dye:green",                "dye:green",      "dye:green", "dye:blue", nil,        4 },
	{ "spring",     "dye:green",                "dye:cyan",       nil,         nil,        nil,        2 },
	{ "spring",     "dye:green",                "dye:green",      "dye:blue",  nil,        nil,        3 },
	{ "turquoise",  "dye:spring",               "dye:cyan",       nil,         nil,        nil,        2 },
	{ "turquoise",  "dye:green",                "dye:cyan",       "dye:cyan",  nil,        nil,        3 },
	{ "turquoise",  "dye:green",                "dye:green",      "dye:green", "dye:blue", "dye:blue", 5 },
	{ "cyan",       "dye:green",                "dye:blue",       nil,         nil,        nil,        2 },
	{ "cerulean",   "dye:cyan",                 "dye:azure",      nil,         nil,        nil,        2 },
	{ "cerulean",   "dye:cyan",                 "dye:cyan",       "dye:blue",  nil,        nil,        3 },
	{ "cerulean",   "dye:green",                "dye:green",      "dye:blue",  "dye:blue", "dye:blue", 5 },
	{ "azure",      "dye:cyan",                 "dye:blue",       nil,         nil,        nil,        2 },
	{ "azure",      "dye:green",                "dye:blue",       "dye:blue",  nil,        nil,        3 },
	{ "sapphire",   "dye:azure",                "dye:blue",       nil,         nil,        nil,        2 },
	{ "sapphire",   "dye:cyan",                 "dye:blue",       "dye:blue",  nil,        nil,        3 },
	{ "sapphire",   "dye:green",                "dye:blue",       "dye:blue",  "dye:blue", nil,        4 },
	{ "indigo",     "dye:blue",                 "dye:violet",     nil,         nil,        nil,        2 },
	{ "violet",     "dye:blue",                 "dye:magenta",    nil,         nil,        nil,        2 },
	{ "mulberry",   "dye:violet",               "dye:magenta",    nil,         nil,        nil,        2 },
	{ "mulberry",   "dye:violet",               "dye:blue",       "dye:red",   nil,        nil,        3 },
	{ "magenta",    "dye:blue",                 "dye:red",        nil,         nil,        nil,        2 },
	{ "fuchsia",    "dye:magenta",              "dye:rose",       nil,         nil,        nil,        2 },
	{ "fuchsia",    "dye:blue",                 "dye:red",        "dye:rose",  nil,        nil,        3 },
	{ "fuchsia",    "dye:red",                  "dye:violet",     nil,         nil,        nil,        2 },
	{ "rose",       "dye:magenta",              "dye:red",        nil,         nil,        nil,        2 },
	{ "rose",       "dye:red",                  "dye:red",        "dye:blue",  nil,        nil,        3 },
	{ "crimson",    "dye:rose",                 "dye:red",        nil,         nil,        nil,        2 },
	{ "crimson",    "dye:magenta",              "dye:red",        "dye:red",   nil,        nil,        3 },
	{ "crimson",    "dye:red",                  "dye:red",        "dye:red",   "dye:blue", nil,        4 },

	{ "red",        "flowers:rose",             nil,              nil,         nil,        nil,        4 },
	{ "orange",     "flowers:tulip",            nil,              nil,         nil,        nil,        4 },
	{ "yellow",     "flowers:dandelion_yellow", nil,              nil,         nil,        nil,        4 },
	{ "green",      "default:cactus",           nil,              nil,         nil,        nil,        4 },
	{ "blue",       "flowers:geranium",         nil,              nil,         nil,        nil,        4 },
	{ "violet",     "flowers:viola",            nil,              nil,         nil,        nil,        4 },
	{ "black",      "default:coal_lump",        nil,              nil,         nil,        nil,        4 },
	{ "white",      "flowers:dandelion_white",  nil,              nil,         nil,        nil,        4 },
}

local shade_crafts = {
	{ "faint_",  "",     "dye:white",      "dye:white", "dye:white", 4 },
	{ "pastel_", "",     "dye:white",      "dye:white", nil,         3 },
	{ "light_",  "",     "dye:white",      nil,         nil,         2 },
	{ "bright_", "",     "color",          "dye:white", nil,         3 },
	{ "",        "_s50", "dye:light_grey", nil,         nil,         2 },
	{ "",        "_s50", "dye:black",      "dye:white", "dye:white", 3 },
	{ "medium_", "",     "dye:black",      nil,         nil,         2 },
	{ "medium_", "_s50", "dye:grey",       nil,         nil,         2 },
	{ "medium_", "_s50", "dye:black",      "dye:white", nil,         3 },
	{ "dark_",   "",     "dye:black",      "dye:black", nil,         3 },
	{ "dark_",   "_s50", "dye:dark_grey",  nil,         nil,         2 },
	{ "dark_",   "_s50", "dye:black",      "dye:black", "dye:white", 4 },
}

for _, i in ipairs(base_color_crafts) do
	local color = i[1]
  output.dye[color].recipe = { i[2], i[3], i[4], i[5], i[6] }

	for _, j in ipairs(shade_crafts) do
		local firstdye = j[3]
		if firstdye == "color" then
      firstdye = "dye:" .. color
    end

		-- ignore black, white, anything containing the word "grey"
		if color ~= "black" and color ~= "white" and not string.find(color, "grey") then
      local shade = string.format("%s%s%s", j[1], color, j[2])
      local recipe = {"dye:" .. color, firstdye, j[4], j[5]}
      output.dye[shade].recipe = recipe
		end
	end
end

-- greys
local grey_mix = {
  { 1,  "dye:black",      "dye:black",      "dye:black",      "dye:dark_grey", 4 },
  { 2,  "dye:black",      "dye:black",      "dye:dark_grey",  nil,	3 },
  { 3,  "dye:black",      "dye:dark_grey",  nil,              nil,	2 },
  { 4,  "dye:white",      "dye:black",      "dye:black",      nil,	3 },
  { 5,  "dye:dark_grey",  "dye:dark_grey",  "dye:grey",       nil,	3 },
  { 6,  "dye:dark_grey",  "dye:grey",       nil,              nil,	2 },
  { 7,  "dye:dark_grey",  "dye:grey",       "dye:grey",       nil,	3 },
  { 8,  "dye:white",      "dye:black",      nil,              nil,	2 },
  { 9,  "dye:grey",       "dye:grey",       "dye:light_grey", nil,	3 },
  { 10, "dye:grey",       "dye:light_grey", "dye:light_grey", nil,	3 },
  { 11, "dye:white",      "dye:white",      "dye:black",      nil,	3 },
  { 12, "dye:light_grey", "dye:light_grey", "dye:white",      nil,	3 },
  { 13, "dye:light_grey", "dye:white",      nil,              nil,	2 },
  { 14, "dye:white",      "dye:white",      "dye:light_grey", nil,	3 },
}

for _, i in ipairs(grey_mix) do
	local shade = i[1]
  local recipe = { i[2], i[3], i[4], i[5] }
	local color = "grey_" .. shade

	if shade == 4 then
		color = "dark_grey"
	elseif shade == 8 then
		color = "grey"
	elseif shade == 11 then
		color = "light_grey"
	end

  output.dye[color].recipe = recipe
end

-- other crafts
output.dye["dark_orange"].recipe = {
  "dye:brown", "dye:brown"
}

local sorted = {}
for n,v in pairs(output.dye) do
  table.insert(sorted, {
    dye = n,
    hex = v.hex,
    rgb = "(" .. table.concat(v.rgb, ", ") .. ")",
    recipe = table.concat(v.recipe, " + ")
  })
end

table.sort(sorted, function(a, b) return a.hex > b.hex end)

local o = {}
local trd = 
[[      <tr>
        <th style="background-color:%s">%s</th>
        <td>%s</td>
        <td>%s</td>
        <td>%s</td>
      </tr>]]

-- for n,v in pairs(output.dye) do
for _,v in ipairs(sorted) do

  -- local rgb = "(" .. table.concat(v.rgb, ", ") .. ")"
  -- local recipe = table.concat(v.recipe, ", ")
  o[#o+1] = string.format(trd, v.hex, v.dye, v.hex, v.rgb, v.recipe)

  -- o[#o+1] = string.format(trd, v.hex, n, v.hex, rgb, recipe)
end

local html_template = [[
  <table>
    <thead>
      <tr>
        <th>Dye Color</th>
        <th>#Hex</th>
        <th>(RGB)</th>
        <th>Recipe</th>
      </tr>
    </thead>
    <tbody>
%s
    </tbody>
  </table>
]]

local table_output = string.format(html_template, table.concat(o, "\n"))

print(table_output)



------------------------------------------------------------------------------------
-- MIT & GPL-2.0 License                                                          --
--                                                                                --
-- UnifiedDyes © GPL-2.0 https://github.com/mt-mods/unifieddyes                   --
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