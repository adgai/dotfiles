local awful = require("awful")
local beautiful = require("beautiful")

local gaps = beautiful.useless_gap
gaps = tonumber(value)

function inc_value_of_gaps()
	value =gaps+5,
	awesome.emit_signal("gaps::value", value)
end
