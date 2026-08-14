-- SquareOne CMS
-- Copyright © 2026 monk (https://github.com/monk-afk)
-- SPDX-License-Identifier: MIT
local landing_page = [[
              <li%s>
                <a href="/%s.html" aria-expanded="%s" class="sidebar-brand">
                  <img src="/images/squareone_text.png" id="sidebar-logo" alt="SquareOne">
                </a>
              </li>
]]

local drop_menu_selector = [[
              <li class="%s">
                <a href="#" class="%shas-arrow webkitNoSelect" aria-expanded="%s">MOD INFO</a>
                <ul class="mm-collapse">
%s                </ul>
              </li>
]]

local menu_item_page = [[
                  <li%s><a href="/%s.html" aria-expanded="%s" class="%swebkitNoSelect">%s</a></li>
]]

-- ["filename"] = "menu title"
local menu_pages = {
  {["index"] = "SPAWN"},
  {["rules"] = "RULES"},
  {["staff"] = "STAFF"},
  {["guide"] = "GUIDE"},
  {["map"]   = "MAPS"},
  {
    ["mod_info"] = {
      title = "MOD INFO",
      pages = {
        {["economy"] = "Economy"},
        {["tools"]   = "Tools"},
        {["armor"]   = "Armor"},
        {["exp"]     = "Exp"},
        {["mining"]  = "Mining"},
        {["crystal"] = "Crystal"},
        {["protect"] = "Protect"},
      }
    }
  },
  {["faq"] = "FAQs"},
}

local li_class = function(active) return active and ' class="mm-active"' or "" end

local a_class  = function(active) return active and "mm-active " or "" end

local aria_exp = function(active) return active and "true" or "false" end

local page_select = function(is_index, page_key)
  local page_name = is_index and page_key or string.format("pages/%s", page_key)
  local list_item = is_index and landing_page or menu_item_page
  return list_item, page_name
end

local function generate_sidebar(active_page)
  local html_output = {}

  for menu_index, page in ipairs(menu_pages) do
    if type(page) == "table" and page.mod_info then
      local is_dropdown_active = false
      local submenu_items = {}

      for _, sub_page in ipairs(page.mod_info.pages) do
        for sub_page_key, sub_page_title in pairs(sub_page) do
          local is_active = (sub_page_key == active_page)
          if is_active then
            is_dropdown_active = true
          end

          table.insert(submenu_items,
              string.format(menu_item_page,
                  li_class(is_active), "pages/" .. sub_page_key,
                  aria_exp(is_active), a_class(is_active),
                  sub_page_title
              )
          )
        end
      end

        -- dropdown
      table.insert(html_output,
          string.format(drop_menu_selector,
              li_class(is_dropdown_active),
              a_class(is_dropdown_active),
              aria_exp(is_dropdown_active),
              table.concat(submenu_items)
          )
      )

    else
      -- non-dropdown pages
      for page_key, page_title in pairs(page) do
        local is_active = (page_key == active_page)
        local list_item, page_name = page_select(menu_index == 1, page_key)
        table.insert(html_output,
            string.format(list_item,
                li_class(is_active), page_name,
                aria_exp(is_active), a_class(is_active), page_title
            )
        )
      end
    end
  end

  return table.concat(html_output, "\n")
end

return generate_sidebar
-- bottom one for testing, just do  `$ lua macro_nav.lua index`
-- return arg[1] and print(generate_sidebar(arg[1])) or generate_sidebar
