function Client_SaveConfigureUI(alert)
	if (
		ExpansionInputField == nil or
		villageInputField == nil or
		armyCacheInputField == nil or
		cardCacheInputField == nil or
		attackNeutralInputField == nil
	) then
		-- is this alert actually needed? settings seem to use a default anyway
		alert("You must open and close every button in CivLight once before you can save settings (sorry).");
	end

	if ExpansionInputField == nil then
		Mod.Settings.NumToConvert = 2;
		Mod.Settings.SetArmiesTo = 2;
		Mod.Settings.OnlyBaseNeutrals = false;
	else
		Mod.Settings.NumToConvert = ExpansionInputField.GetValue();
		Mod.Settings.SetArmiesTo = ExpArmyInputField.GetValue();
		Mod.Settings.OnlyBaseNeutrals = ExpBaseInputField.GetIsChecked();
	end

	if villageInputField == nil then
		Mod.Settings.NumOfVillages = 3;
		Mod.Settings.Armies = 2;
		Mod.Settings.ONeutrals = true;
	else
		Mod.Settings.NumOfVillages = villageInputField.GetValue();
		Mod.Settings.Armies = vValueInputField.GetValue();
		Mod.Settings.ONeutrals = ONInputField.GetIsChecked();
	end

	if armyCacheInputField == nil then
		Mod.Settings.NumOfACaches = 3;
		Mod.Settings.Armies = 5;
		Mod.Settings.FixedArmies = true;
		Mod.Settings.aLuck = 5;
	else
		Mod.Settings.NumOfACaches = armyCacheInputField.GetValue();
		Mod.Settings.Armies = armyAmountInputField.GetValue();
		Mod.Settings.FixedArmies = fixedArmyInputField.GetIsChecked();
		Mod.Settings.aLuck = randArmyInputField.GetValue();
	end

	if cardCacheInputField == nil then
		Mod.Settings.NumOfRCaches = 2;
		Mod.Settings.cPieces = 3;
		Mod.Settings.FixedPieces = true;
		Mod.Settings.rLuck = 3;
	else
		Mod.Settings.NumOfRCaches = cardCacheInputField.GetValue();
		Mod.Settings.cPieces = PiecesInputField.GetValue();
		Mod.Settings.FixedPieces = fixedPiecesInputField.GetIsChecked();
		Mod.Settings.rLuck = randPiecesInputField.GetValue();
	end

	if attackNeutralInputField == nil then
		Mod.Settings.AttackNeutral = true;
	else
		Mod.Settings.AttackNeutral = attackNeutralInputField.GetIsChecked();
	end
end
