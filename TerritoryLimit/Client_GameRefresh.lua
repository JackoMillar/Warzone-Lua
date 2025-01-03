Alerted = false;

function Client_GameRefresh(game)
	if not game.Us then
		return;
	end

	if not Alerted and not (WL and WL.IsVersionOrHigher and WL.IsVersionOrHigher('5.22') then
		UI.Alert('You must update your app to the latest version to use the Territory Limit mod');
		Alerted = true;
	end
end
