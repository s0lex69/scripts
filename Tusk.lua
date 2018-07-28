--[[
TO DO:
	Prediction optimization
--]]
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
function Tusk.Init( ... )
	myHero = Heroes.GetLocal()
	myPlayer = Players.GetLocal()
	added = false
	nextTick = 0
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
function Tusk.OnUpdate( ... )
	if not myHero or not Menu.IsEnabled(optionEnable) then return end
	if Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_tusk_3")) > 0 and not added then
		snowballspeed = snowballspeed + 300
		added = true
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
	local myDir = Entity.GetRotation(myHero):GetForward():Normalized()
	local dir = Entity.GetRotation(ent):GetForward():Normalized()
	if myDir:__sub(dir):GetX() < 0.7 then
		dir:SetX(dir:GetX() - 0.7)
	elseif myDir:__sub(dir):GetX() > -0.7 then
		dir:SetX(dir:GetX() + 0.7)
	end
	if not speed then
		speed = NPC.GetMoveSpeed(ent)
	end
	if speed <= 350 then
		return pos + dir:Scaled(speed*1.5)
	else
		return pos + dir:Scaled(speed)
	end	 
end
function Tusk.Combo(enemy)
	local myMana = NPC.GetMana(myHero)
	local urn = NPC.GetItem(myHero, "item_urn_of_shadows", true)
	local vessel = NPC.GetItem(myHero, "item_spirit_vessel", true)
	local mjolnir = NPC.GetItem(myHero, "item_mjollnir", true)
	local halberd = NPC.GetItem(myHero, "item_heavens_halberd", true)
	local abyssal = NPC.GetItem(myHero, "item_abyssal_blade", true)
	local orchid = NPC.GetItem(myHero, "item_orchid", true)
	local armlet = NPC.GetItem(myHero, "item_armlet", true)
	local bloodthorn = NPC.GetItem(myHero, "item_bloodthorn", true)
	local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
	local courage = NPC.GetItem(myHero, "item_medallion_of_courage", true)
	local solar = NPC.GetItem(myHero, "item_solar_crest", true)
	if not enemy or not NPC.IsEntityInRange(myHero, enemy, comboRadius) then
		enemy = nil
		return
	end
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		return
	end
	if Menu.IsEnabled(pickTeam) and (NPC.HasModifier(myHero, "modifier_tusk_snowball_movement") or NPC.HasModifier(myHero, "modifier_tusk_snowball_visible") or NPC.HasModifier(myHero, "modifier_tusk_snowball_movement_friendly")) and Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND) then
		for i, k in pairs(Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND)) do
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET, k, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		end
	end
	if Menu.IsEnabled(snowballEnable) and Ability.GetLevel(snowball) > 0 and Ability.IsCastable(snowball, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(snowball, enemy)
		if Ability.IsCastable(launch_snowball, 0) then
			Ability.CastNoTarget(launch_snowball)
		end
		return
	end
	if Menu.IsEnabled(shardEnable) and Ability.GetLevel(shard) > 0 and Ability.IsCastable(shard, myMana) and not NPC.IsTurning(enemy) and not NPC.HasModifier(myHero, "modifier_tusk_snowball_movement") then
		if NPC.HasModifier(enemy, "modifier_stunned") and Modifier.GetDieTime(NPC.GetModifier(enemy,"modifier_stunned")) > (Entity.GetAbsOrigin(myHero):__sub(Entity.GetAbsOrigin(enemy))):Length()/snowballspeed then
			if Entity.GetAbsOrigin(myHero):__sub(Vector(-7317.406250, -6815.406250, 512.000000)):Length() < Entity.GetAbsOrigin(enemy):__sub(Vector(-7317.406250, -6815.406250, 512.000000)):Length() then
				Ability.CastPosition(shard, Entity.GetAbsOrigin(enemy) + Vector(250,0,0))
			else
				Ability.CastPosition(shard, Entity.GetAbsOrigin(enemy) + Vector(-250,0,0))
			end
		elseif not NPC.IsRunning(enemy) or NPC.IsEntityInRange(myHero, enemy, 300) then
			if Entity.GetAbsOrigin(myHero):__sub(Vector(-7317.406250, -6815.406250, 512.000000)):Length() < Entity.GetAbsOrigin(enemy):__sub(Vector(-7317.406250, -6815.406250, 512.000000)):Length() then
				Ability.CastPosition(shard, Entity.GetAbsOrigin(enemy) + Vector(250,0,0))
			else	
				Ability.CastPosition(shard, Entity.GetAbsOrigin(enemy) + Vector(-250,0,0))
			end
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
	if not NPC.IsAttacking(myHero) and Menu.IsEnabled(punchEnable) and not Ability.IsCastable(punch, myMana then
		Player.AttackTarget(myPlayer, myHero, enemy, true)
	elseif not NPC.IsAttacking(myHero) and not Menu.IsEnabled(punchEnable) then
		Player.AttackTarget(myPlayer, myHero, enemy, true)	
	end
end
Tusk.Init()
return Tusk