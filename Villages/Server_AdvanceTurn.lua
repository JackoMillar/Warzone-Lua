require('Utilities');
require('WLUtilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if order.proxyType == "GameOrderAttackTransfer" then
		if orderResult.IsAttack and orderResult.IsSuccessful then
			local attackedTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];

			if attackedTerr.Structures ~= nil then
				if attackedTerr.Structures[WL.StructureType.MercenaryCamp] ~= nil then
					-- there is a mercenary camp on the territory that was successfully attacked -- so now you can do what you want :p

					local list = {};

					for terrID, territory in pairs(game.Map.Territories[order.To].ConnectedTo) do
						if (Mod.Settings.ONeutrals == true) then
							if (game.ServerGame.LatestTurnStanding.Territories[terrID].IsNeutral == true) then
								local terrMod = WL.TerritoryModification.Create(terrID);
								terrMod.SetOwnerOpt = order.PlayerID;
								terrMod.SetArmiesTo = Mod.Settings.Armies;
								table.insert(list, terrMod);
							end
						end
						if (Mod.Settings.ONeutrals == false) then

							local terrMod = WL.TerritoryModification.Create(terrID);
							if (game.ServerGame.LatestTurnStanding.Territories[terrID].OwnerPlayerID ~= order.PlayerID) then
								terrMod.SetOwnerOpt = order.PlayerID;
								terrMod.SetArmiesTo = Mod.Settings.Armies;
								if terrMod ~= nil then
									table.insert(list, terrMod);
								end
							end


						end

					end
					addNewOrder(WL.GameOrderEvent.Create(order.PlayerID,"new territory",{}, list), true);
				end
			end
		end
	end
end



--[[
function Server_AdvanceTurn_End(game, addNewOrder)
	local camps = {};
	local count = 0;
	local structures = structures[WL.StructureID.MercenaryCamp];
	local structures = game.ServerGame.LatestTurnStanding.Territories[order.To].Structures;

	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if territory.Structures ~= nil then
			local structures = territory.Structures;

			if (structures[WL.StructureType.MercenaryCamp] and territory.OwnerPlayerID ~= WL.PlayerID.Neutral) then

				table.insert(camps, terrID);   --gets each territory ID of controlled camps

				count = count + 1;
			end
		end
	end

	for times = 1, math.min(count, math.floor(#camps / getTableLength(game.ServerGame.Game.PlayingPlayers))) do

		for i, _ in pairs(game.ServerGame.Game.PlayingPlayers) do
			local rand = math.random(#camps);
		end
	end
end
]]

function getTableLength(t)
	local a = 0;
	for i, _ in pairs(t) do

		a = a + 1;
	end
	return a;
end
