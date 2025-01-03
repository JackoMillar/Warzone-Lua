function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('Amount of villages that spawned = ' .. Mod.Settings.NumOfVillages);
	UI.CreateLabel(vert).SetText('Amount of armies with each claimed territory = ' .. Mod.Settings.Armies);

	if Mod.Settings.ONeutrals then
		UI.CreateLabel(vert).SetText('Villages will only take neutral territories that border it.');
	else
		UI.CreateLabel(vert).SetText('Villages will take every territory that borders it.');
	end
end
