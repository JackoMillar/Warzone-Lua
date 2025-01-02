function Client_SaveConfigureUI(alert)

	Mod.Settings.NumOfRCaches = numberInputField.GetValue();
	Mod.Settings.cPieces = numberInputField2.GetValue();
	Mod.Settings.FixedPieces = booleanInputField.GetIsChecked();
	Mod.Settings.Luck = numberInputField3.GetValue();
	print(Mod.Settings.FixedPieces);

end
