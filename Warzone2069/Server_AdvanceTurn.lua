function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer' and orderResult.IsSuccessful) then
		return;
	end

	local r = math.random(1, 25);
	local list = {};-- FIXME should this be after the r == 25 condition?

	if not (r == 25) then
		return;
	end

	local attackedTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];
	local attackerTerr = game.ServerGame.LatestTurnStanding.Territories[order.From];
	local terrModTo = WL.TerritoryModification.Create(order.To);
	local terrModfrom = WL.TerritoryModification.Create(order.From);

	terrModTo.SetOwnerOpt = attackedTerr.OwnerPlayerID;
	terrModTo.SetArmiesTo = (attackedTerr.NumArmies.NumArmies);

	terrModfrom.SetArmiesTo = (attackerTerr.NumArmies.NumArmies);

	table.insert(list, terrModfrom);
	table.insert(list, terrModTo);

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Rubberbanding', {}, list), true);
end

function Server_AdvanceTurn_End(game, addNewOrder)
	local data = Mod.PublicGameData;
	local count = 0;
	local t = {};

	for p, player in pairs(game.Game.PlayingPlayers) do
		local IncomeAmount = 1;

		addNewOrder(WL.GameOrderEvent.Create(p, 'Paying Taxes', {}, {}, {}, {WL.IncomeMod.Create(p, -IncomeAmount, 'Paying taxes')}));

		if data.Viewed[p] or player.IsAI then
			table.insert(t, data.Viewed[p]);
		end

		count = count + 1;
	end

	print(count);
	print(#t);

	for p, _ in pairs(game.Game.PlayingPlayers) do
		if count == #t then
			print(22);
			data.Gullible[p] = false;
			data.Viewed[p] = false;
		end
	end

	Mod.PublicGameData = data;
end
