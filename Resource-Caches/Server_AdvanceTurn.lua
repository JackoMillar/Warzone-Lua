require('Utilities');
require('WLUtilities');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	checkForResourceCacheCaptured(game, order, orderResult, skipThisOrder, addNewOrder);
end

function checkForResourceCacheCaptured(game, order, orderResult, skipThisOrder, addNewOrder)
	if not (order.proxyType == 'GameOrderAttackTransfer') then
		return;
	end

	if not orderResult.IsSuccessful then
		return;
	end

	local TransferredTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];

	if not (TransferredTerr.Structures and TransferredTerr.Structures[WL.StructureType.ResourceCache]) then
		return;
	end

	local cardArray = {};
	local t1 = {};
	local t2 = {};
	local list = {};
	local terrMod = WL.TerritoryModification.Create(order.To);
	local structures = {};

	structures[WL.StructureType.ResourceCache] = -1;
	terrMod.AddStructuresOpt = structures;

	for cardID, _ in pairs(game.Settings.Cards) do
		table.insert(cardArray, cardID);
	end

	local rand = math.random(#cardArray);
	local randomCard = cardArray[rand]; -- picks random card to give to player
	local pieces = Mod.Settings.cPieces;

	if Mod.Settings.FixedPieces == false then
		pieces = math.max(pieces + math.random(-Mod.Settings.Luck, Mod.Settings.Luck), 0);
	end

	t1[randomCard] = pieces;

	local msg = 'Claimed a Card Cache and received ' .. pieces .. ' pieces for a random card';
	local cardEvent = WL.GameOrderEvent.Create(order.PlayerID, msg, {}, {terrMod}, {}, {});

	t2[order.PlayerID] = t1;
	cardEvent.AddCardPiecesOpt = t2;

	addNewOrder(cardEvent, true);
end

function getTableLength(t)
	local a = 0;

	for i, _ in pairs(t) do
		a = a + 1;
	end

	return a;
end
