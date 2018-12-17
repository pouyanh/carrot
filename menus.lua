-------------------------------------------------------------
--  Carrot launcher menu
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
--  Licensed under the GNU General Public License v2:
--  https://opensource.org/licenses/GPL-2.0
-------------------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful") -- Theme handling library
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Launcher menu
local function new(apps)
  local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end},
    { "manual", apps.terminal .. " -e man awesome" },
    { "edit config", apps.geditor .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end}
  }

  local menu = awful.menu({
    items = {
      { "awesome", myawesomemenu, beautiful.awesome_icon },
      { "open terminal", apps.terminal }
    }
  })

  --local menu = freedesktop.menu.build({
  --  icon_size = beautiful.menu_height or 16,
  --  before = {
  --    { "Awesome", myawesomemenu, beautiful.awesome_icon },
  --    -- other triads can be put here
  --  },
  --  after = {
  --    { "Open terminal", terminal },
  --    -- other triads can be put here
  --  }
  --})
  
  return menu
end

return {
  New = new;
}
