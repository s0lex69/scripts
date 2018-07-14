local clinkz = {}
clinkz.optionEnable = Menu.AddOptionBool({"Hero Specific", "Clinkz"}, "Enable", false)
clinkz.optionKey = Menu.AddKeyOption({"Hero Specific", "Clinkz"}, "Combo Key", Enum.ButtonCode.KEY_Z)
clinkz.optionEnableLockTarget = Menu.AddOptionBool({"Hero Specific", "Clinkz"}, "Target Locker", false)
clinkz.optionEnableBlood = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Bloodthorn", false)
clinkz.optionEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Orchid", false)
clinkz.optionEnableNullifier = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Nullifier", false)
clinkz.optionEnableDiffusal = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Diffusal Blade", false)
clinkz.optionEnableHex = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Hex", false)
clinkz.optionEnableBkb = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Bkb", false)
clinkz.optionEnableSolar = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Solar Crest", false)
clinkz.optionEnableCourage = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Medallion of Courage", false)
clinkz.optionEnablePoopLinkens = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Enable", false)
clinkz.optionEnablePoopForce = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Force Staff", false)
clinkz.optionEnablePoopDiffusal = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Diffusal Blade", false)
clinkz.optionEnablePoopBlood = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Bloodthorn", false)
clinkz.optionEnablePoopOrchid = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Orchid", false)
clinkz.optionEnablePoopEul = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Eul", false)
clinkz.optionEnablePoopHex = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Hex", false)
clinkz.optionEnablePoopPike = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Hurricane Pike", false)
local LockTarget = false
local enemy = nil
local myHero
function clinkz.Init()
    myHero = Heroes.GetLocal()
end
function clinkz.OnGameStart()
  clnikz.Init()
end
function clinkz.OnUpdate()
  if not myHero or not Menu.IsEnabled(clinkz.optionEnable) or not Engine.IsInGame() then return end
  if NPC.GetUnitName(myHero) ~= "npc_dota_hero_clinkz" then return end
  if LockTarget == false then
    enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
  end
  clinkz.Combo(enemy)
end
function clinkz.Combo(enemy)
  local myMana = NPC.GetMana(myHero)
  local strafe = NPC.GetAbilityByIndex(myHero, 0)
  local arrows = NPC.GetAbilityByIndex(myHero, 1)
  local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local solar = NPC.GetItem(myHero, "item_solar_crest", true)
  local courage = NPC.GetItem(myHero, "item_medallion_of_courage", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local nullifier = NPC.GetItem(myHero, "item_nullifier", true)
  local diffusal = NPC.GetItem(myHero, "item_diffusal_blade", true)
  if enemy then
    if Menu.IsEnabled(clinkz.optionEnableLockTarget) then LockTarget = true end
    if Menu.IsKeyDown(clinkz.optionKey) and Entity.GetHealth(enemy) > 0 and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasModifier(enemy, "modifier_dark_willow_shadow_realm_buff") then
      local attackRange = NPC.GetAttackRange(myHero)
      if NPC.IsEntityInRange(myHero, enemy, attackRange) then
        if clinkz.heroCanCastSpells(enemy) == true then
          if strafe and Ability.IsCastable(strafe, myMana) then
            Ability.CastNoTarget(strafe)
          end
          if Ability.GetAutoCastState(arrows) == false and AutoCasted == false then
            Ability.ToggleMod(arrows)
            AutoCasted = true
          end
        end
        if clinkz.heroCanCastItems() == true then
          if NPC.IsLinkensProtected(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            clinkz.PoopLinken(myHero, enemy)
          end
          if diffusal and not NPC.HasModifier(enemy, "modifier_item_diffusal_blade_slow") and Menu.IsEnabled(clinkz.optionEnableDiffusal) and Ability.IsCastable(diffusal,myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(diffusal, enemy)
          end 
          if blood and not NPC.HasModifier(enemy, "modifier_bloodthorn_debuff") and Menu.IsEnabled(clinkz.optionEnableBlood) and Ability.IsCastable(blood, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(blood, enemy)
          end
          if orchid and not NPC.HasModifier(enemy, "modifier_orchid_malevolence_debuff") and Menu.IsEnabled(clinkz.optionEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(orchid, enemy)
          end
          if bkb and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and Menu.IsEnabled(clinkz.optionEnableBkb) and Ability.IsCastable(bkb, myMana) then
            Ability.CastNoTarget(bkb)
          end
          if hex and not NPC.HasModifier(enemy, "modifier_sheepstick_debuff") and Menu.IsEnabled(clinkz.optionEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(hex, enemy)
          end
          if nullifier and not NPC.HasModifier(enemy, "modifier_item_nullifier_mute") and Menu.IsEnabled(clinkz.optionEnableNullifier) and Ability.IsCastable(nullifier, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            if NPC.GetItem(enemy, "item_aeon_disk", true) then
              if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") and not Ability.IsReady(NPC.GetItem(enemy, "item_aeon_disk", true)) then
                 Ability.CastTarget(nullifier,enemy)
              end
            else
              Ability.CastTarget(nullifier,enemy) 
            end 
          end
          if courage and not NPC.HasModifier(enemy, "modifier_item_medallion_of_courage_armor_reduction") and Menu.IsEnabled(clinkz.optionEnableCourage) and Ability.IsCastable(courage, myMana) then
            Ability.CastTarget(courage, enemy)
          end
          if solar and not NPC.HasModifier(enemy, "modifier_item_solar_crest_armor_reduction") and Menu.IsEnabled(clinkz.optionEnableSolar) and Ability.IsCastable(solar, myMana) then
            Ability.CastTarget(solar, enemy)
          end
        end
        Player.AttackTarget(Players.GetLocal(), myHero, enemy)
      end
    else
      LockTarget = false
      AutoCasted = false
    end
  end
end
function clinkz.PoopLinken(enemy)
  local diffusal = NPC.GetItem(myHero, "item_diffusal_blade", true)
  local eul = NPC.GetItem(myHero, "item_cyclone", true)
  local force = NPC.GetItem(myHero, "item_force_staff", true)
  local pike = NPC.GetItem(myHero, "item_hurricane_pike", true)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local myMana = NPC.GetMana(myHero)
  if diffusal and Menu.IsEnabled(clinkz.optionEnablePoopDiffusal) and Ability.IsCastable(diffusal, myMana) then
    Ability.CastTarget(diffusal,enemy)
    return
  end 
  if eul and Menu.IsEnabled(clinkz.optionEnablePoopEul) and Ability.IsCastable(eul, myMana) then
    Ability.CastTarget(eul, enemy)
    return
  end
  if force and NPC.IsEntityInRange(myHero, enemy, 750) and Menu.IsEnabled(clinkz.optionEnablePoopForce) and Ability.IsCastable(force, myMana) then
    Ability.CastTarget(force, enemy)
    return
  end
  if pike and NPC.IsEntityInRange(myHero, enemy, 400) and Menu.IsEnabled(clinkz.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
    Ability.CastTarget(pike, enemy)
    return
  end
  if orchid and Menu.IsEnabled(clinkz.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
    Ability.CastTarget(orchid, enemy)
    return
  end
  if blood and Menu.IsEnabled(clinkz.optionEnablePoopBlood) and Ability.IsCastable(blood, myMana) then
    Ability.CastTarget(blood, enemy)
    return
  end
  if hex and Menu.IsEnabled(clinkz.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
    Ability.CastTarget(hex, enemy)
    return
  end
end
function clinkz.heroCanCastSpells(enemy)

  if not myHero then return false end
  if not Entity.IsAlive(myHero) then return false end

  if NPC.IsSilenced(myHero) then return false end
  if NPC.IsStunned(myHero) then return false end
  if NPC.HasModifier(myHero, "modifier_bashed") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end
  if NPC.HasModifier(myHero, "modifier_eul_cyclone") then return false end
  if NPC.HasModifier(myHero, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_demon_disruption") then return false end
  if NPC.HasModifier(myHero, "modifier_invoker_tornado") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) then return false end
  if NPC.HasModifier(myHero, "modifier_legion_commander_duel") then return false end
  if NPC.HasModifier(myHero, "modifier_axe_berserkers_call") then return false end
  if NPC.HasModifier(myHero, "modifier_winter_wyvern_winters_curse") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_fiends_grip") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_nightmare") then return false end
  if NPC.HasModifier(myHero, "modifier_faceless_void_chronosphere_freeze") then return false end
  if NPC.HasModifier(myHero, "modifier_enigma_black_hole_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_magnataur_reverse_polarity") then return false end
  if NPC.HasModifier(myHero, "modifier_pudge_dismember") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_shaman_shackles") then return false end
  if NPC.HasModifier(myHero, "modifier_techies_stasis_trap_stunned") then return false end
  if NPC.HasModifier(myHero, "modifier_storm_spirit_electric_vortex_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_tidehunter_ravage") then return false end
  if NPC.HasModifier(myHero, "modifier_windrunner_shackle_shot") then return false end
  if NPC.HasModifier(myHero, "modifier_item_nullifier_mute") then return false end

  if enemy then
    if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") then return false end
  end

  return true
end
function clinkz.heroCanCastItems()

  if not myHero then return false end
  if not Entity.IsAlive(myHero) then return false end

  if NPC.IsStunned(myHero) then return false end
  if NPC.HasModifier(myHero, "modifier_bashed") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end
  if NPC.HasModifier(myHero, "modifier_eul_cyclone") then return false end
  if NPC.HasModifier(myHero, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_demon_disruption") then return false end
  if NPC.HasModifier(myHero, "modifier_invoker_tornado") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) then return false end
  if NPC.HasModifier(myHero, "modifier_legion_commander_duel") then return false end
  if NPC.HasModifier(myHero, "modifier_axe_berserkers_call") then return false end
  if NPC.HasModifier(myHero, "modifier_winter_wyvern_winters_curse") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_fiends_grip") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_nightmare") then return false end
  if NPC.HasModifier(myHero, "modifier_faceless_void_chronosphere_freeze") then return false end
  if NPC.HasModifier(myHero, "modifier_enigma_black_hole_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_magnataur_reverse_polarity") then return false end
  if NPC.HasModifier(myHero, "modifier_pudge_dismember") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_shaman_shackles") then return false end
  if NPC.HasModifier(myHero, "modifier_techies_stasis_trap_stunned") then return false end
  if NPC.HasModifier(myHero, "modifier_storm_spirit_electric_vortex_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_tidehunter_ravage") then return false end
  if NPC.HasModifier(myHero, "modifier_windrunner_shackle_shot") then return false end
  if NPC.HasModifier(myHero, "modifier_item_nullifier_mute") then return false end

  return true
end
clinkz.Init()
return clinkz