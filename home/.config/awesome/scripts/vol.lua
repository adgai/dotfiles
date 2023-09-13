local awful = require("awful")


function update_value_of_volume()
	awful.spawn.easy_async_with_shell("amixer -D pipewire sget Master", function (stdout)
		local value = string.match(stdout, "(%d?%d?%d)%%")
		local muted = string.match(stdout, "%[(o%D%D?)%]")
		value = tonumber(value)
		local icon = ""
		if muted == "off" then
			icon = ""
		elseif value <= 33 then
			icon = ""
		elseif value <= 66 then
			icon = ""
		elseif value <= 100 then
			icon = ""
		end
		awesome.emit_signal("volume::value", value, icon)
	end)
end

function update_value_of_capture()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle | tail -n 1 | awk '{print $5}' | tr -d []%", function (stdout)
		local value =  string.gsub(stdout, '^%s*(.-)%s*$', '%1')
		value = tonumber(value)
		awesome.emit_signal("capture::value", value)
	end)
end

function update_value_of_capture_muted()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle | tail -n 1 | awk '{print $6}' | tr -d '[]'", function (stdout)
		local value =  string.gsub(stdout, '^%s*(.-)%s*$', '%1')
		awesome.emit_signal("capture_muted::value", value)
	end)
end

update_value_of_volume()
update_value_of_capture_muted()

function updateVolumeSignals()
	update_value_of_volume()
	update_value_of_capture_muted()
end
