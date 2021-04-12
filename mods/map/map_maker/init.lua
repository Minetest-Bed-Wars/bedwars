map_maker = {}
local storage = minetest.get_mod_storage()
local randint = math.random(100)
local defaults = {
	mapname = "bedwars_"..randint,
	mapauthor = nil,
	maptitle = "Untitled Map "..randint,
	mapinitial = "",
	center = {x = 0,y = 0,z = 0,r = 115,h = 140},
	beds = {}
}

local context = {
	mapname = storage:get_string("mapname"),
	maptitle = storage:get_string("maptitle"),
	mapauthor = storage:get_string("mapauthor"),
	mapinitial = storage:get_string("mapinitial"),
	center = storage:get_string("center"),
	beds = storage:get_string("beds"),
}

if context.mapname == "" then
	context.mapname = defaults.mapname
end
if context.mapauthor == "" then
	context.mapauthor = defaults.mapauthor
end
if context.maptitle == "" then
	context.maptitle = defaults.maptitle
end
if context.center == "" then
	context.center = defaults.center
else
	context.center = minetest.parse_json(storage:get_string("center"))
end
if context.beds == "" then
	context.beds = defaults.beds
else
	context.beds = minetest.parse_json(storage:get_string("beds"))
end

--[[minetest.register_node(":ctf_map:flag", {
	description = "Flag",
	drawtype="nodebox",
	paramtype = "light",
	walkable = false,
	tiles = {
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"map_maker_flag_grey.png",
		"map_maker_flag_grey.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{ 0.250000,-0.500000,0.000000,0.312500,0.500000,0.062500},
			{ -0.5,0,0.000000,0.250000,0.500000,0.062500}
		}
	},
	groups = {oddly_breakable_by_hand=1,snappy=3},
	after_place_node = function(pos)
		table.insert(context.flags, vector.new(pos))
		storage:set_string("flags", minetest.write_json(context.flags))
	end,
	on_destruct = function(pos)
		for i, v in pairs(context.flags) do
			if vector.equals(pos, v) then
				context.flags[i] = nil
				return
			end
		end
	end
})]]

--assert(minetest.get_modpath("worldedit") and minetest.get_modpath("worldedit_commands"),"worldedit and worldedit_commands are required!")

function map_maker.get_context()
	return context
end

function map_maker.we_select(name)
	local pos1, pos2 = to_2pos()
	worldedit.pos1[name] = pos1
	worldedit.mark_pos1(name)
	worldedit.player_notify(name, "position 1 set to " .. minetest.pos_to_string(pos1))
	worldedit.pos2[name] = pos2
	worldedit.mark_pos2(name)
	worldedit.player_notify(name, "position 2 set to " .. minetest.pos_to_string(pos2))
end

function map_maker.we_import(name)
	local pos1 = worldedit.pos1[name]
	local pos2 = worldedit.pos2[name]
	if pos1 and pos2 then
		local size = vector.subtract(pos2, pos1)
		local r = max(size.x, size.z) / 2
		context.center = vector.divide(vector.add(pos1, pos2), 2)
		context.center.r = r
		context.center.h = size.y
		storage:set_string("center", minetest.write_json(context.center))
	end
end

function map_maker.set_meta(k, v)
	if v ~= context[k] then
		context[k] = v

		if type(v) == "number" then
			storage:set_int(k, v)
		else
			storage:set_string(k, v)
		end
	end
end

function map_maker.set_center(name, center)
	if center then
		for k, v in pairs(center) do
			context.center[k] = v
		end
	else
		local r   = context.center.r
		local h   = context.center.h
		local pos = minetest.get_player_by_name(name):get_pos()
		context.center = vector.floor(pos)
		context.center.r = r
		context.center.h = h
	end
	storage:set_string("center", minetest.write_json(context.center))
end

function map_maker.get_bed_status()
	if #context.beds > 4 then
		return "Too many beds! (" .. #context.beds .. "/2)"
	elseif #context.beds < 4 then
		return "Place more beds (" .. #context.beds .. "/2)"
	else
		return "Place 4 beds."
	end
end

function map_maker.export(name)
	if #context.beds ~= 4 then
		minetest.chat_send_all("You need to place 4 beds!")
		return
	end

	map_maker.we_select(name)
	map_maker.show_progress_formspec(name, "Exporting...")

	local path = minetest.get_worldpath() .. "/schems/" .. context.mapname .. "/"
	minetest.mkdir(path)

	-- Reset mod_storage
	storage:set_string("center", "")
	storage:set_string("maptitle", "")
	storage:set_string("mapauthor", "")
	storage:set_string("mapname", "")

	-- Write to .conf
	local meta = Settings(path .. "map.conf")
	meta:set("name", context.maptitle)
	meta:set("author", context.mapauthor)
	meta:set("r", context.center.r)
	meta:set("h", context.center.h)

	--[[for _, beds in pairs(context.beds) do
		local pos = vector.subtract(beds, context.center)
		--[[local old = vector.new(pos)
		pos.x = old.z
		pos.z = -old.x]]

		-- loop through placed beds and add info
		--[[local idx = pos.z > 0 and 1 or 2
		meta:set("team." .. idx, pos.z > 0 and "red" or "blue")
		meta:set("team." .. idx .. ".color", pos.z > 0 and "red" or "blue")
		meta:set("team." .. idx .. ".pos", minetest.pos_to_string(pos))
	end]]
	meta:write()

	minetest.after(0.1, function()
		local filepath = path .. "map.mts"
		if minetest.create_schematic(worldedit.pos1[name], worldedit.pos2[name],
				worldedit.prob_list[name], filepath) then
			minetest.chat_send_all("Exported " .. context.mapname .. " to " .. path)
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
		"button[6.05,0.7;1.5,1;towe;To WE]",
		"button[7.55,0.7;1.5,1;fromwe;From WE]",
		"button[4.3,1.7;4.75,1;emerge;Emerge Area]",

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

function map_maker.emerge_progress(ctx)
	map_maker.show_progress_formspec(ctx.name,
		string.format("Emerging Area - %d/%d blocks emerged (%.1f%%)",
		ctx.current_blocks, ctx.total_blocks,
		(ctx.current_blocks / ctx.total_blocks) * 100))
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

	if fields.author then
		map_maker.set_meta("mapauthor", fields.author)
	end

	if fields.name then
		map_maker.set_meta("mapname", fields.name)
	end

	if fields.set_center then
		map_maker.set_center(name)
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
