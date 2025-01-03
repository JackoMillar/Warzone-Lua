function RandomizeWastelands(game, standing)
	for _, territory in pairs(standing.Territories) do
		local numArmies = territory.NumArmies.NumArmies;

		if territory.OwnerPlayerID == WL.PlayerID.Neutral and numArmies == game.Settings.WastelandSize then
			local newArmies =  math.min(math.max(math.random(-Mod.Settings.RandomizeAmount, Mod.Settings.RandomizeAmount) + numArmies, 0), 100000);

			territory.NumArmies = WL.Armies.Create(newArmies);
		end
	end
end
