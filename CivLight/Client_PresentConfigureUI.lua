require('UI');

function Client_PresentConfigureUI(rootParent, rootParent2, rootParent3)
	initialValueConvert = Mod.Settings.NumToConvert or 2;
	initialValueArmies = Mod.Settings.SetArmiesTo or 2;
	initialcheckbox = Mod.Settings.OnlyBaseNeutrals or false;

	initialVillages = Mod.Settings.NumOfVillages or 3;
	ON = (Mod.Settings.ONeutrals == nil and true) or Mod.Settings.ONeutrals;
	GainedArmies = Mod.Settings.Armies;-- FIXME exact setting name used more than once for multiple settings

	initialACaches = Mod.Settings.NumOfACaches or 3;
	GainedArmies = Mod.Settings.Armies;-- FIXME exact setting name used more than once for multiple settings
	FixedArmies = (Mod.Settings.FixedArmies == nil and true) or Mod.Settings.FixedArmies;
	difference = Mod.Settings.aLuck or 5;

	initialRCaches = Mod.Settings.NumOfRCaches or 2;
	Pieces = Mod.Settings.cPieces or 3;
	FixedPieces = (Mod.Settings.FixedPieces == nil and true) or Mod.Settings.FixedPieces;
	difference2 = Mod.Settings.rLuck or 3;

	AttackNeutral = (Mod.Settings.AttackNeutral == nil and true) or Mod.Settings.AttackNeutral;

	Init(rootParent);
	-- initiliase all default values for the inputs
	showMainConfig();
end

function showMainConfig()
	DestroyWindow();
	SetWindow('Main');

	local vert = CreateVert(GetRoot());

	CreateButton(vert).SetText('Expansion+').SetOnClick(showExpansionConfig).SetColor('#00FF8C');
	CreateButton(vert).SetText('Villages').SetOnClick(showVillagesConfig).SetColor('#00FF8C');
	CreateButton(vert).SetText('Army-Caches').SetOnClick(showArmyCacheConfig).SetColor('#00FF8C');
	CreateButton(vert).SetText('Card-Caches').SetOnClick(showCardCacheConfig).SetColor('#00FF8C');

	CreateButton(vert).SetText('Misc Features').SetOnClick(showMiscConfig).SetColor('#AC0059');
end

function showExpansionConfig()
	DestroyWindow();
	SetWindow('FreeExpansion');

	local vert = CreateVert(GetRoot());

	CreateLabel(vert).SetText('Allows players to gain a free neutral every turn (only on connected territories).').SetColor('#606060');
	CreateLabel(vert).SetText('you can disable this mod by setting amount to 0.').SetColor('#606060');

	UI.CreateLabel(vert).SetText('Amount of neutrals a player shall gain each turn').SetColor('#23A0FF');
	ExpansionInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueConvert);

	UI.CreateLabel(vert).SetText('Amount of armies a player shall get with the territory').SetColor('#23A0FF');
	ExpArmyInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialValueArmies);

	UI.CreateLabel(vert).SetText('Only base neutral armies and less shall be claimed').SetColor('#23A0FF');
	ExpBaseInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(initialcheckbox);

	CreateButton(GetRoot()).SetText('Return').SetOnClick(saveExpansionConfig).SetColor('#94652E');
end

function saveExpansionConfig()
	initialValueConvert = ExpansionInputField.GetValue();
	initialValueArmies = ExpArmyInputField.GetValue();
	initialcheckbox = ExpBaseInputField.GetIsChecked();
	showMainConfig();
end

function showVillagesConfig()
	DestroyWindow();
	SetWindow('Villages');

	if GainedArmies == nil then
		GainedArmies = 2;
	end

	local vert = CreateVert(GetRoot());

	UI.CreateLabel(vert).SetText('At the start of the game, "villages" will spawn around the map. Capturing a village will claim all the adjacent territories to your side. These are shown as Idle Mercenary Camps.').SetColor('#606060');
	CreateLabel(vert).SetText('you can disable this mod by setting amount to 0.').SetColor('#606060');

	UI.CreateLabel(vert).SetText('Amount of Villages that will be created at the start of the game').SetColor('#23A0FF');
	villageInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(initialVillages);

	UI.CreateLabel(vert).SetText('Amount of armies that you will get with each new territory').SetColor('#23A0FF');
	vValueInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(GainedArmies);

	UI.CreateLabel(vert).SetText('only neutrals territories shall be claimed (recommended)').SetColor('#23A0FF');
	ONInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(ON);

	CreateButton(GetRoot()).SetText('Return').SetOnClick(saveVillageConfig).SetColor('#94652E');
end

function saveVillageConfig()
	initialVillages = villageInputField.GetValue();
	GainedArmies = vValueInputField.GetValue();
	ON = ONInputField.GetIsChecked();
	showMainConfig();
end

function showArmyCacheConfig()
	DestroyWindow();
	SetWindow('Army-Caches');

	if GainedArmies == nil then
		GainedArmies = 5;
	end

	local vert = CreateVert(GetRoot());

	UI.CreateLabel(vert).SetText('Army Caches will spawn around the map, grab them to boost your income for the next turn only. These are shown as Idle Army Caches.').SetColor('#606060');
	CreateLabel(vert).SetText('you can disable this mod by setting amount to 0.').SetColor('#606060');

	UI.CreateLabel(vert).SetText('Amount of Army Caches that will spawn at the start of the game').SetColor('#23A0FF');
	armyCacheInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialACaches);

	UI.CreateLabel(vert).SetText('Amount of armies that you will get for claiming a army cache').SetColor('#23A0FF');
	armyAmountInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(15)
		.SetValue(GainedArmies);

	UI.CreateLabel(vert).SetText('if checked will only give a fixed amount of armies').SetColor('#23A0FF');
	fixedArmyInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(FixedArmies);

	UI.CreateLabel(vert).SetText('Random +/- limit').SetColor('#23A0FF');
	randArmyInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(difference);

	CreateButton(GetRoot()).SetText('Return').SetOnClick(saveArmyConfig).SetColor('#94652E');
end

function saveArmyConfig()
	initialACaches = armyCacheInputField.GetValue();
	GainedArmies = armyAmountInputField.GetValue();
	FixedArmies = fixedArmyInputField.GetIsChecked();
	difference = randArmyInputField.GetValue();
	showMainConfig();
end

function showCardCacheConfig()
	DestroyWindow();
	SetWindow('Card-Caches');

	local vert = CreateVert(GetRoot());

	UI.CreateLabel(vert).SetText('Card Caches will spawn around the map at the start of the game, claiming the territory it is on will give you pieces for one random card (cards that are enabled by host before hand). These are shown as Idle Resource Caches.').SetColor('#606060');
	CreateLabel(vert).SetText('you can disable this mod by setting amount to 0.').SetColor('#606060');

	UI.CreateLabel(vert).SetText('Amount of Card Caches that will spawn at the start of the game (shown as resource cache)').SetColor('#23A0FF');
	cardCacheInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(initialRCaches);

	UI.CreateLabel(vert).SetText('Amount of card pieces that you will get for claiming a card cache').SetColor('#23A0FF');
	PiecesInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(Pieces);

	UI.CreateLabel(vert).SetText('if checked will only give a fixed amount of card pieces').SetColor('#23A0FF');
	fixedPiecesInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(FixedPieces);

	UI.CreateLabel(vert).SetText('Random +/- limit').SetColor('#23A0FF');
	randPiecesInputField = UI.CreateNumberInputField(vert)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(difference2);

	CreateButton(GetRoot()).SetText('Return').SetOnClick(saveCardCacheConfig).SetColor('#94652E');
end

function saveCardCacheConfig()
	initialRCaches = cardCacheInputField.GetValue();
	Pieces = PiecesInputField.GetValue();
	FixedPieces = fixedPiecesInputField.GetIsChecked();
	difference2 = randPiecesInputField.GetValue();
	showMainConfig();
end

function showMiscConfig()     -- 0 parameters!
	DestroyWindow();          -- Destroys every UI object currently visible
	SetWindow('Misc');  -- Allows you to do even more advanced shit

	local vert = CreateVert(GetRoot());

	UI.CreateLabel(vert).SetText('These are extra features that you can enable!').SetColor('#606060');
	UI.CreateLabel(vert).SetText('if checked will allow the player to claim neutral territories manually. (note that the player can still claim structures on bordering neutral territories)').SetColor('#23A0FF');
	attackNeutralInputField = UI.CreateCheckBox(vert)
		.SetIsChecked(AttackNeutral);

	CreateButton(GetRoot()).SetText('Return').SetOnClick(saveMiscConfig).SetColor('#94652E');  -- Allows game creators to go back to the previous page
end

function saveMiscConfig()
	AttackNeutral = attackNeutralInputField.GetIsChecked();
	showMainConfig();
end

--[[
basic template for functions:
function functionName()     -- 0 parameters!
	DestroyWindow();          -- Destroys every UI object currently visible
	SetWindow('WindowName');  -- Allows you to do even more advanced shit
	-- do here what you want
	CreateButton(parent).SetText('Return').SetOnClick(previousFunction);  -- Allows game creators to go back to the previous page
end
]]--
