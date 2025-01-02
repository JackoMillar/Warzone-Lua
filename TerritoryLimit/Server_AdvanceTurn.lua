require('UI');
function Server_AdvanceTurn_End(game, addNewOrder)
	local playerTerrs = {};
	for p, _ in pairs(game.Game.PlayingPlayers) do
		playerTerrs[p] = {};
	end

	for _, terr in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if terr.OwnerPlayerID ~= WL.PlayerID.Neutral then
			-- you should make it so only territories without special units can be lost imo
			local numArmies = terr.NumArmies.NumArmies
			local index = 0;
			for i, terr2 in pairs(playerTerrs[terr.OwnerPlayerID]) do
				if game.ServerGame.LatestTurnStanding.Territories[terr2].NumArmies.NumArmies > numArmies then
					index = i;
					print(100);
					break;
				end
			end
			if index == 0 then
				index = #playerTerrs[terr.OwnerPlayerID] + 1;
			end

			table.insert(playerTerrs[terr.OwnerPlayerID], index, terr.ID);

		end
	end

	-- Now playerTerrs is a table with as key a PlayerID and as value a sorted array, with at index 1 the one with the most armies and the last index the terr with the least

	for p, arr in pairs(playerTerrs) do
		local list = {};
		local t = {};
		for i = 1, #arr - Mod.Settings.TerrLimit do      -- I reversed the loop now
			local terr = game.ServerGame.LatestTurnStanding.Territories[arr[i]];
			local mod = WL.TerritoryModification.Create(arr[i]);
			mod.SetOwnerOpt = WL.PlayerID.Neutral
			for _, sp in ipairs(terr.NumArmies.SpecialUnits) do
				table.insert(t, sp.ID);
			end
			if #t ~= 0 then
				mod.RemoveSpecialUnitsOpt = t;
			end
			table.insert(list, mod);
		end
		local event = WL.GameOrderEvent.Create(p, "Territory cap", {}, list);
		addNewOrder(event);
	end
end

function getTableLength(t)
	local a = 0;
	for i, _ in pairs(t) do

		a = a + 1;
	end
	return a;
end
