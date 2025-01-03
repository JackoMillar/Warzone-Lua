function Client_SaveConfigureUI(alert)
	local cost = costInputField.GetValue();
	local maxRecruiters = maxRecruitersField.GetValue();

	if cost < 1 then
		alert('the cost to buy a Recruiter must be positive');
	end

	if maxRecruiters < 1 or maxRecruiters > 5 then
		alert('Max number of Recruiters per player must be between 1 and 5');
	end

	Mod.Settings.CostToBuyRecruiter = cost;
	Mod.Settings.MaxRecruiters = maxRecruiters;
	Mod.Settings.NumArmies = armiesField.GetValue();
end
