function Client_SaveConfigureUI(alert)
	local maxCap = numberInputField3.GetValue();
	local maxDip = numberInputField4.GetValue();
	local maxMed = numberInputField5.GetValue();
	local maxPri = numberInputField6.GetValue();

	if maxCap < 1 or maxCap > 5 then
		alert('Max number of Capitalists per player must be between 1 and 5');
	end

	if maxDip < 1 or maxDip > 5 then
		alert('Max number of Diplomats per player must be between 1 and 5');
	end

	if maxMed < 1 or maxMed > 5 then
		alert('Max number of Medics per player must be between 1 and 5');
	end

	if maxPri < 1 or maxPri > 5 then
		alert('Max number of Priests per player must be between 1 and 5');
	end

	Mod.Settings.NumOfVillages = numberInputField.GetValue();
	Mod.Settings.Armies = numberInputField2.GetValue();
	Mod.Settings.ONeutrals = booleanInputField.GetIsChecked();
	Mod.Settings.CapitalistLimit = maxCap;
	Mod.Settings.DiplomatLimit = maxDip;
	Mod.Settings.MedicLimit = maxMed;
	Mod.Settings.PriestLimit = maxPri;
end
