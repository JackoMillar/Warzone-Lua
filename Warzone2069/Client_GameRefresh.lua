require('LoreBook');
Alerted = false;

function Client_GameRefresh(game)
	local data = Mod.PublicGameData;
	Game = game;
	local Viewed = false;
	for p, player in pairs(game.Game.PlayingPlayers) do
		if data.Gullible[p] == true then
			Viewed = true;
			if data.Viewed[game.Us.ID] == false then
				local name = player.DisplayName(nil, false)
				UI.Alert(gullible(name));
				Game.SendGameCustomMessage('Player Viewed', {type = "UpdatingViewed", p = data.Viewed[Game.Us.ID]}, function(placeholder) end);
			end
		end
	end

	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use the Warzone2069 mod");
		Alerted = true;
	end
	if(game.Us == nil)then
		return;
	end
	if Viewed == false then
		if game.Game.TurnNumber >= 2 then
			local advert = advert();
			UI.Alert(advert);
		end
	end
end
