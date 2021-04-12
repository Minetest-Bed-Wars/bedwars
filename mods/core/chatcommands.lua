minetest.registered_chatcommands["me"].func = function(name, param)
	local pteam = bedwars.get_player_team(name)
	if pteam then
		name = minetest.colorize(bedwars.team_colors[pteam], "* " .. name)
	else
		name = "* ".. name
	end
	minetest.chat_send_all(name .. " " .. param)
end
