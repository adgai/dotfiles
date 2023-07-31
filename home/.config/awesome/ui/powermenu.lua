local wibox = require("wibox")
local awful = require("awful")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")

-- Widgets --

local powermenudisplay = wibox {
	width = 295,
	height = 295,
	bg = beautiful.background,
	ontop = true,
	visible = false
}


local exit_button = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.foreground,
  bg = beautiful.background_alt,
	forced_height = 133,
  forced_width = 133,
	buttons = {
		awful.button({}, 1, function()
			awful.spawn("loginctl terminate-session 1")
		end)
	},
	{
		widget = wibox.widget.textbox,
		text = "",
		font = beautiful.font .. " 40",
		halign = "center",
		valign = "center",
	}
}
exit_button:connect_signal("mouse::enter", function(c) 
	c:set_bg(beautiful.foreground) 
	c:set_fg(beautiful.background) 
end)
exit_button:connect_signal("mouse::leave", function(c) 
	c:set_bg(beautiful.background_alt)
	c:set_fg(beautiful.foreground) 
end)

local reboot_button = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.foreground,
  bg = beautiful.background_alt,
  forced_height = 133,
  forced_width = 133,
	buttons = {
		awful.button({}, 1, function()
			awful.spawn("loginctl reboot")
		end)
	},
	{
		widget = wibox.widget.textbox,
		text = "",
		font = beautiful.font .. " 40",
		halign = "center",
		valign = "center",
	}
}
reboot_button:connect_signal("mouse::enter", function(c) 
	c:set_bg(beautiful.foreground) 
	c:set_fg(beautiful.background) 
end)
reboot_button:connect_signal("mouse::leave", function(c) 
	c:set_bg(beautiful.background_alt)
	c:set_fg(beautiful.foreground) 
end)

local poweroff_button = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.foreground,
  bg = beautiful.background_alt,
  forced_height = 133,
  forced_width = 133,
	buttons = {
		awful.button({}, 1, function()
			awful.spawn("loginctl poweroff")
		end)
	},
	{
		widget = wibox.widget.textbox,
		text = "",
		font = beautiful.font .. " 40",
		halign = "center",
		valign = "center",
	}
}
poweroff_button:connect_signal("mouse::enter", function(c) 
	c:set_bg(beautiful.foreground) 
	c:set_fg(beautiful.background) 
end)
poweroff_button:connect_signal("mouse::leave", function(c) 
	c:set_bg(beautiful.background_alt)
	c:set_fg(beautiful.foreground) 
end)


local suspend_button = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.foreground,
  bg = beautiful.background_alt,
  forced_height = 133,
  forced_width = 133,
	buttons = {
		awful.button({}, 1, function()
			awful.spawn("loginctl suspend")
		end)
	},
	{
		widget = wibox.widget.textbox,
		text = "",
		font = beautiful.font .. " 40",
		halign = "center",
		valign = "center",
	}
}
suspend_button:connect_signal("mouse::enter", function(c) 
	c:set_bg(beautiful.foreground) 
	c:set_fg(beautiful.background) 
end)
suspend_button:connect_signal("mouse::leave", function(c) 
	c:set_bg(beautiful.background_alt)
	c:set_fg(beautiful.foreground) 
end)


powermenudisplay:setup {
  widget = wibox.container.place,
  halign = "center",
  {
    widget = wibox.container.margin,
    margins = 10,
    {
	    layout = wibox.layout.grid,
      reboot_button,
      poweroff_button,
      exit_button,
      suspend_button,
      forced_num_cols = 2,
      forced_num_rows = 2,
      spacing = 10,
    },
  },
}

local function open()
end

-- Summon funcs --

local function powermenu_hide()
	if powermenudisplay.visible then
		powermenudisplay.visible = false
		awful.keygrabber.stop()
	end
end

local function powermenu_toggle()

	local click = awful.button({ }, 1, function(c) powermenu_hide() end)

	if not powermenudisplay.visible then
		awful.mouse.append_global_mousebinding(click)
		client.connect_signal("button::press", function() powermenu_hide() end)
		open()       
		powermenudisplay.visible = true
	else
		client.disconnect_signal("mouse::press", function() powermenu_hide() end)
		awful.mouse.remove_global_mousebinding(click)
		powermenu_hide()
	end
end

awesome.connect_signal("summon::powermenu", function()
	powermenu_toggle()
	awful.placement.centered(powermenudisplay, { honor_workarea = false})
end)
