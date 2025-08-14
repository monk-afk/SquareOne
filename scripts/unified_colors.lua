local output = {
  dye = {}, recipe = {}
}

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
	{ "crimson",    0xff, 0x00, 0x40 },

	{ "black",      0x00, 0x00, 0x00 },
  { "grey_1",     0x11, 0x11, 0x11 },
  { "grey_2",     0x22, 0x22, 0x22 },
  { "grey_3",     0x33, 0x33, 0x33 },
  { "grey_5",     0x55, 0x55, 0x55 },
	{ "dark_grey",  0x44, 0x44, 0x44 },
  { "grey_6",     0x66, 0x66, 0x66 },
  { "grey_7",     0x77, 0x77, 0x77 },
	{ "grey",       0x88, 0x88, 0x88 },
  { "grey_9",     0x99, 0x99, 0x99 },
  { "grey_a",     0xaa, 0xaa, 0xaa },
	{ "light_grey", 0xbb, 0xbb, 0xbb },
  { "grey_c",     0xcc, 0xcc, 0xcc },
  { "grey_d",     0xdd, 0xdd, 0xdd },
  { "grey_e",     0xee, 0xee, 0xee },
	{ "white",      0xff, 0xff, 0xff },
}

local function clamp01(x) return math.max(0, math.min(1, x)) end

local function hex_to_rgb01(hex)
  hex = hex:gsub("^#", "")
  if #hex == 3 then
    hex = hex:sub(1,1) .. hex:sub(1,1)
      .. hex:sub(2,2) .. hex:sub(2,2)
      .. hex:sub(3,3) .. hex:sub(3,3)
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
  { ["faint_"]  = { kind = "white", t = 0.70 }},
  { ["pastel_"] = { kind = "white", t = 0.60 }},
  { ["light_"]  = { kind = "white", t = 0.50 }},
  { ["bright_"] = { kind = "white", t = 0.20 }},
  { [""]        = { kind = "none",  t = 0 }},
  { ["medium_"] = { kind = "black", t = 0.35 }}, -- darken to 65% brightness
  { ["dark_"]   = { kind = "black", t = 0.62 }}, -- darken more
}

for _, h in ipairs(hues) do
  local hue, r, g, b = h[1], h[2], h[3], h[4]
  -- add base hue to output
  local hex = string.format("#%02x%02x%02x", r, g, b)
  output.dye[hue] = output.dye[hue] or {}
  output.dye[hue].hex = hex
  output.dye[hue].rgb = { r, g, b }

  if hue ~= "white" and hue ~= "black" and not string.find(hue, "grey") then
    for v, map in ipairs(value_map) do
      local val = next(value_map[v])
      local vm = value_map[v][val] or { kind = "none", t = 0 }

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
      local rgb2 = {
        math.floor(sr2 * 255 + 0.5),
        math.floor(sg2 * 255 + 0.5),
        math.floor(sb2 * 255 + 0.5)
      }

      local dye_name = val .. hue
      output.dye[dye_name] = output.dye[dye_name] or {}
      output.dye[dye_name].hex = hex2
      output.dye[dye_name].rgb = rgb2

      if v > 4 then -- 4,5,6
        -- produce low-saturation (50%) version: desaturate in linear space by 50%
        local dlr, dlg, dlb = desaturate_rgb_linear(lr2, lg2, lb2, 0.5)
        local dsr, dsg, dsb = linear_to_srgb(dlr), linear_to_srgb(dlg), linear_to_srgb(dlb)
        local hex3 = rgb01_to_hex(dsr, dsg, dsb)
        local rgb3 = {
          math.floor(dsr * 255 + 0.5),
          math.floor(dsg * 255 + 0.5),
          math.floor(dsb * 255 + 0.5)
        }
        local dye_name_low_sat = dye_name .. "_s50"
        output.dye[dye_name_low_sat] = output.dye[dye_name_low_sat] or {}
        output.dye[dye_name_low_sat].hex = hex3
        output.dye[dye_name_low_sat].rgb = rgb3
      end
    end
  end
end

local sorted = {}
for n,v in pairs(output.dye) do
  table.insert(sorted, {
    dye = n,
    hex = v.hex,
    rgb = table.concat(v.rgb, ","),
  })
end

table.sort(sorted, function(a, b) return a.hex > b.hex end)

for _,v in ipairs(sorted) do
  local color_name = v.dye
  local rgb = v.rgb
  local hex = v.hex
  -- local cmd = string.format(
  --     [[convert "%s" -colorspace Gray -normalize -fill "rgb(%s)" -colorize 65%% "%s" -compose Over -composite "%s"]],
  --     brick_template, rgb, mortar_image, out_file)
  -- os.execute(cmd)
  io.write(color_name, ", RGB: (", rgb, "), Hex: ", hex, "\n")
end
------------------------------------------------------------------------------------
-- MIT                                                                            --
--                                                                                --
-- Copyright © 2025 monk (Discord ID: monk.moe)                                   --
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