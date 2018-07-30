local Tusk = {}
local optionEnable = Menu.AddOptionBool({"Hero Specific", "Tusk"}, "Enable", false)
Menu.AddMenuIcon({"Hero Specific", "Tusk"}, "panorama/images/heroes/icons/npc_dota_hero_tusk_png.vtex_c")
local pickTeam = Menu.AddOptionBool({"Hero Specific", "Tusk"}, "Pick teammates to the snowball", false)
local comboKey = Menu.AddKeyOption({"Hero Specific", "Tusk"}, "Combo Key", Enum.ButtonCode.KEY_Z)
local shardEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Abilities"}, "Ice Shards", false)
local snowballEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Abilities"}, "Snowball", false)
local sigilEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Abilities"}, "Frozen Sigil", false)
local punchEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Abilities"}, "Walrus Punch", false)
local courageEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Medallion of Courage", false)
local solarEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Solar Crest", false)
local urnEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Urn of Shadows", false)
local armletEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Armlet of Mordiggian", false)
local vesselEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Spirit Vessel", false)
local halberdEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Heavens Halberd", false)
local abyssalEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Abyssal Blade", false)
local mjollnirEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Mjolnir", false)
local orchidEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Orchid", false)
local bloodthornEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Bloodthorn", false)
local bkbEnable = Menu.AddOptionBool({"Hero Specific", "Tusk", "Items"}, "Black King Bar", false)
local comboRadius = Menu.AddOptionSlider({"Hero Specific", "Tusk"}, "Combo Radius", 200, 1250, 1000)
local myHero, myTeam, myPlayer
local enemy
local nextTick
local added = false
local shard, snowball, launch_snowball, snowballspeed,sigil, punch
local urn, vessel, solar, courage, armlet, mjolnir, bloodthorn, orchid, bkb, abyssal, halberd
function Tusk.Init( ... )
	myHero = Heroes.GetLocal()
	myPlayer = Players.GetLocal()
	added = false
	nextTick = 0
	Tusk.ClearVar()
	if not myHero then return end
	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_tusk" then
		myHero = nil
	end
	if not myHero then return end
	shard = NPC.GetAbilityByIndex(myHero, 0)
	snowball = NPC.GetAbilityByIndex(myHero, 1)
	snowballspeed = 600
	launch_snowball = NPC.GetAbility(myHero, "tusk_launch_snowball")
	sigil = NPC.GetAbilityByIndex(myHero, 2)
	punch = NPC.GetAbility(myHero, "tusk_walrus_punch")
	myTeam = Entity.GetTeamNum(myHero)
end
function Tusk.OnGameStart( ... )
	Tusk.Init()
end
function Tusk.ClearVar( ... )
	urn = nil
	vessel = nil
	solar = nil
	courage = nil 
	armlet = nil
	mjolnir = nil 
	bloodthorn = nil
	orchid = nil
	bkb = nil 
	abyssal = nil
	halberd = nil
end
function Tusk.OnUpdate( ... )
	if not myHero or not Menu.IsEnabled(optionEnable) then return end
	if not added and Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_tusk_3")) > 0 then
		snowballspeed = snowballspeed + 300
		added = true
	end
	Tusk.ClearVar()
	for i = 0, 5 do
		item = NPC.GetItemByIndex(myHero, i)
		if item and item ~= 0 then
			local name = Ability.GetName(item)
			if name == "item_urn_of_shadows" then
				urn = item
			elseif name == "item_spirit_vessel" then
				vessel = item
			elseif name == "item_mjollnir" then
				mjolnir = item
			elseif name == "item_heavens_halberd" then
				halberd = item
			elseif name == "item_abyssal_blade" then
				abyssal = item
			elseif name == "item_orchid" then
				orchid = item
			elseif name == "item_armlet" then
				armlet = item
			elseif name == "item_bloodthorn" then
				bloodthorn = item
			elseif name == "item_black_king_bar" then
				bkb = item
			elseif name == "item_medallion_of_courage" then
				courage = item
			elseif name == "item_solar_crest" then
				solar = item
			end	
		end
	end
	
	if Menu.IsKeyDown(comboKey) then
		if not enemy then
			enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
		end
		Tusk.Combo(enemy)
	else
		enemy = nil	
	end
end
function Tusk.PosPrediction(ent, speed)
	local pos = Entity.GetAbsOrigin(ent)
	local dir = Entity.GetRotation(myHero):GetForward():Normalized()
	if not speed then
		speed = NPC.GetMoveSpeed(ent)
	end
	if speed == 0 then
		pos = pos + dir:Scaled(100)
	end	
	if speed <= 350 then
		pos = pos + dir:Scaled(speed*1.2)
	else
		pos = pos + dir:Scaled(speed*1.3)
	end	 
	return pos
end
function Tusk.Combo(enemy)
	local myMana = NPC.GetMana(myHero)
	if not enemy or not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(comboRadius)) then
		enemy = nil
		return
	end
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		return
	end
	if Menu.IsEnabled(pickTeam) and (NPC.HasModifier(myHero, "modifier_tusk_snowball_movement") or NPC.HasModifier(myHero, "modifier_tusk_snowball_visible") or NPC.HasModifier(myHero, "modifier_tusk_snowball_movement_friendly")) and Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND) then
		for i, k in pairs(Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND)) do
			if not NPC.HasModifier(k, "modifier_tusk_snowball_movement_friendly") then
				Player.AttackTarget(myPlayer, myHero, k, false)
			end
		end
	end
	if Menu.IsEnabled(snowballEnable) and Ability.GetLevel(snowball) > 0 and Ability.IsCastable(snowball, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(snowball, enemy)
		local tempTable = Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND)
		if not Menu.IsEnabled(pickTeam) then
			tempTable = nil
		else
			if tempTable then
				for i, k in pairs(tempTable) do
					if not NPC.HasModifier(k, "modifier_tusk_snowball_movement_friendly") then
						Player.AttackTarget(myPlayer, myHero, k, false)
					end
				end
				tempTable = nil
			end	
		end
		if Ability.IsCastable(launch_snowball, 0) and not tempTable then
			Ability.CastNoTarget(launch_snowball)
		end
		return
	end
	if Menu.IsEnabled(shardEnable) and Ability.GetLevel(shard) > 0 and Ability.IsCastable(shard, myMana) and not NPC.IsTurning(enemy) then
		if NPC.HasModifier(enemy, "modifier_stunned") and Modifier.GetDieTime(NPC.GetModifier(enemy,"modifier_stunned")) > (Entity.GetAbsOrigin(myHero):__sub(Entity.GetAbsOrigin(enemy))):Length()/snowballspeed then
			Ability.CastPosition(shard, Tusk.PosPrediction(enemy, 0))
		elseif not NPC.IsRunning(enemy) then
			Ability.CastPosition(shard, Tusk.PosPrediction(enemy, 0))
		else
			Ability.CastPosition(shard, Tusk.PosPrediction(enemy))
		end
		return
	end
	if Menu.IsEnabled(sigilEnable) and Ability.GetLevel(sigil) > 0 and Ability.IsCastable(sigil, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		if NPC.IsEntityInRange(myHero, enemy, 450) then
			Ability.CastNoTarget(sigil)
		end
		return
	end
	if urn and Menu.IsEnabled(urnEnable) and Item.GetCurrentCharges(urn) > 0 and Ability.IsCastable(urn,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(urn, enemy)
		return
	end
	if vessel and Menu.IsEnabled(vesselEnable) and Item.GetCurrentCharges(vessel) > 0 and Ability.IsCastable(vessel,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(vessel, enemy)
		return
	end
	if solar and Menu.IsEnabled(solarEnable) and Ability.IsCastable(solar,0) then
		Ability.CastTarget(solar, enemy)
		return
	end
	if courage and Menu.IsEnabled(courageEnable) and Ability.IsCastable(courage,0) then
		Ability.CastTarget(courage, enemy)
		return
	end
	if orchid and Menu.IsEnabled(orchidEnable) and Ability.IsCastable(orchid,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(orchid, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(bloodthornEnable) and Ability.IsCastable(bloodthorn,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if mjolnir and Menu.IsEnabled(mjollnirEnable) and Ability.IsCastable(mjolnir,0) then
		Ability.CastTarget(mjolnir, myHero)
		return
	end
	if abyssal and Menu.IsEnabled(abyssalEnable) and Ability.IsCastable(abyssal,0) then
		Ability.CastTarget(abyssal, enemy)
		return
	end
	if halberd and Menu.IsEnabled(halberdEnable) and Ability.IsCastable(halberd,0) and NPC.IsAttacking(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(halberd, enemy)
		return
	end
	if bkb and Menu.IsEnabled(bkbEnable) and Ability.IsCastable(bkb,0) then
		Ability.CastNoTarget(bkb)
		return
	end
	if armlet and Menu.IsEnabled(armletEnable) and not Ability.GetToggleState(armlet) and Ability.IsCastable(armlet,0) and GameRules.GetGameTime() >= nextTick then
		Ability.Toggle(armlet)
		nextTick = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if Menu.IsEnabled(punchEnable) and Ability.GetLevel(punch) > 0 and Ability.IsCastable(punch, myMana) and NPC.IsEntityInRange(myHero, enemy, 350) and not NPC.HasModifier(myHero, "modifier_tusk_snowball_movement") then
		Ability.CastTarget(punch, enemy)
		return
	end	
	if not NPC.IsAttacking(myHero) and Menu.IsEnabled(punchEnable) and not Ability.IsCastable(punch, myMana) then
		Player.AttackTarget(myPlayer, myHero, enemy, false)
	elseif not NPC.IsAttacking(myHero) and not Menu.IsEnabled(punchEnable) then
		Player.AttackTarget(myPlayer, myHero, enemy, false)	
	end
end
Tusk.Init()
return Tusk