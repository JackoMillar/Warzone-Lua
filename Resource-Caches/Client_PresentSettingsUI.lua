function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('Amount of Resource Caches that spawned = ' .. Mod.Settings.NumOfRCaches);
	UI.CreateLabel(vert).SetText('Amount of card pieces with each claimed Cache = ' .. Mod.Settings.cPieces);

	if not Mod.Settings.FixedPieces then
		UI.CreateLabel(vert).SetText('Random +/- limit of: ' .. Mod.Settings.Luck);
	end
end
