function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('A Priest costs: ' .. Mod.Settings.CostToBuyPriest);
	UI.CreateLabel(vert).SetText('Power of a Priest: ' .. Mod.Settings.PriestPower);
	UI.CreateLabel(vert).SetText('Max Priests: ' .. Mod.Settings.MaxPriests);
	UI.CreateLabel(vert).SetText('Conversion percentage: ' .. Mod.Settings.Percentage .. '%');

	if Mod.Settings.Offensive == true then
		UI.CreateLabel(vert).SetText('Priest converts when they attack');
	end

	if Mod.Settings.Defensive == true then
		UI.CreateLabel(vert).SetText('Priest converts when they are attacked');
	end
end
