-------------------------------------------------------------
--  Carrot configuration library
-------------------------------------------------------------
--  Licensed under the GNU General Public License v2:
--  https://opensource.org/licenses/GPL-2.0
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
-------------------------------------------------------------

local Utils = require("carrot.utils")

local DEFAULT = {
  theme = "multicolor",
  mod = "Mod4",
  alt = "Mod1",
  tags = {"1", "2", "3", "4", "Mid", "6", "7", "8", "9"},
  apps = {
    terminal = "uxvt",
    editor = os.getenv("EDITOR") or "vim",
    geditor = "atom",
    browser = "firefox",
    explorer = "thunar",
    locker = "slock",
    shoter = "scrot",
  }
}

local function read(path)
  local conf = {}
   
  fp = io.open(path, "r")
  if nil == fp then
    return {}
  end
   
  for line in fp:lines() do
    line = line:match("%s*(.+)")
    -- Ignore commented lines
    if line and line:sub(1, 1) ~= "#"
      and line:sub(1, 1) ~= ";" then
      local option = line:match("%S+"):lower()
      local value  = line:match("%S*%s*(.*)")
      local last = option:match("%.?(%w+)$")

      local item = conf
      for nxt in option:gmatch("%s*(.-)%.") do
        item[nxt] = item[nxt] or {}
        item = item[nxt]
      end
     
      if not value then
        value = true
      else
        if value:find(",") then
          value = value .. ","
          local arr = {}
          for entry in value:gmatch("%s*(.-),") do
            arr[#arr + 1] = entry
          end
          value = arr
        end
      end

      item[last] = value
    end
  end
   
  fp:close()

  return conf
end

local function loadFile(path)
  local d = DEFAULT

  return Utils.Merge(d, read(path))
end

return {
  DEFAULT = DEFAULT;
  LoadFile = loadFile;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
