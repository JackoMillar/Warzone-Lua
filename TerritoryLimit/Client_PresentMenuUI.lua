require("UI");

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
  
  data = Mod.PublicGameData;
   Init(rootParent);  
   local vert = CreateVert(GetRoot());
  
    if game.Us == nil then
       return; 
    end
  
   CreateLabel(vert).SetText('You currently hold ' .. data.TerrLimit[Game.Us.ID] .. 'territories').SetColor('#FFAF56');
end
