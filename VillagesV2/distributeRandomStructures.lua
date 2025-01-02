--  distributeRandomStructures: Distributes the given structure type on the standing
--  Mandatory parameters:
--      * standing:     The GameStanding object
--      * structure:    The structure type, must be of the library WL.StructureType
--      * amount:       The amount of territories which will get the structure
--  Optional parameters:
--      * payload       A table with specific fields which allows for a more specific distribution

function distributeRandomStructures(standing, structure, amount, payload)
--  payload: A table with fields you can pass to allow for better configuration
--  Possible payload values:
--      * maxPercentage             (default = 50, limit the maximum amount of structures that will be placed on the map)
--      * numberOfStructures        (Default = 1)
--      * onlyPlaceOnNeutrals       (Default = true, set to false to also allow structures to be placed on player territories)
--      * allowMultipleStructures   (Default = false, if set to true it will allow for 2 structure types to be placed on 1 territory)
--      * allowConnectedTerrs       (Default = true, if set to false it won't place structures on all neighbouring territories. For this to work mapDetails has to be a 'MapDetails' object (Game --> MapDetails))
--      * mapDetails                (default = nil)
--  Example table: {maxPercentage = 50, numberOfStructures = 1, onlyPlaceOnNeutrals = true, allowMultipleStructures = false, AllowConnectedTerrs = true}

	local maxPercentage = 50;
	local numberOfStructures = 1;
	local onlyPlaceOnNeutrals = true;
	local allowMultipleStructures = false;
	local allowConnectedTerrs = true;
	local mapDetails = nil;

	VillageAmount =  Mod.Settings.NumOfVillages;

	if payload ~= nil then
		if type(payload) == type({}) then
			if payload.maxPercentage ~= nil then
				maxPercentage = payload.maxPercentage;
			end
			if payload.numberOfStructures ~= nil then
				numberOfStructures = payload.numberOfStructures;
			end
			if payload.onlyPlaceOnNeutrals ~= nil then
				onlyPlaceOnNeutrals = payload.onlyPlaceOnNeutrals;
			end
			if payload.allowMultipleStructures ~= nil then
				allowMultipleStructures = payload.allowMultipleStructures;
			end
			if payload.allowConnectedTerrs ~= nil then
				allowConnectedTerrs = payload.allowConnectedTerrs;
				mapDetails = payload.mapDetails;
			end
		end
	end

	local terrArray = {};
	local terrCount = 0;
	for _, terr in pairs(standing.Territories) do
		terrCount = terrCount + 1;
		if (not onlyPlaceOnNeutrals or terr.IsNeutral) and (not allowMultipleStructures or getTableLength_POI(terr.Structures) < 1) then
			table.insert(terrArray, terr.ID);
		end
	end

	VillageAmount = math.min(#terrArray, VillageAmount)
	if VillageAmount / terrCount > maxPercentage / 100 then
		VillageAmount = math.floor(VillageAmount - ((VillageAmount / terrCount - maxPercentage / 100) * terrCount));
	end

	for i = 1, VillageAmount do
		if #terrArray < 1 then break; end
		local rand = math.random(#terrArray);
		local terr = terrArray[rand];
		local structures = standing.Territories[terr].Structures
		if structures == nil then structures = {}; end
		structures[structure] = numberOfStructures;
		standing.Territories[terr].Structures = structures
		table.remove(terrArray, rand);
		if not allowConnectedTerrs then
			terrArray = removeConnectedTerrs_POI(mapDetails, terrArray, terr);
		end
	end
end

function removeConnectedTerrs_POI(map, terrs, terr)
	if terr == nil then return terrs; end
	for i, _ in pairs(map.Territories[terr].ConnectedTo) do
		if getKeyFromValue_POI(terrs, i) ~= nil then
			table.remove(terrs, getKeyFromValue_POI(terrs, i));
		end
	end
	return terrs;
end

function getTableLength_POI(t)
	if type(t) ~= type({}) then return 0; end
	local c = 0;
	for _, _ in pairs(t) do
		c = c + 1;
	end
	return c;
end

function getKeyFromValue_POI(t, v)
	for i, v2 in pairs(t) do
		if v2 == v then
			return i;
		end
	end
	return nil;
end
