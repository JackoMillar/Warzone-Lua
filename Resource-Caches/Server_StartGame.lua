require('Utilities');
require('WLUtilities');
require('distributeRandomStructures');

function Server_StartGame(game, standing)

	local count = 0;
	for cardID, _ in pairs(game.Settings.Cards) do
		count = count + 1;
	end
	if count > 0 then
		distributeRandomStructures(standing, WL.StructureType.ResourceCache, Mod.Settings.NumOfRCaches, {maxPercentage = 50, numberOfStructures = 1, onlyPlaceOnNeutrals = true, allowMultipleStructures = false});
	end
--	local s = standing;
--	local cards = s.Cards;
--	local armies = 0;
--
--	if game.Settings.Cards[WL.CardID.Reinforcement] ~= nil then
--		if game.Settings.Cards[WL.CardID.Reinforcement].Mode == WL.ReinforcementCardMode.Fixed then
--			armies = game.Settings.Cards[WL.CardID.Reinforcement].FixedArmies;		-- fixed amount
--		elseif game.Settings.Cards[WL.CardID.Reinforcement].Mode == WL.ReinforcementCardMode.ProgressiveByNumberOfTerritories then
--			armies = round(getTableLength(game.ServerGame.Game.PlayingPlayers) * game.Settings.Cards[WL.CardID.Reinforcement].ProgressivePercentage)
--		else
--			armies = 1;
--			-- Turn 0, so 0 * x
--			-- To give some armies it is always 1
--		end
--	end
--	for _, player in pairs(game.ServerGame.Game.PlayingPlayers) do
--		local playerCards = WL.PlayerCards.Create(player.ID);
--		local newPieces = playerCards.Pieces;
--		local newCards = playerCards.WholeCards;
--		for card, cardGame in pairs(game.Settings.Cards) do
--			local totalPieces = cardGame.InitialPieces;
--			if Mod.Settings.cPieces ~= nil then
--				totalPieces = totalPieces + Mod.Settings.cPieces;
--			end
--			if card ~= WL.CardID.Reinforcement then
--				for k = 1, math.floor(totalPieces / cardGame.NumPieces) do
--					local instance = WL.NoParameterCardInstance.Create(card);
--					newCards[instance.ID] = instance;
--					print(instance);
--				end
--				newPieces[card] = totalPieces % cardGame.NumPieces;
--			else
--				for k = 1, math.floor(totalPieces / cardGame.NumPieces) do
--					local instance = WL.ReinforcementCardInstance.Create(armies);
--					newCards[instance.ID] = instance;
--				end
--				newPieces[card] = totalPieces % cardGame.NumPieces;
--			end
--		end
--		playerCards.WholeCards = newCards;
--		playerCards.Pieces = newPieces;
--		cards[player.ID] = playerCards;
--	end
--	s.Cards = cards;
--	standing = s;

end
