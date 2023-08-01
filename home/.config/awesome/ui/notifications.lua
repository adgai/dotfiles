local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")

-- notifications -------------------------------------------------------------

ruled.notification.connect_signal('request::rules', function()

	ruled.notification.append_rule {
		rule = { urgency = "normal" },
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
			position = "top_right",
			spacing = 10,
			bg = beautiful.background,
			fg = beautiful.foreground,
			border_width = 0,
			border_color = beautiful.border_color,
		}
	}

	ruled.notification.append_rule {
		rule = { urgency = "critical" },
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
			position = "top_right",
			spacing = 10,
			bg = beautiful.background,
			fg = beautiful.foreground,
			border_width = 0,
			border_color = beautiful.border_color,
			icon = beautiful.notification_alert,
		}
	}

end)

naughty.connect_signal("request::display", function(n)

	if not n.app_icon then
		n.app_icon = beautiful.notification_icon
	end

	naughty.layout.box {
		notification = n,
		widget_template = {
			strategy = "max",
			width = 100,
			widget = wibox.container.constraint,
			{
				id = "background_role",
				widget = naughty.container.background,
				{
					widget = wibox.container.margin,
					left = 15,
					right = 25,
					top = 25,
					bottom = 25,
					{
						naughty.widget.icon,
						fill_space = true,
						spacing = 10,
						layout = wibox.layout.fixed.horizontal,
						{
							naughty.widget.title,
							naughty.widget.message,
							spacing = 4,
							layout = wibox.layout.fixed.vertical,
						}
					}
				}
			}
		}
	}

end)
