require('UI');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	checkForMercenaryCampCaptured(game, order, orderResult, skipThisOrder, addNewOrder);
	checkForArmyCacheCaptured(game, order, orderResult, skipThisOrder, addNewOrder);
end

function Server_AdvanceTurn_End(game, addNewOrder)
	local pTable = {}; -- table of player territories
	local t = {};
	local randomNeutralTerr;
	local nonDistArmies = game.Settings.InitialNonDistributionArmies;

	local list = {};

	for playerID, _ in pairs(game.Game.PlayingPlayers) do
		t[playerID] = {};
		pTable[playerID] = {};
	end

	local onlyBaseNeutrals = Mod.Settings.OnlyBaseNeutrals or false;

	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if not territoriy.IsNeutral then
			for connID, _ in pairs(territory.ConnectedTo) do
				local connectedTerr =  game.ServerGame.LatestTurnStanding.Territories[connID];

				if (
					connectedTerr.OwnerPlayerID == WL.PlayerID.Neutral and
					((onlyBaseNeutrals and connectedTerr.NumArmies.NumArmies <= nonDistArmies) or true)
				) then
					table.insert(t[connectedTerr.OwnerPlayerID], connID);
				end
			end
		end
	end

	for p, arr in pairs(t) do
		for times = 1, math.min(Mod.Settings.NumToConvert, #arr) do
			local rand = math.random(#arr);
			local randomNeutralTerrId = arr[rand]; -- picks random neutral then gives it too player

			if not randomNeutralTerrId then
				break;
			end

			if bordersOpponent(game, t, p, terrID) then
				local terrMod = WL.TerritoryModification.Create(randomNeutralTerrId);

				terrMod.SetOwnerOpt = p;
				terrMod.SetArmiesTo = Mod.Settings.SetArmiesTo; -- you can leave this out, if this field is nil it will not change anything to the army count
				table.insert(list, terrMod);

				local randomNeutralTerr = game.ServerGame.LatestTurnStanding.Territories[randomNeutralTerr];
				local terr_has_merc_camp = territoryHasStructure(randomNeutralTerr, WL.StructureType.MercenaryCamp);
				--local terr_has_army_cache = territoryHasStructure(randomNeutralTerr, WL.StructureType.ArmyCache);

				if terr_has_merc_camp then
					playerID = p;
					Village(game, addNewOrder, randomNeutralTerrId, playerID);
				end

				--if terr_has_army_cache then
					--playerID = p;
					--ArmyCache(game, addNewOrder, randomNeutralTerrId, playerID);
				--end
			end

			--addNewOrder(WL.GameOrderEvent.Create(p, 'New territory', {}, {terrMod}), true));

			table.remove(arr, rand);
		end

		table.insert(pTable[p], WL.GameOrderEvent.Create(p, 'New territory', {}, list));
		list = {};
	end

	local i = 1;
	local addedOrders = true;

	while addedOrders do
		addedOrders = false;

		for p, _  in pairs(game.Game.PlayingPlayers) do
			if pTable[p][i] ~= nil then
				addedOrders = true;
				addNewOrder(pTable[p][i]);
			end
		end

		i = i + 1;
	end
end

function checkForMercenaryCampCaptured(game, order, orderResult, addNewOrder, skipThisOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	if not (orderResult.IsAttack and orderResult.IsSuccessful) then
		return;
	end

	local attackedTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];
	local attackerTerr = game.ServerGame.LatestTurnStanding.Territories[order.From];

	if territoryHasStructure(attackedTerr, WL.StructureType.MercenaryCamp) then
		-- there is a mercenary camp on the territory that was successfully attacked
		-- so now you can do what you want :p

		Village(game, addNewOrder, order.To, order.PlayerID);
	end

	if not (not Mod.Settings.AttackNeutral and (attackedTerr.OwnerPlayerID == WL.PlayerID.Neutral)) then
		return;
	end

	print(attackedTerr.NumArmies.NumArmies);
	print(orderResult.AttackingArmiesKilled.NumArmies);

	local terrModTo = WL.TerritoryModification.Create(order.To);

	terrModTo.SetOwnerOpt = WL.PlayerID.Neutral;
	terrModTo.SetArmiesTo = (attackedTerr.NumArmies.NumArmies - orderResult.DefendingArmiesKilled.NumArmies);

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Calculating damage done', {}, {terrModTo}));

	local terrModfrom = WL.TerritoryModification.Create(order.From);

	terrModfrom.SetArmiesTo = attackerTerr.NumArmies.NumArmies - orderResult.AttackingArmiesKilled.NumArmies;

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Returning damaged troops', {}, {terrModfrom}), true);
end

function checkForArmyCacheCaptured(game, order, orderResult, addNewOrder, skipThisOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer' and orderResult.IsSuccessful) then
		return;
	end

	local TransferredTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];

	if not territoryHasStructure(TransferredTerr, WL.StructureType.ArmyCache) then
		return;
	end

	-- there is a army cache on the territory that was successfully attacked
	-- so now you can do what you want :p

	ArmyCache(game, addNewOrder, order.To, order.PlayerID);

	if territoryHasStructure(TransferredTerr, WL.StructureType.ResourceCache) then
		ResourceCache(game, addNewOrder, order.To, order.PlayerID);
	end
end

function territoryHasStructure(territory, structureType)
	return territory.Structures and territory.Structures[structureType];
end

function ResourceCache(game, addNewOrder, terrID, playerID)
	local cardArray = {};
	local t1 = {};
	local t2 = {};
	local list = {};

	local terrMod = WL.TerritoryModification.Create(terrID);

	structures = {};
	structures[WL.StructureType.ResourceCache] = -1;
	terrMod.AddStructuresOpt = structures;

	for cardID, _ in pairs(game.Settings.Cards) do
		table.insert(cardArray, cardID);
	end

	local rand = math.random(#cardArray);
	local randomCard = cardArray[rand]; -- picks random card to give to player
	local pieces = Mod.Settings.cPieces;

	if Mod.Settings.FixedPieces == false then
		if Mod.Settings.Luck ~= nil then
			pieces = math.max(pieces + math.random(-Mod.Settings.Luck, Mod.Settings.Luck), 0);
		end
	end

	print(Mod.Settings.cPieces);
	print(playerID);
	print(pieces);

	local cardEvent = WL.GameOrderEvent.Create(playerID, 'Claimed a card cache and received ' .. pieces .. ' pieces for a random card', {}, {terrMod}, {}, {});

	t1[randomCard] = pieces;
	t2[playerID] = t1;
	cardEvent.AddCardPiecesOpt = t2;

	addNewOrder(cardEvent, true);
end

function ArmyCache(game, addNewOrder, terrID, playerID)
	local structures = game.ServerGame.LatestTurnStanding.Territories[terrID].Structures
	local IncomeAmount = Mod.Settings.Armies;
	local terrMod = WL.TerritoryModification.Create(terrID);

	structures = {};
	structures[WL.StructureType.ArmyCache] = -1;
	terrMod.AddStructuresOpt = structures;

	if not Mod.Settings.FixedArmies then
		local luck = Mod.Settings.Luck or 10;

		IncomeAmount = IncomeAmount + math.random(-luck, luck);
	end

	local incomeMod = WL.IncomeMod.Create(playerID, IncomeAmount, 'You have captured an army cache');

	addNewOrder(WL.GameOrderEvent.Create(playerID, 'Updated income', {}, {terrMod}, {}, {incomeMod}));
end

function Village(game, addNewOrder, terrID, playerID)
	local list = {};

	for terrID, territory in pairs(game.Map.Territories[terrID].ConnectedTo) do
		if (
			(Mod.Settings.ONeutrals == and game.ServerGame.LatestTurnStanding.Territories[terrID].IsNeutral) or
			(not Mod.Settings.ONeutrals and game.ServerGame.LatestTurnStanding.Territories[terrID].OwnerPlayerID ~= playerID)
		) then
			local terrMod = WL.TerritoryModification.Create(terrID);

			terrMod.SetOwnerOpt = playerID;
			terrMod.SetArmiesTo = Mod.Settings.Armies;

			table.insert(list, terrMod);
		end
	end

	addNewOrder(WL.GameOrderEvent.Create(playerID, 'New territory', {}, list), true);
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

	return true;
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

	return false;
end
