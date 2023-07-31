pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

awful.util.spawn("/home/sinomor/.config/awesome/autostart.sh")

beautiful.init("~/.config/awesome/themes/theme.lua")

terminal = "alacritty"
modkey = "Mod4"

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
})
end)

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

awful.mouse.snap.edge_enabled = false

require("rules")
require("keybindings")
require("ui.init")
