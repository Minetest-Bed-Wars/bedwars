bedwars_map = {}
bedwars_map.maps = {}
bedwars_map.lobby = nil
bedwars_map.map = nil
bedwars_map.mapdir = minetest.get_modpath(minetest.get_current_modname()) .. "/map_schems/"

function bedwars_map.load_maps()
	local idx = 1
	bedwars_map.available_maps = {}
	for _, dirname in pairs(minetest.get_dir_list(bedwars_map.mapdir, true)) do
		local conf = Settings(bedwars_map.mapdir .. "/" .. dirname .. "/map.conf")
		local map = bedwars_map.load_map_meta(idx, dirname, conf)
		if string.lower(map.name) == "lobby" then
			bedwars.log("Loaded 'lobby'")
			bedwars_map.lobby = map
		else
			bedwars.log("Loaded map '" .. map.name .. "'")
			bedwars_map.available_maps[idx] = map
			idx = idx + 1
		end
	end

	if not next(bedwars_map.available_maps) then
		error("No maps found in directory " .. bedwars_map.mapdir)
	end

	-- add random order

	bedwars.log("Maps Loaded!")
	return bedwars_map.available_maps
end

function bedwars.init_lobby()
	if bedwars_map.lobby then
		bedwars_map.place_map(bedwars_map.lobby)
	else
		error("Lobby Failed to Load!")
	end

	bedwars.log("Lobby Placed!")
end

function bedwars.init_world()
	bedwars_map.place_map(bedwars_map.available_maps[1])

	bedwars.log("Map Loaded!")
end

function bedwars_map.load_map_meta(idx, dirname, meta)
	bedwars.log("load_map_meta: Loading map meta from '" .. dirname .. "/map.conf'")

	local map = {
		dirname       = dirname,
		name          = meta:get("name"),
		r             = tonumber(meta:get("r")),
		h             = tonumber(meta:get("h")),
		author        = meta:get("author"),
		teams         = {}
	}

	if string.lower(meta:get("name")) == "lobby" then
		map.offset = vector.new(0,0,0)
	else
		map.offset = vector.new(600 * idx, 0, 0)
	end

	map.pos1 = vector.add(map.offset, { x = -map.r, y = -map.h / 2, z = -map.r })
	map.pos2 = vector.add(map.offset, { x =  map.r, y =  map.h / 2, z =  map.r })
	if map.name == "lobby" then -- center the lobby
		map.pos = vector.add(map.offset, vector.new(-map.r/2, -map.h/2, -map.r/2))
	else
		map.pos = map.pos1
	end

	-- Read teams from config
	local i = 1
	while meta:get("team." .. i) do
		local tname = meta:get("team." .. i)
		local tcolor = meta:get("team." .. i .. ".color")
		local tpos = minetest.string_to_pos(meta:get("team." .. i .. ".pos"))
		local tspawnpos = minetest.string_to_pos(meta:get("team." .. i .. ".spawn_pos"))

		map.teams[tname] = {
			color = tcolor,
			pos = vector.add(map.offset, tpos),
			spawn_pos = vector.add(map.offset, tspawnpos),
			dir = tonumber(meta:get("team." .. i .. ".dir"))
		}

		i = i + 1
	end

	return map
end

function bedwars_map.place_map(map)
	local schempath = bedwars_map.mapdir .. map.dirname .. "/map.mts"
	local res = minetest.place_schematic(map.pos, schempath, "0")

	assert(res, "Unable to place schematic, does the MTS file exist? Path: " .. schempath)

	bedwars_map.map = map
	print(dump(map))

	for team_color, value in pairs(bedwars_map.map.teams) do
		--bedwars_map.place_bed(value.color, value.pos)
		minetest.set_node(value.pos, {name="default:dirt"})
	end
	-- add colored beds for each team

	if string.lower(map.name) ~= "lobby" then
		minetest.after(2, function()
			local msg = (minetest.colorize("#fcdb05", "Map: ") .. minetest.colorize("#f49200", map.name) ..
				minetest.colorize("#fcdb05", " by ") .. minetest.colorize("#f49200", map.author))
			minetest.chat_send_all(msg)
		end)
	end

	minetest.after(10, function()
		minetest.fix_light(bedwars_map.map.pos1, bedwars_map.map.pos2)
	end)

	bedwars.log(map.name .. " has been placed!")
end

if bedwars.mode == "Game_Play" then
	minetest.after(0, function ()
		bedwars_map.load_maps()
		bedwars.init_lobby()
	end)
end