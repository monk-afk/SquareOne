-- this file will create colored textures from a greyscale template file
-- it should work with any texture. first it will convert to grayscale,
-- then normalize contrast, then apply fill color and colorize blend 70%
-- output: "./colorized_textures/coloredblocks/wood/coloredblocks_wood_red.png"

local mod_name = "coloredblocks"

local nodes = {
  "wood",
  "stone",
}

local colors = {
  red        = "255,0,0",
  pink       = "255,156,255",

  blue       = "0,0,125",
  light_blue = "0,128,255",
  cyan       = "0,255,255",

  green      = "0,205,0",
  chartreuse = "128,255,0",
  dark_green = "32,128,32",

  yellow     = "255,255,128",
  orange     = "255,156,64",

  purple     = "128,0,128",
  magenta    = "255,64,255",
  black      = "32,32,32",
}

for color_name, rgb in pairs(colors) do
  for _, node_name in ipairs(nodes) do

    local original_image = mod_name .. "_" .. node_name .. ".png"
    local out_dir = "colorized_textures/" .. mod_name .. "/" .. node_name .. "/"

    os.execute("mkdir -p " .. out_dir)

    local out_file = out_dir .. mod_name .. "_" .. node_name .. "_" .. color_name .. ".png"

    local cmd = string.format(
      [[convert "%s" -colorspace Gray -normalize -fill "rgb(%s)" -colorize 70%% "%s"]],
      original_image, rgb, out_file
    )

    print("creating: ", out_file)
    os.execute(cmd)
  end
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
