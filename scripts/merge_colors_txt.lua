-- merge_colors_txt.lua
-- Copyright © 2026 monk (https://github.com/monk-afk)
-- SPDX-License-Identifier: MIT

local line_patterns = {
  "^#%s+([%w_]+)$",  -- mod name header: # 3d_armor_stand
  "^([%w_]+):([%w_]+)%s+([%d%s]+)$",  -- node string and color: 3d_armor_stand:top 0 0 0
}


local string_match = string.match
local function match_line_pattern(line)
  for _, pattern in ipairs(line_patterns) do
    local mod_name, node_name, rgb = string_match(line, pattern)

    if mod_name then
      return mod_name, node_name, rgb
    end
  end
end


local function collect_data(colors_txt, nodes)
  for line in io.lines(colors_txt) do
    local mod_name, node_name, rgb = match_line_pattern(line)

    if mod_name and not (node_name and rgb)  then
      if not nodes[mod_name] then
        nodes[mod_name] = {}
      end

    elseif mod_name and node_name and rgb then
      local node_entry = nodes[mod_name][node_name]

      if not node_entry then
        nodes[mod_name][node_name] = rgb
      end
    end
  end
end


local function sort_data(nodes)
  local t = {}
  for mod_name, mod_nodes in pairs(nodes) do
    local node_list = {}

    for node_name, rgb in pairs(mod_nodes) do
      node_list[#node_list + 1] = {node_name, rgb}
    end

    table.sort(node_list, function(a, b) return a[1] < b[1] end)

    t[#t + 1] = {mod_name, node_list}
  end

  table.sort(t, function(a, b) return a[1] < b[1] end)

  return t
end


local function rebuild_colors_txt(...)
  local nodes = {}
  local colors_txt_files = {...}
  local master_colors_txt = colors_txt_files[1]

  for _, filename in ipairs(colors_txt_files) do
    collect_data(filename, nodes)
  end

  nodes = sort_data(nodes)

  local file_out = io.open(master_colors_txt, "w")
  for _, mod in ipairs(nodes) do
    local mod_name = mod[1]
    local mod_nodes = mod[2]

    file_out:write(string.format("# %s\n", mod_name))

    for _, node in ipairs(mod_nodes) do
      local node_name = node[1]
      local rgb = node[2]

      file_out:write(
        string.format("%s:%s %s\n", mod_name, node_name, rgb)
      )
    end

    file_out:write("\n")
  end

  file_out:close()
end

rebuild_colors_txt("colors.txt", "colors_new.txt")
