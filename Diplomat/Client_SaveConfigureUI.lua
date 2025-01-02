function Client_SaveConfigureUI(alert)
	local cost = costInputField.GetValue();
	local maxWorkers = maxWorkersField.GetValue();

	if cost < 1 then alert("the cost to buy a Worker must be positive"); end
	if maxWorkers < 1 or maxWorkers > 5 then alert("Max number of Workers per player must be between 1 and 5"); end

	Mod.Settings.CostToBuyWorker = cost;
	Mod.Settings.MaxWorkers = maxWorkers;
	Mod.Settings.NumCities = citiesField.GetValue();
end
