function Client_PresentConfigureUI(rootParent)
	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end

	local cost = Mod.Settings.CostToBuyWorker;
	if cost == nil then cost = 15; end

	local maxWorkers = Mod.Settings.MaxWorkers;
	if maxWorkers == nil then maxWorkers = 3; end

	local cities = Mod.Settings.NumCities;
	if cities == nil then cities = 1; end

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText('How much gold it costs to buy a Worker?');
	costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);

	local row2 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row2).SetText('How many Workers each player can have at a time.');
	maxWorkersField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxWorkers);

	local row3 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row3).SetText('Number of Cities a Worker creates per turn');
	citiesField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(cities);
end
