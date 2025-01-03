function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)
	local initialValueStrikes = Mod.Settings.NumOfStrikes or 5;
	local initialValueKilled = Mod.Settings.ArmiesKilled or 2;
	local initalcheckbox = not not Mod.Settings.EnableDoomsDay;
	local initialValueSurvived = Mod.Settings.TerrSurvived or 1;
	local InitialDoomsDay = Mod.Settings.TurnDoomsDay or 25;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert); -- not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert); -- not used but here for reference

	UI.CreateLabel(vert).SetText('Amount of meteors that will hit per turn');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialValueStrikes);

	UI.CreateLabel(vert).SetText('Amount of armies that will die per hit');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(initialValueKilled);

	-- DoomsDay Mode

	UI.CreateLabel(vert).SetText('Enable DoomsDay Mode:');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(initalcheckbox);

	UI.CreateLabel(vert).SetText('What turn does the DoomsDay meteor hit?');
	numberInputField3 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(100)
		.SetValue(InitialDoomsDay);

	UI.CreateLabel(vert).SetText('How much territories do you want to survive?');
	numberInputField4 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialValueSurvived);
end
