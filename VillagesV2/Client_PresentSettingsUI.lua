function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('Amount of villages that spawned = ' .. Mod.Settings.NumOfVillages).SetColor('#4EFFFF');
	UI.CreateLabel(vert).SetText('Amount of armies with each claimed territory = ' .. Mod.Settings.Armies).SetColor('#4EFFFF');

	if Mod.Settings.ONeutrals then
		UI.CreateLabel(vert).SetText('Villages will only take neutral territories that border it.').SetColor('#4EFFFF');
	else
		UI.CreateLabel(vert).SetText('Villages will take every territory that borders it.').SetColor('#4EFFFF');
	end

	-- Special Unit Limits
	UI.CreateLabel(vert).SetText('Limit on Capitalists = ' .. Mod.Settings.CapitalistLimit).SetColor('#AD7E7E');
	UI.CreateLabel(vert).SetText('Limit on Diplomats = ' .. Mod.Settings.DiplomatLimit).SetColor('#AD7E7E');
	UI.CreateLabel(vert).SetText('Limit on Priests = ' .. Mod.Settings.PriestLimit).SetColor('#AD7E7E');
	UI.CreateLabel(vert).SetText('Limit on Medics = ' .. Mod.Settings.MedicLimit).SetColor('#AD7E7E');
end
