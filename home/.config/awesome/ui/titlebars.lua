local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- titlebars --

client.connect_signal("request::titlebars", function(c)

local titlebar = awful.titlebar(c, {
	position = "left",
	size = 36,
})

local buttons = gears.table.join(
	awful.button({ }, 1, function()
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	end)
)

titlebar.widget = {
	layout = wibox.layout.align.vertical,
	{
		widget = wibox.container.place,
		valign = "top",
		{
			widget = wibox.container.margin,
			margins = {right = 8, left = 8, top = 8},
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 8,
				awful.titlebar.widget.maximizedbutton(c),
				awful.titlebar.widget.minimizebutton(c),
				awful.titlebar.widget.closebutton(c)
			}
		}
	},
	{
		widget = wibox.container.background,
		buttons = buttons,
	},
	{
		widget = wibox.container.background,
		buttons = buttons,
	},
}

end)
