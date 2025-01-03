Alerted = false;

function Client_GameRefresh(game)
	if not Alerted and not (WL and WL.IsVersionOrHigher and WL.IsVersionOrHigher('5.21')) then
		UI.Alert('You must update your app to the latest version to use the Priest mod');
		Alerted = true;
	end
end
