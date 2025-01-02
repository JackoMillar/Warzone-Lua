require('UI');
require('distributeRandomStructures');
function Server_StartGame(game, standing)

	distributeRandomStructures(standing, WL.StructureType.MercenaryCamp, 100, {maxPercentage = 50, numberOfStructures = 1, onlyPlaceOnNeutrals = true, allowMultipleStructures = false, allowConnectedTerrs = false, mapDetails = game.Map});

	local data = Mod.PublicGameData;
	data.Counters = {};
	data.Markets = {};
	data.Hospitals = {};
	data.Churchs = {};
	data.Embassys = {};

	for p, _ in pairs(game.Game.PlayingPlayers) do
		data.Counters[p] = 0;
		data.Markets[p] = 0;
		data.Hospitals[p] = 0;
		data.Churchs[p] = 0;
		data.Embassys[p] = 0;
	end

	Mod.PublicGameData = data;
end
