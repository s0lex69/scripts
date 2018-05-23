local AutoDagon = {}

AutoDagon.IsToggled = Menu.AddOptionBool({"Utility"}, "AutoDagon", "")
AutoDagon.sleepers = {}
AutoDagon.Modifiers = {[0] = "modifier_medusa_stone_gaze_stone",[1] = "modifier_winter_wyvern_winters_curse",[2] = "modifier_item_lotus_orb_active",[3] = "modifier_templar_assassin_refraction_absorb",[4] = "modifier_item_blade_mail_reflect",[5] = "modifier_nyx_assassin_spiked_carapace" }

function AutoDagon.OnUpdate()
	local hero = Heroes.GetLocal()
	if not hero or not Menu.IsEnabled(AutoDagon.IsToggled) or not AutoDagon.SleepCheck(0.1, "updaterate") or not Entity.IsAlive(hero) or NPC.HasState(hero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return end
	local dagon = NPC.GetItem(hero, "item_dagon", true)
	if not dagon then
		for i = 2, 5 do
			dagon = NPC.GetItem(hero, "item_dagon_" .. i, true)
			if dagon then break end
		end
	end	
	if not dagon or not Ability.IsReady(dagon) or not Ability.IsCastable(dagon, Ability.GetManaCost(dagon))  then return end	
	local target = AutoDagon.FindTarget(hero, dagon)
	if not target then return end
	Ability.CastTarget(dagon, target)	
	AutoDagon.Sleep(0.1, "updaterate");
end

AutoDagon.font = Renderer.LoadFont("Tahoma", 20, Enum.FontWeight.EXTRABOLD)

function AutoDagon.FindTarget(me, item)	
	local entities = Heroes.GetAll()
	for index, ent in pairs(entities) do
		local enemyhero = Heroes.Get(index)
		if not Entity.IsSameTeam(me, enemyhero) and not NPC.IsLinkensProtected(enemyhero) and not NPC.IsIllusion(enemyhero) and NPC.IsEntityInRange(me, enemyhero, Ability.GetCastRange(item) + NPC.GetCastRangeBonus(me)) then
			local amplf = 0
			if NPC.GetItem(me, "item_kaya", true) then
				amplf = 0.1
			end
			amplf = amplf + AutoDagon.GetAmplifiers(me, enemyhero)
			local dagondmg = Ability.GetLevelSpecialValueFor(item, "damage") + Ability.GetLevelSpecialValueFor(item, "damage") *(Hero.GetIntellectTotal(me)/100 * (0.066891 + amplf))
			local totaldmg = NPC.GetMagicalArmorDamageMultiplier(enemyhero) * dagondmg
			local isValid = AutoDagon.CheckForModifiers(enemyhero)
			if Entity.GetHealth(enemyhero) < totaldmg and isValid then return enemyhero end
		end
	end
end

function AutoDagon.GetAmplifiers(hero, enemy)
	local amplfs = 0
	if NPC.HasModifier(hero, "modifier_bloodseeker_bloodrage") then
		amplfs = amplfs + Modifier.GetConstantByIndex(NPC.GetModifier(hero, "modifier_bloodseeker_bloodrage"), 1) / 100
	end
	if NPC.HasModifier(enemy, "modifier_bloodseeker_bloodrage") then
		amplfs = amplfs + Modifier.GetConstantByIndex(NPC.GetModifier(enemy, "modifier_bloodseeker_bloodrage"), 1) / 100
	end
	if NPC.HasModifier(enemy, "modifier_chen_penitence") then
		amplfs = amplfs + Modifier.GetConstantByIndex(NPC.GetModifier(enemy, "modifier_chen_penitence"), 1) / 100
	end
	if NPC.HasModifier(enemy, "modifier_shadow_demon_soul_catcher") then
		amplfs = amplfs + Modifier.GetConstantByIndex(NPC.GetModifier(enemy, "modifier_shadow_demon_soul_catcher"), 0) / 100
	end
	if NPC.HasModifier(enemy, "modifier_item_mask_of_death") then
		amplfs = amplfs + 25 / 100
	end

	if NPC.HasModifier(enemy, "modifier_item_orchid_malevolence") then
		amplfs = amplfs + 30 / 100
	end

	return amplfs
end

function AutoDagon.CheckForModifiers(target)
	for i = 0, 5 do
		if NPC.HasModifier(target, AutoDagon.Modifiers[i]) then
			return false
		end
	end
	return true
end

function AutoDagon.SleepCheck(delay, id)
	if not AutoDagon.sleepers[id] or(os.clock() - AutoDagon.sleepers[id]) > delay then
		return true
	end
	return false
end

function AutoDagon.Sleep(delay, id)
	if not AutoDagon.sleepers[id] or AutoDagon.sleepers[id] < os.clock() + delay then
		AutoDagon.sleepers[id] = os.clock() + delay
	end
end

return AutoDagon
