--  This function will return a WL.TerritoryModification and removes armies from the given territory, just like it was attacked
--  This function will turn the territory neutral when it has no armies or special units left
--
--
--  Inputs:
--      game            [Game]         The game object you get passed in Server_AdvanceTurn
--      terr            [Territory]    The event territory. The function will only remove armies from this territory
--      damage          [Integer]      The amount of damage the territory takes (pass a 0 to remove all armies and units and turn the territory neutral)
--
--  Output:
--      mod             [WL.TerritoryModification]

function killArmiesOrTurnNeutral(game, terr, damage)
	local mod = WL.TerritoryModification.Create(terr.ID);

	mod.AddArmies = math.max(-damage, -terr.NumArmies.NumArmies);

	if terr.NumArmies.DefensePower <= damage or damage == 0 then
		mod.AddArmies = -terr.NumArmies.NumArmies;

		local t = {};

		for _, sp in ipairs(terr.NumArmies.SpecialUnits) do
			table.insert(t, sp.ID);
		end

		if #t ~= 0 then
			mod.RemoveSpecialUnitsOpt = t;
		end

		mod.SetOwnerOpt = WL.PlayerID.Neutral;
	else
		local spInOrder = {};

		for _, sp in ipairs(terr.NumArmies.SpecialUnits) do
			local co = sp.CombatOrder
			local b = false;

			for i, sp2 in ipairs(spInOrder) do
				if sp2.CombatOrder > co then
					table.insert(spInOrder, i, sp);
					b = true;

					break;
				end
			end

			if not b then
				table.insert(spInOrder, sp);
			end
		end

		damage = damage - terr.NumArmies.NumArmies;

		local t = {};

		for _, sp in ipairs(spInOrder) do
			if getHealth(sp) <= damage then
				table.insert(t, sp.ID);
--[[
			elseif unitHasHealth(sp) then
				table.insert(t, sp);
				if damage - getHealth(sp) < 0 then
					mod.AddSpecialUnits = {getClone(sp, damage)}
				end
]]
			end

			damage = damage - getHealth(sp);

			if damage <= 0 then
				break;
			end
		end

		if #t ~= 0 then
			mod.RemoveSpecialUnitsOpt = t;
		end
	end

	return mod;
end

--  Clone the passed special unit (only if it has [Health] instead of [DamageAbsorbedWhenAttacked])
--  It will subtract the passed damage and return a the new special unit (with updated Health)
--  This function should not be called elsewhere, and if you, do not call it when the unit should die
--
--  Inputs:
--      sp              [CustomSpecialUnit]    The unit to be modified
--      damage          [Integer]              The damage that will get subtracted from it's health
--
--  Output:
--      copy            [CustomSpecialUnit]    The updated unit, with only a changed Health

function getClone(sp, damage)
	local copy;

	copy = WL.CustomSpecialUnitBuilder.CreateCopy(sp);
	copy.Health = copy.Health - damage;
	copy = copy.Build();

	return copy;
end

--  Returns a boolean based on if the passed unit uses the field [Health] instead of [DamageAbsorbedWhenAttacked]
--
--  Input:
--      sp              [SpecialUnit]          The unit you want to know if it uses the [Health] field
--
--  Output:
--                      [Boolean]              True if the unit does use the [Health] field, false if not

function unitHasHealth(sp)
	if sp.proxyType == 'CustomSpecialUnit' then
		return sp.Health ~= nil;
	end

	return false;
end

--  Returns the [Health] (or [DamageAbsorbedWhenAttacked]) of the passed unit
--
--  Input:
--      sp              [SpecialUnit]          The unit you want to know the stats from
--
--  Output:
--                      [Integer]              The 'power' of the passed unit

function getHealth(sp)
	if sp.proxyType == 'CustomSpecialUnit' then
		if sp.Health ~= nil then
			return sp.Health;
		else
			return sp.DamageAbsorbedWhenAttacked;
		end
	else
		if sp.proxyType == 'Commander' then
			return 7;
		elseif sp.proxyType == 'Boss1' or sp.proxyType == 'Boss4' then
			return sp.Health;
		elseif sp.proxyType == 'Boss2' or sp.proxyType == 'Boss3' then
			return sp.Power;
		else
			return 0;
		end
	end
end
