local ShadowFiend = {}
ShadowFiend.optionEnable = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend"}, "Enable", false)
ShadowFiend.optionKey = Menu.AddKeyOption({"Hero Specific", "Shadow Fiend"}, "Auto Raze Key", Enum.ButtonCode.KEY_Z)
ShadowFiend.optionEulKey = Menu.AddKeyOption({"Hero Specific", "Shadow Fiend"}, "Eul combo key", Enum.ButtonCode.KEY_F)
ShadowFiend.optionEnableBlink = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Blink", false)
ShadowFiend.optionEnablePhase = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Phase Boots", false)
ShadowFiend.optionEnableBkb = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "BKB", false)
ShadowFiend.optionEnableEblade = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Ethereal blade", false)
ShadowFiend.optionEnableHex = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Hex", false)
ShadowFiend.optionEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Orchid", false)
ShadowFiend.optionEnableBlood = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Bloodthorn", false)
ShadowFiend.optionEnablePoopLinken = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Enable", false)
ShadowFiend.optionEnablePoopForce = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Force Staff", false)
ShadowFiend.optionEnablePoopHex = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Scythe of Vise", false)
ShadowFiend.optionEnablePoopPike = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Hurricane Pike", false)
ShadowFiend.optionEnablePoopDagon = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Dagon", false)
ShadowFiend.optionEnablePoopOrchid = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Orchid", false)
ShadowFiend.optionEnablePoopBlood = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Bloodthorn", false)
ShadowFiend.font = Renderer.LoadFont("Tahoma", 25, Enum.FontWeight.BOLD)
ShadowFiend.lastTick = 0
ShadowFiend.EbladeCasted = {}
ShadowFiend.cycloneDieTime = nil
local lastAttackTime2 = 0
ShadowFiend.Draw = false
local LockTarget = false
local enemy = nil
local needInit = true
local myHero
function ShadowFiend.Init()
  myHero = Heroes.GetLocal()
  needInit = false
end
function ShadowFiend.OnUpdate()
  if not Menu.IsEnabled(ShadowFiend.optionEnable) or not Engine.IsInGame() or not Heroes.GetLocal() then return end
  if needInit then
    ShadowFiend.Init()
  end
  if LockTarget == false then
    enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
  end
  if NPC.GetUnitName(myHero) ~= "npc_dota_hero_nevermore" then return end
  ShadowFiend.Combo(enemy)
end
function ShadowFiend.Combo(enemy)
  local razeShort = NPC.GetAbilityByIndex(myHero, 0)
  local razeMid = NPC.GetAbilityByIndex(myHero, 1)
  local razeLong = NPC.GetAbilityByIndex(myHero, 2)
  local requiem = NPC.GetAbility(myHero, "nevermore_requiem")
  local myMana = NPC.GetMana(myHero)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local eblade = NPC.GetItem(myHero, "item_ethereal_blade", true)
  local blink = NPC.GetItem(myHero, "item_blink", true)
  local eul = NPC.GetItem(myHero, "item_cyclone", true)
  local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
  local phase = NPC.GetItem(myHero, "item_phase_boots", true)
  if enemy and Entity.IsAlive(enemy) then
    if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then LockTarget = false return end
    if requiem and Ability.IsCastable(requiem, myMana) then
      if Menu.IsKeyDown(ShadowFiend.optionEulKey) and Entity.GetHealth(enemy) > 0 then
        LockTarget = true
        if not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and ShadowFiend.heroCanCastSpells(enemy) == true then
          if NPC.IsLinkensProtected(enemy) then
            ShadowFiend.PoopLinken(enemy, eul, requiem, myMana)
          end
          local possibleRange = 0.80 * NPC.GetMoveSpeed(myHero)
          if not NPC.IsEntityInRange(myHero, enemy, possibleRange) then
            if blink and not NPC.IsEntityInRange(myHero, enemy, possibleRange) and Ability.IsCastable(blink, 0) and Menu.IsEnabled(ShadowFiend.optionEnableBlink) and NPC.IsEntityInRange(myHero, enemy, 1175 + 0.75 * possibleRange) then
              Ability.CastPosition(blink, (Entity.GetAbsOrigin(enemy) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(enemy)):Normalized():Scaled(0.75 * possibleRange)))
              return
            else
              ShadowFiend.GenericMainAttack("Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION", nil, Entity.GetAbsOrigin(enemy))
              return
            end
          end

          if blood and Menu.IsEnabled(ShadowFiend.optionEnableBlood) and Ability.IsCastable(blood, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and Menu.IsEnabled(ShadowFiend.optionEnableBlood) then
            Ability.CastTarget(blood, enemy)
          end
          if orchid and Menu.IsEnabled(ShadowFiend.optionEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and Menu.IsEnabled(ShadowFiend.optionEnableOrchid) then
            Ability.CastTarget(orchid, enemy)
          end
          if eblade and Menu.IsEnabled(ShadowFiend.optionEnableEblade) and Ability.IsCastable(eblade, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and Menu.IsEnabled(ShadowFiend.optionEnableEblade) then
            Ability.CastTarget(eblade, enemy)
            ShadowFiend.EbladeCasted[enemy] = 1
          end
          if hex and Menu.IsEnabled(ShadowFiend.optionEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
            Ability.CastTarget(hex, enemy)
          end
          if phase and Menu.IsEnabled(ShadowFiend.optionEnablePhase) and Ability.IsCastable(phase, myMana) then
            Ability.CastNoTarget(phase)
          end
          if bkb and Ability.IsCastable(bkb, myMana) and Menu.IsEnabled(ShadowFiend.optionEnableBkb) then
            Ability.CastNoTarget(bkb)
          end
          if eul and Ability.IsCastable(eul, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
            if Menu.IsEnabled(ShadowFiend.optionEnableEblade) and ShadowFiend.EbladeCasted[enemy] and eblade then
              if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
                Ability.CastTarget(eul, enemy)
                ShadowFiend.EbladeCasted[enemy] = nil
              end
            else
              Ability.CastTarget(eul, enemy)
            end
          end
          if NPC.HasModifier(enemy, "modifier_eul_cyclone") then
            ShadowFiend.cycloneDieTime = Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_eul_cyclone"))
            if not NPC.IsEntityInRange(myHero, enemy, 65) then
              ShadowFiend.GenericMainAttack("Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION", nil, Entity.GetAbsOrigin(enemy))
              return
            else
              if ShadowFiend.cycloneDieTime - GameRules.GetGameTime() <= 1.67 then
                Ability.CastNoTarget(requiem)
                return
              end
            end
          end
        end
      else LockTarget = false
      end
    end

    if Menu.IsEnabled(ShadowFiend.optionEnable) and Entity.GetHealth(enemy) > 0 and Menu.IsKeyDown(ShadowFiend.optionKey) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
      if razeShort and Ability.IsCastable(razeShort, myMana) then
        local razePos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(200)
        local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
        local predictedPos = ShadowFiend.castPrediction(enemy, razePrediction)
        local disRazePOSpredictedPOS = (razePos - predictedPos):Length2D()
        if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
          Ability.CastNoTarget(razeShort) return
        end
      end
      if razeMid and Ability.IsCastable(razeMid, myMana) then
        local razePos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(450)
        local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
        local predictedPos = ShadowFiend.castPrediction(enemy, razePrediction)
        local disRazePOSpredictedPOS = (razePos - predictedPos):Length2D()
        if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
          Ability.CastNoTarget(razeMid) return
        end
      end
      if razeLong and Ability.IsCastable(razeLong, myMana) then
        local razePos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(700)
        local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
        local predictedPos = ShadowFiend.castPrediction(enemy, razePrediction)
        local disRazePOSpredictedPOS = (razePos - predictedPos):Length2D()
        if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
          Ability.CastNoTarget(razeLong) return
        end
      end
    end
  end
end
function ShadowFiend.PoopLinken(enemy, eul, requiem, myMana)
  if not Menu.IsEnabled(ShadowFiend.optionEnablePoopLinken) then return end
  local Force = NPC.GetItem(myHero, "item_force_staff", true)
  local pike = NPC.GetItem(myHero, "item_hurricane_pike", true)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local dagon = NPC.GetItem(myHero, "item_dagon", true)
  if not dagon then
    for i = 2, 5 do
      dagon = NPC.GetItem(myHero, "item_dagon_" .. i, true)
      if dagon then break end
    end
  end

  if eul and requiem and Ability.IsCastable(requiem, myMana) then
    if Force and Menu.IsEnabled(ShadowFiend.optionEnablePoopForce) and Ability.IsCastable(Force, myMana) then
      Ability.CastTarget(Force, enemy)
      return
    end
    if pike and Menu.IsEnabled(ShadowFiend.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
      Ability.CastTarget(pike, enemy)
      return
    end
    if orchid and Menu.IsEnabled(ShadowFiend.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
      Ability.CastTarget(orchid, enemy)
      return
    end
    if blood and Menu.IsEnabled(ShadowFiend.optionEnablePoopBlood) and Ability.IsCastable(blood, myMana) then
      Ability.CastTarget(blood, enemy)
      return
    end
    if dagon and Menu.IsEnabled(ShadowFiend.optionEnablePoopDagon) and Ability.IsCastable(dagon, myMana) then
      Ability.CastTarget(dagon, enemy)
      return
    end
    if hex and Menu.IsEnabled(ShadowFiend.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
      Ability.CastTarget(hex, enemy)
      return
    end
  end
end
function ShadowFiend.heroCanCastSpells(enemy)

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
function ShadowFiend.GenericMainAttack(attackType, target, position)

  if not myHero then return end
  if not target and not position then return end

  if ShadowFiend.isHeroChannelling() == true then return end
  if ShadowFiend.heroCanCastItems() == false then return end
  if ShadowFiend.IsInAbilityPhase() == true then return end
  ShadowFiend.GenericAttackIssuer(attackType, target, position)

end
function ShadowFiend.heroCanCastItems()

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
function ShadowFiend.IsInAbilityPhase()

  if not myHero then return false end

  local myAbilities = {}

  for i = 0, 10 do
    local ability = NPC.GetAbilityByIndex(myHero, i)
    if ability and Entity.IsAbility(ability) and Ability.GetLevel(ability) > 0 then
      table.insert(myAbilities, ability)
    end
  end

  if #myAbilities < 1 then return false end

  for _, v in ipairs(myAbilities) do
    if v then
      if Ability.IsInAbilityPhase(v) then
        return true
      end
    end
  end

  return false

end
function ShadowFiend.isHeroChannelling()

  if not myHero then return true end

  if NPC.IsChannellingAbility(myHero) then return true end
  if NPC.HasModifier(myHero, "modifier_teleporting") then return true end

  return false

end
function ShadowFiend.GenericAttackIssuer(attackType, target, position)

  if not myHero then return end
  local npc = myHero
  if not target and not position then return end
  if os.clock() - lastAttackTime2 < 0.5 then return end

  if attackType == "Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET" then
    if target ~= nil then
      if target ~= LastTarget then
        Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, target, Vector(0, 0, 0), ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
        LastTarget = target
      end
    end
  end

  if attackType == "Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE" then
    if position ~= nil then
      if not NPC.IsAttacking(npc) or not NPC.IsRunning(npc) then
        if position:__tostring() ~= LastTarget then
          Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE, target, position, ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
          LastTarget = position:__tostring()
        end
      end
    end
  end

  if attackType == "Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION" then
    if position ~= nil then
      if position:__tostring() ~= LastTarget then
        Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, target, position, ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
        LastTarget = position:__tostring()
      end
    end
  end

  if target ~= nil then
    if target == LastTarget then
      if not NPC.IsAttacking(npc) then
        LastTarget = nil
        lastAttackTime2 = os.clock()
        return
      end
    end
  end

  if position ~= nil then
    if position:__tostring() == LastTarget then
      if not NPC.IsRunning(npc) then
        LastTarget = nil
        lastAttackTime2 = os.clock()
        return
      end
    end
  end
end
function ShadowFiend.castPrediction(enemy, adjustmentVariable)

  if not myHero then return end
  if not enemy then return end

  local enemyRotation = Entity.GetRotation(enemy):GetVectors()
  enemyRotation:SetZ(0)
  local enemyOrigin = Entity.GetAbsOrigin(enemy)
  enemyOrigin:SetZ(0)

  if enemyRotation and enemyOrigin then
    if not NPC.IsRunning(enemy) then
      return enemyOrigin
    else return enemyOrigin:__add(enemyRotation:Normalized():Scaled(ShadowFiend.GetMoveSpeed(enemy) * adjustmentVariable))
    end
  end
end
function ShadowFiend.GetMoveSpeed(enemy)

  if not enemy then return end

  local base_speed = NPC.GetBaseSpeed(enemy)
  local bonus_speed = NPC.GetMoveSpeed(enemy) - NPC.GetBaseSpeed(enemy)
  local modifierHex
  local modSheep = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
  local modLionVoodoo = NPC.GetModifier(enemy, "modifier_lion_voodoo")
  local modShamanVoodoo = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")

  if modSheep then
    modifierHex = modSheep
  end
  if modLionVoodoo then
    modifierHex = modLionVoodoo
  end
  if modShamanVoodoo then
    modifierHex = modShamanVoodoo
  end

  if modifierHex then
    if math.max(Modifier.GetDieTime(modifierHex) - GameRules.GetGameTime(), 0) > 0 then
      return 140 + bonus_speed
    end
  end

  if NPC.HasModifier(enemy, "modifier_invoker_ice_wall_slow_debuff") then
    return 100
  end

  if NPC.HasModifier(enemy, "modifier_invoker_cold_snap_freeze") or NPC.HasModifier(enemy, "modifier_invoker_cold_snap") then
    return (base_speed + bonus_speed) * 0.5
  end

  if NPC.HasModifier(enemy, "modifier_spirit_breaker_charge_of_darkness") then
    local chargeAbility = NPC.GetAbility(enemy, "spirit_breaker_charge_of_darkness")
    if chargeAbility then
      local specialAbility = NPC.GetAbility(enemy, "special_bonus_unique_spirit_breaker_2")
      if specialAbility then
        if Ability.GetLevel(specialAbility) < 1 then
          return Ability.GetLevel(chargeAbility) * 50 + 550
        else
          return Ability.GetLevel(chargeAbility) * 50 + 1050
        end
      end
    end
  end

  return base_speed + bonus_speed
end
return ShadowFiend