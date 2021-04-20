map_maker = {}
local randint = math.random(100)
map_maker.context = {
	mapname = "bedwars_"..randint,
	mapauthor = nil,
	maptitle = "Untitled Map "..randint,
	mapinitial = "",
	center = {x = 0,y = 0,z = 0,r = 115,h = 140},
	beds = {},
	spawn_pos = {}
}
if not (minetest.get_modpath("worldedit") or minetest.get_modpath("worldedit_commands")) then
	bedwars.log("worldedit and worldedit_commands are required!")
	return
end
--assert(minetest.get_modpath("worldedit") and minetest.get_modpath("worldedit_commands"),
--	"worldedit and worldedit_commands are required!")

function map_maker.give_beds(player)
	local item = ItemStack("beds:core 4")
	player:get_inventory():set_stack("main", 1, item)
end

function map_maker.get_context()
	return map_maker.context
end

function map_maker.set_meta(k, v)
	if v ~= map_maker.context[k] then
		map_maker.context[k] = v
	end
end

function map_maker.set_center(name, center)
	if center then
		for k, v in pairs(center) do
			map_maker.context.center[k] = v
		end
	else
		local r   = map_maker.context.center.r
		local h   = map_maker.context.center.h
		local pos = minetest.get_player_by_name(name):get_pos()
		map_maker.context.center = vector.floor(pos)
		map_maker.context.center.r = r
		map_maker.context.center.h = h
	end
end

function map_maker.get_bed_status()
	if #map_maker.context.beds > 4 then
		return "Too many beds! (" .. #map_maker.context.beds .. "/4)"
	elseif #map_maker.context.beds < 4 then
		return "Place more beds (" .. #map_maker.context.beds .. "/4)"
	else
		return "You placed 4 beds."
	end
end

local function max(a, b)
	if a > b then
		return a
	else
		return b
	end
end

function map_maker.from_we(name)
	local pos1 = worldedit.pos1[name]
	local pos2 = worldedit.pos2[name]
	if pos1 and pos2 then
		local size = vector.subtract(pos2, pos1)
		local r = max(size.x, size.z) / 2
		map_maker.context.center = vector.divide(vector.add(pos1, pos2), 2)
		map_maker.context.center.r = r
		map_maker.context.center.h = size.y
	end
end

function map_maker.export(name)
	if #map_maker.context.beds ~= 4 then
		minetest.chat_send_all("You need to place 4 beds!")
		return
	end

	if #map_maker.context.spawn_pos ~= 4 then
		minetest.chat_send_all("You need to place 4 spawn point!")
		return
	end

	map_maker.show_progress_formspec(name, "Exporting...")

	local path = minetest.get_worldpath() .. "/schems/" .. map_maker.context.mapname .. "/"
	minetest.mkdir(path)

	-- Write to .conf
	local meta = Settings(path .. "map.conf")
	meta:set("name", map_maker.context.maptitle)
	meta:set("author", map_maker.context.mapauthor)
	meta:set("r", map_maker.context.center.r)
	meta:set("h", map_maker.context.center.h)

	local idx = 1
	for team, _ in pairs(bedwars.team_colors) do
		meta:set("team." .. idx, team)
		meta:set("team." .. idx .. ".color", team)
		meta:set("team." .. idx .. ".pos", minetest.pos_to_string(vector.subtract(map_maker.context.beds[idx].pos, map_maker.context.center)))
		meta:set("team." .. idx .. ".dir", map_maker.context.beds[idx].dir)
		meta:set("team." .. idx .. ".spawn_pos", minetest.pos_to_string(vector.subtract(map_maker.context.spawn_pos[idx], map_maker.context.center)))
		idx = idx + 1
	end
	meta:write()

	minetest.after(0.1, function()
		local filepath = path .. "map.mts"
		if minetest.create_schematic(worldedit.pos1[name], worldedit.pos2[name], worldedit.prob_list[name], filepath) then
			minetest.chat_send_all("Exported " .. map_maker.context.mapname .. " to " .. path)
			minetest.close_formspec(name, "")
		else
			minetest.chat_send_all("Failed!")
			map_maker.show_gui(name)
		end
	end)
	return
end

function map_maker.show_gui(name)
	local context = map_maker.get_context()
	local mapauthor = context.mapauthor or name

	local formspec = {
		"size[9,9.5]",
		"bgcolor[#080808BB;true]",

		"label[0,0;1. Select Area]",
		"field[0.4,1;1,1;posx;X;", context.center.x, "]",
		"field[1.4,1;1,1;posy;Y;", context.center.y, "]",
		"field[2.4,1;1,1;posz;Z;", context.center.z, "]",
		"field[0.4,2;1.5,1;posr;R;", context.center.r, "]",
		"field[1.9,2;1.5,1;posh;H;", context.center.h, "]",
		"button[4.3,0.7;1.75,1;set_center;Player Pos]",
		"button[7.55,0.7;1.5,1;fromwe;From WE]",

		--"box[0,2.65;8.85,0.05;#111111BB]",
		--"box[4.4,2.8;0.05,2.2;#111111BB]",

		"label[4.8,2.8;3. Place Beds]",
		"label[4.8,3.3;", minetest.formspec_escape(map_maker.get_bed_status()), "]",
		"button[4.8,4;3.5,1;giveme;Giveme Beds]",

		"box[0,5.06;8.85,0.05;#111111BB]",

		"label[0,5.15;4. Meta Data]",
		"field[0.4,6.2;8.5,1;title;Title;",
		minetest.formspec_escape(context.maptitle), "]",
		"field[0.4,8.4;4.25,1;name;File Name;",
		minetest.formspec_escape(context.mapname), "]",
		"field[4.625,8.4;4.25,1;author;Author;",
		minetest.formspec_escape(mapauthor), "]",

		"button_exit[1.3,9;3,1;close;Close]",
		"button_exit[4.3,9;3,1;export;Export]",
	}

	formspec = table.concat(formspec, "")
	minetest.show_formspec(name, "bedwars_core:tool", formspec)
end

function map_maker.show_progress_formspec(name, text)
	minetest.show_formspec(name, "bedwars_core:progress",
		"size[6,1]bgcolor[#080808BB;true]" ..
		"label[0,0;" ..
		minetest.formspec_escape(text) .. "]")
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "bedwars_core:tool" then
		return
	end

	local name = player:get_player_name()

	if fields.posx or fields.posy or fields.posz or fields.posh or fields.posr then
		map_maker.set_center(name, {
			x = tonumber(fields.posx),
			y = tonumber(fields.posy),
			z = tonumber(fields.posz),
			h = tonumber(fields.posh),
			r = tonumber(fields.posr)
		})
	end

	if fields.title then
		map_maker.set_meta("maptitle", fields.title)
	end

	if fields.giveme then
		map_maker.give_beds(player)
	end

	if fields.author then
		map_maker.set_meta("mapauthor", fields.author)
	end

	if fields.name then
		map_maker.set_meta("mapname", fields.name)
	end

	if fields.set_center then
		map_maker.set_center(name)
	end

	if fields.fromwe then
		map_maker.from_we(name)
	end

	if fields.export then
		map_maker.export(name)
	end

	if not fields.quit then
		map_maker.show_gui(name)
	end
end)

minetest.register_chatcommand("gui", {
	func = function(name)
		map_maker.show_gui(name)
		return true
	end
})
