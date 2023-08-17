local awful = require("awful")

local update_interval = 1
local netspeed_script = [[
  sh -c "cat /sys/class/net/wlo1/statistics/rx_bytes"
]]


awful.widget.watch(netspeed_script, update_interval, function(widget, stdout)
  local rx_1 =  string.gsub(stdout, '^%s*(.-)%s*$', '%1')
  local rx_1 = tonumber(rx_1)
  local rx_2 = 0
  local rx_3 = math.floor(rx_1-rx_2)
  awesome.emit_signal("netspeed::value", rx_3)
end)


