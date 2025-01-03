require('Utilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	checkForBuyDiplomat(game, order, orderResult, skipThisOrder, addNewOrder);
	checkForDiplomatKilledWhileDefending(game, order, orderResult, skipThisOrder, addNewOrder);
end

function checkForBuyDiplomat(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyDiplomat_')) then
		return;
	end

	-- look for the order that we inserted in Client_PresentCommercePurchaseUI
	-- in Client_PresentMenuUI, we stuck the territory ID after BuyDiplomat_. Break it out and parse it to a number.

	local targetTerritoryID = tonumber(string.sub(order.Payload, 13));
	local targetTerritoryStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];

	print(string.sub(order.Payload, 13));
	print(targetTerritoryID);

	if targetTerritoryStanding.OwnerPlayerID ~= order.PlayerID then
		-- can only buy a Diplomat onto a territory you control
		return;
	end

	if not order.CostOpt then
		-- shouldn't ever happen, unless another mod interferes
		return;
	end

	local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; -- this is the cost from the order. We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there. Therefore, we must calculate it ourselves, and only do the purchase if they match
	local realCost = Mod.Settings.CostToBuyDiplomat;

	if realCost > costFromOrder then
		-- don't do the purchase if their cost didn't line up. This would only really happen if they hacked their client or another mod interfered
		return;
	end

	local numDiplomatsAlreadyHave = 0;

	for _, ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if ts.OwnerPlayerID == order.PlayerID then
			numDiplomatsAlreadyHave = numDiplomatsAlreadyHave + NumDiplomatsIn(ts.NumArmies);
		end
	end

	if numDiplomatsAlreadyHave >= Mod.Settings.MaxDiplomats then
		-- this player already has the maximum number of Diplomats possible, so skip adding a new one.

		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping Diplomat purchase since max is ' .. Mod.Settings.MaxDiplomats .. ' and you have ' .. numDiplomatsAlreadyHave));
		return;
	end

	local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
	local terrMod = WL.TerritoryModification.Create(targetTerritoryID);

	builder.Name = 'Diplomat';
	builder.IncludeABeforeName = true;
	builder.ImageFilename = 'truce.png';
	builder.AttackPower = 1;
	builder.DefensePower = 1;
	builder.CombatOrder = 3415; -- defends commanders
	builder.DamageToKill = 1;
	builder.DamageAbsorbedWhenAttacked = 1;
	builder.CanBeGiftedWithGiftCard = true;
	builder.CanBeTransferredToTeammate = true;
	builder.CanBeAirliftedToSelf = true;
	builder.CanBeAirliftedToTeammate = true;
	builder.IsVisibleToAllPlayers = false;

	terrMod.AddSpecialUnits = {builder.Build()};

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a Diplomat', {}, {terrMod}));
end

function checkForDiplomatKilledWhileDefending(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	if not (orderResult.IsAttack and hasNoDiplomat(game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies)) then
		return;
	end

	if not deadDiplomat(orderResult.DefendingArmiesKilled) then
		return;
	end

	if not (game.Settings.Cards and game.Settings.Cards[WL.CardID.Diplomacy]) then
		return;
	end

	local p = order.PlayerID; -- the attacker
	local p2 = game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID; -- player that was attacked
	local instance = WL.NoParameterCardInstance.Create(WL.CardID.Diplomacy);

	addNewOrder(WL.GameOrderReceiveCard.Create(p, {instance}));
	addNewOrder(WL.GameOrderPlayCardDiplomacy.Create(instance.ID, p, p, p2));
end

function isDiplomat(specialUnit)
	return specialUnit.proxyType == 'CustomSpecialUnit' and specialUnit.Name == 'Diplomat';
end

function NumDiplomatsIn(armies)
	local ret = 0;

	for _, su in pairs(armies.SpecialUnits) do
		if isDiplomat(su) then
			ret = ret + 1;
		end
	end

	return ret;
end

function hasNoDiplomat(armies)
	for _, sp in pairs(armies.SpecialUnits) do
		if isDiplomat(sp) then
			return true;
		end
	end
end

function deadDiplomat(army)
	for _, sp in pairs(army.SpecialUnits) do
		if isDiplomat(sp) then
			return true;
		end
	end
end

function round(n)
	return math.floor(n + 0.5);
end
