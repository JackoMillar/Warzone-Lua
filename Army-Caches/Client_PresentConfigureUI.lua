function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)
	print(1);

	local initialACaches = Mod.Settings.NumOfACaches or 2;
	local GainedArmies = Mod.Settings.Armies or 5;
	local FixedArmies = Mod.Settings.FixedArmies;
	local difference = Mod.Settings.Luck or 5;

	if FixedArmies == nil then
		FixedArmies = true;
	end

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert);  --not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert);  --not used but here for reference

	UI.CreateLabel(vert).SetText('Amount of Army Caches that will spawn at the start of the game');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialACaches);

	UI.CreateLabel(vert).SetText('Amount of armies that you will get for claiming a cache');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(GainedArmies);

	UI.CreateLabel(vert).SetText('if checked will only give a fixed amount of armies');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(FixedArmies);

	UI.CreateLabel(vert).SetText('Random +/- limit');
	numberInputField3 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(difference);
end
