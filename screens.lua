-------------------------------------------------------------
--  Carrot clients key bindings and rules
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
--  Licensed under the GNU General Public License v2:
--  https://opensource.org/licenses/GPL-2.0
-------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful") -- Theme handling library
local wibox = require("wibox") -- Widget and layout library
local lain = require("lain")
local vicious = require("vicious") -- Vicious Widgets
local freedesktop = require("freedesktop") -- Freedesktop.org menu and desktop icons support for Awesome WM

local _t = awful.util.table or gears.table -- 4.{0,1} compatibility

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
-- }}}

local function newTaglistMouseBindings(modkey)
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

  return buttons
end

local function newTasklistMouseBindings()
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

  return buttons
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

-- {{{ Screen Setup

-- Screen builder
local function newScreenBuilder(tags, taglistButtons, tasklistButtons, apps)
  -- Create a wibox for each screen and add it
  return function(s)
    -- Quake application
    s.quake = lain.util.quake({ app = apps.terminal })

    -- Each screen has its own tag table.
    awful.tag(tags, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglistButtons)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklistButtons)

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(_t.join(
      awful.button({}, 1, function () awful.layout.inc(1) end),
      awful.button({}, 3, function () awful.layout.inc(-1) end),
      awful.button({}, 4, function () awful.layout.inc(1) end),
      awful.button({}, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create the wibox
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
        mykeyboardlayout,
        wibox.widget.systray(),
        mytextclock,
        s.mylayoutbox,
      },
    })

    -- Wallpaper
    setScreenWallpaper(s)

    -- Let theme create wibox
    -- beautiful.at_screen_connect(s)
  end
end
-- }}}

-- {{{ Widgets
-- Launcher
local mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  --menu = mymainmenu
})

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Battery Widget
batwidget = awful.widget.progressbar()
batwidget:set_width(8)
batwidget:set_height(10)
batwidget:set_vertical(true)
batwidget:set_background_color("#494B4F")
batwidget:set_border_color(nil)
batwidget:set_color("#AECF96")
batwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 10 },
stops = {{ 0, "#AECF96" }, { 0.5, "#88A175" }, { 1, "#FF5656" }}})
vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT0")
-- }}}


local function setup(config)
  local tasklistButtons = newTasklistMouseBindings()
  local taglistButtons = newTaglistMouseBindings(config.mod)

  -- awful.layout.layouts = ???

  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", setScreenWallpaper)
  awful.screen.connect_for_each_screen(newScreenBuilder(
    config.tags,
    taglistButtons,
    tasklistButtons,
    config.apps
  ))
end

return {
  Setup = setup;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
