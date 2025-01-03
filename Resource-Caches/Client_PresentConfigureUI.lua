function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)

	local initialRCaches = Mod.Settings.NumOfRCaches or 2;
	local Pieces = Mod.Settings.cPieces or 5;
	local FixedPieces = (Mod.Settings.FixedPieces == nil and true) or Mod.Settings.FixedPieces;
	local difference = Mod.Settings.Luck or 3;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert); -- not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert); -- not used but here for reference

	UI.CreateLabel(vert).SetText('Amount of Resource Caches that will spawn at the start of the game');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialRCaches);

	UI.CreateLabel(vert).SetText('Amount of card pieces you will get for claiming a cache');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(Pieces);

	UI.CreateLabel(vert).SetText('If checked will only give a fixed amount of card pieces');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(FixedPieces);

	UI.CreateLabel(vert).SetText('Random +/- limit (any negative pieces will get changed to 0)');
	numberInputField3 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(difference);
end
