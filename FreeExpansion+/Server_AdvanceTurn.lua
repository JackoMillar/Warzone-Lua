function Server_AdvanceTurn_End(game, addNewOrder)
	local pTable = {}; -- table of player territories
	local t = {};
	local randomNeutralTerr;
	local nonDistArmies = game.Settings.InitialNonDistributionArmies;
	local list = {};

	print(nonDistArmies);

	local onlyBaseNeutrals = Mod.Settings.OnlyBaseNeutrals or false;

	for playerID, _ in pairs(game.Game.PlayingPlayers) do
		t[playerID] = {};
		pTable[playerID] = {};
	end

	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if not territory.IsNeutral then
			for connID, _ in pairs(game.Map.Territories[terrID].ConnectedTo) do
				local connectedTerritory = game.ServerGame.LatestTurnStanding.Territories[connID];
				local connectedTerritoryIsNeutral = connectedTerritory.OwnerPlayerID == WL.PlayerID.Neutral;

				if (
					(onlyBaseNeutrals and connectedTerritoryIsNeutral and connectedTerritory.NumArmies.NumArmies <= nonDistArmies) or
					(not onlyBaseNeutrals and connectedTerritoryIsNeutral)
				) then
					table.insert(t[territory.OwnerPlayerID], connID);
					print(3);
				end
			end
		end
	end

	for p, arr in pairs(t) do
		for times = 1, math.min(Mod.Settings.NumToConvert, #arr) do
			local rand = math.random(#arr);
			local randomNeutralTerr = arr[rand]; -- picks random neutral then gives it too player

			if not randomNeutralTerr then
				break;
			end

			if bordersOpponent(game, t, p, terrID) then
				local terrMod = WL.TerritoryModification.Create(randomNeutralTerr);

				terrMod.SetOwnerOpt = p;
				terrMod.SetArmiesTo = Mod.Settings.SetArmiesTo; -- you can leave this out, if this field is nil it will not change anything to the army count
				table.insert(list, terrMod);

				--addNewOrder(WL.GameOrderEvent.Create(p, 'New territory', {}, {terrMod}), true));
			end

			table.remove(arr, rand);
		end

		table.insert(pTable[p], WL.GameOrderEvent.Create(p, 'New territory', {}, list));
	end

	local i = 1;
	local addedOrders = true;

	while addedOrders do
		addedOrders = false;

		for p, _ in pairs(game.Game.PlayingPlayers) do
			if pTable[p][i] ~= nil then
				addedOrders = true;
				addNewOrder(pTable[p][i]);
			end
		end

		i = i + 1;
	end
end

function getTableLength(t)
	local a = 0;

	for i, _ in pairs(t) do
		a = a + 1;
	end

	return a;
end

function bordersOpponent(game, t, p, terrID)
	for p2, arr in pairs(t) do
		if p ~= p2 and (getTeam(game, p) == -1 or getTeam(game, p) ~= getTeam(game, p2)) then
			if valueInTable(arr, terrID) then
				return false;
			end
		end
	end
end

function getTeam(game, p)
	return game.Game.PlayingPlayers[p].Team;
end

function valueInTable(t, v)
	for _, v2 in pairs(t) do
		if v == v2 then
			return true;
		end
	end
end
