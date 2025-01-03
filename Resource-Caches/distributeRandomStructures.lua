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
--  Example table: {maxPercentage = 50, numberOfStructures = 1, onlyPlaceOnNeutrals = true, allowMultipleStructures = false}

	if type(payload) ~= 'table' then
		payload = {};
	end

	local maxPercentage = payload.maxPercentage or 50;
	local numberOfStructures = payload.numberOfStructures or 1;
	local onlyPlaceOnNeutrals = (payload.onlyPlaceOnNeutrals == nil and true) or payload.onlyPlaceOnNeutrals;
	local allowMultipleStructures = not not payload.allowMultipleStructures;

	local terrArray = {};
	local terrCount = 0;

	for _, terr in pairs(standing.Territories) do
		terrCount = terrCount + 1;

		if (not onlyPlaceOnNeutrals or terr.IsNeutral) and (not allowMultipleStructures or getTableLength_POI(terr.Structures) < 1) then
			table.insert(terrArray, terr.ID);
		end
	end

	amount = math.min(#terrArray, amount);

	if amount / terrCount > maxPercentage / 100 then
		amount = math.floor(amount - ((amount / terrCount - maxPercentage / 100) * terrCount));
	end

	for i = 1, amount do
		local rand = math.random(#terrArray);
		local structures = standing.Territories[terrArray[rand]].Structures or {};

		structures[structure] = numberOfStructures;
		standing.Territories[terrArray[rand]].Structures = structures;
		table.remove(terrArray, rand);
	end
end

function getTableLength_POI(t)
	if type(t) ~= type({}) then
		return 0;
	end

	local c = 0;

	for _, _ in pairs(t) do
		c = c + 1;
	end

	return c;
end
