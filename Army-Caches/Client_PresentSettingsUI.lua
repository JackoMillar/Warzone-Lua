function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('Amount of Army Caches that spawned = ' .. Mod.Settings.NumOfACaches);
	UI.CreateLabel(vert).SetText('Amount of Armies with each claimed Cache = ' .. Mod.Settings.Armies);

	if not Mod.Settings.FixedArmies then
		UI.CreateLabel(vert).SetText('Random +/- limit of: ' .. Mod.Settings.Luck);
	end
end
