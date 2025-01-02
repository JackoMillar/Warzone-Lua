require('Utilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyCapitalist_')) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI
		--in Client_PresentMenuUI, we stuck the territory ID after BuyCapitalist_.  Break it out and parse it to a number.
		local targetTerritoryID = tonumber(string.sub(order.Payload, 15));
		print(string.sub(order.Payload, 15));
		print(targetTerritoryID);
		local targetTerritoryStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];
		if (targetTerritoryStanding.OwnerPlayerID ~= order.PlayerID) then
			return; --can only buy a priest onto a territory you control
		end

		if (order.CostOpt == nil) then
			return; --shouldn't ever happen, unless another mod interferes
		end

		local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; --this is the cost from the order.  We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there.  Therefore, we must calculate it ourselves, and only do the purchase if they match
		local realCost = Mod.Settings.CostToBuyCapitalist;

		if (realCost > costFromOrder) then
			return; --don't do the purchase if their cost didn't line up.  This would only really happen if they hacked their client or another mod interfered
		end

		local numCapitalistsAlreadyHave = 0;
		for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
			if (ts.OwnerPlayerID == order.PlayerID) then
				numCapitalistsAlreadyHave = numCapitalistsAlreadyHave + NumCapitalistsIn(ts.NumArmies);
			end
		end

		if (numCapitalistsAlreadyHave >= Mod.Settings.MaxCapitalists) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping Capitalist purchase since max is ' .. Mod.Settings.MaxCapitalists .. ' and you have ' .. numCapitalistsAlreadyHave));
			return; --this player already has the maximum number of Capitalists possible, so skip adding a new one.
		end

		local CapitalistPower = Mod.Settings.CapitalistPower;

		local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
		builder.Name = 'Capitalist';
		builder.IncludeABeforeName = true;
		builder.ImageFilename = 'piggy-bank.png';
		builder.AttackPower = 1;
		builder.DefensePower = 1;
		builder.CombatOrder = 3415; --defends commanders
		builder.DamageToKill = 1;
		builder.DamageAbsorbedWhenAttacked = 1;
		builder.CanBeGiftedWithGiftCard = true;
		builder.CanBeTransferredToTeammate = true;
		builder.CanBeAirliftedToSelf = true;
		builder.CanBeAirliftedToTeammate = true;
		builder.IsVisibleToAllPlayers = false;

		local terrMod = WL.TerritoryModification.Create(targetTerritoryID);
		terrMod.AddSpecialUnits = {builder.Build()};

		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a Capitalist', {}, {terrMod}));
	end
	if order.proxyType == "GameOrderAttackTransfer" then
		if orderResult.IsAttack and hasNoCapitalist(game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies) then
			if deadCapitalist(orderResult.DefendingArmiesKilled) then
				local p = order.PlayerID; -- the attacker

				local currentIncome = game.Game.PlayingPlayers[p].Income(0, game.ServerGame.LatestTurnStanding, false, false);

				local IncomeAmount = currentIncome.Total;
				print(IncomeAmount);
				IncomeAmount = IncomeAmount * (Mod.Settings.Percentage / 100);
				addNewOrder(WL.GameOrderEvent.Create(p, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(p, -IncomeAmount, "You have killed a Capitalist and have been sanctioned")}));

			end
		end
	end
end

function NumCapitalistsIn(armies)
	local ret = 0;
	for _,su in pairs(armies.SpecialUnits) do
		if (su.proxyType == 'CustomSpecialUnit' and su.Name == 'Capitalist') then
			ret = ret + 1;
		end
	end
	return ret;
end

function hasNoCapitalist(armies)
	for _, sp in pairs(armies.SpecialUnits) do
		if (sp.proxyType == 'CustomSpecialUnit' and sp.Name == "Capitalist") then
			return true;
		end
	end
	return false;
end

function deadCapitalist(army)
	for _, sp in pairs(army.SpecialUnits) do
		if sp.proxyType == "CustomSpecialUnit" and sp.Name == "Capitalist" then
			return true;
		end
	end
	return false;
end

function round(n)
	return math.floor(n + 0.5);
end
