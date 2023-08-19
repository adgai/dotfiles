local awful = require("awful")

function update_value_of_volume()
	awful.spawn.easy_async_with_shell("amixer -D pipewire sget Master", function (stdout)
		local value = string.match(stdout, "(%d?%d?%d)%%")
		value = tonumber(value)
		awesome.emit_signal("volume::value", value)
	end)
end

function update_value_of_muted()
	awful.spawn.easy_async_with_shell("amixer -D pipewire sget Master", function (stdout)
		local value = string.match(stdout, "%[(o%D%D?)%]")
		awesome.emit_signal("muted::value", value)
	end)
end

update_value_of_volume()
update_value_of_muted()

function updateVolumeSignals()
	update_value_of_volume()
  update_value_of_muted()
end
