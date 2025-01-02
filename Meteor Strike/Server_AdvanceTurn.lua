require('Utilities');
require('WLUtilities');
require('RemoveArmies');

function Server_AdvanceTurn_End(game, addNewOrder)

	if (Mod.Settings.EnableDoomsDay == true) and (game.ServerGame.Game.TurnNumber == Mod.Settings.TurnDoomsDay) then
		inflictDamage(game, addNewOrder, math.max(getTableLength(game.ServerGame.LatestTurnStanding.Territories) - Mod.Settings.TerrSurvived, 0), 0) -- 0 is a special value that indicates that all armies and special units are removed, and the territory set to neutral
	else
		inflictDamage(game, addNewOrder, Mod.Settings.NumOfStrikes, Mod.Settings.ArmiesKilled);
	end

end	--last end for the function

function inflictDamage(game, addNewOrder, num, damage)
	local terr = {};

	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		table.insert(terr, terrID);   --gets each territory ID of neutrals
	end

	for times = 1, math.min(num, #terr) do
		local rand = math.random(#terr);
		local randomNeutralTerr = terr[rand]; --picks random neutral then gives it too player
		local terrMod = killArmiesOrTurnNeutral(game, game.ServerGame.LatestTurnStanding.Territories[randomNeutralTerr], damage);
		local event = WL.GameOrderEvent.Create(WL.PlayerID.Neutral, "Meteor Strike at " .. game.Map.Territories[randomNeutralTerr].Name, {}, {terrMod});
		event.JumpToActionSpotOpt = WL.RectangleVM.Create(game.Map.Territories[randomNeutralTerr].MiddlePointX, game.Map.Territories[randomNeutralTerr].MiddlePointY, game.Map.Territories[randomNeutralTerr].MiddlePointX, game.Map.Territories[randomNeutralTerr].MiddlePointY);
		addNewOrder(event, true);
		table.remove(terr, rand);
	end
end


function getTableLength(t)
	local a = 0;
	for i, _ in pairs(t) do

		a = a + 1;
	end
	return a;
end
