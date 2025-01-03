require('Utilities');
require('WLUtilities');
require('distributeRandomStructures');

function Server_StartGame(game, standing)
	distributeRandomStructures(
		standing,
		WL.StructureType.ArmyCache,
		Mod.Settings.NumOfACaches,
		{
			maxPercentage = 50,
			numberOfStructures = 1,
			onlyPlaceOnNeutrals = true,
			allowMultipleStructures = false
		}
	);
end

--[[
function getRandomTerritory(territoryArray)
	local index = math.random(#territoryArray)
	local territoryID = territoryArray[index].ID
	table.remove(territoryArray, index)

	return territoryID
end
]]
