
function Client_PresentConfigureUI(rootParent)

	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end


	local power = Mod.Settings.PriestPower;
	if power == nil then power = 1; end

	local cost = Mod.Settings.CostToBuyPriest;
	if cost == nil then cost = 25; end

	local maxPriests = Mod.Settings.MaxPriests;
	if maxPriests == nil then maxPriests = 3; end;

	local percentage = Mod.Settings.Percentage;
	if percentage == nil then percentage = 50; end

	local defense = Mod.Settings.Defensive;
	if defense == nil then defense = true; end

	local offence= Mod.Settings.Offensive;
	if offence == nil then offence = true; end

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText('How much gold it costs to buy a priest');
	costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);


	local row2 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row2).SetText('How powerful the priest is (in armies). (recommended to be 1)');
	powerInputField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(30)
		.SetValue(power);

	local row3 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row3).SetText('How many priests each player can have at a time');
	maxPriestsField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxPriests);

	local row4 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row4).SetText('percentage of armies converted');
	percentageField = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(100)
		.SetValue(percentage);

	local row5 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row5).SetText('priest conversion activates when he is attacked:');
	defenseField = UI.CreateCheckBox(row5)
		.SetIsChecked(defense);

	local row6 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row6).SetText('priest conversion activates when he attacks');
	offenceField = UI.CreateCheckBox(row6)
		.SetIsChecked(offence);

end
