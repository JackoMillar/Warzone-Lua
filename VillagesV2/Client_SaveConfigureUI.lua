function Client_SaveConfigureUI(alert)

	Mod.Settings.NumOfVillages = numberInputField.GetValue();
	Mod.Settings.Armies = numberInputField2.GetValue();
	Mod.Settings.ONeutrals = booleanInputField.GetIsChecked();

	local maxCap = numberInputField3.GetValue();
	if maxCap < 1 or maxCap > 5 then alert("Max number of Capitalists per player must be between 1 and 5"); end
	Mod.Settings.CapitalistLimit = maxCap;

	local maxDip = numberInputField4.GetValue();
	if maxDip < 1 or maxDip > 5 then alert("Max number of Diplomats per player must be between 1 and 5"); end
	Mod.Settings.DiplomatLimit = maxDip;

	local maxMed = numberInputField5.GetValue();
	if maxMed < 1 or maxMed > 5 then alert("Max number of Medics per player must be between 1 and 5"); end
	Mod.Settings.MedicLimit = maxMed;

	local maxPri = numberInputField6.GetValue();
	if maxPri < 1 or maxPri > 5 then alert("Max number of Priests per player must be between 1 and 5"); end
	Mod.Settings.PriestLimit = maxPri;
end
