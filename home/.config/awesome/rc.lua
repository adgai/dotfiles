pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")

awful.util.spawn("/home/sinomor/.config/awesome/autostart.sh")
beautiful.init("~/.config/awesome/themes/theme.lua")
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
	})
end)
require("config")
require("ui")
