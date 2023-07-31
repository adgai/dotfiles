local gears = require("gears")
local awful = require("awful")
require("scripts.init")

awful.keyboard.append_global_keybindings({
	awful.key({ modkey, "Shift" }, "r", awesome.restart, {group = "awesome"}),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, {group = "awesome"}),
	awful.key({ modkey }, "Return", function () awful.spawn(terminal) end, {group = "launcher"}),

	awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn.with_shell("amixer -D pipewire sset Master 2%+")
    updateVolumeSignals()
    awesome.emit_signal("summon::osd")
  end),
	awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn.with_shell("amixer -D pipewire sset Master 2%-")
    updateVolumeSignals()
    awesome.emit_signal("summon::osd")
  end),
	awful.key({}, "XF86AudioMute", function()
    awful.spawn.with_shell("amixer -D pipewire sset Master toggle")
    updateVolumeSignals()
    awesome.emit_signal("summon::osd")
  end),
	awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn.with_shell("brightnessctl s 5%+")
    update_value_of_bright()
    awesome.emit_signal("summon::osd")
  end),
	awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn.with_shell("brightnessctl s 5%-")
    update_value_of_bright()
    awesome.emit_signal("summon::osd")
  end),
	awful.key({ modkey }, "e", function() awful.spawn("thunar") end),
	awful.key({ modkey }, "b", function() awful.spawn("librewolf") end),
	awful.key({ modkey }, "a", function() awful.spawn("telegram-desktop") end),

	awful.key({ modkey }, "m", function () awesome.emit_signal("signal::dnd") end),
	awful.key({ modkey }, "n", function () awesome.emit_signal("summon::action") end, {group = "launcher"}),
	awful.key({ modkey }, "d", function () awesome.emit_signal("summon::launcher") end, {group = "launcher"}),
	awful.key({ modkey }, "x", function () awesome.emit_signal("summon::powermenu") end, {group = "launcher"}),
	awful.key({}, "Print", function() awful.spawn("flameshot gui") end),
	awful.key({ modkey }, "p", function() awful.spawn("colorpicker", false) end, {group = "launcher"}),
})

awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "l", function () awful.client.focus.byidx( 1) end, {group = "client"}
    ),
    awful.key({ modkey }, "h", function () awful.client.focus.byidx(-1) end, {group = "client"}
    ),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incmwfact(0.01) end, {group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incmwfact(-0.01) end, {group = "layout"}),
})

awful.keyboard.append_global_keybindings({
awful.key {
  modifiers = { modkey },
  keygroup = "numrow",
  description = "only view tag",
  group = "tag",
  on_press = function (index)
    local screen = awful.screen.focused()
    local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
  end,
},
awful.key {
  modifiers = { modkey, "Shift" },
  keygroup = "numrow",
  description = "move focused client to tag",
  group = "tag",
  on_press = function (index)
    if client.focus then
      local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
    end
  end,
},
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey }, "s",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
	awful.key({ modkey }, "c", function (c)
		c.maximized = not c.maximized
			c:raise()
	end, {description = "(un)maximize", group = "client"}),
    })
end)


