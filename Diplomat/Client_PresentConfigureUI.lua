function Client_PresentConfigureUI(rootParent)
	if not (WL and WL.IsVersionOrHigher and WL.IsVersionOrHigher("5.21")) then
		UI.Alert('You must update your app to the latest version to use this mod');
		return;
	end

	local cost = Mod.Settings.CostToBuyDiplomat or 25;
	local maxDiplomats = Mod.Settings.MaxDiplomats or 3;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row1).SetText('How much gold it costs to buy a Diplomat');
	costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);

	local row2 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row2).SetText('How many diplomats each player can have at a time');
	maxDiplomatsField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxDiplomats);
end
