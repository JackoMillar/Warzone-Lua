function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('A Construction Worker generates cities at the end of each turn on the territory it occupies.');

	UI.CreateLabel(vert).SetText('A Worker costs: ' .. Mod.Settings.CostToBuyWorker .. ' gold.').SetColor('#800080');
	UI.CreateLabel(vert).SetText('Max Workers: ' .. Mod.Settings.MaxWorkers).SetColor('#800080');
	UI.CreateLabel(vert).SetText('Number of Cities generated per turn per Worker: '.. Mod.Settings.NumCities).SetColor('#800080');
	UI.CreateLabel(vert).SetText('A Worker will always have the same power as 3 armies!').SetColor('#800080');
end
