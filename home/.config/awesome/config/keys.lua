local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
require("scripts")

modkey = "Mod4"
alt = "Mod1"
ctrl = "Control"
shift = "Shift"
terminal = "alacritty"

awful.keyboard.append_global_keybindings({
	-- launch programms --

	awful.key({ modkey }, "Return", function() awful.spawn(terminal) end),
	awful.key({ modkey }, "e", function() awful.spawn("thunar") end),
	awful.key({ modkey }, "b", function() awful.spawn("librewolf") end),
	awful.key({ modkey }, "a", function() awful.spawn("telegram-desktop") end),
	awful.key({}, "Print", function() awful.spawn("flameshot gui") end),

	-- rofi -- 

	awful.key({ modkey }, "d", function () awful.spawn("rofi -show drun -config .config/awesome/other/rofi/configs/config.rasi") end),
	awful.key({ modkey, ctrl }, "c", function () awful.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -config  .config/awesome/other/rofi/configs/config.rasi") end),
	awful.key({ modkey, ctrl }, "p", function() awful.spawn("rofi-pass") end),
	awful.key({ modkey, ctrl }, "b", function() awful.spawn ("books") end),
	awful.key({ modkey }, "x", function () awful.spawn("powermenu") end),

	-- some scripts --

	awful.key({ modkey }, "p", function() awful.spawn("colorpicker", false) end),
	awful.key({ modkey, ctrl }, "q", function() awful.spawn("qr_codes", false) end),

	-- volume up/down/mute --

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

	-- brightness up/down --

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

	-- binds to widgets --

	awful.key({ modkey }, "m", function () awesome.emit_signal("signal::dnd") end),
	awful.key({ modkey }, "n", function () awesome.emit_signal("summon::notif_center") end),
	awful.key({ modkey }, "c", function () awesome.emit_signal("summon::control") end),
	awful.key({ modkey, shift }, "b", function() awesome.emit_signal("hide::bar") end),
	awful.key({ modkey }, "t", function() awesome.emit_signal("show::tray") end),

	-- switching a focus client -- 

	awful.key({ modkey }, "l", function () awful.client.focus.byidx(1) end),
	awful.key({ modkey }, "h", function () awful.client.focus.byidx(-1) end),

	-- focus to tag --

	awful.key {
		modifiers = { modkey },
		keygroup = "numrow",
		on_press = function (index)
		local screen = awful.screen.focused()
		local tag = screen.tags[index]
		if tag then
			tag:view_only()
		end
		local c = awful.client.restore()
		if c then
			c:activate { raise = true, context = "key.unminimize" }
		end

	end},

-- move focused client to tag --

	awful.key {
		modifiers = { modkey, shift },
		keygroup = "numrow",
		on_press = function (index)
		if client.focus then
			local tag = client.focus.screen.tags[index]
			if tag then
				client.focus:move_to_tag(tag)
			end
					end
	end},

	-- restart wm --

	awful.key({ modkey, shift }, "r", awesome.restart),

	-- resize client --

   awful.key({ modkey, ctrl }, "k", function(c)
		helpers.client.resize_client(client.focus, "up")
	end),
	awful.key({ modkey, ctrl }, "j", function(c)
		helpers.client.resize_client(client.focus, "down")
	end),
	awful.key({ modkey, ctrl }, "h", function(c)
		helpers.client.resize_client(client.focus, "left")
	end),
	awful.key({ modkey, ctrl }, "l", function(c)
		helpers.client.resize_client(client.focus, "right")
	end),

	awful.key({ modkey, shift }, "=", function()
		helpers.client.resize_padding(5)
	end, { description = "add padding", group = "layout" }),
	awful.key({ modkey, shift }, "-", function()
		helpers.client.resize_padding(-5)
	end, { description = "subtract padding", group = "layout" }),

	awful.key({ modkey }, "=", function()
		helpers.client.resize_gaps(5)
	end, { description = "add gaps", group = "layout" }),

	awful.key({ modkey }, "-", function()
		helpers.client.resize_gaps(-5)
	end, { description = "subtract gaps", group = "layout" }),

    awful.key({ modkey, ctrl }, "n",
              function ()
                                end),


})


-- mouse binds --

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({ }, 1, function (c)
			c:activate { context = "mouse_click" }
		end),
		awful.button({ modkey }, 1, function (c)
			c:activate { context = "mouse_click", action = "mouse_move"  }
		end),
		awful.button({ modkey }, 3, function (c)
			c:activate { context = "mouse_click", action = "mouse_resize" }
		end),
	})
end)

-- client binds --

client.connect_signal("request::default_keybindings", function()
awful.keyboard.append_client_keybindings({
	awful.key({ modkey }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end),

	awful.key({ modkey }, "q", function (c) c:kill() end),
	awful.key({ modkey }, "s", awful.client.floating.toggle),

	-- Move or swap by direction --

	awful.key({ modkey, shift }, "k", function(c)
		helpers.client.move_client(c, "up")
	end),
	awful.key({ modkey, shift }, "j", function(c)
		helpers.client.move_client(c, "down")
	end),
	awful.key({ modkey, shift }, "h", function(c)
		helpers.client.move_client(c, "left")
	end),
	awful.key({ modkey, shift }, "l", function(c)
		helpers.client.move_client(c, "right")
	end),

	--- Relative move  floating client --

	awful.key({ modkey, shift, ctrl }, "j", function(c)
		c:relative_move(0, 20, 0, 0)
	end),
	awful.key({ modkey, shift, ctrl }, "k", function(c)
		c:relative_move(0, -20, 0, 0)
	end),
	awful.key({ modkey, shift, ctrl }, "h", function(c)
		c:relative_move(-20, 0, 0, 0)
	end),
	awful.key({ modkey, shift, ctrl }, "l", function(c)
		c:relative_move(20, 0, 0, 0)
	end),

})
end)


