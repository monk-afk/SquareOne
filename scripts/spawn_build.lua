--[[ This is the function used to generate the (now demolished) Spawn building.
    It is a Menger Sponge twisted by the spiral of the Golden Ratio. ]]
local function generate_spawn2(name)
  local function is_wall(x, y, z) -- slightly modified menger sponge generator
    while x > 0 or y > 0 or z > 0 do
      if (x % 2 == 1 and y % 2 == 1) or
        (x % 2 == 1 and z % 2 == 1) or
        (y % 2 == 1 and z % 2 == 1) then
        return false
      end
      x = math.floor(x / 3)
      y = math.floor(y / 3)
      z = math.floor(z / 3)
    end
    return true
  end

  local function frexprt(n)
    local fr, exp = math.frexp(n)
    return math.sqrt(fr*exp) * exp
  end

  local function generate_structure(ppos)
    minetest.chat_send_all(minetest.colorize("#F30023", "Warning: Generating Structure! Expect lag!"))
    local node_name = "default:silver_sandstone_block"
    local size = 144
    local step = 0.1
    local batch_size = 1000
    local sub_slices = 4

    for slice = 1, 12 do
      minetest.chat_send_all(minetest.colorize("#F30023", "Progress: " .. slice .. "/12!"))
      local slice_start = (slice * 12) - 12
      local slice_end = slice_start + 12
      local sub_step = (slice_end - slice_start) / sub_slices

      for sub = 0, sub_slices - 1 do
        local start_x = slice_start + sub * sub_step
        local end_x = start_x + sub_step
        local batch = {}
        local seen = {}

        for xi = start_x, end_x, step do
          for y = 1, size do
            for zi = 0, (size-1) / step do
              local z = 1 + zi * step

              if is_wall(xi, y, z) then
                local F = z
                local fe = frexprt(F)
                local x = math.floor(xi * math.cos(fe) + 0.5)
                local y_pos = math.floor(((y + math.sqrt(5) / 2) % (fe * math.pi * 2)) + 2 + 0.5)
                local z_pos = math.floor(F * math.sin(fe) + 0.5)
                local key = string.format("%s_%s_%s", x, y_pos, z_pos)

                if not seen[key] then
                  seen[key] = true
                  batch[#batch+1] = {x = ppos.x + x, y = ppos.y + y_pos, z = ppos.z + z_pos}

                  if #batch >= batch_size then
                    minetest.bulk_set_node(batch, {name = node_name})
                    batch = {}
                  end
                end
              end
            end
          end
        end

        if #batch > 0 then
          minetest.bulk_set_node(batch, {name = node_name})
        end
      end
    end
    minetest.chat_send_all(minetest.colorize("#F30023", "DONE!"))
  end

  local player = minetest.get_player_by_name(name)
  local ppos = vector.round(player:get_pos())
  ppos.y = ppos.y - 1
  generate_structure(ppos)
end

return generate_spawn2
