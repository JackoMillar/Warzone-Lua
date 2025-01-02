function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)


	local initialValueConvert = Mod.Settings.NumToConvert;
	local initialValueArmies = Mod.Settings.SetArmiesTo;
	local initalcheckbox = Mod.Settings.OnlyBaseNeutrals;

	if initialValueConvert == nil then
		initialValueConvert = 2;
	end

	if initialValueArmies == nil then
		initialValueArmies = 2;
	end

	if initalcheckbox == nil then
		initalcheckbox = false;
	end

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert);  --not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert);  --not used but here for reference

	UI.CreateLabel(vert).SetText('only base neutral armies and less shall be claimed');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(initalcheckbox);

	UI.CreateLabel(vert).SetText('amount of neutrals a player shall gain each turn');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueConvert);
	print(5);
	UI.CreateLabel(vert).SetText('amount of armies a player shall get with the territory');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueArmies);

end
