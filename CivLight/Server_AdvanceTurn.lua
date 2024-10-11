require('UI');

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
	if order.proxyType == "GameOrderAttackTransfer" then 
          if orderResult.IsAttack and orderResult.IsSuccessful then
			 
          	local attackedTerr = game.ServerGame.LatestTurnStanding.Territories[order.To];
		local attackerTerr = game.ServerGame.LatestTurnStanding.Territories[order.From]; 
                if attackedTerr.Structures ~= nil then 
                	if attackedTerr.Structures[WL.StructureType.MercenaryCamp] ~= nil then -- there is a mercenary camp on the territory that was successfully attacked -- so now you can do what you want :p		
				Village(game, addNewOrder, order.To, order.PlayerID)			
			end 
		end
		if (Mod.Settings.AttackNeutral == false) and (attackedTerr.OwnerPlayerID == WL.PlayerID.Neutral) then
				
			local terrModTo = WL.TerritoryModification.Create(order.To);   
			terrModTo.SetOwnerOpt = WL.PlayerID.Neutral;
				
			print(attackedTerr.NumArmies.NumArmies);
			print(orderResult.AttackingArmiesKilled.NumArmies);
				
			terrModTo.SetArmiesTo = (attackedTerr.NumArmies.NumArmies - orderResult.DefendingArmiesKilled.NumArmies);
			local terrModfrom = WL.TerritoryModification.Create(order.From);
			terrModfrom.SetArmiesTo = (attackerTerr.NumArmies.NumArmies - orderResult.AttackingArmiesKilled.NumArmies);
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "calculating damage done", {}, {terrModTo}));
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, "returning damaged troops",{}, {terrModfrom}), true);
		end
			
	  end 
	end 

 	if order.proxyType == "GameOrderAttackTransfer" then 
        	if orderResult.IsSuccessful then 
          		local TransferredTerr = game.ServerGame.LatestTurnStanding.Territories[order.To]; 
                	if TransferredTerr.Structures ~= nil then 
                		if TransferredTerr.Structures[WL.StructureType.ArmyCache] ~= nil then -- there is a army cache on the territory that was successfully attacked -- so now you can do what you want :p
					ArmyCache(game, addNewOrder, order.To, order.PlayerID);
		    		end	
				if TransferredTerr.Structures[WL.StructureType.ResourceCache] ~= nil then
					ResourceCache(game, addNewOrder, order.To, order.PlayerID);
				end 
			end 
		end 
	end 
end      

function Server_AdvanceTurn_End(game, addNewOrder)
   	
	local pTable = {}; -- table of player territories
	local t = {};
	
	local randomNeutralTerr;   
        local nonDistArmies = game.Settings.InitialNonDistributionArmies;
	
	local list = {};

	if (Mod.Settings.OnlyBaseNeutrals == nil) then
      		Mod.Settings.OnlyBaseNeutrals = false; 
	end
	
	for playerID, _ in pairs(game.Game.PlayingPlayers) do
		t[playerID] = {};
		pTable[playerID] = {};
	end

	if (Mod.Settings.OnlyBaseNeutrals == false) then				
		for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
			if (game.ServerGame.LatestTurnStanding.Territories[terrID].IsNeutral == false) then
 		 		for connID, _ in pairs(game.Map.Territories[terrID].ConnectedTo) do
					if (game.ServerGame.LatestTurnStanding.Territories[connID].OwnerPlayerID == WL.PlayerID.Neutral) then
						table.insert(t[game.ServerGame.LatestTurnStanding.Territories[terrID].OwnerPlayerID], connID);		
					end
		 		end 
			end 
		end		
		for p, arr in pairs(t) do
  			for times = 1, math.min(Mod.Settings.NumToConvert, #arr) do
    				local rand = math.random(#arr);
    				local randomNeutralTerr = arr[rand]; --picks random neutral then gives it too player
    				if randomNeutralTerr == nil then break; end
    					if bordersOpponent(game, t, p, terrID) then
    		 				local terrMod = WL.TerritoryModification.Create(randomNeutralTerr);   
     		 				terrMod.SetOwnerOpt = p;
    		 				terrMod.SetArmiesTo = Mod.Settings.SetArmiesTo; -- you can leave this out, if this field is nill it will not change anything to the army count
						table.insert(list, terrMod);
		
	        				structs = game.ServerGame.LatestTurnStanding.Territories[randomNeutralTerr].Structures;
	    					local terr_has_merc_camp = false;
	     					--local terr_has_army_cache = false; 
	     					if structs ~= nil then
 	     						for key,val in pairs(structs) do
   	     							if key == WL.StructureType.MercenaryCamp then
    	     								terr_has_merc_camp = true
	     							end
	     							--if key == WL.StructureType.ArmyCache then
	     		 					--	terr_has_army_cache = true
   	      							--end
 							end
							if terr_has_merc_camp then
  								playerID = p;					
  								Village(game, addNewOrder, randomNeutralTerr, playerID);
							end	
							--if terr_has_army_cache then
  							--	playerID = p;					
  							--	ArmyCache(game, addNewOrder, randomNeutralTerr, playerID);
							--end	
						end		 
				
					end --   addNewOrder(WL.GameOrderEvent.Create(p,"new territory",{},{terrMod}), true));	
    					table.remove(arr, rand);
  				end
				table.insert(pTable[p], WL.GameOrderEvent.Create(p,"new territory",{}, list));
				list = {};
			end

			local i = 1;
			local addedOrders = true;
			while addedOrders do
 	 			addedOrders = false;
 	 			for p, _  in pairs(game.Game.PlayingPlayers) do
    	  				if pTable[p][i] ~= nil then
     	   					addedOrders = true;
           					addNewOrder(pTable[p][i]);
    	   				end
         			end
         			i = i + 1;
      			end
		end
		if (Mod.Settings.OnlyBaseNeutrals == true) then				
			for terrID, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
				if (game.ServerGame.LatestTurnStanding.Territories[terrID].IsNeutral == false) then
 		 			for connID, _ in pairs(game.Map.Territories[terrID].ConnectedTo) do
						if (game.ServerGame.LatestTurnStanding.Territories[connID].OwnerPlayerID == WL.PlayerID.Neutral and game.ServerGame.LatestTurnStanding.Territories[connID].NumArmies.NumArmies <= nonDistArmies) then				
							
							table.insert(t[game.ServerGame.LatestTurnStanding.Territories[terrID].OwnerPlayerID], connID);
						end
		 			end 
				end 
			end		
		
		for p, arr in pairs(t) do
  			for times = 1, math.min(Mod.Settings.NumToConvert, #arr) do

		    		local rand = math.random(#arr);
    				local randomNeutralTerr = arr[rand]; --picks random neutral then gives it too player
		    		if randomNeutralTerr == nil then break; end
    					if bordersOpponent(game, t, p, terrID) then
				    		local terrMod = WL.TerritoryModification.Create(randomNeutralTerr);   
				     		terrMod.SetOwnerOpt = p;
				    		terrMod.SetArmiesTo = Mod.Settings.SetArmiesTo; -- you can leave this out, if this field is nill it will not change anything to the army count
				        	table.insert(list, terrMod);
					
					     	structs = game.ServerGame.LatestTurnStanding.Territories[randomNeutralTerr].Structures;
					        local terr_has_merc_camp = false;
						--local terr_has_army_cache = false; 
	     					if structs ~= nil then
 	     						for key,val in pairs(structs) do
	
   	      							if key == WL.StructureType.MercenaryCamp then
    	      								terr_has_merc_camp = true
	      							end					
	     							--if key == WL.StructureType.ArmyCache then
							        --terr_has_army_cache = true
   	      							--end
 			 				end
						end
						if terr_has_merc_camp then
							playerID = p;					
							Village(game, addNewOrder, randomNeutralTerr, playerID);
						end	
						--if terr_has_army_cache then
  						--	playerID = p;					
  						--	ArmyCache(game, addNewOrder, randomNeutralTerr, playerID);
						--end		
					
					end --   addNewOrder(WL.GameOrderEvent.Create(p,"new territory",{},{terrMod}), true));
		
    					table.remove(arr, rand);
  				end
				table.insert(pTable[p], WL.GameOrderEvent.Create(p,"new territory",{}, list));
				list = {};
			end

			local i = 1;
			local addedOrders = true;
			while addedOrders do
 			addedOrders = false;
 	 		for p, _  in pairs(game.Game.PlayingPlayers) do
    	   			if pTable[p][i] ~= nil then
     	   				addedOrders = true;
           				addNewOrder(pTable[p][i]);
    	   			end
         		end
         		i = i + 1;
        	end
	end		
end

function ResourceCache(game, addNewOrder, terrID, playerID)
	local cardArray = {};
	local t1 = {};
	local t2 = {};
	local list = {};
					
	local terrMod = WL.TerritoryModification.Create(terrID);
					
	structures = {};
	structures[WL.StructureType.ResourceCache] = -1;					
	terrMod.AddStructuresOpt = structures;
			
	for cardID, _ in pairs(game.Settings.Cards) do
        	table.insert(cardArray, cardID);
        end
        local rand = math.random(#cardArray);
        local randomCard = cardArray[rand]; --picks random card to give to player
	local pieces = Mod.Settings.cPieces;
			 
	if Mod.Settings.FixedPieces == false then
		if Mod.Settings.Luck ~= nil then
			pieces = pieces + math.random(-Mod.Settings.Luck, Mod.Settings.Luck);
		end
		if pieces < 0 then
			pieces = 0;
		end
	end
	print(Mod.Settings.cPieces);
	print(playerID);
	print(pieces);
	             
	local cardEvent = WL.GameOrderEvent.Create(playerID, "Claimed a card cache and received " .. pieces .. " pieces for a random card", {}, {terrMod}, {}, {});
			
	t1[randomCard] = pieces;
	t2[playerID] = t1;			
	cardEvent.AddCardPiecesOpt = t2;
			
	addNewOrder(cardEvent, true);										   
end 

function ArmyCache(game, addNewOrder, terrID, playerID)
	
	local structures = game.ServerGame.LatestTurnStanding.Territories[terrID].Structures
	local IncomeAmount = Mod.Settings.Armies;
	local terrMod = WL.TerritoryModification.Create(terrID);
	
	structures = {}
	structures[WL.StructureType.ArmyCache] = -1;					
	terrMod.AddStructuresOpt = structures;
	if Mod.Settings.FixedArmies == true then	 
		addNewOrder(WL.GameOrderEvent.Create(playerID, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(playerID, IncomeAmount, "You have captured an army cache")}));
	end
	if Mod.Settings.FixedArmies == false then
		local luck = Mod.Settings.Luck;
		if Mod.Settings.Luck == nil then
			luck = 10;
		end 
		IncomeAmount = (IncomeAmount + math.random(-luck, luck));
		addNewOrder(WL.GameOrderEvent.Create(playerID, "Updated income", {}, {terrMod}, {}, {WL.IncomeMod.Create(playerID, IncomeAmount, "You have captured an army cache")}));	
	end						   
end 

function Village(game, addNewOrder, terrID, playerID)
	local list = {};			    
	for terrID, territory in pairs(game.Map.Territories[terrID].ConnectedTo) do
		if (Mod.Settings.ONeutrals == true) then	
			if (game.ServerGame.LatestTurnStanding.Territories[terrID].IsNeutral == true) then
				local terrMod = WL.TerritoryModification.Create(terrID);
				terrMod.SetOwnerOpt = playerID;
				terrMod.SetArmiesTo = Mod.Settings.Armies;
				table.insert(list, terrMod);
			end
		end
		if (Mod.Settings.ONeutrals == false) then
					     
			local terrMod = WL.TerritoryModification.Create(terrID);
			if (game.ServerGame.LatestTurnStanding.Territories[terrID].OwnerPlayerID ~= playerID) then
				terrMod.SetOwnerOpt = playerID;
				terrMod.SetArmiesTo = Mod.Settings.Armies;
				if terrMod ~= nil then
					table.insert(list, terrMod);
				end
			end
		end
	end 
	addNewOrder(WL.GameOrderEvent.Create(playerID,"new territory",{}, list), true);						   
end 

function getTableLength(t)
	local a = 0;
	for i, _ in pairs(t) do
		
		a = a + 1;
	end
	return a;
end

function bordersOpponent(game, t, p, terrID)
  for p2, arr in pairs(t) do
    if p ~= p2 and (getTeam(game, p) == -1 or getTeam(game, p) ~= getTeam(game, p2)) then
      if valueInTable(arr, terrID) then
        return false;
      end
    end
  end
  return true;
end

function getTeam(game, p)
  return game.Game.PlayingPlayers[p].Team;
end

function valueInTable(t, v)
  for _, v2 in pairs(t) do
    if v == v2 then
      return true;
    end
  end
  return false;
end
