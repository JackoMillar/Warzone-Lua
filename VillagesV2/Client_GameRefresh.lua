Alerted = false;

function Client_GameRefresh(game)
	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher('5.21')) then
		UI.Alert('You must update your app to the latest version to use the VillagesV2 mod');
		Alerted = true;
	end

	if not game.Us then
		return;
	end

	local data = Mod.PublicGameData;

	if game.Game.TurnNumber < 1 or data.Counters[game.Us.ID] == 0 or game.Us.State ~= WL.GamePlayerState.Playing then
		return;
	end

	for p, _ in pairs(game.Game.PlayingPlayers) do
		if p == game.Us.ID then

		end
	end

	if data.Counters[game.Us.ID] == nil then
		data.Counters[game.Us.ID] = 0;
	end

	local numCounters = data.Counters[game.Us.ID];

	UI.Alert('You have ' .. numCounters .. ' village' .. (numCounters == 1 and '' or 's') .. 'to convert');
end
