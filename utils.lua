-------------------------------------------------------------
--  Carrot utilities
-------------------------------------------------------------
--  Licensed under the GNU General Public License v2:
--  https://opensource.org/licenses/GPL-2.0
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
-------------------------------------------------------------

local function merge(t, tp)
  for k, v in pairs(tp) do
    if "table" == type(v) then
      if "table" == type(t[k] or false) then
        t[k] = merge(t[k] or {}, tp[k] or {})
      else
        t[k] = v
      end
    else
      t[k] = v
    end
  end

  return t
end

local function fileExists(path)
  fp = io.open(path, "r")
  if nil == fp then
    return false
  end

  fp:close()

  return true
end

return {
  Merge = merge;
  FileExists = fileExists;
}
