function Client_PresentSettingsUI(rootParent, game)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	--Expansion+ mod related
	UI.CreateLabel(vert).SetText('Amount of territories(neutrals) you get for free every turn = ' .. Mod.Settings.NumToConvert).SetColor('#07dfe3');
	UI.CreateLabel(vert).SetText('Amount of armies that come with each new territory = ' .. Mod.Settings.SetArmiesTo).SetColor('#07dfe3');

	if (Mod.Settings.initalcheckbox == true) then
		UI.CreateLabel(vert).SetText('The mod will only claim neutrals that are less than or equal to armies on distributed territories.').SetColor('#07dfe3');
	end

	--village mod related
	UI.CreateLabel(vert).SetText('Amount of Villages that spawned = ' .. Mod.Settings.NumOfVillages).SetColor('#0780e3');
	UI.CreateLabel(vert).SetText('Amount of armies with each claimed territory = ' .. Mod.Settings.Armies).SetColor('#0780e3');

	if (Mod.Settings.ONeutrals == false) then
		UI.CreateLabel(vert).SetText('Claimed territories will also take other players.').SetColor('#0780e3');
	end

	--army caches related
	UI.CreateLabel(vert).SetText('Amount of Army Caches that spawned = ' .. Mod.Settings.NumOfACaches).SetColor('#09cc02');
	UI.CreateLabel(vert).SetText('Amount of Armies with each claimed Cache = ' .. Mod.Settings.Armies).SetColor('#09cc02');

	if (Mod.Settings.FixedArmies == false) then
		UI.CreateLabel(vert).SetText('Random +/- limit of armies: ' .. Mod.Settings.aLuck).SetColor('#09cc02');
	end

	--card caches related
	UI.CreateLabel(vert).SetText('Amount of Card Caches that spawned = ' .. Mod.Settings.NumOfRCaches).SetColor('#FFD700');
	UI.CreateLabel(vert).SetText('Amount of card pieces with each claimed Cache = ' .. Mod.Settings.cPieces).SetColor('#FFD700');

	if Mod.Settings.FixedPieces == false then
		UI.CreateLabel(vert).SetText('Random +/- limit of pieces: ' .. Mod.Settings.rLuck).SetColor('#FFD700');
	end

	--misc settings
	if Mod.Settings.AttackNeutral == false then
		UI.CreateLabel(vert).SetText('You are unable to take neutrals by yourself, you can damage them though.').SetColor('#AC0059');
	end
end
