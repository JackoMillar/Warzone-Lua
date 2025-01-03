function Client_PresentConfigureUI(rootParent)
	local initialValue = Mod.Settings.RandomizeAmount or 5;

	local horz = UI.CreateHorizontalLayoutGroup(rootParent);

	UI.CreateLabel(horz).SetText('Random +/- limit');

	numberInputField = UI.CreateNumberInputField(horz)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(initialValue);
end
