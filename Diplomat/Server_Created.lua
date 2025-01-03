function Server_Created(game, settings)
	local cards = settings.Cards;

	if not settings.Cards[WL.CardID.Diplomacy] then
		cards[WL.CardID.Diplomacy] = WL.CardGameDiplomacy.Create(1, 0, 0, 0, 2);
	end

	for i, v in pairs(game.Settings.Cards) do
		cards[i] = v;
	end

	settings.Cards = cards;
end
