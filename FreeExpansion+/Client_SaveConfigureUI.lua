function Client_SaveConfigureUI(alert)
	Mod.Settings.NumToConvert = numberInputField.GetValue();
	Mod.Settings.SetArmiesTo = numberInputField2.GetValue();
	Mod.Settings.OnlyBaseNeutrals = booleanInputField.GetIsChecked();

	print(Mod.Settings.OnlyBaseNeutrals);
end
