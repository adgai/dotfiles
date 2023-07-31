local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local theme = {}

theme.font = "Jetbrains Mono Nerd Font 11"

theme.useless_gap = 5

-- colors ----------------------------

theme.background = "#3c3836"
theme.background_alt = "#4d4642"
theme.background_urgent = "#665c54"

theme.foreground = "#d4be98"

theme.accent = theme.foreground

-- default vars ----------------------

theme.bg_normal = theme.background
theme.fg_normal = theme.foreground

-- notification --------------------------------

theme.notification_spacing = 20

-- taglist -------------------------------------
theme.taglist_bg_focus = theme.accent
theme.taglist_fg_focus = theme.background
theme.taglist_bg_urgent = theme.background_urgent
theme.taglist_fg_urgent = theme.foreground
theme.taglist_bg_occupied = theme.background
theme.taglist_fg_occupied = theme.foreground
theme.taglist_bg_empty = theme.background_alt
theme.taglist_fg_empty = theme.foreground
theme.taglist_bg_volatile = theme.background_alt
theme.taglist_fg_volatile = foreground

-- tooltips -------------------------------------

theme.tooltip_bg = theme.background
theme.tooltip_fg = theme.foreground
theme.tooltip_border_width = 0

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = Papirus

return theme

