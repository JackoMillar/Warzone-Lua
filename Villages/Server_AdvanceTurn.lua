require('Utilities');
require('WLUtilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	checkForMercenaryCampCaptured(game, order, orderResult, skipThisOrder, addNewOrder);
end

function checkForMercenaryCampCaptured(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	if not (orderResult.IsAttack and orderResult.IsSuccessful) then
		return;
	end

	local attackedTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];

	if not (attackedTerr.Structures and attackedTerr.Structures[WL.StructureType.MercenaryCamp]) then
		return;
	end

	-- there is a mercenary camp on the territory that was successfully attacked
	-- so now you can do what you want :p

	local list = {};

	for terrID, _ in pairs(game.Map.Territories[order.To].ConnectedTo) do
		local connectedTerritory = game.ServerGame.LatestTurnStanding.Territories[terrID];

		if (
			(Mod.Settings.ONeutrals and connectedTerritory.IsNeutral) or
			(not Mod.Settings.ONeutrals and connectedTerritory.OwnerPlayerID ~= order.PlayerID)
		) then
			local terrMod = WL.TerritoryModification.Create(terrID);

			terrMod.SetOwnerOpt = order.PlayerID;
			terrMod.SetArmiesTo = Mod.Settings.Armies;
			table.insert(list, terrMod);
		end
	end

	if #list > 0 then
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'New territory', {}, list), true);
	end
end

--[[
function Server_AdvanceTurn_End(game, addNewOrder)
	local camps = {};

	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if territory.OwnerPlayerID ~= WL.PlayerID.Neutral then
			local structures = territory.Structures;

			if structures and structures[WL.StructureType.MercenaryCamp] then
				table.insert(camps, terrID); -- gets each territory ID of controlled camps
			end
		end
	end

	for times = 1, math.min(#camps, math.floor(#camps / getTableLength(game.ServerGame.Game.PlayingPlayers))) do
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
