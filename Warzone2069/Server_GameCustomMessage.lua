function Server_GameCustomMessage(game, playerId, payload, setReturn)
	data = Mod.PublicGameData;
	if not payload then
		return;
	end

	if payload.type == "UpdatingGullible" then
		--Init variables
		data.Gullible[playerId] = true;
		--need to input the data to server and end function
		Mod.PublicGameData = data;
		return(data.Gullible[playerId]);
	end
	if payload.type == "UpdatingViewed" then
		--Init variables
		print(2);
		data.Viewed[playerId] = true;
		--need to input the data to server and end function
		Mod.PublicGameData = data;
		return(data.Viewed[playerId]);
	end
end
