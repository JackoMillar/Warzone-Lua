function Client_SaveConfigureUI(alert)
	local cost = costInputField.GetValue();
	local maxDiplomats = maxDiplomatsField.GetValue();

	if cost < 1 then
		alert('The cost to buy a Diplomat must be positive');
	end

	if maxDiplomats < 1 or maxDiplomats > 5 then
		alert('Max number of Diplomats per player must be between 1 and 5');
	end

	Mod.Settings.CostToBuyDiplomat = cost;
	Mod.Settings.MaxDiplomats = maxDiplomats;
end
