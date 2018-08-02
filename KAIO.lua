local AllInOne = {}
local myHero, myPlayer, myTeam, myMana, attackRange
local enemy
local comboHero
local q,w,e,r
local razeShortPos, razeMidPos, razeLongPos
local nextTick = 0
local ebladeCasted = {}
--items
local urn, vessel, hex, halberd, mjolnir, bkb, nullifier, solar, courage, force, pike, eul, orchid, bloodthorn, diffusal, armlet, lotus, satanic, blademail, blink, abyssal, eblade, phase

AllInOne.optionClinkzEnable = Menu.AddOptionBool({"Hero Specific", "Clinkz"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnable, "panorama/images/items/branches_png.vtex_c")
Menu.AddMenuIcon({"Hero Specific", "Clinkz"}, "panorama/images/heroes/icons/npc_dota_hero_clinkz_png.vtex_c")
AllInOne.optionClinkzComboKey = Menu.AddKeyOption({"Hero Specific", "Clinkz"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionClinkzEnableBkb = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionClinkzEnableBlood = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionClinkzEnableCourage = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionClinkzEnableDiffusal = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionClinkzEnableHex = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionClinkzEnableNullifier = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Nullifier", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableNullifier, "panorama/images/items/nullifier_png.vtex_c")
AllInOne.optionClinkzEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionClinkzEnableSolar = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionLegionEnable = Menu.AddOptionBool({"Hero Specific", "Legion Commander"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionLegionOnlyWithDuel = Menu.AddOptionBool({"Hero Specific", "Legion Commander"}, "Combo only when duel ready", false)
Menu.AddOptionIcon(AllInOne.optionLegionOnlyWithDuel, "panorama/images/spellicons/legion_commander_duel_png.vtex_c")
Menu.AddMenuIcon({"Hero Specific", "Legion Commander"}, "panorama/images/heroes/icons/npc_dota_hero_legion_commander_png.vtex_c")
AllInOne.optionLegionComboKey = Menu.AddKeyOption({"Hero Specific", "Legion Commander"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionLegionEnablePressTheAttack = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Skills"}, "Press The Attack", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnablePressTheAttack, "panorama/images/spellicons/legion_commander_press_the_attack_png.vtex_c")
AllInOne.optionLegionEnableDuel = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Skills"}, "Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableDuel, "panorama/images/spellicons/legion_commander_duel_png.vtex_c")
AllInOne.optionLegionEnableAbyssalWithDuel = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Abbysal Blade In Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableAbyssalWithDuel, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionLegionEnableAbyssalWthDuel = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Abbysal Without Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableAbyssalWthDuel, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionLegionEnableArmlet = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Armlet of Mordiggian", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableArmlet, "panorama/images/items/armlet_png.vtex_c")
AllInOne.optionLegionEnableBkb = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionLegionEnableBlademail = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Blade Mail", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlademail, "panorama/images/items/blade_mail_png.vtex_c")
AllInOne.optionLegionEnableBlink = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionLegionEnableBlood = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionLegionEnableCourage = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionLegionEnableHalberd = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionLegionEnableLotus = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Lotus Orb", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableLotus, "panorama/images/items/lotus_orb_png.vtex_c")
AllInOne.optionLegionEnableMjolnir = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Mjolnir", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableMjolnir, "panorama/images/items/mjollnir_png.vtex_c")
AllInOne.optionLegionEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionLegionEnableSatanic = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Satanic", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableSatanic, "panorama/images/items/satanic_png.vtex_c")
AllInOne.optionLegionSatanicThreshold = Menu.AddOptionSlider({"Hero Specific", "Legion Commander", "Items"}, "HP Percent for satanic use", 1, 100, 15)
AllInOne.optionLegionEnableSolar = Menu.AddOptionBool({"Hero Specific", "Legion Commander", "Items"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionLegionBlinkRange = Menu.AddOptionSlider({"Hero Specific", "Legion Commander"}, "Minimum Blink Range", 200, 1150, 300)
AllInOne.optionSfEnable = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend"}, "Enable", false)
Menu.AddMenuIcon({"Hero Specific", "Shadow Fiend"}, "panorama/images/heroes/icons/npc_dota_hero_nevermore_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionSfEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionSfRazeKey = Menu.AddKeyOption({"Hero Specific", "Shadow Fiend"}, "Auto Raze Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionSfDrawRazePos = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend"}, "Draw Raze Position", false)
AllInOne.optionSfComboKey = Menu.AddKeyOption({"Hero Specific", "Shadow Fiend"}, "Eul combo key", Enum.ButtonCode.KEY_F)
AllInOne.optionSfEnableBkb = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionSfEnableBlink = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Blink", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionSfEnableBlood = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionSfEnableDagon = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionSfEnableEthereal = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Ethereal blade", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableEthereal, "panorama/images/items/ethereal_blade_png.vtex_c")
AllInOne.optionSfEnableHex = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionSfEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionSfEnablePhase = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Phase Boots", false)
Menu.AddOptionIcon(AllInOne.optionSfEnablePhase, "panorama/images/items/phase_boots_png.vtex_c")
AllInOne.optionEnablePoopLinken = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Enable", false)
Menu.AddMenuIcon({"Utility", "KAIO Poop Linken"}, "panorama/images/items/sphere_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionEnablePoopLinken, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionEnablePoopAbyssal = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Abyssal Blade", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopAbyssal, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionEnablePoopBlood = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionEnablePoopDagon = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionEnablePoopDiffusal = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionEnablePoopEul = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Eul", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopEul, "panorama/images/items/cyclone_png.vtex_c")
AllInOne.optionEnablePoopForce = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Force Staff", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopForce, "panorama/images/items/force_staff_png.vtex_c")
AllInOne.optionEnablePoopHalberd = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionEnablePoopHex = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionEnablePoopPike = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Hurricane Pike", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopPike, "panorama/images/items/hurricane_pike_png.vtex_c")
AllInOne.optionEnablePoopOrchid = Menu.AddOptionBool({"Utility", "KAIO Poop Linken"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopOrchid, "panorama/images/items/orchid_png.vtex_c")
function AllInOne.Init( ... )
	myHero = Heroes.GetLocal()
	nextTick = 0
	if not myHero then return end
	if NPC.GetUnitName(myHero) == "npc_dota_hero_clinkz" then
		comboHero = "Clinkz"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_legion_commander" then
		comboHero = "Legion"
		w = NPC.GetAbilityByIndex(myHero, 1)
		r = NPC.GetAbility(myHero, "legion_commander_duel")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_nevermore" then
		comboHero = "SF"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		e = NPC.GetAbilityByIndex(myHero, 2)
		r = NPC.GetAbility(myHero, "nevermore_requiem")
	else
		myHero = nil
		return	
	end
	myTeam = Entity.GetTeamNum(myHero)
	myPlayer = Players.GetLocal()
end
function AllInOne.OnGameStart( ... )
	AllInOne.Init()
end
function AllInOne.ClearVar( ... )
	urn = nil
	vessel = nil 
	hex = nil
	halberd = nil 
	mjolnir = nil
	bkb = nil
	nullifier = nil 
	solar = nil 
	courage = nil 
	force = nil
	pike = nil
	eul = nil
	orchid = nil
	bloodthorn = nil
	diffusal = nil
	armlet = nil 
	lotus = nil 
	satanic = nil 
	blademail = nil
	blink = nil
	abyssal = nil
end
function AllInOne.OnUpdate( ... )
	if not myHero then return end
	myMana = NPC.GetMana(myHero)
	if comboHero == "Clinkz" and Menu.IsEnabled(AllInOne.optionClinkzEnable) then
		if Menu.IsKeyDown(AllInOne.optionClinkzComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if Entity.IsAlive(enemy) then
				AllInOne.ClinkzCombo()
			end
		else
			enemy = nil
		end
	elseif comboHero == "Legion" and Menu.IsEnabled(AllInOne.optionLegionEnable) then
		if Menu.IsKeyDown(AllInOne.optionLegionComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				AllInOne.LegionCombo()
			end
		else
			enemy = nil
		end
	elseif comboHero == "SF" and Menu.IsEnabled(AllInOne.optionSfEnable) then
		if Menu.IsKeyDown(AllInOne.optionSfComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if Entity.IsAlive(enemy) then
				AllInOne.SfCombo(eul)
			end
		else
			enemy = nil
		end
		AllInOne.SfAutoRaze()
	end
	AllInOne.ClearVar()
	for i = 0, 5 do
		item = NPC.GetItemByIndex(myHero, i)
		if item and item ~= 0 then
			local name = Ability.GetName(item)
			if name == "item_urn_of_shadows" then
				urn = item
			elseif name == "item_spirit_vessel" then
				vessel = item
			elseif name == "item_sheepstick" then
				hex = item
			elseif name == "item_nullifier" then
				nullifier = item
			elseif name == "item_diffusal_blade" then
				diffusal = item
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
			elseif name == "item_blink" then
				blink = item
			elseif name == "item_blade_mail" then
				blademail = item
			elseif name == "item_orchid" then
				orchid = item
			elseif name == "item_lotus_orb" then
				lotus = item
			elseif name == "item_cyclone" then
				eul = item
			elseif name == "item_satanic" then
				satanic = item
			elseif name == "item_force_staff" then
				force = item
			elseif name == "item_hurricane_pike" then
				pike = item 
			elseif name == "item_ethereal_blade" then
				eblade = item
			elseif name == "item_phase_boots" then
				phase = item
			elseif name == "item_dagon" or name == "item_dagon_2" or name == "item_dagon_3" or name == "item_dagon_4" or name == "item_dagon_5" then
				dagon = item
			end	
		end
	end
end
function AllInOne.SfCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		enemy = nil
		return
	end
	if r and Ability.IsCastable(r, myMana) then
		if NPC.IsLinkensProtected(enemy) then
			AllInOne.PoopLinken(eul)
		end
		local possibleRange = NPC.GetMoveSpeed(myHero) * 0.8
		if not NPC.IsEntityInRange(myHero, enemy, possibleRange) then
			if blink and Menu.IsEnabled(AllInOne.optionSfEnableBlink) and Ability.IsCastable(blink,0) and NPC.IsEntityInRange(myHero, enemy, 1175 + 0.75 * possibleRange) then
				Ability.CastPosition(blink, (Entity.GetAbsOrigin(enemy) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(enemy)):Normalized():Scaled(0.75 * possibleRange)))
				return
			else
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET, enemy, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)	
			end
		end
		if eblade and Menu.IsEnabled(AllInOne.optionSfEnableEthereal) and Ability.IsCastable(eblade, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(eblade, enemy)
			ebladeCasted[enemy] = true
			return
		end
		if hex and Menu.IsEnabled(AllInOne.optionSfEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(hex, enemy)
			return
		end
		if bkb and Menu.IsEnabled(AllInOne.optionSfEnableBkb) and Ability.IsCastable(bkb, 0) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastNoTarget(bkb)
			return
		end
		if orchid and Menu.IsEnabled(AllInOne.optionSfEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if bloodthorn and Menu.IsEnabled(AllInOne.optionSfEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(bloodthorn, enemy)
			return
		end
		if phase and Menu.IsEnabled(AllInOne.optionSfEnablePhase) and Ability.IsCastable(phase, 0) then
			Ability.CastNoTarget(phase)
		end
		if eul and Ability.IsCastable(eul, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.IsLinkensProtected(enemy) then
			if Menu.IsEnabled(AllInOne.optionSfEnableEthereal) and ebladeCasted[enemy] and eblade and Ability.SecondsSinceLastUse(eblade) < 3 then
				Ability.CastTarget(eul, enemy)
				ebladeCasted[enemy] = nil
			else
				Ability.CastTarget(eul, enemy)
			end
			return
		end	
		if NPC.HasModifier(enemy, "modifier_eul_cyclone") then
			local cycloneDieTime = Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_eul_cyclone"))
			if not NPC.IsEntityInRange(myHero, enemy, 65) then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(enemy), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
			else
				if cycloneDieTime - GameRules.GetGameTime() <= 1.67 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
					Ability.CastNoTarget(r)
					return
				end
			end

		end
	end
end
function AllInOne.SfAutoRaze( ... )
	razeShortPos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(200)
	razeMidPos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(450)
	razeLongPos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(700)
	if Menu.IsKeyDown(AllInOne.optionSfRazeKey) then
		if not enemy then
			enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
		end
	else
		if not Menu.IsKeyDown(AllInOne.optionSfComboKey) then
			enemy = nil
		end
		return
	end
	local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
	if not enemy or not Entity.IsAlive(enemy) then return end
	local predictPos = AllInOne.castPrediction(razePrediction)
	if q and Ability.IsCastable(q, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		local disRazePOSpredictedPOS = (razeShortPos - predictPos):Length2D()
		if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
			Ability.CastNoTarget(q)
			return
		end
	end
	if w and Ability.IsCastable(w, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		local disRazePOSpredictedPOS = (razeMidPos - predictPos):Length2D()
		if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
			Ability.CastNoTarget(w)
			return
		end
	end
	if e and Ability.IsCastable(e, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		local disRazePOSpredictedPOS = (razeLongPos - predictPos):Length2D()
		if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
			Ability.CastNoTarget(e)
			return
		end
	end
end
function AllInOne.OnDraw( ... )
	if not myHero then return end
	if comboHero == "SF" and Menu.IsEnabled(AllInOne.optionSfDrawRazePos) and Ability.GetLevel(q) >= 1 then
		if not razeShortPos or not razeMidPos or not razeLongPos then
			return
		end
		local x,y,vis = Renderer.WorldToScreen(razeShortPos)
		if vis and Ability.IsReady(q) then
			if Heroes.InRadius(razeShortPos,250,myTeam,Enum.TeamType.TEAM_ENEMY) then
				Renderer.SetDrawColor(255,0,0)
			else
				Renderer.SetDrawColor(0,255,100)	
			end
			Renderer.DrawOutlineRect(x,y,15,15)
		end
		local x1,y1,vis1 = Renderer.WorldToScreen(razeMidPos)
		if vis1 and Ability.IsReady(w) then
			if Heroes.InRadius(razeMidPos,250,myTeam,Enum.TeamType.TEAM_ENEMY)then
				Renderer.SetDrawColor(255,0,0)
			else
				Renderer.SetDrawColor(0,255,100)
			end
			Renderer.DrawOutlineRect(x1,y1,15,15)
		end
		local x2,y2,vis2 = Renderer.WorldToScreen(razeLongPos)
		if vis2 and Ability.IsReady(e) then
			if Heroes.InRadius(razeLongPos,250,myTeam,Enum.TeamType.TEAM_ENEMY) then
				Renderer.SetDrawColor(255,0,0)
			else
				Renderer.SetDrawColor(0,255,100)
			end
			Renderer.DrawOutlineRect(x2,y2,15,15)
		end
	end
end
function AllInOne.GetMoveSpeed()
	local baseSpeed = NPC.GetBaseSpeed(enemy)
	local bonusSpeed = NPC.GetMoveSpeed(enemy) - baseSpeed
	local modHex
	if NPC.HasModifier(enemy, "modifier_sheepstick_debuff") or NPC.HasModifier(enemy, "modifier_lion_voodoo") or NPC.HasModifier(enemy, "modifier_shadow_shaman_voodoo") then
		return 140 + bonusSpeed
	end
	if NPC.HasModifier(enemy, "modifier_invoker_cold_snap_freeze") or NPC.HasModifier(enemy, "modifier_invoker_cold_snap") then
		return NPC.GetMoveSpeed(ent) * 0.5
	end
	return baseSpeed + bonusSpeed
end
function AllInOne.castPrediction(adjVar)
	local enemyRotation = Entity.GetRotation(enemy):GetVectors()
	enemyRotation:SetZ(0)
	local enemyOrigin = Entity.GetAbsOrigin(enemy)
	enemyOrigin:SetZ(0)
	if enemyRotation and enemyOrigin then
		if not NPC.IsRunning(enemy) then
			return enemyOrigin
		else
			return enemyOrigin:__add(enemyRotation:Normalized():Scaled(AllInOne.GetMoveSpeed(enemy) * adjVar))	
		end
	end
end
function AllInOne.LegionCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		enemy = nil
		return
	end
	if Menu.IsEnabled(AllInOne.optionLegionOnlyWithDuel) and not Ability.IsCastable(r, myMana) then
		enemy = nil
		return
	end
	if not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionLegionBlinkRange)) and NPC.IsEntityInRange(myHero, enemy, 1199) then
		if w and Menu.IsEnabled(AllInOne.optionLegionEnablePressTheAttack) and Ability.IsCastable(w, myMana) then
			Ability.CastTarget(w, myHero)
			return
		end
		if blademail and Menu.IsEnabled(AllInOne.optionLegionEnableBlademail) and Ability.IsCastable(blademail, myMana) then
			Ability.CastNoTarget(blademail)
			return
		end
		if bkb and Menu.IsEnabled(AllInOne.optionLegionEnableBkb) and Ability.IsCastable(bkb, 0) then
			Ability.CastNoTarget(bkb)
			return
		end
		if mjolnir and Menu.IsEnabled(AllInOne.optionLegionEnableMjolnir) and Ability.IsCastable(mjolnir, myMana) then
			Ability.CastTarget(mjolnir, myHero)
			return
		end
		if lotus and Menu.IsEnabled(AllInOne.optionLegionEnableLotus) and Ability.IsCastable(lotus, myMana) then
			Ability.CastTarget(lotus, myHero)
			return
		end
		if blink and Menu.IsEnabled(AllInOne.optionLegionEnableBlink) and Ability.IsCastable(blink, 0) then
			Ability.CastPosition(blink, Entity.GetAbsOrigin(enemy))
			return
		end
	end
	if NPC.IsEntityInRange(myHero, enemy, 150) then
		if NPC.IsLinkensProtected(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			AllInOne.PoopLinken()
		end
		if w and Menu.IsEnabled(AllInOne.optionLegionEnablePressTheAttack) and Ability.IsCastable(w, myMana) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)  then
			Ability.CastTarget(w, myHero)
			return
		end		
		if bkb and Menu.IsEnabled(AllInOne.optionLegionEnableBkb) and Ability.IsCastable(bkb, 0) then
			Ability.CastNoTarget(bkb)
			return
		end
		if abyssal and Ability.IsCastable(abyssal, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_STUNNED) and (Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWithDuel) or Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWthDuel)) then
			if Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWithDuel) and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) then
				Ability.CastTarget(abyssal, enemy)
				return
			elseif Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWthDuel) and (not Ability.IsCastable(r, myMana) or not Menu.IsEnabled(AllInOne.optionLegionEnableDuel)) then
				Ability.CastTarget(abyssal, enemy)
				return
			end
		end
		if mjolnir and Menu.IsEnabled(AllInOne.optionLegionEnableMjolnir) and Ability.IsCastable(mjolnir, myMana) then
			Ability.CastTarget(mjolnir, myHero)
			return
		end
		if lotus  and Menu.IsEnabled(AllInOne.optionLegionEnableLotus) and Ability.IsCastable(lotus, myMana) then
			Ability.CastTarget(lotus, myHero)
			return
		end
		if armlet and Menu.IsEnabled(AllInOne.optionLegionEnableArmlet) and not Ability.GetToggleState(armlet) and Ability.IsCastable(armlet, 0) and GameRules.GetGameTime() >= nextTick then
			Ability.Toggle(armlet)
			nextTick = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if blademail and Menu.IsEnabled(AllInOne.optionLegionEnableBlademail) and Ability.IsCastable(blademail, myMana) then
			Ability.CastNoTarget(blademail)
			return
		end
		if solar and Menu.IsEnabled(AllInOne.optionLegionEnableSolar) and Ability.IsCastable(solar, 0) then
			Ability.CastTarget(solar, enemy)
			return
		end
		if courage and Menu.IsEnabled(AllInOne.optionLegionEnableCourage) and Ability.IsCastable(courage, 0) then
			Ability.CastTarget(courage, enemy)
			return
		end
		if halberd and Menu.IsEnabled(AllInOne.optionLegionEnableHalberd) and Ability.IsCastable(halberd, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(halberd, enemy)
			return
		end
		if orchid and Menu.IsEnabled(AllInOne.optionLegionEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if bloodthorn and Menu.IsEnabled(AllInOne.optionLegionEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(bloodthorn, enemy)
			return
		end
		if satanic and Menu.IsEnabled(AllInOne.optionLegionEnableSatanic) and Ability.IsCastable(satanic, myMana) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero) < Menu.GetValue(AllInOne.optionLegionSatanicThreshold)/100 then
			Ability.CastNoTarget(satanic)
			return
		end
		if r and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) then
			Ability.CastTarget(r, enemy)
			return
		end
	else
		if r and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) then
			Ability.CastTarget(r, enemy)
		else
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, enemy, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		end
		return
	end
end
function AllInOne.ClinkzCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or NPC.HasModifier(enemy, "modifier_dark_willow_shadow_realm_buff") then
		enemy = nil
		return
	end
	if attackRange ~= NPC.GetAttackRange(myHero) then
		attackRange = NPC.GetAttackRange(myHero)
	end
	if NPC.IsEntityInRange(myHero, enemy, attackRange) then
		if q and Ability.IsCastable(q, myMana) then
			Ability.CastNoTarget(q)
			return
		end
		if not Ability.GetAutoCastState(w) and GameRules.GetGameTime() >= nextTick then
			Ability.ToggleMod(w)
			nextTick = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if NPC.IsLinkensProtected(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			AllInOne.PoopLinken()
		end
		if nullifier and not NPC.HasModifier(enemy, "modifier_item_nullifier_mute") and Menu.IsEnabled(AllInOne.optionClinkzEnableNullifier) and Ability.IsCastable(nullifier, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			if NPC.GetItem(enemy, "item_aeon_disk", true) then
				if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") and not Ability.IsReady(NPC.GetItem(enemy, "item_aeon_disk", true)) then
					Ability.CastTarget(nullifier,enemy)
				end
			else
				Ability.CastTarget(nullifier, enemy)	
			end
			return
		end		
		if diffusal and not NPC.HasModifier(enemy, "modifier_item_diffusal_blade_slow") and Menu.IsEnabled(AllInOne.optionClinkzEnableDiffusal) and Ability.IsCastable(diffusal,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(diffusal, enemy)
			return
		end
		if orchid and not NPC.HasModifier(enemy, "modifier_orchid_malevolence_debuff") and Menu.IsEnabled(AllInOne.optionClinkzEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if bloodthorn and not NPC.HasModifier(enemy, "modifier_bloodthorn_debuff") and Menu.IsEnabled(AllInOne.optionClinkzEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(bloodthorn, enemy)
			return
		end
		if hex and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) and Menu.IsEnabled(AllInOne.optionClinkzEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(hex, enemy)
			return
		end
		if courage and not NPC.HasModifier(enemy, "modifier_item_medallion_of_courage_armor_reduction") and Menu.IsEnabled(AllInOne.optionClinkzEnableCourage) and Ability.IsCastable(courage, 0) then
			Ability.CastTarget(courage, enemy)
			return
		end
		if solar and not NPC.HasModifier(enemy, "modifier_item_solar_crest_armor_reduction") and Menu.IsEnabled(AllInOne.optionClinkzEnableSolar) and Ability.IsCastable(solar, 0) then
			Ability.CastTarget(solar, enemy)
			return
		end
		if bkb and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and Menu.IsEnabled(AllInOne.optionClinkzEnableBkb) and Ability.IsCastable(bkb, 0) then
			Ability.CastNoTarget(bkb)
			return
		end
		Player.AttackTarget(myPlayer, myHero, enemy)
	end
end
function AllInOne.PoopLinken(exception)
	if abyssal and Menu.IsEnabled(AllInOne.optionEnablePoopAbyssal) and Ability.IsCastable(abyssal, myMana) then
		Ability.CastTarget(abyssal, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(AllInOne.optionEnablePoopBlood) and Ability.IsCastable(bloodthorn, myMana) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if dagon and Menu.IsEnabled(AllInOne.optionEnablePoopDagon) and Ability.IsCastable(dagon, myMana) then
		Ability.CastTarget(dagon, enemy)
		return
	end
	if diffusal and Menu.IsEnabled(AllInOne.optionEnablePoopDiffusal) and Ability.IsCastable(diffusal, 0) then
		Ability.CastTarget(diffusal, enemy)
		return
	end
	if eul and Menu.IsEnabled(AllInOne.optionEnablePoopEul) and Ability.IsCastable(eul, myMana) and eul ~= exception then
		Ability.CastTarget(eul, enemy)
		return
	end
	if force and Menu.IsEnabled(AllInOne.optionEnablePoopForce) and Ability.IsCastable(force, myMana) then
		Ability.CastTarget(force, enemy)
		return
	end
	if halberd and Menu.IsEnabled(AllInOne.optionEnablePoopHalberd) and Ability.IsCastable(halberd, myMana) then
		Ability.CastTarget(halberd, enemy)
		return
	end
	if hex and Menu.IsEnabled(AllInOne.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
		Ability.CastTarget(hex, enemy)
		return
	end
	if pike and Menu.IsEnabled(AllInOne.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
		Ability.CastTarget(pike, enemy)
		return
	end
	if orchid and Menu.IsEnabled(AllInOne.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
		Ability.CastTarget(orchid, enemy)
		return
	end
end
AllInOne.Init()
return AllInOne