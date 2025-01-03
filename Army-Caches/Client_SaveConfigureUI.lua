function Client_SaveConfigureUI(alert)
	Mod.Settings.NumOfACaches = numberInputField.GetValue();
	Mod.Settings.Armies = numberInputField2.GetValue();
	Mod.Settings.FixedArmies = booleanInputField.GetIsChecked();
	Mod.Settings.Luck = numberInputField3.GetValue();
end
