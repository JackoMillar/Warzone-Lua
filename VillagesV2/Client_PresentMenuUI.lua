require('UI');

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Game = game;
	Init(rootParent);
	setMaxSize(500, 400);
	setSize = setMaxSize;

	if not game.Us then
		return;
	end

	if game.Game.TurnNumber < 1 then
		UI.Alert('This mod cannot be used in the distribution turn');
		close();
		return;
	end

	showMenu(game);
end

function showMenu(game)
	DestroyWindow();
	SetWindow('Main');

	local vert = CreateVert(GetRoot());
	local horz = CreateHorz(GetRoot());

	CreateLabel(vert).SetText('This is the main menu screen, select the buttons below related on what you want to do.').SetColor('#606060');
	CreateButton(horz).SetText('Build').SetOnClick(buildMenu).SetColor('#00FF8C');
	CreateButton(horz).SetText('Information').SetOnClick(infoMenu);
	CreateButton(horz).SetText('Credits').SetOnClick(showCredits).SetColor('#C04000');
end

function buildMenu()
	DestroyWindow();
	SetWindow('build');

	data = Mod.PublicGameData;

	local vert = CreateVert(GetRoot());
	local horz = CreateHorz(GetRoot());

	CreateLabel(vert).SetText('Convert your village to a new structure! Each structure has its own associated special unit that it can create.').SetColor('#FFAF56');

	if data.Counters[Game.Us.ID] > 0 then
		CreateLabel(vert).SetText('You currently have ' .. data.Counters[Game.Us.ID] .. ' Villages to convert.');
		CreateButton(horz).SetText('Market').SetOnClick(showMarket).SetColor('#00FF8C');
		CreateButton(horz).SetText('Hospital').SetOnClick(showHospital).SetColor('#00FF8C');
		CreateButton(horz).SetText('Embassy').SetOnClick(showEmbassy).SetColor('#00FF8C');
		CreateButton(horz).SetText('Church').SetOnClick(showChurch).SetColor('#00FF8C');
		CreateButton(GetRoot()).SetText("Return").SetOnClick(menuReturn).SetColor('#94652E');
	else
		CreateLabel(vert).SetText('Structures will be shown when you control at least one village that meeds converting.').SetColor('#FFAF56');
	end
end

function infoMenu()
	DestroyWindow();
	SetWindow('Info');

	local vert = CreateVert(GetRoot());
	local horz = CreateHorz(GetRoot());

	CreateLabel(vert).SetText('This menu will provide a description for what each Special Unit does').SetColor('#606060');
	CreateLabel(vert).SetText('Capitalist').SetColor('#FFAF56');
	CreateLabel(vert).SetText('The Market structure produces Capitalists, if the Capitalist is killed, it will reduce 20% of income that the opponent that killed it holds (1 turn only)')
	CreateLabel(vert).SetText('Diplomat').SetColor('#FFAF56');
	CreateLabel(vert).SetText('The Embassy structure produces Diplomats, if the Diplomat is killed in defense of itself, it will enforce a diplomacy card between the killer and the person who owns it (1 turn only)')
	CreateLabel(vert).SetText('Priest').SetColor('#FFAF56');
	CreateLabel(vert).SetText('The Church structure produces Priests, When an priest attacks or is attacked it will convert armies that are killed, 10% in offensive attacks, 20% in defensive.')
	CreateLabel(vert).SetText('Medic').SetColor('#FFAF56');
	CreateLabel(vert).SetText('The Hospital structure produces Medics, the medic can heal 20% of armies on connected territories as well as the territory it sits on')
	CreateButton(GetRoot()).SetText('Return').SetOnClick(showMenu).SetColor('#94652E');
end

function showCredits()
	DestroyWindow();
	SetWindow('Credits');

	local vert = CreateVert(GetRoot());
	local horz = CreateHorz(GetRoot());

	CreateLabel(vert).SetText('Thanks for playing, I need to credit Just_A_Dutchman for allowing me to implement his medic unit in this mod as well as the Modding Discord for testing and help debugging when I myself got stuck, a link to the discord is provided below');
	CreateTextInputField(vert).SetText('https://discord.gg/hqGkVXagyt');
	CreateLabel(vert).SetText('Creator: UnFairerOrb76 (UFO)');
	CreateButton(GetRoot()).SetText("Return").SetOnClick(menuReturn).SetColor('#94652E');
end

function showMarket()
	DestroyWindow();
	SetWindow('Market');

	local vert = CreateVert(GetRoot());

	CreateLabel(vert).SetText('The Market structure produces Capitalists, if the Capitalist is killed, it will reduce 20% of income that the opponent that killed it holds (1 turn only)').SetColor('#FFAF56');
	CreateButton(vert).SetText("Convert").SetOnClick(createMarket).SetColor('#00FF8C');
	CreateButton(GetRoot()).SetText("Return").SetOnClick(buildReturn).SetColor('#94652E');
end

function showHospital()
	DestroyWindow();
	SetWindow('Hospital');

	local vert = CreateVert(GetRoot());

	CreateLabel(vert).SetText('The Hospital structure produces Medics, the medic can heal 20% of armies on connected territories as well as the territory it sits on').SetColor('#FFAF56');
	CreateButton(vert).SetText('Convert').SetOnClick(createHospital).SetColor('#00FF8C');
	CreateButton(GetRoot()).SetText('Return').SetOnClick(buildReturn).SetColor('#94652E');
end

function showEmbassy()
	DestroyWindow();
	SetWindow('Embassy');

	local vert = CreateVert(GetRoot());

	CreateLabel(vert).SetText('The Embassy structure produces Diplomats, if the Diplomat is killed in defense of itself, it will enforce a diplomacy card between the killer and the person who owns it (1 turn only)').SetColor('#FFAF56');
	CreateButton(vert).SetText('Convert').SetOnClick(createEmbassy).SetColor('#00FF8C');
	CreateButton(GetRoot()).SetText('Return').SetOnClick(buildReturn).SetColor('#94652E');
end

function showChurch()
	DestroyWindow();
	SetWindow('Church');

	local vert = CreateVert(GetRoot());

	CreateLabel(vert).SetText('The Church structure produces Priests, When an priest attacks or is attacked it will convert armies that are killed, 10% in offensive attacks, 20% in defensive.').SetColor('#FFAF56');
	CreateButton(vert).SetText('Convert').SetOnClick(createChurch).SetColor('#00FF8C');
	CreateButton(GetRoot()).SetText('Return').SetOnClick(buildReturn).SetColor('#94652E');
end

function createMarket()
	Game.SendGameCustomMessage(
		'Updating Markets',
		{
			type = 'UpdatingMarkets',
			numStruct = data.Markets[Game.Us.ID]
		},
		function(UpdateMarket)
			showMenu(Game);
		end
	);
end

function createHospital()
	Game.SendGameCustomMessage(
		'Updating Hospitals',
		{
			type = 'UpdatingHospitals',
			numStruct = data.Hospitals[Game.Us.ID]
		},
		function(UpdateHospital)
			showMenu(Game);
		end
	);
end

function createEmbassy()
	Game.SendGameCustomMessage(
		'Updating Embassys',
		{
			type = 'UpdatingEmbassys',
			numStruct = data.Embassys[Game.Us.ID]
		},
		function(UpdateEmbassy)
			showMenu(Game);
		end
	);
end

function createChurch()
	Game.SendGameCustomMessage(
		'Updating Churchs',
		{
			type = 'UpdatingChurchs',
			numStruct = data.Churchs[Game.Us.ID]
		},
		function(UpdateChurch)
			showMenu(Game);
		end
	);
end

function buildReturn()
	buildMenu(Game);
end

function menuReturn()
	showMenu(Game);
end
