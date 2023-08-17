local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")

-- notifications -------------------------------------------------------------

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message,
		icon = beautiful.notification_icon_error,
	}
end)

ruled.notification.connect_signal('request::rules', function()

ruled.notification.append_rule {
	rule = { urgency = "normal" },
	properties = {
		screen = awful.screen.preferred,
		implicit_timeout = 4,
		position = "top_left",
		spacing = 10,
		bg = beautiful.background,
		fg = beautiful.foreground,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
	}
}

ruled.notification.append_rule {
	rule = { urgency = "critical" },
	properties = {
		screen = awful.screen.preferred,
		implicit_timeout = 4,
		position = "top_left",
		spacing = 10,
		bg = beautiful.background,
		fg = beautiful.foreground,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		icon = beautiful.notification_error,
	}
}

end)

naughty.connect_signal("request::display", function(n)
	if not n.app_icon then
		n.app_icon = beautiful.notification_icon
	end

naughty.layout.box {
	notification = n,
	maximum_width = 600,
	maximum_height = 200,
	widget_template = {
		strategy = "max",
		width = 100,
		widget = wibox.container.constraint,
		{
			id = "background_role",
			widget = naughty.container.background,
			{
				widget = wibox.container.margin,
				left = 10,
				right = 10,
				top = 10,
				bottom = 10,
				{
					naughty.widget.icon,
					fill_space = true,
					spacing = 10,
					layout = wibox.layout.fixed.horizontal,
					{
						naughty.widget.title,
						naughty.widget.message,
						spacing = 10,
						layout = wibox.layout.fixed.vertical,
					}
				}
			}
		}
	}
}

end)
