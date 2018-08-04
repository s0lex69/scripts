local AllInOne = {}
local myHero, myPlayer, myTeam, myMana, attackRange
local enemy
local comboHero
local q,w,e,r,f
local razeShortPos, razeMidPos, razeLongPos
local remnant_casted = false
local snowball_speed
local nextTick = 0
local needTime = 0
local added = false
local ebladeCasted = {}
--items
local urn, vessel, hex, halberd, mjolnir, bkb, nullifier, solar, courage, force, pike, eul, orchid, bloodthorn, diffusal, armlet, lotus, satanic, blademail, blink, abyssal, eblade, phase, discord, shiva, refresher

AllInOne.optionClinkzEnable = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnable, "panorama/images/items/branches_png.vtex_c")
Menu.AddMenuIcon({"KAIO","Hero Specific", "Clinkz"}, "panorama/images/heroes/icons/npc_dota_hero_clinkz_png.vtex_c")
AllInOne.optionClinkzComboKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Clinkz"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionClinkzEnableBkb = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionClinkzEnableBlood = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionClinkzEnableCourage = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionClinkzEnableDiffusal = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionClinkzEnableHex = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionClinkzEnableNullifier = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Nullifier", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableNullifier, "panorama/images/items/nullifier_png.vtex_c")
AllInOne.optionClinkzEnableOrchid = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionClinkzEnableSolar = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionEmberEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnable, "panorama/images/items/branches_png.vtex_c")
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Ember Spirit"}, "panorama/images/heroes/icons/npc_dota_hero_ember_spirit_png.vtex_c")
AllInOne.optionEmberAutoChain = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit"}, "Auto Cast Chains After Fist")
AllInOne.optionEmberComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Ember Spirit"}, "Combo Key", Enum.ButtonCode.KEY_F)
AllInOne.optionEmberComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Ember Spirit"}, "Combo Radius", 250, 1500, 1500)
AllInOne.optionEmberEnableChains = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Searing Chains", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableChains, "panorama/images/spellicons/ember_spirit_searing_chains_png.vtex_c")
AllInOne.optionEmberEnableFist = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Sleight of Fist", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableFist, "panorama/images/spellicons/ember_spirit_sleight_of_fist_png.vtex_c")
AllInOne.optionEmberEnableFlame = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Flame Guard", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableFlame, "panorama/images/spellicons/ember_spirit_flame_guard_png.vtex_c")
AllInOne.optionEmberEnableRemnant = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Fire Remnant", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableRemnant, "panorama/images/spellicons/ember_spirit_fire_remnant_png.vtex_c")
AllInOne.optionEmberSaveRemnantCount = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Fire Remnant Save Count", 0, 2, 0)
AllInOne.optionEmberEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionEmberEnableBlademail = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Blademail", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableBlademail, "panorama/images/items/blade_mail_png.vtex_c")
AllInOne.optionEmberEnableBloodthorn = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableBloodthorn, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionEmberEnableDiscord = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Veil of Discord", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableDiscord, "panorama/images/items/veil_of_discord_png.vtex_c")
AllInOne.optionEmberEnableOrchid = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionEmberEnableShiva = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Shiva's Guard", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableShiva, "panorama/images/items/shivas_guard_png.vtex_c")
AllInOne.optionEnigmaEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Enigma"}, "panorama/images/heroes/icons/npc_dota_hero_enigma_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionEnigmaEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionEnigmaComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Enigma"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionEnigmaComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Enigma"}, "Combo Radius", 420, 1200, 1200)
AllInOne.optionEnigmaComboPos = Menu.AddOptionCombo({"KAIO", "Hero Specific", "Enigma"}, "Combo Position", {"Auto Find Better Position [BETA]", "Cursor Position"}, 0)
AllInOne.optionEnigmaEnablePulse = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Skills"}, "Midnight Pulse", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnablePulse, "panorama/images/spellicons/enigma_midnight_pulse_png.vtex_c")
AllInOne.optionEnigmaEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionEnigmaEnableBlink = Menu.AddOptionBool({"KAIO", "Hero Specific","Enigma", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionEnigmaEnableRefresher = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Items"}, "Refresher Orb", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableRefresher, "panorama/images/items/refresher_png.vtex_c")
AllInOne.optionEnigmaEnableShiva = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Items"}, "Shiva's Guard", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableShiva, "panorama/images/items/shivas_guard_png.vtex_c")
AllInOne.optionLegionEnable = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionLegionOnlyWithDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander"}, "Combo only when duel ready", false)
Menu.AddOptionIcon(AllInOne.optionLegionOnlyWithDuel, "panorama/images/spellicons/legion_commander_duel_png.vtex_c")
Menu.AddMenuIcon({"KAIO","Hero Specific", "Legion Commander"}, "panorama/images/heroes/icons/npc_dota_hero_legion_commander_png.vtex_c")
AllInOne.optionLegionComboKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Legion Commander"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionLegionEnablePressTheAttack = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Skills"}, "Press The Attack", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnablePressTheAttack, "panorama/images/spellicons/legion_commander_press_the_attack_png.vtex_c")
AllInOne.optionLegionEnableDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Skills"}, "Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableDuel, "panorama/images/spellicons/legion_commander_duel_png.vtex_c")
AllInOne.optionLegionEnableAbyssalWithDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Abbysal Blade In Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableAbyssalWithDuel, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionLegionEnableAbyssalWthDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Abbysal Without Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableAbyssalWthDuel, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionLegionEnableArmlet = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Armlet of Mordiggian", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableArmlet, "panorama/images/items/armlet_png.vtex_c")
AllInOne.optionLegionEnableBkb = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionLegionEnableBlademail = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Blade Mail", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlademail, "panorama/images/items/blade_mail_png.vtex_c")
AllInOne.optionLegionEnableBlink = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionLegionEnableBlood = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionLegionEnableCourage = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionLegionEnableHalberd = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionLegionEnableLotus = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Lotus Orb", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableLotus, "panorama/images/items/lotus_orb_png.vtex_c")
AllInOne.optionLegionEnableMjolnir = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Mjolnir", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableMjolnir, "panorama/images/items/mjollnir_png.vtex_c")
AllInOne.optionLegionEnableOrchid = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionLegionEnableSatanic = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Satanic", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableSatanic, "panorama/images/items/satanic_png.vtex_c")
AllInOne.optionLegionSatanicThreshold = Menu.AddOptionSlider({"KAIO","Hero Specific", "Legion Commander", "Items"}, "HP Percent for satanic use", 1, 100, 15)
AllInOne.optionLegionEnableSolar = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionLegionBlinkRange = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Legion Commander"}, "Minimum Blink Range", 200, 1150, 300)
AllInOne.optionSfEnable = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend"}, "Enable", false)
Menu.AddMenuIcon({"KAIO","Hero Specific", "Shadow Fiend"}, "panorama/images/heroes/icons/npc_dota_hero_nevermore_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionSfEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionSfRazeKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Shadow Fiend"}, "Auto Raze Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionSfDrawRazePos = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend"}, "Draw Raze Position", false)
AllInOne.optionSfComboKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Shadow Fiend"}, "Eul combo key", Enum.ButtonCode.KEY_F)
AllInOne.optionSfEnableBkb = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionSfEnableBlink = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Blink", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionSfEnableBlood = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionSfEnableDagon = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionSfEnableEthereal = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Ethereal blade", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableEthereal, "panorama/images/items/ethereal_blade_png.vtex_c")
AllInOne.optionSfEnableHex = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionSfEnableOrchid = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionSfEnablePhase = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Phase Boots", false)
Menu.AddOptionIcon(AllInOne.optionSfEnablePhase, "panorama/images/items/phase_boots_png.vtex_c")
AllInOne.optionTuskEnable = Menu.AddOptionBool({"KAIO","Hero Specific" ,"Tusk"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Tusk"}, "panorama/images/heroes/icons/npc_dota_hero_tusk_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionTuskEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionTuskEnablePickTeam = Menu.AddOptionBool({"KAIO","Hero Specific", "Tusk"}, "Pick teammates to the snowball", false)
AllInOne.optionTuskComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Tusk"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionTuskEnableShard = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Ice Shards", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableShard, "panorama/images/spellicons/tusk_ice_shards_png.vtex_c")
AllInOne.optionTuskEnableSnowball = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Snowball", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableSnowball, "panorama/images/spellicons/tusk_snowball_png.vtex_c")
AllInOne.optionTuskEnableSigil = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Frozen Sigil", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableSigil, "panorama/images/spellicons/tusk_frozen_sigil_png.vtex_c")
AllInOne.optionTuskEnablePunch = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Walrus Punch", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnablePunch, "panorama/images/spellicons/tusk_walrus_punch_png.vtex_c")
AllInOne.optionTuskEnableAbyssal = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Abyssal Blade", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableAbyssal, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionTuskEnableArmlet = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Armlet of Mordiggian", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableArmlet, "panorama/images/items/armlet_png.vtex_c")
AllInOne.optionTuskEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionTuskEnableBlood = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionTuskEnableCourage = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionTuskEnableHalberd = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionTuskEnableMjolnir = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Mjolnir", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableMjolnir, "panorama/images/items/mjollnir_png.vtex_c")
AllInOne.optionTuskEnableOrchid = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionTuskEnableSolar = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionTuskEnableUrn = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Urn of Shadows", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableUrn, "panorama/images/items/urn_of_shadows_png.vtex_c")
AllInOne.optionTuskEnableVessel = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Spirit Vessel", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableVessel, "panorama/images/items/spirit_vessel_png.vtex_c")
AllInOne.optionTuskComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Tusk"}, "Combo Radius", 200, 1250, 1000)
AllInOne.optionEnablePoopLinken = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Poop Linken"}, "panorama/images/items/sphere_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionEnablePoopLinken, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionEnablePoopAbyssal = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Abyssal Blade", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopAbyssal, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionEnablePoopBlood = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionEnablePoopDagon = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionEnablePoopDiffusal = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionEnablePoopEul = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Eul", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopEul, "panorama/images/items/cyclone_png.vtex_c")
AllInOne.optionEnablePoopForce = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Force Staff", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopForce, "panorama/images/items/force_staff_png.vtex_c")
AllInOne.optionEnablePoopHalberd = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionEnablePoopHex = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionEnablePoopPike = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Hurricane Pike", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopPike, "panorama/images/items/hurricane_pike_png.vtex_c")
AllInOne.optionEnablePoopOrchid = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopOrchid, "panorama/images/items/orchid_png.vtex_c")
function AllInOne.Init( ... )
	myHero = Heroes.GetLocal()
	nextTick = 0
	needTime = 0
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
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_tusk" then
		comboHero = "Tusk"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		e = NPC.GetAbilityByIndex(myHero, 2)
		f = NPC.GetAbility(myHero, "tusk_launch_snowball")
		r = NPC.GetAbility(myHero, "tusk_walrus_punch")
		snowball_speed = 600
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_ember_spirit" then
		comboHero = "Ember"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		e = NPC.GetAbilityByIndex(myHero, 2)
		r = NPC.GetAbility(myHero, "ember_spirit_fire_remnant")
		f = NPC.GetAbility(myHero, "ember_spirit_activate_fire_remnant")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_enigma" then
		comboHero = "Enigma"
		e = NPC.GetAbilityByIndex(myHero, 2)
		r = NPC.GetAbility(myHero, "enigma_black_hole")
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
	discrd = nil
	phase = nil
	dagon = nil
	eblade = nil
	shiva = nil
	refresher = nil
end
function AllInOne.OnUpdate( ... )
	if not myHero then return end
	myMana = NPC.GetMana(myHero)
	added = false
	if comboHero == "Clinkz" and Menu.IsEnabled(AllInOne.optionClinkzEnable) then
		if Menu.IsKeyDown(AllInOne.optionClinkzComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
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
			if enemy and Entity.IsAlive(enemy) then
				AllInOne.SfCombo(eul)
			end
		else
			enemy = nil
		end
		AllInOne.SfAutoRaze()
	elseif comboHero == "Tusk" and Menu.IsEnabled(AllInOne.optionTuskEnable) then
		if Menu.IsKeyDown(AllInOne.optionTuskComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				AllInOne.TuskCombo()
			end
		end
	elseif comboHero == "Ember" and Menu.IsEnabled(AllInOne.optionEmberEnable) then
		if Menu.IsKeyDown(AllInOne.optionEmberComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				AllInOne.EmberCombo()
			end
		elseif Menu.IsEnabled(AllInOne.optionEmberAutoChain) then
			if NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_marker") or NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_caster") or NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_caster_invulnerability") then
				if not enemy then
					if Heroes.InRadius(Entity.GetAbsOrigin(myHero),150, myTeam, Enum.TeamType.TEAM_ENEMY) then
						for i, k in pairs(Heroes.InRadius(Entity.GetAbsOrigin(myHero),150, myTeam, Enum.TeamType.TEAM_ENEMY)) do
							enemy = k
							break
						end
					end
				end
				if enemy and Entity.IsAlive(enemy) then
					if NPC.IsEntityInRange(myHero, enemy, 125) then
						if Ability.IsCastable(q,myMana) then
							Ability.CastNoTarget(q)
						end
					end
				end
			else
				if not Menu.IsKeyDown(AllInOne.optionEmberComboKey) then
					enemy = nil
				end	
			end
		else	
			enemy = nil	
		end
	elseif comboHero == "Enigma" and Menu.IsEnabled(AllInOne.optionEnigmaEnable) then
		if Menu.IsKeyDown(AllInOne.optionEnigmaComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				AllInOne.EnigmaCombo()
			end
		end	
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
			elseif name == "item_veil_of_discord" then
				discord = item
			elseif name == "item_shivas_guard" then
				shiva = item
			elseif name == "item_refresher" then
				refresher = item
			end	
		end
	end
end
function AllInOne.SfCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		enemy = nil
		return
	end
	if r and Ability.IsCastable(r, myMana) then
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
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
		if dagon and Menu.IsEnabled(AllInOne.optionSfEnableDagon) and Ability.IsCastable(dagon, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(dagon, enemy)
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
		if eul and Ability.IsCastable(eul, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not AllInOne.IsLinkensProtected() then
			if Menu.IsEnabled(AllInOne.optionSfEnableEthereal) and ebladeCasted[enemy] and eblade and Ability.SecondsSinceLastUse(eblade) < 3 then
				if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
					Ability.CastTarget(eul, enemy)
					ebladeCasted[enemy] = nil
				end
			else
				Ability.CastTarget(eul, enemy)
				ebladeCasted[enemy] = nil
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
function AllInOne.EmberCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionEmberComboRadius)) then
		enemy = nil
		return
	end
	local enemyPos = Entity.GetAbsOrigin(enemy)
	local remnant_count = Modifier.GetStackCount(NPC.GetModifier(myHero, "modifier_ember_spirit_fire_remnant_charge_counter")) - Menu.GetValue(AllInOne.optionEmberSaveRemnantCount)
	if discord and Menu.IsEnabled(AllInOne.optionEmberEnableDiscord) and Ability.IsCastable(discord, myMana) then
		Ability.CastPosition(discord, AllInOne.castPrediction(1))
	end
	if bkb and Menu.IsEnabled(AllInOne.optionEmberEnableBkb) and Ability.IsCastable(bkb,0) then
		Ability.CastNoTarget(bkb)
		return
	end
	if r and Ability.IsCastable(f,myMana) and Menu.IsEnabled(AllInOne.optionEmberEnableRemnant) and remnant_count > 0 and GameRules.GetGameTime() >= nextTick then
		for i = 1, remnant_count do
			Ability.CastPosition(r, AllInOne.castPrediction(1))
			remnant_casted = true
		end
		needTime = GameRules.GetGameTime() + ((Entity.GetAbsOrigin(myHero):__sub(enemyPos)):Length() - 350)/(AllInOne.GetMoveSpeed(myHero)*2.5)
		nextTick = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if AllInOne.IsLinkensProtected() and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		AllInOne.PoopLinken()
	end
	if f and Ability.IsCastable(f,myMana) and remnant_casted and GameRules.GetGameTime() >= needTime then
		Ability.CastPosition(f, enemyPos)
		remnant_casted = false
		return
	end
	if shiva and Menu.IsEnabled(AllInOne.optionEmberEnableShiva) and Ability.IsCastable(shiva, myMana) then
		Ability.CastNoTarget(shiva)
		return
	end
	if blademail and Menu.IsEnabled(AllInOne.optionEmberEnableBlademail) and Ability.IsCastable(blademail, myMana) then
		Ability.CastNoTarget(blademail)
		return
	end
	if orchid and Menu.IsEnabled(AllInOne.optionEmberEnableOrchid) and Ability.IsCastable(orchid, myMana) then
		Ability.CastTarget(orchid, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(AllInOne.optionEmberEnableBloodthorn) and Ability.IsCastable(bloodthorn, myMana) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if q and Menu.IsEnabled(AllInOne.optionEmberEnableChains) and Ability.IsCastable(q, myMana) and NPC.IsEntityInRange(myHero, enemy, 200) then
		Ability.CastNoTarget(q)
		return
	end
	if w and Menu.IsEnabled(AllInOne.optionEmberEnableFist) and Ability.IsCastable(w, myMana) and GameRules.GetGameTime() > needTime+0.25 then
		Ability.CastPosition(w, enemyPos)
		return
	end
	if e and Menu.IsEnabled(AllInOne.optionEmberEnableFlame) and Ability.IsCastable(e, myMana) then
		Ability.CastNoTarget(e)
		return
	end
	Player.AttackTarget(myPlayer, myHero, enemy)
end
function AllInOne.EnigmaCombo( ... )
	if not enemy then
		return 
	end
	local orderPos
	if Menu.GetValue(AllInOne.optionEnigmaComboPos) == 0 then
		local tempTable = Entity.GetHeroesInRadius(myHero, 1600, Enum.TeamType.TEAM_ENEMY)
		orderPos = AllInOne.FindBestOrderPosition(tempTable)
	else
		orderPos = Input.GetWorldCursorPos()
	end	
	if NPC.IsPositionInRange(myHero, orderPos, Menu.GetValue(AllInOne.optionEnigmaComboRadius)) and not Ability.IsChannelling(r) then
		if bkb and Ability.IsCastable(bkb, 0) and Menu.IsEnabled(AllInOne.optionEnigmaEnableBkb) then
			Ability.CastNoTarget(bkb)
			return
		end
		if blink and Ability.IsCastable(blink, 0) and Menu.IsEnabled(AllInOne.optionEnigmaEnableBlink) then
			if NPC.IsPositionInRange(myHero, orderPos, 1200) then
				Ability.CastPosition(blink, orderPos)
				return
			end
		end
		if Ability.IsCastable(e, myMana - Ability.GetManaCost(r)) and Menu.IsEnabled(AllInOne.optionEnigmaEnablePulse) then
			Ability.CastPosition(e, orderPos)
			return
		end
		if shiva and Menu.IsEnabled(AllInOne.optionEnigmaEnableShiva) and Ability.IsCastable(shiva, myMana - Ability.GetManaCost(r)) then
			Ability.CastNoTarget(shiva)
			return
		end
		if Ability.IsCastable(r, myMana) then
			Ability.CastPosition(r, orderPos)
			return
		end
		if refresher and Ability.IsCastable(refresher, myMana - Ability.GetManaCost(r)) and not Ability.IsChannelling(r) then
			Ability.CastNoTarget(refresher)
			return
		end
	end
end
function AllInOne.FindBestOrderPosition(tempTable)
	if not tempTable then
		return
	end
	local enemyCount = #tempTable
	if enemyCount == 1 then
		return Entity.GetAbsOrigin(tempTable[1])
	end
	local count = 0
	local coord = {}
	for i, k in pairs(tempTable) do
		if NPC.IsEntityInRange(k, tempTable[1], 800) then
			local origin = Entity.GetAbsOrigin(k)
			local originX = origin:GetX()
			local originY = origin:GetY()
			table.insert(coord, {x = originX, y = originY})
			count = count + 1
		end
	end 
	local x = 0
	local y = 0
	for i = 1, count do
		x = x + coord[i].x
		y = y + coord[i].y
	end
	x = x/count
	y = y/count
	return Vector(x,y,0)
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
function AllInOne.GetMoveSpeed(ent)
	local baseSpeed = NPC.GetBaseSpeed(ent)
	local bonusSpeed = NPC.GetMoveSpeed(ent) - baseSpeed
	local modHex
	if NPC.HasModifier(ent, "modifier_sheepstick_debuff") or NPC.HasModifier(ent, "modifier_lion_voodoo") or NPC.HasModifier(ent, "modifier_shadow_shaman_voodoo") then
		return 140 + bonusSpeed
	end
	if NPC.HasModifier(ent, "modifier_invoker_cold_snap_freeze") or NPC.HasModifier(ent, "modifier_invoker_cold_snap") then
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
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		enemy = nil
		return
	end
	if Menu.IsEnabled(AllInOne.optionLegionOnlyWithDuel) and not Ability.IsCastable(r, myMana) then
		enemy = nil
		return
	end
	if blink and Ability.IsCastable(blink, 0) and not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionLegionBlinkRange)) and NPC.IsEntityInRange(myHero, enemy, 1199) then
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
	if NPC.IsEntityInRange(myHero, enemy, NPC.GetAttackRange(myHero)*1.5) then
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)then
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
			if not NPC.IsEntityInRange(myHero, enemy, 150) then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(enemy), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
			else	
				Ability.CastTarget(r, enemy)
				return
			end
		end
	else
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			AllInOne.PoopLinken()
		end
		if r and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) then
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(enemy), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		else
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, enemy, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		end
		return
	end
end
function AllInOne.TuskCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionTuskComboRadius)) then
		enemy = nil
		return
	end
	if not added and Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_tusk_3")) > 0 then
		snowball_speed = snowball_speed + 300
	end
	if w and Menu.IsEnabled(AllInOne.optionTuskEnableSnowball) and Ability.IsCastable(w, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(w, enemy)
		local tempTable = Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND)
		if not Menu.IsEnabled(AllInOne.optionTuskEnablePickTeam) then
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
		if Ability.IsCastable(f, 0) and not tempTable then
			Ability.CastNoTarget(f)
		end
		return
	end
	if q and Menu.IsEnabled(AllInOne.optionTuskEnableShard) and Ability.IsCastable(q, myMana) and not NPC.IsTurning(myHero) then
		if NPC.HasModifier(enemy, "modifier_stunned") and Modifier.GetDieTime(NPC.GetModifier(enemy,"modifier_stunned")) > (Entity.GetAbsOrigin(myHero):__sub(Entity.GetAbsOrigin(enemy))):Length()/snowballspeed then
			Ability.CastPosition(q, AllInOne.ShardPrediction(0))
		elseif not NPC.IsRunning(enemy) then
			Ability.CastPosition(q, AllInOne.ShardPrediction(0))
		else
			Ability.CastPosition(q, AllInOne.ShardPrediction())
		end
		return
	end
	if Menu.IsEnabled(AllInOne.optionTuskEnableSigil) and Ability.IsCastable(e, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		if NPC.IsEntityInRange(myHero, enemy, 450) then
			Ability.CastNoTarget(e)
		end
		return
	end
	if urn and Menu.IsEnabled(AllInOne.optionTuskEnableUrn) and Item.GetCurrentCharges(urn) > 0 and Ability.IsCastable(urn,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(urn, enemy)
		return
	end
	if vessel and Menu.IsEnabled(AllInOne.optionTuskEnableVessel) and Item.GetCurrentCharges(vessel) > 0 and Ability.IsCastable(vessel,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(vessel, enemy)
		return
	end
	if solar and Menu.IsEnabled(AllInOne.optionTuskEnableSolar) and Ability.IsCastable(solar,0) then
		Ability.CastTarget(solar, enemy)
		return
	end
	if courage and Menu.IsEnabled(AllInOne.optionTuskEnableCourage) and Ability.IsCastable(courage,0) then
		Ability.CastTarget(courage, enemy)
		return
	end
	if orchid and Menu.IsEnabled(AllInOne.optionTuskEnableOrchid) and Ability.IsCastable(orchid,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(orchid, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(AllInOne.optionTuskEnableBloodthorn) and Ability.IsCastable(bloodthorn,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if mjolnir and Menu.IsEnabled(AllInOne.optionTuskEnableMjolnir) and Ability.IsCastable(mjolnir,0) then
		Ability.CastTarget(mjolnir, myHero)
		return
	end
	if abyssal and Menu.IsEnabled(AllInOne.optionTuskEnableAbyssal) and Ability.IsCastable(abyssal,0) then
		Ability.CastTarget(abyssal, enemy)
		return
	end
	if halberd and Menu.IsEnabled(AllInOne.optionTuskEnableHalberd) and Ability.IsCastable(halberd,0) and NPC.IsAttacking(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(halberd, enemy)
		return
	end
	if bkb and Menu.IsEnabled(AllInOne.optionTuskEnableBkb) and Ability.IsCastable(bkb,0) then
		Ability.CastNoTarget(bkb)
		return
	end
	if armlet and Menu.IsEnabled(AllInOne.optionTuskEnableArmlet) and not Ability.GetToggleState(armlet) and Ability.IsCastable(armlet,0) and GameRules.GetGameTime() >= nextTick then
		Ability.Toggle(armlet)
		nextTick = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if Menu.IsEnabled(AllInOne.optionTuskEnablePunch) and Ability.GetLevel(r) > 0 and Ability.IsCastable(r, myMana) and NPC.IsEntityInRange(myHero, enemy, 350) and not NPC.HasModifier(myHero, "modifier_tusk_snowball_movement") then
		Ability.CastTarget(r, enemy)
		return
	end	
	if not NPC.IsAttacking(myHero) and Menu.IsEnabled(AllInOne.optionTuskEnablePunch) and not Ability.IsCastable(r, myMana) then
		Player.AttackTarget(myPlayer, myHero, enemy, false)
	elseif not NPC.IsAttacking(myHero) and not Menu.IsEnabled(AllInOne.optionTuskEnablePunch) then
		Player.AttackTarget(myPlayer, myHero, enemy, false)	
	end
end
function AllInOne.ShardPrediction(speed)
	if not enemy then return end
	local pos = Entity.GetAbsOrigin(enemy)
	local dir = Entity.GetRotation(myHero):GetForward():Normalized()
	if not speed then
		speed = AllInOne.GetMoveSpeed(enemy)
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
function AllInOne.ClinkzCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or NPC.HasModifier(enemy, "modifier_dark_willow_shadow_realm_buff") then
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
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
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
function AllInOne.IsLinkensProtected()
	if NPC.IsLinkensProtected(enemy) then
		return true
	end
	return false
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