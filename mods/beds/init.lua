beds = {}
beds.player = {}
beds.bed_position = {}
beds.pos = {}

local reverse = true
local function destruct_bed(pos, n)
	local node = minetest.get_node(pos)
	local other
	local dir = minetest.facedir_to_dir(node.param2)
	if n == 2 then
		other = vector.subtract(pos, dir)
	elseif n == 1 then
		other = vector.add(pos, dir)
	end

	if reverse then
		reverse = not reverse
		minetest.remove_node(other)
	else
		reverse = not reverse
	end
end

function beds.register_bed(name, def)
	local groups= {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1}
	if name ~= "beds:core" then
		groups.not_in_creative_inventory  = 1
	end
	minetest.register_node(name .. "_bottom", {
		description = def.description,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		drawtype = "nodebox",
		tiles = def.tiles.bottom,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		drop = {},
		groups = groups,
		sounds = def.sounds or default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = def.nodebox.bottom,
		},
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox,
		},
		on_place = function(itemstack, placer, pointed_thing)
			local under = pointed_thing.under
			local node = minetest.get_node(under)
			local udef = minetest.registered_nodes[node.name]

			local pos
			if udef and udef.buildable_to then
				pos = under
			else
				pos = pointed_thing.above
			end

			local node_def = minetest.registered_nodes[minetest.get_node(pos).name]
			if not node_def or not node_def.buildable_to then
				return itemstack
			end

			local dir = placer and placer:get_look_dir() and
				minetest.dir_to_facedir(placer:get_look_dir()) or 0
			local botpos = vector.add(pos, minetest.facedir_to_dir(dir))

			local botdef = minetest.registered_nodes[minetest.get_node(botpos).name]
			if not botdef or not botdef.buildable_to then
				return itemstack
			end

			minetest.set_node(pos, {name = name .. "_bottom", param2 = dir})
			minetest.set_node(botpos, {name = name .. "_top", param2 = dir})

			itemstack:take_item()
			if def.on_place then
				def.on_place(itemstack, placer, pointed_thing)
			end
			return itemstack
		end,
		on_destruct = function(pos)
			destruct_bed(pos, 1)
		end,
		can_dig = function(pos, player)
			return beds.can_dig(pos, player)
		end,
		on_dig = function (pos, node, player)
			if def.on_dig then
				def.on_dig(pos, node, player)
			else
				minetest.node_dig(pos, node, player)
			end
		end
	})

	minetest.register_node(name .. "_top", {
		drawtype = "nodebox",
		tiles = def.tiles.top,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = def.sounds or default.node_sound_wood_defaults(),
		drop = {},
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox,
		},
		node_box = {
			type = "fixed",
			fixed = def.nodebox.top,
		},
		on_destruct = function(pos)
			return destruct_bed(pos, 2)
		end,
		can_dig = function(pos, player)
			return beds.can_dig(pos, player)
		end
	})

	minetest.register_alias(name, name .. "_bottom")
end

function beds.can_dig(bed_pos, player)
	local node = minetest.get_node(bed_pos)
	local pteam = bedwars.get_player_team(player:get_player_name())
	if pteam and string.match(node.name, pteam) then
		bedwars.msg(player:get_player_name(), "You can't break your teams bed!")
		return false
	end
	local bcolor = nil -- find the bed color
	for a,_ in pairs(bedwars.team_colors) do
		if string.match(node.name, a) then
			bcolor = a
		end
	end
	if not (bcolor == pteam) then
		bedwars.msg(nil, minetest.colorize(bedwars.team_colors[pteam], player:get_player_name()) ..
		" has broken " .. minetest.colorize(bedwars.team_colors[bcolor], bcolor) .. "'s bed!")
	end
	return true
end

local def_nodebox = {
	bottom = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5},
	top = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5},
}
local def_selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5}

for _,clr in pairs({"red","green","blue","yellow"}) do
	beds.register_bed("beds:"..clr, {
		description = clr.." Bed",
		inventory_image = "beds_bed.png",
		wield_image = "beds_bed.png",
		tiles = {
			bottom = {
				"beds_bed_top_bottom_"..clr..".png^[transformR90",
				"beds_bed_under.png",
				"beds_bed_side_bottom_r_"..clr..".png",
				"beds_bed_side_bottom_r_"..clr..".png^[transformfx",
				"beds_transparent.png",
				"beds_bed_side_bottom_"..clr..".png"
			},
			top = {
				"beds_bed_top_top_"..clr..".png^[transformR90",
				"beds_bed_under.png",
				"beds_bed_side_top_r_"..clr..".png",
				"beds_bed_side_top_r_"..clr..".png^[transformfx",
				"beds_bed_side_top.png",
				"beds_transparent.png",
			}
		},
		nodebox = def_nodebox,
		selectionbox = def_selectionbox
	})
end

beds.register_bed("beds:core", {
	description = "Core Bed",
	inventory_image = "beds_bed.png",
	wield_image = "beds_bed.png",
	tiles = {
		bottom = {
			"beds_bed_top_bottom_core.png^[transformR90",
			"beds_bed_under.png",
			"beds_bed_side_bottom_r_core.png",
			"beds_bed_side_bottom_r_core.png^[transformfx",
			"beds_transparent.png",
			"beds_bed_side_bottom_core.png"
		},
		top = {
			"beds_bed_top_top_core.png^[transformR90",
			"beds_bed_under.png",
			"beds_bed_side_top_r_core.png",
			"beds_bed_side_top_r_core.png^[transformfx",
			"beds_bed_side_top.png",
			"beds_transparent.png",
		}
	},
	nodebox = def_nodebox,
	selectionbox = def_selectionbox,
	on_place = function (itemstack, placer, pointed_thing)
		local dir = minetest.dir_to_facedir(placer:get_look_dir()) or 0
		table.insert(map_maker.context.beds, {pos=pointed_thing.above, dir=dir})
	end,
	on_dig = function (pos, node, player)
		minetest.node_dig(pos, node, player)
		map_maker.context.beds = {}
	end
})
