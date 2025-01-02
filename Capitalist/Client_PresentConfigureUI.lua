function Client_PresentConfigureUI(rootParent)
	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end

	local cost = Mod.Settings.CostToBuyCapitalist;
	if cost == nil then cost = 20; end

	local maxCapitalists = Mod.Settings.MaxCapitalists;
	if maxCapitalists == nil then maxCapitalists = 3; end

	local Percentage = Mod.Settings.Percentage;
	if Percentage == nil then Percentage = 25; end

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText('How much gold it costs to buy a Capitalist');
	costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);

	local row2 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row2).SetText('How many Capitalists each player can have at a time.');
	maxCapitalistsField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxCapitalists);

	local row3 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row3).SetText('Percentage of income taken away from the enemy upon them killing the Capitalist.');
	PercentageField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(100)
		.SetValue(Percentage);
end
