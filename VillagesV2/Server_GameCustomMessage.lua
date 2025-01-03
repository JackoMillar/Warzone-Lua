function Server_GameCustomMessage(game, playerId, payload, setReturn)
	data = Mod.PublicGameData;
	--We need this if statement to ensure that the mod does not break if payload == nil
	if not payload then
		return;
	end

	if payload.type == "UpdatingMarkets" then
		--Init variables
		numMarket = payload.numStruct;
		--Add one to players Market total
		data.Markets[playerId] = numMarket + 1;
		--subtract one from players village count
		data.Counters[playerId] = data.Counters[playerId] - 1;
		--need to input the data to server and end function
		Mod.PublicGameData = data;
		return(data.Markets[playerId]);

	elseif payload.type == "UpdatingHospitals" then
		--Init variables
		numHospital = payload.numStruct;
		--Add one to players Market total
		data.Hospitals[playerId] = numHospital + 1;
		--subtract one from players village count
		data.Counters[playerId] = data.Counters[playerId] - 1;
		--need to input the data to server and end function
		Mod.PublicGameData = data;
		return(data.Hospitals[playerId]);

	elseif payload.type == "UpdatingEmbassys" then
		--Init variables
		numEmbassy = payload.numStruct;
		--Add one to players Market total
		data.Embassys[playerId] = numEmbassy + 1;
		--subtract one from players village count
		data.Counters[playerId] = data.Counters[playerId] - 1;
		--need to input the data to server and end function
		Mod.PublicGameData = data;
		return(data.Embassys[playerId]);

	elseif payload.type == "UpdatingChurchs" then
		--Init variables
		numChurch = payload.numStruct;
		--Add one to players Market total
		data.Churchs[playerId] = numChurch + 1;
		--subtract one from players village count
		data.Counters[playerId] = data.Counters[playerId] - 1;
		--need to input the data to server and end function
		Mod.PublicGameData = data;
		return(data.Churchs[playerId]);

	end
end
