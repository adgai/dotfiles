local awful = require("awful")

local update_interval = 600
local weather_script= [[
  bash -c "curl -s 'wttr.in/Gomel?format=%c%t'"
]]

awful.widget.watch(weather_script, update_interval, function(widget, stdout)
  local value =  string.gsub(stdout, '^%s*(.-)%s*$', '%1')
  awesome.emit_signal("weather::value", value)
end)
