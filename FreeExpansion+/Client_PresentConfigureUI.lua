function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)
	local initialValueConvert = Mod.Settings.NumToConvert or 2;
	local initialValueArmies = Mod.Settings.SetArmiesTo or 2;
	local initalcheckbox = Mod.Settings.OnlyBaseNeutrals or false;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert);  --not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert);  --not used but here for reference

	UI.CreateLabel(vert).SetText('Only base neutral armies and less shall be claimed');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(initalcheckbox);

	UI.CreateLabel(vert).SetText('Amount of neutrals a player shall gain each turn');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueConvert);

	print(5);

	UI.CreateLabel(vert).SetText('Amount of armies a player shall get with the territory');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueArmies);
end
