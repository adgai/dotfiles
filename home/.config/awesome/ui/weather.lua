local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require "beautiful"

local icon_map = {
	["01d"] = "",
	["02d"] = "",
	["03d"] = "",
	["04d"] = "",
	["09d"] = "",
	["10d"] = "",
	["11d"] = "",
	["13d"] = "",
	["50d"] = "",
	["01n"] = "",
	["02n"] = "",
	["03n"] = "",
	["04n"] = "",
	["09n"] = "",
	["10n"] = "",
	["11n"] = "",
	["13n"] = "",
	["50n"] = ""
}

local createWeatherProg = function()

	local widget = wibox.widget {
		spacing = 6,
		layout = wibox.layout.fixed.vertical,
		{
			id = "time",
			halign = 'center',
			widget = wibox.widget.textbox,
			font = beautiful.font .. " 10",
		},
		{
			id = "icon",
			font = beautiful.font.. " 20",
			halign = 'center',
			widget = wibox.widget.textbox
		},
		{
			id = "temp",
			halign = "center",
			font = beautiful.font.. " 10",
			widget = wibox.widget.textbox
		},
	}

	widget.update = function(out, i)
		local hour = out.hourly[i]
		widget:get_children_by_id('temp')[1].markup = helpers.ui.colorizeText(math.floor(hour.temp) .. "°C", beautiful.foreground)
		widget:get_children_by_id('icon')[1].text = icon_map[hour.weather[1].icon]
		widget:get_children_by_id('time')[1].text = os.date("%Hh", tonumber(hour.dt))
	end

  return widget
end

local hour1 = createWeatherProg()
local hour2 = createWeatherProg()
local hour3 = createWeatherProg()
local hour4 = createWeatherProg()
local hour5 = createWeatherProg()
local hour6 = createWeatherProg()
local hour7 = createWeatherProg()

local hourList = { hour1, hour2, hour3, hour4, hour5, hour6, hour7}

local widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.background_alt,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 14,
			{
				layout = wibox.layout.align.horizontal,
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = 10,
					{
						id = "weathericon",
						forced_width = 70,
						forced_height = 70,
						halign = 'center',
						font = beautiful.font.. " 34",
						widget = wibox.widget.textbox
					},
					{
						widget = wibox.widget.textbox,
						id = "humid",
						valign = "top"
					}
				},
				nil,
				{
					spacing = 4,
					layout = wibox.layout.fixed.vertical,
					{
						id = "temp",
						halign = 'right',
						font = beautiful.font.. " 18",
						widget = wibox.widget.textbox,
						markup = helpers.ui.colorizeText("Hello", beautiful.foreground)
					},
					{
						id = "desc",
						halign = 'right',
						widget = wibox.widget.textbox,
						markup = helpers.ui.colorizeText("Hello", beautiful.foreground)
					},
				},
			},
			{
				widget = wibox.container.place,
				align = "center",
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = 29,
					hour1,
					hour2,
					hour3,
					hour4,
					hour5,
					hour6,
					hour7
				}
			}
		}
	}
}


awesome.connect_signal("connect::weather", function(out)
	widget:get_children_by_id('weathericon')[1].text = out.image
	widget:get_children_by_id('desc')[1].markup = helpers.ui.colorizeText(string.lower(out.desc), beautiful.foreground)
	widget:get_children_by_id('temp')[1].markup = helpers.ui.colorizeText(out.temp .. "°C", beautiful.foreground)
	-- widget:get_children_by_id('feels')[1].markup = "Feels like " .. out.feelsLike .. "°C"
	widget:get_children_by_id('humid')[1].markup = "Humidity: " .. out.humidity .. "%"
	for i, j in ipairs(hourList) do
		j.update(out, i)
	end
end)

return widget
