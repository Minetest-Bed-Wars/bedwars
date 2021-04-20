-----------
-- Nodes --
-----------

minetest.register_node("bedwars_core:dirt", {
	description = "Unbreakable Dirt",
	tiles = {"default_dirt.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:stone", {
	description = "Unbreakable Stone",
	tiles = {"default_stone.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:stonebrick", {
	description = "Unbreakable Stone Brick",
	tiles = {"default_stone_brick.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:wood", {
	description = "Unbreakable Wood",
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:dirt_with_grass", {
	description = "Unbreakable Grass",
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:tree", {
	description = "Unbreakable Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {immortal = 1},
	on_place = minetest.rotate_node
})

minetest.register_node("bedwars_core:meseblock", {
	description = "Unbreakable Mese Block",
	tiles = {"default_mese_block.png"},
	is_ground_content = false,
	light_source = 3,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:diamondblock", {
	description = "Unbreakable Diamond Block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:goldblock", {
	description = "Unbreakable Gold Block",
	tiles = {"default_gold_block.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:aspenwood", {
	description = "Unbreakable Aspen Wood",
	tiles = {"default_aspen_wood.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:pinewood", {
	description = "Unbreakable Pine Wood",
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:glass", {
	description = "Unbreakable Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	is_ground_content = false,
	sunlight_propagates = true,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:acaciawood", {
	description = "Unbreakable Acacia Wood",
	tiles = {"default_acacia_wood.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:steelblock", {
	description = "Unbreakable Steel Block",
	tiles = {"default_steel_block.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:junglewood", {
	description = "Unbreakable Jungle Wood",
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:bronzeblock", {
	description = "Unbreakable Bronze Block",
	tiles = {"default_bronze_block.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:copperblock", {
	description = "Unbreakable Copper Block",
	tiles = {"default_copper_block.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:stone_with_copper", {
	description = "Unbreakable Copper Ore",
	tiles = {"default_stone.png^default_mineral_copper.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:stone_with_iron", {
	description = "Unbreakable Iron Ore",
	tiles = {"default_stone.png^default_mineral_iron.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:stone_with_diamond", {
	description = "Unbreakable Diamond Ore",
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:stone_with_mese", {
	description = "Unbreakable Mese Ore",
	tiles = {"default_stone.png^default_mineral_mese.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:pine_tree", {
	description = "Unbreakable Pine Tree",
	tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
		"default_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {immortal = 1},
	on_place = minetest.rotate_node
})

minetest.register_node("bedwars_core:jungletree", {
	description = "Unbreakable Jungle Tree",
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png",
		"default_jungletree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {immortal = 1},
	on_place = minetest.rotate_node
})

minetest.register_node("bedwars_core:acacia_tree", {
	description = "Unbreakable Acacia Tree",
	tiles = {"default_acacia_tree_top.png", "default_acacia_tree_top.png",
		"default_acacia_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {immortal = 1},
	on_place = minetest.rotate_node
})

minetest.register_node("bedwars_core:aspen_tree", {
	description = "Unbreakable Aspen Tree",
	tiles = {"default_aspen_tree_top.png", "default_aspen_tree_top.png",
		"default_aspen_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {immortal = 1},
	on_place = minetest.rotate_node
})

minetest.register_on_mods_loaded(function ()
	stairs.my_register_stair_and_slab(
		"unbreakable_aspen_wood",
		"bedwars_core:aspen_wood",
		{immortal = 1},
		{"default_aspen_wood.png"},
		"Unbreakable Aspen Wood Stair",
		"Unbreakable Aspen Wood Slab",
		default.node_sound_wood_defaults(),
		false
	)

	stairs.my_register_stair_and_slab(
		"unbreakable_stone_brick",
		"bedwars_core:unbreakable_stone_brick",
		{immortal = 1},
		{"default_stone_brick.png"},
		"Unbreakable Stone Brick Stair",
		"Unbreakable Stone Brick Slab",
		default.node_sound_wood_defaults(),
		false
	)

	stairs.my_register_stair_and_slab(
		"unbreakable_wood",
		"bedwars_core:wood",
		{immortal = 1},
		{"default_wood.png"},
		"Unbreakable Wood Stair",
		"Unbreakable Wood Slab",
		default.node_sound_wood_defaults(),
		false
	)

	stairs.my_register_stair_and_slab(
		"unbreakable_pine_wood",
		"bedwars_core:pinewood",
		{immortal = 1},
		{"default_pine_wood.png"},
		"Unbreakable Pine Wood Stair",
		"Unbreakable Pine Wood Slab",
		default.node_sound_wood_defaults(),
		false
	)
end)

minetest.register_node("bedwars_core:stonebrick", {
	description = "Unbreakable Stone Brick",
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {immortal = 1}
})

minetest.register_node("bedwars_core:spawn_pos", {
	description = "Team Spawn Point",
	tiles = {"default_stone_block.png^default_mese_crystal.png"},
	is_ground_content = false,
	groups = {immortal=1},
	on_place = function (itemstack, placer, pointed_thing)
		minetest.set_node(pointed_thing.above, {name=itemstack:get_name()})
		itemstack:take_item()
		table.insert(map_maker.context.spawn_pos, pointed_thing.above)
		return itemstack
	end,
	on_dig = function (pos, node, player)
		minetest.node_dig(pos, node, player)
		map_maker.context.spawn_pos = {}
	end
})

if bedwars.mode == "Map_Building" then
	minetest.register_node("bedwars_core:border", {
		description = "Border",
		tiles = {"border_visible.png"},
		is_ground_content = false,
		drawtype = "glasslike_framed_optional",
		paramtype = "light",
		paramtype2 = "glasslikeliquidlevel",
		sunlight_propagates = true,
		walkable = false,
		pointable = true,
		groups = {immortal=1},
	})
else
	minetest.register_node("bedwars_core:border", {
		description = "Border",
		tiles = {"border.png"},
		is_ground_content = false,
		drawtype = "glasslike_framed_optional",
		paramtype = "light",
		paramtype2 = "glasslikeliquidlevel",
		sunlight_propagates = true,
		walkable = false,
		pointable = false,
		groups = {immortal=1}
	})
end

bedwars.log("Unbreakable Blocks Loaded")
