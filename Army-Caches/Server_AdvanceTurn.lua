require('Utilities');
require('WLUtilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if order.proxyType == "GameOrderAttackTransfer" then
		if orderResult.IsSuccessful then
			local TransferredTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];
			local structures = TransferredTerr.Structures
			if TransferredTerr.Structures ~= nil then
				if TransferredTerr.Structures[WL.StructureType.ArmyCache] ~= nil then -- there is a army cache on the territory that was successfully attacked -- so now you can do what you want :p
					if Mod.Settings.FixedArmies == true then
						local IncomeAmount = Mod.Settings.Armies;
						local terrMod = WL.TerritoryModification.Create(order.To);

						structures = {}
						structures[WL.StructureType.ArmyCache] = -1;
						terrMod.AddStructuresOpt = structures;

						addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(order.PlayerID, IncomeAmount, "You have captured an army cache")}));
					end
					if Mod.Settings.FixedArmies == false then

						local IncomeAmount = Mod.Settings.Armies;
						print(IncomeAmount);
						IncomeAmount = (IncomeAmount + math.random(-Mod.Settings.Luck, Mod.Settings.Luck));

						local terrMod = WL.TerritoryModification.Create(order.To);

						structures = {}
						structures[WL.StructureType.ArmyCache] = -1;
						terrMod.AddStructuresOpt = structures;

						addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(order.PlayerID, IncomeAmount, "You have captured an army cache")}));
					end
				end
			end
		end
	end
end

function getTableLength(t)
	local a = 0;
	for i, _ in pairs(t) do

		a = a + 1;
	end
	return a;
end
