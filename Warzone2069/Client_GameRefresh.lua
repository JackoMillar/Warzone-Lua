require('LoreBook');

Alerted = false;

function Client_GameRefresh(game)
	Game = game;

	local data = Mod.PublicGameData;
	local Viewed = false;

	for p, player in pairs(game.Game.PlayingPlayers) do
		if data.Gullible[p] then
			Viewed = true;

			if not data.Viewed[game.Us.ID] then
				local name = player.DisplayName(nil, false);

				UI.Alert(gullible(name));

				Game.SendGameCustomMessage(
					'Player Viewed',
					{
						type = 'UpdatingViewed',
						p = data.Viewed[Game.Us.ID]
					},
					function(placeholder) end
				);
			end
		end
	end

	if not Alerted and not (WL and WL.IsVersionOrHigher and WL.IsVersionOrHigher("5.21")) then
		UI.Alert('You must update your app to the latest version to use the Warzone2069 mod');
		Alerted = true;
	end

	if not game.Us then
		return;
	end

	if not Viewed  then
		if game.Game.TurnNumber >= 2 then
			UI.Alert(advert());
		end
	end
end
