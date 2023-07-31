local wibox = require("wibox")
local awful = require("awful")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")

-- Widgets --

local launcherdisplay = wibox {
	width = 390,
	height = 466,
	bg = beautiful.background,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color,
	ontop = true,
	visible = false
}

local prompt = wibox.widget.textbox()

local entries = wibox.widget {
	homogeneous = false,
	expand = true,
	forced_num_cols = 1,
	forced_width = 370,
  spacing = 10,
	layout = wibox.layout.grid
}

launcherdisplay:setup {
	layout = wibox.layout.fixed.horizontal,
	fill_space = true,
	spacing = 0,
	{
		layout = wibox.layout.fixed.vertical,
		{
			widget = wibox.container.margin,
			left = 10,
			right = 10,
			top = 10,
			bottom = 0,
			{
				bg = beautiful.background,
				widget = wibox.container.background,
				{
					prompt,
					forced_height = 40,
					left = 10,
					right = 10,
					widget = wibox.container.margin,
				},
			},
		},
		{
			entries,
			margins = 10,
			widget = wibox.container.margin,
		},
	},
	}

-- Functions --

local function next(entries)
	if index_entry ~= #filtered then
		index_entry = index_entry + 1
		if index_entry > index_start + 6 then
			index_start = index_start + 1
		end
	end
end

local function back(entries)
	if index_entry ~= 1 then
		index_entry = index_entry - 1
		if index_entry < index_start then
			index_start = index_start - 1
		end
	end
end

local function gen()
	local entries = {}
	for _, entry in ipairs(Gio.AppInfo.get_all()) do
		if entry:should_show() then
			local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
			table.insert(
				entries,
				{ name = name, appinfo = entry }
			)
		end
	end
	return entries
end

local function filter(cmd)

	filtered = {}
	regfiltered = {}

	-- Filter entries

	for _, entry in ipairs(unfiltered) do
		if entry.name:lower():sub(1, cmd:len()) == cmd:lower() then
			table.insert(filtered, entry)
		elseif entry.name:lower():match(cmd:lower()) then
			table.insert(regfiltered, entry)
		end
	end

	-- Sort entries

	table.sort(filtered, function(a, b) return a.name:lower() < b.name:lower() end)
	table.sort(regfiltered, function(a, b) return a.name:lower() < b.name:lower() end)

	-- Merge entries

	for i = 1, #regfiltered do
		filtered[#filtered+1] = regfiltered[i]
	end

	-- Clear entries

	entries:reset()

	-- Add filtered entries

	for i, entry in ipairs(filtered) do
		local widget = wibox.widget {
			forced_height = 48,
			widget = wibox.container.background,
      bg = beautiful.background_alt,
      fg = beautiful.foreground,
			{
				margins = 10,
				widget = wibox.container.margin,
				{
					text = entry.name,
					widget = wibox.widget.textbox,
				},
			},
		}

		if index_start <= i and i <= index_start + 6 then
			entries:add(widget)
		end

		if i == index_entry then
			widget.bg = beautiful.foreground
			widget.fg = beautiful.background
		end
	end

	-- Fix position

	if index_entry > #filtered then
		index_entry, index_start = 1, 1
	elseif index_entry < 1 then
		index_entry = 1
	end

	collectgarbage("collect")
end

local function open()

	-- Reset index and page

	index_start, index_entry = 1, 1

	-- Get entries

	unfiltered = gen()
	filter("")

	-- Prompt

	awful.prompt.run {
		prompt = "Search: ",
		textbox = prompt,
		bg = beautiful.background,
		fg = beautiful.background_alt,
		bg_cursor = beautiful.background_alt,
		done_callback = function()
			launcherdisplay.visible = false
		end,
		changed_callback = function(cmd)
			filter(cmd)
		end,
		exe_callback = function(cmd)
			local entry = filtered[index_entry]
			if entry then
				entry.appinfo:launch()
			else
				awful.spawn.with_shell(cmd)
			end
		end,
		keypressed_callback = function(_, key)
			if key == "Down" then
				next(entries)
			elseif key == "Up" then
				back(entries)
			end
		end
	}
end

-- Summon funcs --

local function launcher_hide()
	if launcherdisplay.visible then
		launcherdisplay.visible = false
		awful.keygrabber.stop()
	end
end

local function launcher_toggle()

	local click = awful.button({ }, 1, function(c) launcher_hide() end)

	if not launcherdisplay.visible then
		awful.mouse.append_global_mousebinding(click)
		client.connect_signal("button::press", function() launcher_hide() end)
		open()       
		launcherdisplay.visible = true
	else
		client.disconnect_signal("mouse::press", function() launcher_hide() end)
		awful.mouse.remove_global_mousebinding(click)
		launcher_hide()
	end
end

awesome.connect_signal("summon::launcher", function()
	launcher_toggle()
	awful.placement.centered(launcherdisplay, { honor_workarea = true })
end)
