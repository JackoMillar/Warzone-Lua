require('LoreBook');
Alerted = false;

function Client_GameRefresh(game)
 local data = Mod.PublicGameData;   
	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use the Special Units Structures modpack");
        Alerted = true;
	end
	if(game.Us == nil)then
		return;
	end
        if game.Game.TurnNumber < 1 or data.Counters[game.Us.ID] == 0 then		
         return;	
        end	 
  
  UI.Alert(advert);
end
