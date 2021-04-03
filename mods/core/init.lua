
-- lobby for players waiting for round to start??

-- team assignment

-- ore generators

-- place beds on round start

-- round control

-- round start

local min_players_for_round = 4
local round_types = {
	"1v1v1"
}

bedwars = {
	round_going = false,
	teams = {},
	round_type = 1,

}

local function make_teams()
	print("Connected players")
	for _,player in pairs(minetest.get_connected_players()) do
		print(player:get_player_name())
	end
end

minetest.register_on_joinplayer(function(player)
	print(player:get_player_name() .." has joined")
	make_teams()
end)

----------
-- Tool --
----------

minetest.register_tool("bedwars_core:digger", {
	description = "Unbreakable Nodes Digger",
	inventory_image = "bedwars_core_digger.png",
	tool_capabilities = {
		max_drop_level = 3,
		groupcaps = {immortal = {times = {[1] = 0}, uses = 0, maxlevel = 3}
		},
	}
})

-----------------
-- Get Modpath --
-----------------

dofile(minetest.get_modpath(minetest.get_current_modname()).."/unbreakable.lua")
