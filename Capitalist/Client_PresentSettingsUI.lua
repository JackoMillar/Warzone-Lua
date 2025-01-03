function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('Anyone who kills a Capitalist special unit will get a percentage of income reducted for 1 turn');

	UI.CreateLabel(vert).SetText('A Capitalist costs: ' .. Mod.Settings.CostToBuyCapitalist .. ' gold.');
	UI.CreateLabel(vert).SetText('Max priests: ' .. Mod.Settings.MaxCapitalists);
	UI.CreateLabel(vert).SetText('Percentage of income taken away: '.. Mod.Settings.Percentage .. '%');

	UI.CreateLabel(vert).SetText('A Capitalist will always have the same power as 1 army!');
end
