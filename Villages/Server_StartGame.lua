require('Utilities');
require('WLUtilities');
require('distributeRandomStructures');

function Server_StartGame(game, standing)
	distributeRandomStructures(
		standing,
		WL.StructureType.MercenaryCamp,
		100,
		{
			maxPercentage = 50,
			numberOfStructures = 1,
			nlyPlaceOnNeutrals = true,
			allowMultipleStructures = false,
			allowConnectedTerrs = false,
			mapDetails = game.Map
		}
	);

--	local privateGameData = Mod.PrivateGameData;
--	local territoryArray = {};
--
--	privateGameData.portals = {};
--
--	for _, territory in pairs(standing.Territories) do
--		if territory.OwnerPlayerID == WL.PlayerID.Neutral then
--			table.insert(territoryArray, territory);
--		end
--	end
--
--	-- Check that the map has enough territories, if not then it only creates one village
--	local NumOfVillages = Mod.Settings.NumOfVillages;
--
--	if #territoryArray < Mod.Settings.NumOfVillages then
--		NumOfVillages = 1;
--	end
--
--	local structure = {};
--	local Villages = WL.StructureType.MercenaryCamp;
--
--	structure[Villages] = 0
--
--	for i = 1, NumOfVillages do
--		privateGameData.portals[i] = getRandomTerritory(territoryArray);
--		structure[Villages] = 1;
--		standing.Territories[privateGameData.portals[i]].Structures = structure;
--	end
--
--	Mod.PrivateGameData = privateGameData;
end

--[[
function getRandomTerritory(territoryArray)
	local index = math.random(#territoryArray);
	local territoryID = territoryArray[index].ID;
	table.remove(territoryArray, index);

	return territoryID;
end
]]
