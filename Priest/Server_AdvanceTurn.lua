require('Utilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	checkForBuyPriest(game, order, orderResult, skipThisOrder, addNewOrder);
	checkIfPriestCanConvertArmies(game. order, orderResult. skipThisOrder, addNewOrder);
end

function checkForBuyPriest(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyPriest_')) then
		return;
	end

	-- look for the order that we inserted in Client_PresentCommercePurchaseUI
	-- in Client_PresentMenuUI, we stuck the territory ID after BuyPriest_. Break it out and parse it to a number.

	print(string.sub(order.Payload, 11));

	local targetTerritoryID = tonumber(string.sub(order.Payload, 11));
	local targetTerritoryStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];

	if targetTerritoryStanding.OwnerPlayerID ~= order.PlayerID then
		-- can only buy a priest onto a territory you control
		return;
	end

	if not order.CostOpt then
		-- shouldn't ever happen, unless another mod interferes
		return;
	end

	local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; -- this is the cost from the order.  We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there.  Therefore, we must calculate it ourselves, and only do the purchase if they match
	local realCost = Mod.Settings.CostToBuyPriest;

	if realCost > costFromOrder then
		-- don't do the purchase if their cost didn't line up.  This would only really happen if they hacked their client or another mod interfered
		return;
	end

	local numPriestsAlreadyHave = 0;

	for _, ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if ts.OwnerPlayerID == order.PlayerID then
			numPriestsAlreadyHave = numPriestsAlreadyHave + NumPriestsIn(ts.NumArmies);
		end
	end

	if numPriestsAlreadyHave >= Mod.Settings.MaxPriests then
		-- this player already has the maximum number of priests possible, so skip adding a new one.
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping Priest purchase since max is ' .. Mod.Settings.MaxPriests .. ' and you have ' .. numPriestsAlreadyHave));
		return;
	end

	local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
	local priestPower = Mod.Settings.PriestPower;

	builder.Name = 'Priest';
	builder.IncludeABeforeName = true;
	builder.ImageFilename = 'robe.png';
	builder.AttackPower = priestPower;
	builder.DefensePower = priestPower;
	builder.CombatOrder = 3415; -- defends commanders
	builder.DamageToKill = priestPower;
	builder.DamageAbsorbedWhenAttacked = priestPower;
	builder.CanBeGiftedWithGiftCard = true;
	builder.CanBeTransferredToTeammate = true;
	builder.CanBeAirliftedToSelf = true;
	builder.CanBeAirliftedToTeammate = true;
	builder.IsVisibleToAllPlayers = false;

	local terrMod = WL.TerritoryModification.Create(targetTerritoryID);

	terrMod.AddSpecialUnits = {builder.Build()};

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a Priest', {}, {terrMod}));
end

function checkIfPriestCanConvertArmies(game. order, orderResult. skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	if Mod.Settings.Offensive then
		makePriestConvertArmies(game, order, orderResult, skipThisOrder, addNewOrder, order.From, false);
	end

	if Mod.Settings.Defensive then
		makePriestConvertArmies(game, order, orderResult, skipThisOrder, addNewOrder, order.To, true);
	end
end

function makePriestConvertArmies(game, order, orderResult, skipThisOrder, addNewOrder, targetTerritoryID, isDefensive)
	if isDefensive and not orderResult.IsSuccessful) then
		return;
	end

	local targetTerritory = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];

	if not (orderResult.IsAttack and hasNoPriest(targetTerritory.NumArmies)) then
		return;
	end

	local armiesToAdd = round(orderResult.AttackingArmiesKilled.NumArmies * (Mod.Settings.Percentage / 100));

	if armiesToAdd <= 0 then
		return;
	end

	local terrMod = WL.TerritoryModification.Create(targetTerritoryID);
	local p = targetTerritory.OwnerPlayerID;
	local msg = 'Priest converted ' .. terrMod.AddArmies .. ((isDefensive and ' of the attacking') or '') .. ' armies';
	local event = WL.GameOrderEvent.Create(p, msg, {}, {terrMod});

	addNewOrder(event, true);
end

function isPriest(specialUnit)
	return specialUnit.proxyType == 'CustomSpecialUnit' and specialUnit.Name == 'Priest';
end

function NumPriestsIn(armies)
	local ret = 0;

	for _, su in pairs(armies.SpecialUnits) do
		if isPriest(su) then
			ret = ret + 1;
		end
	end

	return ret;
end

function hasNoPriest(armies)
	for _, sp in pairs(armies.SpecialUnits) do
		if isPriest(sp) then
			return true;
		end
	end
end

function round(n)
	return math.floor(n + 0.5);
end
