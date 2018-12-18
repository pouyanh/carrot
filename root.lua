-------------------------------------------------------------
--  Carrot root key bindings and rules
-------------------------------------------------------------
--  Copyright (c) 2018 Pouyan Heyratpour <pouyan@janstun.com>
--  Licensed under the GNU General Public License v3:
--  https://opensource.org/licenses/GPL-3.0
-------------------------------------------------------------

local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local menubar = require("menubar")
local lain = require("lain")

local _t = gears.table or awful.util.table -- 4.{0,1} compatibility

-- {{{ Actions
local function toggle_wibox()
  for s in screen do
    s.mywibox.visible = not s.mywibox.visible
    if s.mybottomwibox then
      s.mybottomwibox.visible = not s.mybottomwibox.visible
    end
  end
end
-- }}}

-- {{{ Mouse bindings
local function newMouseBindings(menu)
  local buttons = _t.join(
    awful.button({ }, 3, function () menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
  )

  return buttons
end
-- }}}

-- {{{ Key bindings
local function newKeyBindings(modkey, altkey, apps, menu)
  local keys = _t.join(
    -- Hotkeys
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
      {description="show help", group="awesome"}
    ),

    -- Tag browsing
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
      {description = "view previous", group = "tag"}
    ),

    awful.key({ modkey, }, "Right", awful.tag.viewnext,
      {description = "view next", group = "tag"}
    ),

    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
      {description = "go back", group = "tag"}
    ),

    -- Non-empty tag browsing
    --awful.key({ altkey }, "Left", function ()
    --    lain.util.tag_view_nonempty(-1)
    --  end,
    --  {description = "view  previous nonempty", group = "tag"}
    --),

    --awful.key({ altkey }, "Right", function ()
    --    lain.util.tag_view_nonempty(1)
    --  end,
    --  {description = "view  previous nonempty", group = "tag"}
    --),

    -- Client focus
    awful.key({ modkey, }, "j",
      function ()
        awful.client.focus.byidx(1)
      end,
      {description = "focus next by index", group = "client"}
    ),

    awful.key({ modkey, }, "k",
      function ()
        awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
    ),

    -- Menu
    awful.key({ modkey, }, "w",
      function ()
        mymainmenu:show()
      end,
      {description = "show main menu", group = "awesome"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function ()
        awful.client.swap.byidx(1)
      end,
      {description = "swap with next client by index", group = "client"}
    ),

    awful.key({ modkey, "Shift" }, "k", function ()
        awful.client.swap.byidx(-1)
      end,
      {description = "swap with previous client by index", group = "client"}
    ),

    awful.key({ modkey, "Control" }, "j", function ()
        awful.screen.focus_relative(1)
      end,
      {description = "focus the next screen", group = "screen"}
    ),

    awful.key({ modkey, "Control" }, "k", function ()
        awful.screen.focus_relative(-1)
      end,
      {description = "focus the previous screen", group = "screen"}
    ),

    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}
    ),

    awful.key({ modkey, }, "Tab",
      function ()
        awful.client.focus.history.previous()
        if client.focus then
          client.focus:raise()
        end
      end,
      {description = "go back", group = "client"}
    ),

    -- Show/Hide Wibox
    awful.key({ modkey, }, "b", toggle_wibox,
      {description = "toggle wibox", group = "awesome"}
    ),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function ()
        lain.util.add_tag()
      end,
      {description = "add new tag", group = "tag"}
    ),

    awful.key({ modkey, "Shift" }, "r", function ()
        lain.util.rename_tag()
      end,
      {description = "rename tag", group = "tag"}
    ),

    awful.key({ modkey, "Shift" }, "Left", function ()
        lain.util.move_tag(-1)
      end,
      {description = "move tag to the left", group = "tag"}
    ),

    awful.key({ modkey, "Shift" }, "Right", function ()
        lain.util.move_tag(1)
      end,
      {description = "move tag to the right", group = "tag"}
    ),

    awful.key({ modkey, "Shift" }, "d", function ()
        lain.util.delete_tag()
      end,
      {description = "delete tag", group = "tag"}
    ),

    -- Standard program
    awful.key({ modkey, }, "Return", function () awful.spawn(apps.terminal) end,
      {description = "open a terminal", group = "launcher"}
    ),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
      {description = "reload awesome", group = "awesome"}
    ),

    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
      {description = "quit awesome", group = "awesome"}
    ),

    awful.key({ modkey, }, "l", function ()
        awful.tag.incmwfact(0.05)
      end,
      {description = "increase master width factor", group = "layout"}
    ),

    awful.key({ modkey }, "h", function ()
        awful.tag.incmwfact(-0.05)
      end,
      {description = "decrease master width factor", group = "layout"}
    ),

    awful.key({ modkey, "Shift" }, "h", function ()
        awful.tag.incnmaster(1, nil, true)
      end,
      {description = "increase the number of master clients", group = "layout"}
    ),

    awful.key({ modkey, "Shift" }, "l", function ()
        awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "layout"}
    ),

    awful.key({ modkey, "Control" }, "h", function ()
        awful.tag.incncol( 1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
    ),

    awful.key({ modkey, "Control" }, "l", function ()
        awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "layout"}
    ),

    awful.key({ modkey, }, "space", function ()
        awful.layout.inc(1)
      end,
      {description = "select next", group = "layout"}
    ),

    awful.key({ modkey, "Shift" }, "space", function ()
        awful.layout.inc(-1)
      end,
      {description = "select previous", group = "layout"}
    ),

    awful.key({ modkey, "Control" }, "n",
      function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          client.focus = c
          c:raise()
        end
      end,
      {description = "restore minimized", group = "client"}
    ),

    -- Prompt
    awful.key({ modkey }, "r", function ()
        awful.screen.focused().mypromptbox:run()
      end,
      {description = "run prompt", group = "launcher"}
    ),

    awful.key({ modkey }, "x",
      function ()
        awful.prompt.run {
          prompt       = "Run Lua code: ",
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
      end,
      {description = "lua execute prompt", group = "awesome"}
    ),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
      {description = "show the menubar", group = "launcher"}
    ),

    -- Dropdown application
    awful.key({ modkey, }, "z", function ()
        awful.screen.focused().quake:toggle()
      end,
      {description = "dropdown application", group = "launcher"}
    ),

    -- Locker
    awful.key({ altkey, "Control" }, "l", function ()
        awful.util.spawn(apps.locker)
      end,
      {description = "locks the session", group = "security"}
    ),

    -- Screenshot
    awful.key({}, "Print",
      function ()
        awful.util.spawn(apps.shoter)
      end,
      {description = "screenshot", group = "screen"}
    )
  )

  -- Bind all key numbers to tags.
  -- Be careful: we use keycodes to make it works on any keyboard layout.
  -- This should map on the top row of your keyboard, usually 1 to 9.
  for i = 1, 9 do
    keys = _t.join(keys,
      -- View tag only.
      awful.key({ modkey }, "#" .. i + 9,
        function ()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        {description = "view tag #"..i, group = "tag"}
      ),

      -- Toggle tag display.
      awful.key({ modkey, "Control" }, "#" .. i + 9,
        function ()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            awful.tag.viewtoggle(tag)
          end
        end,
        {description = "toggle tag #" .. i, group = "tag"}
      ),

      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
        function ()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
            end
          end
        end,
        {description = "move focused client to tag #"..i, group = "tag"}
      ),

      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
        function ()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
        end,
        {description = "toggle focused client on tag #" .. i, group = "tag"}
      )
    )
  end

  return keys
end
-- }}}

-- Setup
local function setup(config, menu)
  local keys = newKeyBindings(config.mod, config.alt, config.apps, menu)
  local buttons = newMouseBindings(menu)

  -- Enable hotkeys help widget for VIM and other apps
  -- when client with a matching name is opened:
  require("awful.hotkeys_popup.keys")

  -- Set the terminal for applications that require it
  menubar.utils.terminal = config.apps.terminal

  root.keys(keys)
  root.buttons(buttons)
end

return {
  Setup = setup;
}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
