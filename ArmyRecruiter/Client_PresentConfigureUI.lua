function Client_PresentConfigureUI(rootParent)
	if not WL.IsVersionOrHigher or not WL.IsVersionOrHigher('5.21') then
		UI.Alert('You must update your app to the latest version to use this mod');
		return;
	end

	local cost = Mod.Settings.CostToBuyRecruiter or 10;
	local maxRecruiters = Mod.Settings.MaxRecruiters or 3;
	local armies = Mod.Settings.NumArmies or 2;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row1).SetText('How much gold it costs to buy a Recruiter?');
	costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(30)
		.SetValue(cost);

	local row2 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row2).SetText('How many Recruiters each player can have at a time.');
	maxRecruitersField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxRecruiters);

	local row3 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row3).SetText('Number of Armies a Recruiter creates per turn');
	armiesField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(armies);
end
