--[[ Lua script for generating mapper images with minetestmapper
  To use:
    - Place this file in the same folder as minetestmapper binary
    - Run from command line:

      $ lua make_map_images.lua [params]

    Accepted parameters:
      grid        Automates image creation using a grid with each image being 4096px with 0,0 being the center
        - note: grid does not accept parameters at this time.
      x=0         Focuses the center x coordinate
      z=0         Focuses the center z coordinate
      d=16        Size of the output image in pixels (min 16)
]]
local M = 30720

local server = "~/squareone/worlds/world/"
local images = "~/mapper_images/"
local option = "--backend postgresql --noemptyimage --colors colors.txt --max-y 400 --min-y -20"


local function generate_image_at(x, z, d)
  local a = math.floor(d/2)
  local ax, az = x+(-a), z+(-a)

  local exec_string = string.format(
    "./minetestmapper %s -i %s -o %ssquareone_x%s_z%s_%s.png --geometry %s:%s+%s+%s;",
      option, server, images, x, z, os.date("%F"), ax, az, d, d)

  os.execute(exec_string)
end

if arg[1] == "grid" then
  local max_pos = 12288
  local d = 4096
  for x = -max_pos, max_pos, d do
    for z = -max_pos, max_pos, d do
      generate_image_at(x, z, d)
      print("Generated image: (" .. x .. ", " .. z .. ")")
    end
  end

else
  local cmd = {}
  for p = 1, #arg do
    cmd[p] = string.gsub(arg[p], "([xzd])=(%-?%d+)",
      function(param, val)
        cmd[param] = tonumber(val)
        return param, val
      end)
  end

  local d = math.max(math.min(M, tonumber(cmd.d) or 256), 16)
  local x = tonumber(cmd.x)
  local z = tonumber(cmd.z)

  if not (x and z and d) then
    print("Please provide all options: dimention and coordinates x and z:")
    print("    x=  Point of coordinate on X axis")
    print("    z=  Point of coordinate on Z axis")
    print("    d=  Dimensions of a square image W:H")
    print("Usage: lua mapper.lua x=1 z=-1 d=256")
    return
  end

  if x >= -M and x <= M and z >= -M and z <= M then
    generate_image_at(x, z, d)
      print("Image at coordinates: (" .. x .. ", " .. z .. ")")
  else
    print("Please use coordinates between " .. -M .. " and " .. M .. ".")
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