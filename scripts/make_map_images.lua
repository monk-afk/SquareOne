local function help_message()
  io.write([[ Generate Luanti(Minetest) Map Images
  Requirements:
    - minetestmapper binary
    - colors.txt

  To use:
    - Open this file for editing and configure the local variables:
        local server = "world of your server"
        local images = "where the images will be placed"
        * TODO: local max_y, min_y = max height, min height of captured image

    - Run from command line:

      $ lua mapper.lua [params]
      $ lua mapper.lua x=1 z=-1 d=256

  Accepted parameters:
      grid    Automates image creation using a grid with each image being 4096px with 0,0 being the center
      x=[N]   Focus point of coordinate on X axis
      z=[N]   Focus point of coordinate on Z axis
      d=[N]   Optional Dimention of the output image in pixels (Default 16)
]]); io.stdout:flush()
end


local today = os.date("%F")
local server = "${HOME}/squareone/worlds/world/"
local images = "${PWD}/generated_images/" .. today .. "/"
os.execute("mkdir -p " .. images)

local option = "--backend postgresql --noemptyimage --colors colors.txt --max-y 120 --min-y -12"
local exec_string = "${PWD}/minetestmapper %s -i %s -o %ssquareone_x%s_z%s.png --geometry %s:%s+%s+%s;"

local function generate_image_at(x, z, d)
  local a = math.floor(d / 2)
  local ax, az = x+(-a), z+(-a)
  local exec_format = string.format(
      exec_string, option, server, images, x, z, ax, az, d, d
    )
  os.execute(exec_format)
end


local function process_grid()
  local d = 4096
  local grid = 6 -- this must be multiples of 2
  local max_pos = (d * grid) // 2
  for x = -max_pos, max_pos, d do
    for z = -max_pos, max_pos, d do
      generate_image_at(x, z, d)
      io.write("Generated image: (", x, ", ", z, ")\n"); io.stdout:flush()
    end
  end
  os.execute("echo " .. today .. " > " .. images .. "last_update.txt")
end


local function process_command(arg)
  if arg[1] == "grid" then
    return process_grid()
  end

  local cmd = {}
  for p = 1, #arg do
    cmd[p] = string.gsub(arg[p], "([xzd])=(%-?%d+)",
      function(param, val)
        cmd[param] = tonumber(val)
        return param, val
      end)
  end

  local M = 30720
  local d = math.max(math.min(M, tonumber(cmd.d) or 256), 16)
  local x = tonumber(cmd.x)
  local z = tonumber(cmd.z)
  local y = tonumber(cmd.y)

  if not (x and z and d) or cmd.help or cmd.h then
    return help_message()
  elseif x < -M or z < -M
      or x >  M or z >  M then
    io.write("Please use coordinates between ", -M, " and ", M, ".\n"); io.stdout:flush()
    return
  else
    io.write("Generating Image at Center Coordinates: (", x, ", ", z, ")\n"); io.stdout:flush()
    generate_image_at(x, z, d)
  end
end

process_command(arg)


-- - Build minetestmapper binary from the GitHub repo:
--       https://github.com/luanti-org/minetestmapper

-- - In minetestmapper directory, locate the file: util/dumpnodes/init.lua
--   - There is a chat command, add it to a mod and use it in-game.
--   - Locate the nodes.txt file created in worldpath.

-- - In minetestmapper directory, locate the file: util/generate_colorstxt.py, Run with args:
--   $ ./util/generate_colorstxt.py -g /full/path/worlds/world -m /full/path/worlds/world /full/path/worlds/world/nodes.txt


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
