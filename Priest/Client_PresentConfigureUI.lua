function Client_PresentConfigureUI(rootParent)
	if not (WL and WL.IsVersionOrHigher and WL.IsVersionOrHigher('5.21')) then
		UI.Alert('You must update your app to the latest version to use this mod');
		return;
	end

	local power = Mod.Settings.PriestPower or 1;
	local cost = Mod.Settings.CostToBuyPriest or 25;
	local maxPriests = Mod.Settings.MaxPriests or 3;
	local percentage = Mod.Settings.Percentage or 50;
	local defense = not not Mod.Settings.Defensive;
	local offence= (Mod.Settings.Offensive == nil and true) or Mod.Settings.Offensive;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row1).SetText('How much gold it costs to buy a Priest');
	costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);

	local row2 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row2).SetText('How powerful the Priest is (in armies). (recommended to be 1)');
	powerInputField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(30)
		.SetValue(power);

	local row3 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row3).SetText('How many Priests each player can have at a time:');
	maxPriestsField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxPriests);

	local row4 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row4).SetText('Percentage of armies converted:');
	percentageField = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(100)
		.SetValue(percentage);

	local row5 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row5).SetText('Priest conversion activates when they are attacked:');
	defenseField = UI.CreateCheckBox(row5)
		.SetIsChecked(defense);

	local row6 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row6).SetText('Priest conversion activates when they attack:');
	offenceField = UI.CreateCheckBox(row6)
		.SetIsChecked(offence);
end
