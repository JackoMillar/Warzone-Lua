require('Utilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyWorker_')) then
		return;
	end

	--look for the order that we inserted in Client_PresentCommercePurchaseUI
	--in Client_PresentMenuUI, we stuck the territory ID after BuyRecruiter_.  Break it out and parse it to a number.

	local targetTerritoryID = tonumber(string.sub(order.Payload, 11));
	local targetTerritoryStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];

	if targetTerritoryStanding.OwnerPlayerID ~= order.PlayerID then
		-- can only buy a Worker onto a territory you control
		return;
	end

	if not order.CostOpt then
		-- shouldn't ever happen, unless another mod interferes
		return;
	end

	local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; -- this is the cost from the order. We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there. Therefore, we must calculate it ourselves, and only do the purchase if they match
	local realCost = Mod.Settings.CostToBuyWorker;

	if realCost > costFromOrder then
		-- don't do the purchase if their cost didn't line up. This would only really happen if they hacked their client or another mod interfered
		return;
	end

	local numWorkersAlreadyHave = 0;

	for _, ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if ts.OwnerPlayerID == order.PlayerID then
			numWorkersAlreadyHave = numWorkersAlreadyHave + NumWorkersIn(ts.NumArmies);
		end
	end

	if numWorkersAlreadyHave >= Mod.Settings.MaxWorkers then
		-- this player already has the maximum number of Workers possible, so skip adding a new one.

		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping Worker purchase since max is ' .. Mod.Settings.MaxWorkers .. ' and you have ' .. numWorkersAlreadyHave));
		return;
	end

	local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);

	builder.Name = 'Worker';
	builder.IncludeABeforeName = true;
	builder.ImageFilename = 'hammer.png';
	builder.AttackPower = 3;
	builder.DefensePower = 3;
	builder.CombatOrder = 3417; --defends commanders
	builder.DamageToKill = 3;
	builder.DamageAbsorbedWhenAttacked = 3;
	builder.CanBeGiftedWithGiftCard = true;
	builder.CanBeTransferredToTeammate = true;
	builder.CanBeAirliftedToSelf = true;
	builder.CanBeAirliftedToTeammate = true;
	builder.IsVisibleToAllPlayers = false;

	local terrMod = WL.TerritoryModification.Create(targetTerritoryID);

	terrMod.AddSpecialUnits = {builder.Build()};

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a Worker', {}, {terrMod}));
end

function Server_AdvanceTurn_End(game, addNewOrder)
	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		local numWorkers = NumWorkersIn(territory.NumArmies);

		if numWorkers > 0 then
			local terrMod = WL.TerritoryModification.Create(terrID);

			structures = {};
			structures[WL.StructureType.City] = Mod.Settings.NumCities * numWorkers;
			terrMod.AddStructuresOpt = structures;

			addNewOrder(WL.GameOrderEvent.Create(territory.OwnerPlayerID, 'New cities built', {}, {terrMod}));
		end
	end

end

function NumWorkersIn(armies)
	local ret = 0;

	for _, su in pairs(armies.SpecialUnits) do
		if su.proxyType == 'CustomSpecialUnit' and su.Name == 'Worker' then
			ret = ret + 1;
		end
	end

	return ret;
end

function hasNoWorker(armies)
	for _, sp in pairs(armies.SpecialUnits) do
		if sp.proxyType == 'CustomSpecialUnit' and sp.Name == 'Worker' then
			return true;
		end
	end
end
