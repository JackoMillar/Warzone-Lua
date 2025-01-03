function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)
	print(1);

	local initialVillages = Mod.Settings.NumOfVillages or 3;
	local ON = (Mod.Settings.ONeutrals == nil and true) or Mod.Settings.ONeutrals;
	local GainedArmies = Mod.Settings.Armies or 2;

	print(ON);

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert); -- not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert); -- not used but here for reference

	UI.CreateLabel(vert).SetText('Amount of Villages that will be created at the start of the game');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialVillages);

	UI.CreateLabel(vert).SetText('Amount of armies that you will get with each new territory');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(GainedArmies);

	UI.CreateLabel(vert).SetText('Only neutrals territories shall be claimed (recommended)');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(ON);
end
