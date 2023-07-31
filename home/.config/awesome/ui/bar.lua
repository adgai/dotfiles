local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
require("scripts.init")

screen.connect_signal("request::desktop_decoration", function(s)

-- keyboard layout --------------------------

mykeyboard=awful.widget.keyboardlayout()
mykeyboard.widget.text = string.upper(mykeyboard.widget.text)

mykeyboard.widget:connect_signal("widget::redraw_needed", function(wid) wid.text=string.upper(wid.text) end)

local keyboard = wibox.widget {
layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.background,
   	bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      {
        widget = wibox.widget.textbox,
        text = "",
      },
    },
  },
  {
    widget = wibox.container.background,
   	bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
      widget = wibox.container.margin,
      left = -3,
      right = -3,
      mykeyboard,
    },
  },
}

-- tray --------------------------------

local tray = wibox.widget {
	widget = wibox.widget.systray(),
	base_size = 30,
}

-- clock -------------------------------

local time = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.background,
   	bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      {
        widget = wibox.widget.textbox,
        text = ""
      },
    },
  },
  {
    widget = wibox.container.background,
   	bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      {
      format = "%H:%M:%S",
	    refresh= 1,
	    widget = wibox.widget.textclock,
      },
    }
  },
}

-- taglist -----------------------------

local taglist = awful.widget.taglist {
  screen = s,
  filter = awful.widget.taglist.filter.noempty,
  style = { shape = gears.shape.circle },
	buttons = {
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
  },
	layout = {
    spacing = 4,
    layout = wibox.layout.fixed.horizontal
  },
  widget_template = {
    layout = wibox.layout.fixed.horizontal,
    {
      id = "background_role",
      widget = wibox.container.background,
      forced_width = 30,
      {
        id = "text_role",
        halign = "center",
        valign = "center",
        widget = wibox.widget.textbox
      },
    }
  }
}

-- cpu ----------------------------

local cpu_perc = wibox.widget.textbox()

awesome.connect_signal("signal::cpu", function (value)
	cpu_perc.text = value
end)

local cpu = wibox.widget {
layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.background,
    bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      {
        widget = wibox.widget.textbox,
        text = "",
      },
    },
  },
  {
    widget = wibox.container.background,
    bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
		  widget = wibox.container.margin,
	  	left = 8,
		  right = 8,
		  cpu_perc,
    },
	}
}

-- battery ------------------------------

local bat_perc = wibox.widget.textbox()
local bat_icon = wibox.widget.textbox()

awesome.connect_signal("bat::value", function(value)
  bat_perc.text = value
end)

awesome.connect_signal("bat::state", function(value)
  if value == "Discharging" then
    bat_icon.text = ""
  else
    bat_icon.text = ""
  end
end)

local bat = wibox.widget {
layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.background,
	  bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      bat_icon,
    },
  },
	{
    widget = wibox.container.background,
	  bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
		  widget = wibox.container.margin,
		  left = 8,
		  right = 8,
		  bat_perc,
    },
	}
}

-- ram ------------------------------

local ram_perc = wibox.widget.textbox()

awesome.connect_signal("signal::ram", function (value, total)
	local percantage = math.floor((value/total)*100)
	ram_perc.text = percantage
end)

local ram = wibox.widget {
layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.container.background,
	  bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      {
        widget = wibox.widget.textbox,
        text = "",
      },
    },
  },
	{
    widget = wibox.container.background,
	  bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
		  widget = wibox.container.margin,
		  left = 8,
		  right = 8,
		  ram_perc,
    },
	}
}

-- volume ------------------------------

local volume_perc = wibox.widget.textbox()
local volume_icon = wibox.widget.textbox()

awesome.connect_signal("volume::value", function(value)
  volume_perc.text = value
  if value <= 33 then
    volume_icon.text = ""
  elseif value <= 66 then
    volume_icon.text = ""
  elseif value <= 100 then
    volume_icon.text = ""
  end
end)

awesome.connect_signal("muted::value", function(value)
  if value == "off" then
    volume_icon.text = ""
  end
end)

local volume = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  buttons = {
    awful.button({}, 1, function()
    awful.spawn.with_shell("amixer -D pipewire sset Master toggle")
    updateVolumeSignals()
    end),
    awful.button({}, 4, function()
      awful.spawn.with_shell("amixer -D pipewire sset Master 2%+")
      updateVolumeSignals()
    end),
    awful.button({}, 5, function()
      awful.spawn.with_shell("amixer -D pipewire sset Master 2%-")
      updateVolumeSignals()
    end),
  },
  {
    widget = wibox.container.background,
	  bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      volume_icon,
    },
  },
	{
    widget = wibox.container.background,
	  bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
		  widget = wibox.container.margin,
		  left = 8,
		  right = 8,
		  volume_perc,
    },
	}
}

-- brightness ----------------------------

local bright_perc = wibox.widget.textbox()

awesome.connect_signal("bright::value", function(value)
	bright_perc.text = value
end)

local bright = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  buttons = {
    awful.button({}, 4, function()
      awful.spawn.with_shell("brightnessctl s 5%+")
      update_value_of_bright()
    end),
    awful.button({}, 5, function()
      awful.spawn.with_shell("brightnessctl s 5%-")
      update_value_of_bright()
    end),
  },
  {
    widget = wibox.container.background,
	  bg = beautiful.accent,
    fg = beautiful.background,
    {
      widget = wibox.container.margin,
      left = 8,
      right = 8,
      {
        widget = wibox.widget.textbox,
        text = "",
      },
    },
  },
	{
    widget = wibox.container.background,
	  bg = beautiful.background_alt,
    fg = beautiful.accent,
    {
		  widget = wibox.container.margin,
		  left = 8,
		  right = 8,
		  bright_perc,
    },
	}
}

-- dnd ------------------------------

local dnd_button = wibox.widget {
  widget = wibox.container.background,
  bg = beautiful.background_alt,
  fg = beautiful.accent,
  {
    widget = wibox.container.margin,
    left = 8,
    right = 8,
    {
      widget = wibox.widget.textbox,
      text = "",
    },
  },
}

local dnd = true

awesome.connect_signal("signal::dnd", function()
    dnd = not dnd
    if not dnd then
      dnd_button.widget.widget.text = ""
      naughty.suspend()
    else
       dnd_button.widget.widget.text = ""
      naughty.resume()
    end
  end)

dnd_button:buttons {
  awful.button({}, 1, function()
    dnd = not dnd
    if not dnd then
      dnd_button.widget.widget.text = ""
      naughty.suspend()
   else
      dnd_button.widget.widget.text = ""
      naughty.resume()
    end
  end),
}
-- bar --------------------------

bar = awful.wibar {
	position = "bottom",
	screen   = s,
	height = 50,
	ontop = true,
	margins = {
	left = 10,
	right = 10,
	bottom = 8
	},
	widget = {
		layout = wibox.layout.flex.horizontal,
		{
			widget = wibox.container.place,
			halign = "left",
			content_fill_vertical = true,
			{
			widget = wibox.container.margin,
			margins = 10,
				{
				  layout = wibox.layout.fixed.horizontal,
          spacing = 10,
				  time,
          bright,
          volume,
          bat,
				},
			},
		},
		{
			widget = wibox.container.place,
			halign = "center",
      content_fill_vertical = true,
      {
        widget = wibox.container.margin,
        margins = 10,
			  {
				  layout = wibox.layout.fixed.horizontal,
				  taglist,
	   	  },
      },
		},
		{
			widget = wibox.container.place,
			halign = "right",
      content_fill_vertical = true,
			{
			  widget = wibox.container.margin,
			  margins = 10,
				{
				  layout = wibox.layout.fixed.horizontal,
          spacing = 10,
				  keyboard,
          ram,
          cpu,
          dnd_button,
          tray,
				},
			},
		},
	}
}

end)

client.connect_signal("property::fullscreen", function(c)
	bar.ontop = not c.fullscreen
end)

