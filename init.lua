-------------------------------------------------------------
--  Carrot main application
-------------------------------------------------------------
--  Licensed under the GNU General Public License v2:
--  https://opensource.org/licenses/GPL-2.0
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
-------------------------------------------------------------

local awful = require("awful")
local menubar = require("menubar")

local Root = require("carrot.root") -- Root keys and rules
local Menus = require("carrot.menus")
local Errors = require("carrot.errors") -- Error handling
local Themes = require("carrot.themes") -- Themes manager
local Clients = require("carrot.clients") -- Clients (Windows) keys and rules
local Configs = require("carrot.configs") -- Configuration parser
local Screens = require("carrot.screens") -- Screen wibox

local function loadConfiguration()
  -- TODO: Load configurations from different locations
  local conf = Configs.LoadFile(os.getenv("HOME") .. "/.config/awesome/config")

  return conf
end

local function registerErrorHandlers()
  Errors.Handle()
end

local function start()
  registerErrorHandlers()

  local conf = loadConfiguration()
  local menu = Menus.New(conf.apps)

  Root.Setup(conf, menu)

  Themes.Apply(conf.theme)
  Clients.Setup(conf)
  Screens.Setup(conf, menu)

  -- TODO: Read autosrun apps from config and standard files and load them on
  -- desired screens (tag them)
  -- awful.util.spawn_with_shell("~/.config/awesome/autorun.sh")
end

return {
  Start = start;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
