require('Utilities');
require('WLUtilities');

function Client_PresentCommercePurchaseUI(rootParent, setScrollable, game)
	

	Close1 = close;
	Game = game;
	
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateLabel(row1).SetText("Territories are worth: " + Mod.Settings.terrCost + " gold");
	UI.CreateButton(vert).SetText("Purchase a tank for " .. Mod.Settings.CostToBuyTank .. " gold").SetOnClick(PurchaseClicked);

	
	UI.CreateLabel(row1).SetText("Purchase territory: ");
	TargetTerritoryBtn = UI.CreateButton(row1).SetText("Select territory...").SetOnClick(TargetTerritoryClicked);

	CostLabel = UI.CreateLabel(vert).SetText(" ");
	
	UI.CreateButton(vert).SetText("Purchase").SetOnClick(SubmitClicked);

end


function TargetTerritoryClicked()
	local options = map(filter(Game.LatestStanding.Territories, function(t) 
		return t.FogLevel == WL.StandingFogLevel.Visible and t.OwnerPlayerID == WL.PlayerID.Neutral  --only show unfogged, neutral territories.
		end), TerritoryButton);
	UI.PromptFromList("Select the territory you'd like to purchase", options);
end
function TerritoryButton(terr)
	local name = Game.Map.Territories[terr.ID].Name;
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function()
		TargetTerritoryBtn.SetText(name);
		TargetTerritoryID = terr.ID;
		Cost = terr.NumArmies.NumArmies * Mod.Settings.CostPerNeutralArmy;
		CostLabel.SetText("Cost = " .. Cost .. " gold");
	end
	return ret;
end

function SubmitClicked()
	if (TargetTerritoryID == nil) then
		UI.Alert("Please choose a territory first");
		return;
	end

	local goldHave = Game.LatestStanding.NumResources(Game.Us.ID, WL.ResourceType.Gold);
	
	if (Game.Us.HasCommittedOrders) then
		UI.Alert("You need to uncommit first");
		--since you can't write in the order table when the player has already commited, he needs to uncommit first before he can purchase the territory
		return;
	end
	
	if (goldHave < Cost) then
		UI.Alert("You can't afford it.  You have " .. goldHave .. " gold and it costs " .. Cost);
		return;
	end

	local msg = 'Request to purchase ' ..  Game.Map.Territories[TargetTerritoryID].Name .. ' for ' .. Cost .. ' gold';

	local payload = 'BuyNeutral_' .. TargetTerritoryID;

    --Pass a cost to the GameOrderCustom as its fourth argument.  This ensures the game takes the gold away from the player for this order, both on the client and server.
	local order = WL.GameOrderCustom.Create(Game.Us.ID, msg, payload, { [WL.ResourceType.Gold] = Cost } );

	local orders = Game.Orders;
	table.insert(orders, order);
	Game.Orders = orders;
end
