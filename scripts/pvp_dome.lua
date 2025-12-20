local function safe_set(pos, nodename)
  local node = minetest.get_node_or_nil(pos)
  if node and node.name ~= "ignore" then
    minetest.set_node(pos, {name = nodename})
  end
end

-- builds a flat circular disc or ring at given Y offset
local function build_disc(tasks, cx, cy, cz, outer_radius, floor_mat, height_offset, inner_radius)
  local y = cy + height_offset
  inner_radius = inner_radius or 0  -- 0 = solid disc
  for dx = -outer_radius + 1, outer_radius - 1 do
    for dz = -outer_radius + 1, outer_radius - 1 do
      local dist2 = dx * dx + dz * dz
      if dist2 <= (outer_radius - 1) ^ 2 and dist2 >= inner_radius ^ 2 then
        table.insert(tasks, {
          pos = {x = cx + dx, y = y, z = cz + dz},
          nodename = floor_mat
        })
      end
    end
  end
end


local function build_dome_at(
  center, radius, dome_lower, dome_upper, thickness, floor_mat, lights_mat, lights_every, player_name
)

  local cx, cy, cz = center.x, center.y, center.z
  local tasks = {}

  -- full solid floor
  build_disc(tasks, cx, cy, cz, radius, floor_mat, 0)
  build_disc(tasks, cx, cy, cz, radius + 4, "coloredblocks:obsidian_white", 0, (radius - 16))
  -- observation rings
  build_disc(tasks, cx, cy, cz, radius, floor_mat, 6, (radius - 12))
  build_disc(tasks, cx, cy, cz, radius, floor_mat, 10, (radius - 10))
  build_disc(tasks, cx, cy, cz, radius - 1, floor_mat, 14, (radius - 8))

  -- dome shell
  for dy = 0, radius do
    local y = cy + dy
    for dx = -radius, radius do
      for dz = -radius, radius do
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

        if dist <= radius and dist > (radius - thickness) then
          local pos = {x = cx + dx, y = y, z = cz + dz}

          if dy >= 5 then
            if dz % lights_every == 0 or dx % lights_every == 0 then
              table.insert(tasks, {pos = pos, nodename = lights_mat})
            else
              table.insert(tasks, {pos = pos, nodename = dome_upper})
            end
          else
            table.insert(tasks, {pos = pos, nodename = dome_lower})
          end
        end
      end
    end
  end

  -- avoid blocking
  local idx = 1
  local chunk = 300  -- nodes per tick
  local total = #tasks
  minetest.chat_send_player(player_name, ("Dome: scheduling %d node operations (radius=%d). This may take a few seconds."):format(total, radius))

  local function do_chunk()
    local done = 0
    for n = 1, chunk do
      if idx > total then break end
      local t = tasks[idx]
      safe_set(t.pos, t.nodename)
      idx = idx + 1
      done = done + 1
    end
    if idx <= total then
      -- queue next chunk
      minetest.after(0.01, do_chunk)
    else
      minetest.chat_send_player(player_name, "Dome: finished placing nodes.")
    end
  end

  do_chunk()
end

local function build_dome(player_name)
  local dome_lower = "coloredblocks:obsidian_white"
  local dome_upper = "coloredblocks:stone_block_black"
  local floor_mat = "default:silver_sandstone"
  local lights_mat = "default:obsidian_lantern"
  local thickness = 1
  local radius = 50
  local lights_every = 10

  local player = minetest.get_player_by_name(player_name)
  if not player then return false, "Player not found" end

  local pos = vector.round(player:get_pos())

  local center = {x = pos.x, y = pos.y - 1, z = pos.z}

  build_dome_at(center, radius, dome_lower, dome_upper, thickness, floor_mat, lights_mat, lights_every, player_name)

  return true
end

return build_dome
