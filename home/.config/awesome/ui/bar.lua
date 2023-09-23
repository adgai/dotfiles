local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bling = require("modules.bling")
local naughty = require("naughty")
require("scripts.init")

screen.connect_signal("request::desktop_decoration", function(s)

-- profile ----------------------------------

local profile = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	fill_space = true,
	{
		widget = wibox.container.background,
		id = "profile",
		bg = beautiful.background_alt,
		{
			widget = wibox.container.margin,
			margins = {bottom = 8, top = 8},
			{
				widget = wibox.widget.textbox,
				text = "",
				halign = "center",
			}
		}
	},
}

local profile_default = false

awesome.connect_signal("profile::control", function()
	profile_default = not profile_default
	if not profile_default then
		profile:get_children_by_id('profile')[1]:set_bg(beautiful.background_alt)
		awesome.emit_signal("summon::control")
	else
		profile:get_children_by_id('profile')[1]:set_bg(beautiful.background_urgent)
		awesome.emit_signal("summon::control")
	end
end)


profile:buttons {
	awful.button({}, 1, function()
		awesome.emit_signal("profile::control")
	end)
}

-- keyboard layout --------------------------

local mykeyboard=awful.widget.keyboardlayout()
mykeyboard.widget.text = string.upper(mykeyboard.widget.text)
mykeyboard.widget:connect_signal("widget::redraw_needed", function(wid) wid.text=string.upper(wid.text) end)

local keyboard = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	{
		widget = wibox.container.margin,
		margins = {top = 8, bottom = 6},
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 8,
  			{
				widget = wibox.widget.textbox,
     			text = "",
				halign = "center",
			},
			{
				widget = wibox.container.place,
				halign = "center",
				{
					widget = wibox.container.margin,
					margins = {left = -3, right = -3},
					mykeyboard,
  				},
			},
		},
	},
}

-- tray --------------------------------

local tray = wibox.widget {
	widget = wibox.container.margin,
	top = 4,
	bottom = 8,
	visible = false,
	{
		widget = wibox.widget.systray,
		horizontal = false,
		base_size = 24,
	}
}

local tray_button = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	font = beautiful.font.. " 16",
	halign = "center",
}

local tray_widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	{
		layout = wibox.layout.fixed.vertical,
		{
			widget = wibox.container.margin,
			margins = {bottom = 2, top = 4},
			tray_button,
		},
		{
			widget = wibox.container.place,
			halign = "center",
			tray,
		},
	}
}

awesome.connect_signal("show::tray", function()
	if not tray.visible then
			tray_button.text = ""
			tray.visible = true
		else
			tray_button.text = ""
			tray.visible = false
	end
end)

tray_widget:buttons{
	awful.button({}, 1, function() awesome.emit_signal("show::tray") end)
}

-- clock -------------------------------

local time = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	fill_space = true,
	{
		widget = wibox.container.background,
		id = "clock",
		bg = beautiful.background_alt,
		{
			widget = wibox.container.margin,
			margins = {bottom = 6, top = 10},
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 4,
					{
						widget = wibox.widget.textbox,
						text = "",
						halign = "center",
					},
				{
					widget = wibox.widget.textclock,
					format = "%H\n%M\n%S",
					refresh = 1,
					halign = "center"
				}
			}
		}
	}
}

local time_default = false

awesome.connect_signal("time::calendar", function()
	time_default = not time_default
	if not time_default then
		time:get_children_by_id('clock')[1]:set_bg(beautiful.background_alt)
		awesome.emit_signal("summon::calendar_widget")
	else
		time:get_children_by_id('clock')[1]:set_bg(beautiful.background_urgent)
		awesome.emit_signal("summon::calendar_widget")
	end
end)

time:buttons {
	awful.button({}, 1, function()
		awesome.emit_signal("time::calendar")
	end)
}

-- taglist -----------------------------

local taglist = awful.widget.taglist {
	screen = s,
	filter = awful.widget.taglist.filter.noempty,
	style = { shape = gears.shape.circle },
	buttons = {
		awful.button({ }, 1, function(t) t:view_only() end),
		awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
		awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
	},
	layout = {
		spacing = 8,
		layout = wibox.layout.fixed.vertical
	},
	widget_template = {
		id = "background_role",
		widget = wibox.container.background,
		forced_width = 30,
		{
			id = "text_role",
			halign = "center",
			valign = "center",
			widget = wibox.widget.textbox
		},
	}
}

-- battery ------------------------------

local bat_icon = wibox.widget {
	widget = wibox.widget.textbox,
	halign = "center",
}

local bat_progressbar = wibox.widget {
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_width = 60,
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	background_color = beautiful.background_urgent,
	color = beautiful.green,
}

awesome.connect_signal("bat::value", function(value)
	bat_progressbar.value = value
	if value > 70 then
		bat_progressbar.color = beautiful.green
	elseif value > 20 then
		bat_progressbar.color = beautiful.yellow
	else
		bat_progressbar.color = beautiful.red
	end
end)

awesome.connect_signal("bat::state", function(value)
	if value == "Discharging" then
		bat_icon.text = ""
	else
		bat_icon.text = ""
	end
end)

local bat = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 8,
		{
			widget = wibox.container.margin,
			top = 8,
			bat_icon,
		},
		{
			widget = wibox.container.margin,
			margins = {right = 8, left = 8, bottom = 8},
			{
				widget = wibox.container.rotate,
				direction = "east",
				bat_progressbar,
			}
		},
	},
}

-- dnd ------------------------------

local dnd_button = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	fill_space = true,
	{
		widget = wibox.container.background,
		id = "dnd",
		bg = beautiful.background_alt,
		fg = beautiful.foregraund,
		{
			widget = wibox.container.margin,
			margins = {top = 8, bottom = 8},
			{
				widget = wibox.widget.textbox,
				id = "icon",
				text = "",
				halign = "center",
			},
		},
	},
}

local dnd = true

awesome.connect_signal("signal::dnd", function()
	dnd = not dnd
	if not dnd then
		dnd_button:get_children_by_id('icon')[1].text = ""
		naughty.suspend()
	else
		dnd_button:get_children_by_id('icon')[1].text = ""
		naughty.resume()
	end
end)

local notif_center_default = false

awesome.connect_signal("notif_center::open", function()
	notif_center_default = not notif_center_default
	if not notif_center_default then
		dnd_button:get_children_by_id('dnd')[1]:set_bg(beautiful.background_alt)
		awesome.emit_signal("summon::notif_center")
	else
		dnd_button:get_children_by_id('dnd')[1]:set_bg(beautiful.background_urgent)
		awesome.emit_signal("summon::notif_center")
	end
end)

dnd_button:buttons {
	awful.button({}, 1, function()
		awesome.emit_signal("signal::dnd")
	end),
	awful.button({}, 3, function()
		awesome.emit_signal("notif_center::open")
	end),
}
-- bar --------------------------

bar = awful.wibar {
	screen = s,
	position = "left",
	height = s.geometry.height + beautiful.border_width * 2,
	width = 60,
	bg = beautiful.background,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	margins = {
		top = -beautiful.border_width,
		bottom = -beautiful.border_width,
		left = -beautiful.border_width,
	},
	ontop = false,
	widget = {
	layout = wibox.layout.flex.vertical,
		{
			widget = wibox.container.place,
			valign = "top",
			content_fill_horizontal = true,
			{
				widget = wibox.container.margin,
				margins = {left = 10, right = 10, top = 10},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = 10,
					profile,
					time,
					tray_widget,
				},
			},
		},
		{
			widget = wibox.container.place,
			valign = "center",
			content_fill_horizontal = true,
			{
				widget = wibox.container.margin,
				margins = {left = 10, right = 10},
				{
					layout = wibox.layout.fixed.vertical,
					taglist,
				},
			},
		},
		{
			widget = wibox.container.place,
			valign = "bottom",
			content_fill_horizontal = true,
			{
				widget = wibox.container.margin,
				margins = {right = 10, left = 10, bottom = 10},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = 10,
					bat,
					keyboard,
					dnd_button,
				},
			},
		},
	}
}

end)

awesome.connect_signal("hide::bar", function()
	bar.visible = not bar.visible
end)

