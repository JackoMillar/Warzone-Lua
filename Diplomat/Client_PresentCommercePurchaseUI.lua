require('Utilities');

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	UI.CreateLabel(vert).SetText("each Worker is as powerful as 3 army but cost " .. Mod.Settings.CostToBuyWorker .. " gold to purchase.  You may have up to " .. Mod.Settings.MaxWorkers .. ". If a Worker survives at the end of the turn it will construct " .. Mod.Settings.NumCities .." cities on that territory");
	UI.CreateButton(vert).SetText("Purchase a Worker for " .. Mod.Settings.CostToBuyWorker .. " gold").SetOnClick(PurchaseClicked);
end

function NumWorkersIn(armies)
	local ret = 0;
	for _,su in pairs(armies.SpecialUnits) do
		if (su.proxyType == 'CustomSpecialUnit' and su.Name == 'Worker') then
			ret = ret + 1;
		end
	end
	return ret;
end

function PurchaseClicked()
	--Check if they're already at max.  Add in how many they have on the map plus how many purchase orders they've already made
	--We check on the client for player convenience. Another check happens on the server, so even if someone hacks their client and removes this check they still won't be able to go over the max.

	local playerID = Game.Us.ID;

	local numWorkersAlreadyHave = 0;
	for _,ts in pairs(Game.LatestStanding.Territories) do
		if (ts.OwnerPlayerID == playerID) then
			numWorkersAlreadyHave = numWorkersAlreadyHave + NumWorkersIn(ts.NumArmies);
		end
	end

	for _,order in pairs(Game.Orders) do
		if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'BuyWorker_')) then
			numWorkersAlreadyHave = numWorkersAlreadyHave + 1;
		end
	end

	if (numWorkersAlreadyHave >= Mod.Settings.MaxWorkers) then
		UI.Alert("You already have " .. numWorkersAlreadyHave .. " Workers! You can only have " ..  Mod.Settings.MaxWorkers);
		return;
	end

	Game.CreateDialog(PresentBuyWorkersDialog);
	Close1();
end


function PresentBuyWorkersDialog(rootParent, setMaxSize, setScrollable, game, close)
	Close2 = close;

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1); --set flexible width so things don't jump around while we change InstructionLabel

	SelectTerritoryBtn = UI.CreateButton(vert).SetText("Select Territory").SetOnClick(SelectTerritoryClicked);
	TargetTerritoryInstructionLabel = UI.CreateLabel(vert).SetText("");

	BuyWorkerBtn = UI.CreateButton(vert).SetInteractable(false).SetText("Complete Purchase").SetOnClick(CompletePurchaseClicked);

	SelectTerritoryClicked(); --just start us immediately in selection mode, no reason to require them to click the button
end

function SelectTerritoryClicked()
	UI.InterceptNextTerritoryClick(TerritoryClicked);
	TargetTerritoryInstructionLabel.SetText("Please click on the territory you wish to receive the Recruiter unit on. If needed, you can move this dialog out of the way.");
	SelectTerritoryBtn.SetInteractable(false);
end

function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true);

	if (terrDetails == nil) then
		--The click request was cancelled.   Return to our default state.
		TargetTerritoryInstructionLabel.SetText("");
		SelectedTerritory = nil;
		BuyWorkerBtn.SetInteractable(false);
	else
		--Territory was clicked, check it
		if (Game.LatestStanding.Territories[terrDetails.ID].OwnerPlayerID ~= Game.Us.ID) then
			TargetTerritoryInstructionLabel.SetText("You may only receive a Worker on a territory you own.  Please try again.");
		else
			TargetTerritoryInstructionLabel.SetText("Selected territory: " .. terrDetails.Name);
			SelectedTerritory = terrDetails;
			BuyWorkerBtn.SetInteractable(true);
		end
	end
end

function CompletePurchaseClicked()
	local msg = 'Buy a Worker on ' .. SelectedTerritory.Name;
	local payload = 'BuyWorker_' .. SelectedTerritory.ID;

	local orders = Game.Orders;
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = Mod.Settings.CostToBuyWorker } ));
	Game.Orders = orders;

	Close2();
end
