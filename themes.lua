-------------------------------------------------------------
--  Carrot theming
-------------------------------------------------------------
--  Licensed under the GNU General Public License v3:
--  https://opensource.org/licenses/GPL-3.0
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
-------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful") -- Theme handling library

local file_readable = gears.filesystem.file_readable or awful.util.file_readable
local getGlobalThemesDir = gears.filesystem.get_themes_dir or awful.util.get_themes_dir

local function getUserThemesDir()
  return os.getenv("HOME") .. "/.config/awesome/themes/"
end

local function apply(name)
  local themePaths = {
    getUserThemesDir() .. name .. "/theme.lua",
    getGlobalThemesDir() .. name .. "/theme.lua"
  }

  local themePath = ""
  for k, v in pairs(themePaths) do
    if file_readable(v) then
      themePath = v

      break
    end
  end

  if "" == themePath then
    error(string.format("Cannot load theme `%s`", name))
  end

  beautiful.init(themePath)
end

return {
  Apply = apply;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
