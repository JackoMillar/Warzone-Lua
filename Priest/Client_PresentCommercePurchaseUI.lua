require('Utilities')

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText('Each Priest is worth ' .. Mod.Settings.PriestPower .. ' armies and cost ' .. Mod.Settings.CostToBuyPriest .. ' gold to purchase.  You may have up to ' .. Mod.Settings.MaxPriests .. ' Priests at a time.');
	UI.CreateButton(vert).SetText('Purchase a Priest for ' .. Mod.Settings.CostToBuyPriest .. ' gold').SetOnClick(PurchaseClicked);
end

function NumPriestsIn(armies)
	local ret = 0;

	for _,su in pairs(armies.SpecialUnits) do
		if su.proxyType == 'CustomSpecialUnit' and su.Name == 'Priest' then
			ret = ret + 1;
		end
	end

	return ret;
end

function PurchaseClicked()
	-- Check if they're already at max.  Add in how many they have on the map plus how many purchase orders they've already made
	-- We check on the client for player convenience. Another check happens on the server, so even if someone hacks their client and removes this check they still won't be able to go over the max.

	local playerID = Game.Us.ID;
	local numPriestsAlreadyHave = 0;

	for _, ts in pairs(Game.LatestStanding.Territories) do
		if ts.OwnerPlayerID == playerID then
			numPriestsAlreadyHave = numPriestsAlreadyHave + NumPriestsIn(ts.NumArmies);
		end
	end

	for _, order in pairs(Game.Orders) do
		if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyPriest_')) then
			numPriestsAlreadyHave = numPriestsAlreadyHave + 1;
		end
	end

	if numPriestsAlreadyHave >= Mod.Settings.MaxPriests then
		UI.Alert('You already have ' .. numPriestsAlreadyHave .. ' Priests! You can only have ' ..  Mod.Settings.MaxPriests);
		return;
	end

	Game.CreateDialog(PresentBuyPriestsDialog);
	Close1();
end


function PresentBuyPriestsDialog(rootParent, setMaxSize, setScrollable, game, close)
	Close2 = close;

	-- set flexible width so things don't jump around while we change InstructionLabel
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1);

	SelectTerritoryBtn = UI.CreateButton(vert).SetText('Select Territory').SetOnClick(SelectTerritoryClicked);
	TargetTerritoryInstructionLabel = UI.CreateLabel(vert).SetText('');

	BuyPriestBtn = UI.CreateButton(vert).SetInteractable(false).SetText('Complete Purchase').SetOnClick(CompletePurchaseClicked);

	-- just start us immediately in selection mode, no reason to require them to click the button
	SelectTerritoryClicked();
end

function SelectTerritoryClicked()
	UI.InterceptNextTerritoryClick(TerritoryClicked);
	TargetTerritoryInstructionLabel.SetText('Please click on the territory you wish to receive the Priest unit on. If needed, you can move this dialog out of the way.');
	SelectTerritoryBtn.SetInteractable(false);
end

function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true);

	if not terrDetails then
		--The click request was cancelled.   Return to our default state.

		TargetTerritoryInstructionLabel.SetText('');
		SelectedTerritory = nil;
		BuyPriestBtn.SetInteractable(false);

		return;
	end

	-- Territory was clicked, check it

	if Game.LatestStanding.Territories[terrDetails.ID].OwnerPlayerID ~= Game.Us.ID then
		TargetTerritoryInstructionLabel.SetText('You may only receive a Priest on a territory you own. Please try again.');
	else
		TargetTerritoryInstructionLabel.SetText('Selected territory: ' .. terrDetails.Name);
		SelectedTerritory = terrDetails;
		BuyPriestBtn.SetInteractable(true);
	end
end

function CompletePurchaseClicked()
	local msg = 'Buy a Priest on ' .. SelectedTerritory.Name;
	local payload = 'BuyPriest_' .. SelectedTerritory.ID;
	local orders = Game.Orders;

	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = Mod.Settings.CostToBuyPriest } ));
	Game.Orders = orders;

	Close2();
end
