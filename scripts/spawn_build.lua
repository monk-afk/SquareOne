--[[
  This is the math used to create the (now demolished) Spawn building.
  It features a Menger Cube, twisted by the spiral of the Golden Ratio,
  and also some random math functions which may or may not serve a purpose.

  Intended to be used with a chat command; it will generate the structure
  in 12 slices (preserving RAM), with the center at 0,0,0.
]]

local floor = math.floor
local function is_wall(x, y, z)
  while x > 0 or y > 0 or z > 0 do
    if (x % 2 == 1 and y % 2 == 1) or 
      (x % 2 == 1 and z % 2 == 1) or 
      (y % 2 == 1 and z % 2 == 1) then
      return false
    end
    x = floor(x / 3)
    z = floor(z / 3)
    y = floor(y / 3)
  end
  return true
end

local function frexprt(n)
  local fr, exp = math.frexp(n)
  local frsqrt = math.sqrt(fr*exp)
  return frsqrt * exp
end

local function plot_structure(size, slice)
  local startslice = (slice * 12) - 12
  local endslice = startslice + 12
  local pos = {}
  for x = startslice, endslice, 0.23 do
    for y = 1, size do
      for z = 1, size, 0.15 do
        if is_wall(x, y, z) then
          pos[#pos+1] = {x,y,z}
        end
      end
    end
  end
  return pos
end

minetest.chat_send_all(minetest.colorize("#F30023","Generating Spawn! "..os.date()))
local node_name = "default:silver_sandstone_block"
for slice = 1,12 do
  local size = 144
  minetest.chat_send_all(minetest.colorize("#F30023","Generating Spawn Progress: "..slice.."/12! "..os.date()))
  local coords, pos = plot_structure(size, slice), {}
  if #coords >= 1 then
    for p = 1, #coords do
      local x = coords[p][1]
      local y = coords[p][2]
      local z = coords[p][3]
      local fe = frexprt(z)
      pos[#pos+1] = {
        x = floor((x * math.cos(fe)) + 0.5),
        y = floor((((y + math.sqrt(5) / 2) % (fe * math.pi * 2)) + 2) + 0.5),
        z = floor((z * math.sin(fe)) + 0.5)
      }
    end
    minetest.bulk_set_node(pos, {name=node_name})
  end
end
minetest.chat_send_all(minetest.colorize("#F30023","DONE! "..os.date()))