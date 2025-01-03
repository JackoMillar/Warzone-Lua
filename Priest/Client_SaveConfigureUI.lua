function Client_SaveConfigureUI(alert)
	local cost = costInputField.GetValue();
	local power = powerInputField.GetValue();
	local maxPriests = maxPriestsField.GetValue();
	local percentage = percentageField.GetValue();
	local defense = defenseField.GetIsChecked();
	local offence = offenceField.GetIsChecked();

	if cost < 1 then
		alert('The cost to buy a Priest must be positive');
	end

	if power < 1 then
		alert('A Priest must have at least 1 power');
	end

	if maxPriests < 1 or maxPriests > 5 then
		alert('Max number of priests per player must be between 1 and 5');
	end

	if not offence and not defense then
		alert('Defence or offence must be checked in order for the Priest mod to work');
	end

	Mod.Settings.CostToBuyPriest = cost;
	Mod.Settings.PriestPower = power;
	Mod.Settings.MaxPriests = maxPriests;
	Mod.Settings.Percentage = percentage;
	Mod.Settings.Defensive = defense;
	Mod.Settings.Offensive = offence;
end
