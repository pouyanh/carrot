-------------------------------------------------------------
--  Carrot error handling
-------------------------------------------------------------
--  Licensed under the GNU General Public License v3:
--  https://opensource.org/licenses/GPL-3.0
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
-------------------------------------------------------------

local naughty = require("naughty") -- Notification library

-- {{{ Error handling
local function handle()
  -- Check if awesome encountered an error during startup and fell back to
  -- another config (This code will only ever execute for the fallback config)
  if awesome.startup_errors then
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
    })
  end

  -- Handle runtime errors after startup
  do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
      -- Make sure we don't go into an endless error loop
      if in_error then
        return
      end
      in_error = true

      naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err)
      })
      in_error = false
    end)
  end
end
-- }}}

return {
  Handle = handle;
}
