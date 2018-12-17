-------------------------------------------------------------
--  Carrot clients key bindings and rules
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
--  Licensed under the GNU General Public License v2:
--  https://opensource.org/licenses/GPL-2.0
-------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful") -- Theme handling library 

local _t = gears.table or awful.util.table -- 4.{0,1} compatibility

-- {{{ Actions
-- No border for maximized clients
function getClientSuitableBorder(c)
  local border = {
    width = c.border_width,
    color = c.border_color,
  }

  if c.maximized then -- no borders if only 1 client visible
    border.width = 0
  elseif #awful.screen.focused().clients > 1 then
    border.width = beautiful.border_width
    border.color = beautiful.border_focus
  end

  return border
end
-- }}}

-- {{{ Key bindings
local function newKeyBindings(modkey)
  local keys = _t.join(
      awful.key({ modkey, }, "f",
        function (c)
          c.fullscreen = not c.fullscreen
          c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
      ),

      awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end,
        {description = "close", group = "client"}
      ),

      awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
      ),

      awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}
      ),

      awful.key({ modkey, }, "o", function (c) c:move_to_screen() end,
        {description = "move to screen", group = "client"}
      ),

      awful.key({ modkey, }, "t", function (c)
          c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
      ),

      awful.key({ modkey, }, "n",
        function (c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
        end ,
        {description = "minimize", group = "client"}
      ),

      -- Size change
      awful.key({ modkey, }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}
      ),

      awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}
      ),

      awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}
      )
  )

  return keys
end
-- }}}

-- {{{ Mouse bindings
local function newMouseBindings(modkey)
  local buttons = _t.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
  )

  return buttons
end
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
local function newRules(keys, buttons)
  local rules = {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = keys,
        buttons = buttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
    },

    -- Floating clients.
    {
      rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"
        },

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
      rule_any = {type = { "normal", "dialog" }},
      properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
  }

  return rules
end
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
local function sigManage(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
local function sigRequestTitlebars(c)
  -- buttons for the titlebar
  local buttons = _t.join(
    -- Left mouse button: move
    awful.button({}, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),

    -- Middle mouse button: move
    awful.button({}, 2, function()
      c:kill()
    end),

    -- Right mouse button: resize
    awful.button({}, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end),

    -- Mouse wheel up: increase opacity
    awful.button({}, 4, function()
    end),

    -- Mouse wheel down: decrease opacity
    awful.button({}, 5, function()
    end)
  )

  awful.titlebar(c, {size = 16}):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  })
end

-- Enable sloppy focus, so that focus follows mouse.
local function sigMouseEnter(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end

local function sigPropertyMaximized(c)
  local border = getClientSuitableBorder(c)
  c.border_width = border.width
  c.border_color = border.color
end

local function sigFocus(c)
  local border = getClientSuitableBorder(c)
  c.border_width = border.width
  c.border_color = beautiful.border_focus
end

local function sigUnfocus(c)
  c.border_color = beautiful.border_normal
end
-- }}}

local function setup(config)
  require("awful.autofocus")

  local keys = newKeyBindings(config.mod)
  local buttons = newMouseBindings(config.mod)

  awful.rules.rules = newRules(keys, buttons)

  client.connect_signal("focus", sigFocus)
  client.connect_signal("manage", sigManage)
  client.connect_signal("unfocus", sigUnfocus)
  client.connect_signal("mouse::enter", sigMouseEnter)
  client.connect_signal("property:maximized", sigPropertyMaximized)
  client.connect_signal("request::titlebars", sigRequestTitlebars)
end

return {
  Setup = setup;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
