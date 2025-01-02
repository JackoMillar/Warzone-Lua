require('Utilities');
require('WLUtilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == "GameOrderAttackTransfer" and orderResult.IsSuccessful) then
		return;
	end

	local TransferredTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];
	local structures = TransferredTerr.Structures;

	if not (TransferredTerr.Structures and TransferredTerr.Structures[WL.StructureType.ArmyCache]) then
		return;
	end

	-- there is a army cache on the territory that was successfully attacked -- so now you can do what you want :p

	local IncomeAmount = Mod.Settings.Armies;
	local terrMod = WL.TerritoryModification.Create(order.To);

	if not Mod.Settings.FixedArmies then
		print(IncomeAmount);
		IncomeAmount = IncomeAmount + math.random(-Mod.Settings.Luck, Mod.Settings.Luck);
	end

	structures = {}
	structures[WL.StructureType.ArmyCache] = -1;
	terrMod.AddStructuresOpt = structures;

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(order.PlayerID, IncomeAmount, "You have captured an army cache")}));
end
