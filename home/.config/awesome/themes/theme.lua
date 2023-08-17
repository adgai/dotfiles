local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")

local theme = {}

theme.font = "Jetbrains Mono Nerd Font 11"

theme.useless_gap = 5

-- icons ---------------------------------------

theme.notification_icon = "~/.config/awesome/themes/icons/bell.svg"
theme.notification_icon_error = "~/.config/awesome/themes/icons/alert.svg"
theme.notification_icon_scrensht = "~/.config/awesome/themes/icons/camera.svg"

-- colors -------------------------------------

theme.background = "#191919"
theme.background_alt = "#393939"
theme.background_urgent = "#4c4c4c"
theme.foreground = "#e7e7e7"
theme.accent = "#c49ea0"

-- tray ----------------------------------------

theme.bg_systray = theme.background_alt
theme.systray_icon_spacing = 6

-- borders -------------------------------------

theme.border_width = 2
theme.border_color_normal = theme.background_urgent
theme.border_color_active = theme.accent

-- default vars --------------------------------

theme.bg_normal = theme.background
theme.fg_normal = theme.foreground

-- notification --------------------------------

theme.notification_spacing = 24

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
theme.taglist_fg_volatile = theme.foreground

-- tooltips -------------------------------------

theme.tooltip_bg = theme.background
theme.tooltip_fg = theme.foreground
theme.tooltip_border_width = 0

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = Papirus

return theme

