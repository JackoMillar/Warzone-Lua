function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)
	local initialVillages = Mod.Settings.NumOfVillages or 5;
	local ON = (Mod.Settings.ONeutrals == nil and true) or Mod.Settings.ONeutrals;
	local GainedArmies = Mod.Settings.Armies or 2;
	local dipLimit = Mod.Settings.DiplomatLimit or 3;
	local capLimit = Mod.Settings.CapitalistLimit or 3;
	local priLimit = Mod.Settings.PriestLimit or 2;
	local medLimit = Mod.Settings.MedicLimit or 1;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local horz1 = UI.CreateHorizontalLayoutGroup(vert);  --not used
	local horz2 = UI.CreateHorizontalLayoutGroup(vert);  --not used but here for reference

	UI.CreateLabel(vert).SetText('Amount of Villages that will be created at the start of the game');
	numberInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialVillages);

	UI.CreateLabel(vert).SetText('Amount of armies that you will get with each new territory');
	numberInputField2 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(GainedArmies);

	UI.CreateLabel(vert).SetText('only neutrals territories shall be claimed (recommended)');
	booleanInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(ON);

	UI.CreateLabel(vert).SetText('Maximum amount of Capitalists you can own at any one time. A Capitalist reduces the income of any player that kills it by 20% ');
	numberInputField3 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(capLimit);

	UI.CreateLabel(vert).SetText('Maximum amount of Diplomats you can own at any one time. A Capitalist enforces a diplomacy card on any player that kills it for 1 turn (note: if you have diplomacy cards active for the game it will instead follow the duration of that card)');
	numberInputField4 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(dipLimit);

	UI.CreateLabel(vert).SetText('Maximum amount of Priests you can own at any one time. When an priest attacks or is attacked it will convert armies that are killed, 10% in offensive attacks, 20% in defensive.');
	numberInputField6 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(priLimit);

	UI.CreateLabel(vert).SetText('Maximum amount of Medics you can own at any one time. The Medic can heal 20% of armies on connected territories as well as the territory it sits on');
	numberInputField5 = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(medLimit);
end
