function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('a priest costs: ' .. Mod.Settings.CostToBuyPriest);
	UI.CreateLabel(vert).SetText('power of a priest unit: ' .. Mod.Settings.PriestPower);
	UI.CreateLabel(vert).SetText('Max priests: ' .. Mod.Settings.MaxPriests);
	UI.CreateLabel(vert).SetText('conversion percentage: ' .. Mod.Settings.Percentage .. '%');

	if Mod.Settings.Offensive == true then
		UI.CreateLabel(vert).SetText('Priest converts when he attacks');
	end
	if Mod.Settings.Defensive == true then
		UI.CreateLabel(vert).SetText('Priest converts when he is attacked');
	end
end
