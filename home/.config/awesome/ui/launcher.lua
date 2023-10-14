local wibox = require("wibox")
local awful = require("awful")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")
local dir = "~/.disk/Books/'10 класс'/"

local prompt = wibox.widget.textbox()

local entries_container = wibox.widget {
	homogeneous = false,
	expand = true,
	spacing = 10,
	forced_num_cols = 1,
	forced_width = 287,
	layout = wibox.layout.grid
}

local main = wibox.widget {
	widget = wibox.container.margin,
	margins = 10,
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
			{
				widget = wibox.container.background,
				bg = beautiful.background_alt,
				{
					widget = wibox.container.margin,
					margins = 6,
					{
						widget = wibox.widget.textbox,
						valign = "center",
						id = "mode_icon",
						font = beautiful.font .. " 14",
					}
				}
			},
			prompt,
		},
		entries_container,
	},
}

local launcher = awful.popup {
	minimum_width = 390,
	maximum_width = 390,
	minimum_height = 478,
	maximum_height = 478,
	bg = beautiful.background,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	ontop = true,
	visible = false,
	placement = function(d)
		awful.placement.centered(d, { honor_workarea = false })
	end,
	widget = main
}

-- Functions --
local function next()
	if index_entry ~= #filtered then
		index_entry = index_entry + 1
		if index_entry > index_start + 6 then
			index_start = index_start + 1
		end
	end
end

local function back()
	if index_entry ~= 1 then
		index_entry = index_entry - 1
		if index_entry < index_start then
			index_start = index_start - 1
		end
	end
end

local global_mode = nil

local function gen(mode)

	local list = {
		["books"] = io.popen("ls -A " .. dir):lines(),
		["clipboard"] = io.popen("greenclip print"):lines()
	}
	local entries = {}
	if mode == nil then
		for _, entry in ipairs(Gio.AppInfo.get_all()) do
			if entry:should_show() then
				local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
				table.insert( entries, { name = name, appinfo = entry } )
			end
		end
	else
		for entry in list[global_mode] do
			local open_command = {
				["clipboard"] = "echo " .. "'"..entry.."'" .. " | xclip -r -sel clipboard",
				["books"] = "cd " .. dir .. " && zathura " .. entry,
			}
			local appinfo = open_command[mode]
			if entry:match("[%w+%p+]") then
				table.insert( entries, { name = entry, appinfo = appinfo } )
			end
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
	if global_mode ~= "clipboard" then
		table.sort(filtered, function(a, b) return a.name:lower() < b.name:lower() end)
	end
	table.sort(regfiltered, function(a, b) return a.name:lower() < b.name:lower() end)

	-- Merge entries
	for i = 1, #regfiltered do
		filtered[#filtered+1] = regfiltered[i]
	end

	-- Clear entries
	entries_container:reset()

	-- Add filtered entries
	for i, entry in ipairs(filtered) do
		local entry_widget = wibox.widget {
			forced_height = 50,
			buttons = {
				-- add left double click to launch (first click to navigate entry, second to run entry)
				awful.button({}, 1, function()
					if index_entry == i then
						if global_mode == nil then
							filtered[index_entry].appinfo:launch()
						else
							awful.spawn.with_shell(filtered[index_entry].appinfo)
						end
						awful.keygrabber.stop()
						launcher.visible = false
					else
						index_entry = i
						filter("")
					end
				end),
				-- add mouse scroll
				awful.button({}, 4, function()
					back()
					filter("")
				end),
				awful.button({}, 5, function()
					next()
					filter("")
				end),
			},
			widget = wibox.container.background,
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
			entries_container:add(entry_widget)
		end

		if i == index_entry then
			entry_widget.bg = beautiful.accent
			entry_widget.fg = beautiful.background
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

local function open(mode)

	local mode_icon = {
		["clipboard"] = "",
		["books"] = "",
	}

	if mode == nil then
		main:get_children_by_id("mode_icon")[1].text = ""
	else
		main:get_children_by_id("mode_icon")[1].text = mode_icon[mode]
	end

	global_mode = mode
	-- Reset index and page
	index_start, index_entry = 1, 1

	-- Get entries
	unfiltered = gen(mode)
	filter("")

	-- Prompt
	awful.prompt.run {
		prompt = "Search: ",
		textbox = prompt,
		bg = beautiful.background,
		fg = beautiful.foreground,
		bg_cursor = beautiful.background_alt,
		done_callback = function()
			launcher.visible = false
		end,
		changed_callback = function(cmd)
			filter(cmd)
		end,
		exe_callback = function()
			if filtered[index_entry] then
				if mode == nil then
					filtered[index_entry].appinfo:launch()
				else
					awful.spawn.with_shell(filtered[index_entry].appinfo)
				end
			end
		end,
		keypressed_callback = function(_, key)
			if key == "Down" then
				next()
			elseif key == "Up" then
				back()
			end
		end
	}
end

-- Summon funcs --
awesome.connect_signal("summon::books", function()
	if not launcher.visible then
		open("books")
		launcher.visible = true
	else
		awful.keygrabber.stop()
		launcher.visible = false
	end
end)

awesome.connect_signal("summon::clipboard", function()
	if not launcher.visible then
		open("clipboard")
		launcher.visible = true
	else
		awful.keygrabber.stop()
		launcher.visible = false
	end
end)

awesome.connect_signal("summon::launcher", function()
	if not launcher.visible then
		open()
		launcher.visible = true
	else
		awful.keygrabber.stop()
		launcher.visible = false
	end
end)

-- hide on click --
client.connect_signal("button::press", function()
	awful.keygrabber.stop()
	launcher.visible = false
end)

awful.mouse.append_global_mousebinding(
	awful.button({ }, 1, function()
		awful.keygrabber.stop()
		launcher.visible = false
	end)
)
