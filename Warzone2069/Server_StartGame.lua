require('UI');

function Server_StartGame(game, standing)
	local data = Mod.PublicGameData;
	data.Gullible = {};
	data.Viewed = {};
	for p, _ in pairs(game.Game.PlayingPlayers) do
		data.Gullible[p] = false;
		data.Viewed[p] = false;
	end
	Mod.PublicGameData = data;
end
