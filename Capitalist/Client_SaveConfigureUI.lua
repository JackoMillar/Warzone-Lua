function Client_SaveConfigureUI(alert)
	local cost = costInputField.GetValue();
	if cost < 1 then alert("the cost to buy a Capitalist must be positive"); end
	Mod.Settings.CostToBuyCapitalist = cost;

	local maxCapitalists = maxCapitalistsField.GetValue();
	if maxCapitalists < 1 or maxCapitalists > 5 then alert("Max number of Capitalists per player must be between 1 and 5"); end
	Mod.Settings.MaxCapitalists = maxCapitalists;

	Mod.Settings.Percentage = PercentageField.GetValue();
end
