local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- osd ----------------------------

local slider = wibox.widget {
	widget = wibox.widget.slider,
	maximum = 100,
  minimum = -30,
	bar_height = 60,
  handle_width = 0,
	bar_color = beautiful.background_alt,
	bar_active_color = beautiful.accent,
	handle_color = beautiful.accent,
}

local icon = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.font .. " 26",
}

local info = wibox.widget {
  widget = wibox.container.margin,
  margins = 10,
  {
    layout = wibox.layout.stack,
	  slider,
    {
      widget = wibox.container.margin,
      left = 6,
      {
        widget = wibox.container.background,
        fg = beautiful.background,
	      icon,
      },
    },
  }
}

local osd = awful.popup {
  visible = false,
	ontop = true,
	minimum_height = 80,
	maximum_height = 80,
	minimum_width = 300,
	maximum_width = 300,
  widget = info,
}

-- volume ---------------------------

awesome.connect_signal("volume::value", function(value)
  slider.value = value
  if value <= 33 then
    icon.text = ""
  elseif value <= 66 then
    icon.text = ""
  elseif value <= 100 then
    icon.text = ""
  end
end)

awesome.connect_signal("muted::value", function(value)
  if value == "off" then
    icon.text = ""
  end
end)

-- bright ---------------------------

awesome.connect_signal("bright::value", function(value)
  slider.value = value
  icon.text = ""
end)

-- function -------------------------

local function osd_hide()
  osd.visible = false
  osd_timer:stop()
end

local osd_timer = gears.timer{
  timeout = 3,
  callback = osd_hide
}

local function osd_toggle()
	if not osd.visible then
		osd.visible = true
    osd_timer:start()
	else
    osd_timer:again()
	end
end

awesome.connect_signal("summon::osd", function()
	osd_toggle()
	awful.placement.top_left(osd, { honor_workarea = true, margins = 20 })
end)
