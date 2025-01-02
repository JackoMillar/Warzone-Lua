
function Client_PresentSettingsUI(rootParent)


	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	UI.CreateLabel(vert).SetText('amount of territories that will be hit per turn = ' .. Mod.Settings.NumOfStrikes);
	UI.CreateLabel(vert).SetText('amount of armies that will die per hit = ' .. Mod.Settings.ArmiesKilled);

	if (Mod.Settings.EnableDoomsDay == true) then
		UI.CreateLabel(vert).SetText('the turn of which the final meteor hits = ' .. Mod.Settings.TurnDoomsDay);
		UI.CreateLabel(vert).SetText('amount of territories that will survive the final hit = ' .. Mod.Settings.TerrSurvived);
	end
end
