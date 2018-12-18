-------------------------------------------------------------
--  Carrot clients key bindings and rules
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
--  Licensed under the GNU General Public License v3:
--  https://opensource.org/licenses/GPL-3.0
-------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful") -- Theme handling library
local wibox = require("wibox") -- Widget and layout library
local lain = require("lain")
local vicious = require("vicious") -- Vicious Widgets
local freedesktop = require("freedesktop") -- Freedesktop.org menu and desktop icons support for Awesome WM

local _t = gears.table or awful.util.table -- 4.{0,1} compatibility
local markup = lain.util.markup

-- {{{ Actions
local function toggleClientMenu()
  local instance = nil

  return function ()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({theme = {width = 250}})
    end
  end
end

local function setScreenWallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
-- }}}

-- {{{ Layouts Setup
local function setupLayouts()
  awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    lain.layout.cascade,
    lain.layout.cascade.tile,
    lain.layout.centerwork,
    lain.layout.centerwork.horizontal,
    lain.layout.termfair,
    lain.layout.termfair.center,
  }

  -- Table of layouts to cover with awful.layout.inc, order matters.
  lain.layout.termfair.nmaster = 3
  lain.layout.termfair.ncol = 1
  lain.layout.termfair.center.nmaster = 3
  lain.layout.termfair.center.ncol = 1
  lain.layout.cascade.tile.offset_x = 2
  lain.layout.cascade.tile.offset_y = 32
  lain.layout.cascade.tile.extra_padding = 5
  lain.layout.cascade.tile.nmaster = 5
  lain.layout.cascade.tile.ncol = 2
end
-- }}}

-- {{{ Screen Setup
-- Screen builder
local function newScreenBuilder(tags, apps, builders)
  -- Create a wibox for each screen and add it
  return (function(s)
    -- Each screen has its own tag table.
    awful.tag(tags, s, awful.layout.layouts[1])

    -- Unique per screen
    s.mytaglist = builders.taglist(s)
    s.mypromptbox = builders.promptbox(s)
    s.mytasklist = builders.tasklist(s)
    s.mylayoutbox = builders.layoutbox(s)

    -- Common between screens
    local mylauncher = builders.launcher(s)
    local mykeyboardlayout = builders.kbdlayout(s)
    local mybattery = builders.battery(s)
    local mysystray = builders.systray(s)
    local mytextclock = builders.clock(s)

    -- Create the top wibox
    s.mywibox = awful.wibar({
      position = "top",
      screen = s,
    })

    -- Add widgets to the wibox
    s.mywibox:setup({
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        mysystray,
        mykeyboardlayout,
        mybattery,
        mytextclock,
        s.mylayoutbox,
      },
    })

    -- Wallpaper
    setScreenWallpaper(s)

    -- Quake application
    s.quake = lain.util.quake({ app = apps.terminal })

    -- Let theme create wibox
    -- beautiful.at_screen_connect(s)
  end)
end
-- }}}

-- {{{ Widgets Builders
-- Launcher
local function newLauncherBuilder(menu)
  return (function(s)
    local launcher = awful.widget.launcher({
      image = beautiful.awesome_icon or (awesome.icon_path .. "/awesome16.png"),
      menu = menu,
    })

    return launcher
  end)
end

-- Taglist
local function newTaglistBuilder(modkey)
  local buttons = _t.join(
    awful.button({}, 1, function(t)
      t:view_only()
    end),
    awful.button({modkey}, 1, function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
  )

  return (function(s)
    return awful.widget.taglist(s, awful.widget.taglist.filter.all, buttons)
  end)
end

-- Promptbox
local function newPromptboxBuilder()
  return (function(s)
    return awful.widget.prompt()
  end)
end

-- Tasklist
local function newTasklistBuilder()
  local buttons = _t.join(
    -- Left mouse button: minimize/restore
    awful.button({}, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() and c.first_tag then
          c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
      end
    end),

    -- Middle mouse button: quit
    awful.button({}, 2, function (c)
      c:kill()
    end),

    -- Right mouse button: client menu
    awful.button({}, 3, toggleClientMenu),

    -- Mouse wheel up: next client in current tag
    awful.button({}, 4, function ()
      awful.client.focus.byidx(1)
    end),

    -- Mouse wheel down: previouse client in current tag
    awful.button({}, 5, function ()
      awful.client.focus.byidx(-1)
    end)
  )

  return (function(s)
    return awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, buttons)
  end)
end

-- Keyboard map indicator and switcher
local function newKeyboardLayoutBuilder()
  return (function(s)
    return awful.widget.keyboardlayout()
  end)
end

-- Battery status indicator
local function newBatteryBuilder()
  return (function(s)
    local battery = lain.widget.bat({
      settings = (function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
          perc = perc .. " plug"
        end

        widget:set_markup(markup.fontfg(beautiful.font, "#aaaaaa", perc .. " "))
      end)
    })

    return battery.widget
  end)
end

-- Systray
local function newSystrayBuilder()
  return (function(s)
    return wibox.widget.systray()
  end)
end

-- Create a textclock widget
local function newClockBuilder()
  return (function(s)
    local clock = wibox.widget.textclock(markup("#7788af", "%A %d %B ") .. markup("#ab7367", ">") .. markup("#de5e1e", " %H:%M "))

    -- Calendar
    clock.calendar = lain.widget.cal({
      attach_to = { clock },
      notification_preset = {
        font = beautiful.font,
        -- fg = theme.fg_normal,
        -- bg = theme.bg_normal,
        fg = "#aaaaaa",
        bg = "#000000",
      }
    })

    return clock
  end)
end

-- Layoutbox
local function newLayoutboxBuilder()
  local buttons = _t.join(
    awful.button({}, 1, function () awful.layout.inc(1) end),
    awful.button({}, 3, function () awful.layout.inc(-1) end),
    awful.button({}, 4, function () awful.layout.inc(1) end),
    awful.button({}, 5, function () awful.layout.inc(-1) end)
  )

  return (function(s)
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    local lb = awful.widget.layoutbox(s)
    lb:buttons(buttons)

    return lb
  end)
end
-- }}}

local function setup(config, menu)
  -- Layouts
  setupLayouts()

  awful.util.tagnames = config.tags

  -- Builders
  local builders = {
    launcher = newLauncherBuilder(menu);
    taglist = newTaglistBuilder(config.mod);
    promptbox = newPromptboxBuilder();
    tasklist = newTasklistBuilder();
    kbdlayout = newKeyboardLayoutBuilder();
    battery = newBatteryBuilder();
    systray = newSystrayBuilder();
    clock = newClockBuilder();
    layoutbox = newLayoutboxBuilder();
  }
  local screenBuilder = newScreenBuilder(config.tags, config.apps, builders)

  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", setScreenWallpaper)
  awful.screen.connect_for_each_screen(screenBuilder)
end

return {
  Setup = setup;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
