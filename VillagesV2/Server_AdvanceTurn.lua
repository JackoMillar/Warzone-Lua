function Server_AdvanceTurn_Start(game, addNewOrder, rootParent)
	data = Mod.PublicGameData;

	for p, _ in pairs(game.Game.PlayingPlayers) do
		data.Counters[p] = 0;
	end
end

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	-- VillageV1 code
	checkForMercenaryCampCaptured(game, order, orderResult, skipThisOrder, addNewOrder);

	-- New VillageV2 code beyond this point
	checkForCapitalistKilled(game, order, orderResult, skipThisOrder, addNewOrder);
	checkForDiplomatKilled(game, order, orderResult, skipThisOrder, addNewOrder);
	checkIfPriestCanConvertArmies(game. order, orderResult. skipThisOrder, addNewOrder);
	checkForMedicKilled(game, order, orderResult, skipThisOrder, addNewOrder);
	checkForGetSpecialUnitOrder(game, order, orderResult, skipThisOrder, addNewOrder);
end

function Server_AdvanceTurn_End(game, addNewOrder)
--	local list = {};

	local structuresForSpecialUnits = {
		[WL.StructureType.Market] = 'Capitalist',
		[WL.StructureType.Hospital] = 'Medic',
		[WL.StructureType.Diplomat] = 'Diplomat',
		[WL.StructureType.Arena] = 'Priest'
	};

	for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		local terrdata = tostring(terrID);
		local terrSelected = game.ServerGame.LatestTurnStanding.Territories[terrID];

		if terrSelected.Structures then
			for structureType, unitName in pairs(structuresForSpecialUnits) do
				if terrSelected.Structures[structureType] and not terrSelected.IsNeutral then
					addNewOrder(WL.GameOrderCustom.Create(terrSelected.OwnerPlayerID, 'custom order', 'Get' .. unitName .. '_' .. terrdata , {}));
				end
			end

			if terrSelected.Structures[WL.StructureType.MercenaryCamp] and not terrSelected.IsNeutral then
				-- finds each territory ID of territories with a merc camp

				if data.Markets[terrSelected.OwnerPlayerID] > 0 then
					data.Markets[terrSelected.OwnerPlayerID] = data.Markets[terrSelected.OwnerPlayerID] - 1;
					CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Market);
				elseif data.Hospitals[terrSelected.OwnerPlayerID] > 0 then
					data.Hospitals[terrSelected.OwnerPlayerID] = data.Hospitals[terrSelected.OwnerPlayerID] - 1;
					CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Hospital);
				elseif data.Embassys[terrSelected.OwnerPlayerID] > 0 then
					data.Embassys[terrSelected.OwnerPlayerID] = data.Embassys[terrSelected.OwnerPlayerID] - 1;
					CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Recipe);
				elseif data.Churchs[terrSelected.OwnerPlayerID] > 0 then
					data.Churchs[terrSelected.OwnerPlayerID] = data.Churchs[terrSelected.OwnerPlayerID] - 1;
					CreateStructure(terrID, terrSelected, addNewOrder, WL.StructureType.Arena);
				else
					data.Counters[terrSelected.OwnerPlayerID] = data.Counters[terrSelected.OwnerPlayerID] + 1;
				end
			end
		end
	end

--	for times = 1, #list do
--		local rand = math.random(#list);
--		local terrSelected = game.ServerGame.LatestTurnStanding.Territories[list[rand]];

--		if data.Markets[terrSelected.OwnerPlayerID] > 0 then
--			print(10);

--			data.Markets[terrSelected.OwnerPlayerID] = data.Markets[terrSelected.OwnerPlayerID] - 1;
--			CreateMarket(rand, terrSelected, addNewOrder);
--			table.remove(list, rand);
--			break;
--		end
--	end

	Mod.PublicGameData = data;
end

function checkForMercenaryCampCaptured(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	if not (orderResult.IsAttack and orderResult.IsSuccessful) then
		return;
	end

	local attackedTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];

	if not (attackedTerr.Structures and attackedTerr.Structures[WL.StructureType.MercenaryCamp]) then
		return;
	end

	-- there is a mercenary camp on the territory that was successfully attacked
	-- so now you can do what you want :p

	local list = {};

	for terrID, _ in pairs(game.Map.Territories[order.To].ConnectedTo) do
		local connectedTerritory = game.ServerGame.LatestTurnStanding.Territories[terrID];

		if (
			(Mod.Settings.ONeutrals and connectedTerritory.IsNeutral) or
			(not Mod.Settings.ONeutrals and connectedTerritory.OwnerPlayerID ~= order.PlayerID)
		) then
			local terrMod = WL.TerritoryModification.Create(terrID);

			terrMod.SetOwnerOpt = order.PlayerID;
			terrMod.SetArmiesTo = Mod.Settings.Armies;
			table.insert(list, terrMod);
		end
	end

	if #list > 0 then
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'New territory', {}, list), true);
	end
end

function checkForCapitalistKilled(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	local territory = game.ServerGame.LatestTurnStanding.Territories[order.To];

	if not (orderResult.IsAttack and UnitCount(territory.NumArmies, 'Capitalist')) then
		return;
	end

	if not DeadUnit(orderResult.DefendingArmiesKilled, 'Capitalist') then
		return;
	end

	local attacker = order.PlayerID;
	local currentIncome = game.Game.PlayingPlayers[attacker].Income(0, game.ServerGame.LatestTurnStanding, false, false);
	local IncomeAmount = currentIncome.Total * 0.20;

	addNewOrder(WL.GameOrderEvent.Create(attacker, 'Updated income', {}, {terrMod}, {}, {WL.IncomeMod.Create(attacker, -IncomeAmount, 'You have killed a Capitalist and have been sanctioned')}));
end

function checkForDiplomatKilled(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (game.Settings.Cards and game.Settings.Cards[Wl.CardID.Diplomacy]) then
		return;
	end

	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	local territory = game.ServerGame.LatestTurnStanding.Territories[order.To];

	if not (orderResult.IsAttack and UnitCount(territory.NumArmies, 'Diplomat')) then
		return;
	end

	if not DeadUnit(orderResult.DefendingArmiesKilled, 'Diplomat') then
		return;
	end

	local attacker = order.PlayerID;
	local attackedPlayer = territory.OwnerPlayerID;
	local instance = WL.NoParameterCardInstance.Create(WL.CardID.Diplomacy);

	addNewOrder(WL.GameOrderReceiveCard.Create(attacker, {instance}));
	addNewOrder(WL.GameOrderPlayCardDiplomacy.Create(instance.ID, attacker, attacker, attackedPlayer));
end

function checkIfPriestCanConvertArmies(game. order, orderResult. skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer' and orderResult.IsAttack) then
		return;
	end

	makePriestConvertArmies(game, order, orderResult, skipThisOrder, addNewOrder, order.From, 0.1, 'defending');

	if not orderResult.IsSuccessful then
		makePriestConvertArmies(game, order, orderResult, skipThisOrder, addNewOrder, order.To, 0.2, 'attacking');
	end
end

function makePriestConvertArmies(game, order, orderResult, skipThisOrder, addNewOrder, targetTerritoryID, multiplyer, armyType)
	local armiesToAdd = round(orderResult.AttackingArmiesKilled.NumArmies * multiplyer);

	if armiesToAdd <= 0 then
		return;
	end

	local terrStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];
	local terrMod = WL.TerritoryModification.Create(targetTerritoryID);
	local msg = 'Preist converted ' .. armiesToAdd .. ' of the ' .. armyType .. ' armies';

	terrMod.AddArmies = armiesToAdd;

	addNewOrder(WL.GameOrderEvent.Create(terrStanding.OwnerPlayerID, msg, {}, {terrMod}), true);
end

function checkForMedicKilled(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	local standing = game.ServerGame.LatestTurnStanding;
	local fromTerritoryStanding = standing.Territories[order.From];
	local toTerritoryStanding = standing.Territories[order.To];
	local toTerritoryDetails = game.Map.Territories[order.To];

	for connID, _ in pairs(toTerritoryDetails.ConnectedTo) do
		local connTerritoryStanding = game.Map.Territories[connID];
		local connTerritoryDetails = standing.Territories[connID];
		local x = connTerritoryDetails.MiddlePointX;
		local y = connTerritoryDetails.MiddlePointY;

		if (DeadUnit(connTerritoryStanding.NumArmies, 'Medic') and connID ~= order.From) then
			local armies;
			local p;

			print(1000);

			if toTerritoryStanding.OwnerPlayerID == connTerritoryStanding.OwnerPlayerID then
				armies = round(orderResult.DefendingArmiesKilled.NumArmies * 0.2);
				p = toTerritoryStanding.OwnerPlayerID;
			elseif fromTerritoryStanding.OwnerPlayerID == connTerritoryStanding.OwnerPlayerID then
				armies = round(orderResult.AttackingArmiesKilled.NumArmies * 0.2);
				p = fromTerritoryStanding.OwnerPlayerID;
			end

			if armies and armies > 0 then
				print(20000);

				local terrMod = WL.TerritoryModification.Create(connID);

				terrMod.AddArmies = armies;

				local event = WL.GameOrderEvent.Create(p, 'Medic recovered ' .. terrMod.AddArmies .. ' armies', {}, {terrMod});

				event.JumpToActionSpotOpt = WL.RectangleVM.Create(x, y, x, y);

				addNewOrder(event, true);
			end
		end
	end
end

function checkForGetSpecialUnitOrder(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderCustom') then
		return;
	end

	if not startsWith(order.Payload, 'Get') then
		return;
	end

	local unitTypes = {
		{
			name = 'Capitalist',
			img = 'piggy-bank.png',
			combatOrder = 3415,
		},
		{
			name = 'Medic'
			img = 'Medic.png',
			combatOrder = 9120,
		},
		{
			name = 'Diplomat',
			img = 'truce.png',
			combatOrder = 3414
		},
		{
			name = 'Priest',
			img = 'robe.png',
			combatOrder = 3413
		}
	};

	for _, unitType in ipairs(unitTypes) do
		local pattern = '^Get' + unitType.name + '_';
		local limit = Mod.Settings[unitType.name];
		local terrID = tonumber(order.Payload:gsub(pattern, '', 1));

		if terrID then
			SpecialUnit(terrID, addNewOrder, order, game, unitType.name, unitType.img, unitType.combatOrder, limit);
		end
	end
end

function CreateStructure(terrID, terrSelected, addNewOrder, struct)
	print(100);

	local terrMod = WL.TerritoryModification.Create(terrID);
	local structures = {};

	structures[WL.StructureType.MercenaryCamp] = -1;
	structures[struct] = 1;
	terrMod.AddStructuresOpt = structures;

	addNewOrder(WL.GameOrderEvent.Create(terrSelected.OwnerPlayerID , 'Renovated Village', {}, {terrMod}));
end

function SpecialUnit(terrID, addNewOrder, order, game, name, filename, combatOrder, limit)
	local terrSelected = game.ServerGame.LatestTurnStanding.Territories[terrID];
	local targetTerritoryID = terrID;
	local numUnitsAlreadyHave = 0;

	for _, ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if ts.OwnerPlayerID == order.PlayerID then
			numUnitsAlreadyHave = numUnitsAlreadyHave + UnitCount(ts.NumArmies, name);
		end
	end

	if numUnitsAlreadyHave >= limit then
		-- this player already has the maximum number of Capitalists possible, so skip adding a new one.

		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. name .. ' creation since maximum is ' .. limit, {}));

		return;
	end

	local builder = WL.CustomSpecialUnitBuilder.Create(terrSelected.OwnerPlayerID);

	builder.Name = name;
	builder.IncludeABeforeName = true;
	builder.ImageFilename = filename;
	builder.AttackPower = 1;
	builder.DefensePower = 1;
	builder.CombatOrder = combatOrder; -- defends commanders
	builder.DamageToKill = 1;
	builder.DamageAbsorbedWhenAttacked = 1;
	builder.CanBeGiftedWithGiftCard = true;
	builder.CanBeTransferredToTeammate = true;
	builder.CanBeAirliftedToSelf = true;
	builder.CanBeAirliftedToTeammate = true;
	builder.IsVisibleToAllPlayers = false;

	local terrMod = WL.TerritoryModification.Create(targetTerritoryID);

	terrMod.AddSpecialUnits = {builder.Build()};

	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Created a ' .. name, {}, {terrMod}));
end

function UnitCount(armies, name)
	local ret = 0;

	for _,su in pairs(armies.SpecialUnits) do
		if su.proxyType == 'CustomSpecialUnit' and su.Name == name then
			ret = ret + 1;
		end
	end

	return ret;
end

function DeadUnit(army, name)
	for _, su in pairs(army.SpecialUnits) do
		if su.proxyType == 'CustomSpecialUnit' and su.Name == name then
			return true;
		end
	end

	return false;
end

function getTableLength(t)
	local a = 0;

	for i, _ in pairs(t) do
		a = a + 1;
	end

	return a;
end

function round(n)
	return math.floor(n + 0.5);
end
