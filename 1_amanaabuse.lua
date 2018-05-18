local manaabuse = {}
manaabuse.items = {
	item_soul_ring = true,
	item_arcane_boots = true,
	item_magic_wand = true,
	item_magic_stick = true,
	item_guardian_greaves = true
}
manaabuse.dropItems = {
	item_energy_booster = true,
	item_mantle = true,
	item_mystic_staff = true,
	item_point_booster = true,
	item_robe = true,
	item_staff_of_wizardry = true,
	item_ultimate_orb = true,
	item_arcane_boots = true,
	item_aether_lens = true,
	item_ultimate_scepter = true,
	item_aeon_disk = true,
	item_bloodstone = true,
	item_blade_mail = true,
	item_bloodthorn = true,
	item_bracer = true,
	item_buckler = true,
	item_crimson_guard = true,
	item_dagon = true,
	item_dagon_2 = true,
	item_dagon_3 = true,
	item_dagon_4 = true,
	item_dagon_5 = true,
	item_diffusal_blade = true,
	item_ancient_janggo = true,
	item_echo_sabre = true,
	item_ethereal_blade = true,
	item_cyclone = true,
	item_skadi = true,
	item_force_staff = true,
	item_guardian_greaves = true,
	item_headdress = true,
	item_helm_of_the_dominator = true,
	item_hurricane_pike = true,
	item_kaya = true,
	item_sphere = true,
	item_lotus_orb = true,
	item_magic_wand = true,
	item_manta = true,
	item_mekansm = true,
	item_meteor_hammer = true,
	item_null_talisman = true,
	item_oblivion_staff = true,
	item_octarine_core = true,
	item_orchid = true,
	item_ring_of_aquila = true,
	item_rod_of_atos = true,
	item_sheepstick = true,
	item_shivas_guard = true,
	item_silver_edge = true,
	item_soul_booster = true,
	item_veil_of_discord = true,
	item_wraith_band = true,
}
changed = false
manaabuse.droppedItems = {}
manaabuse.optionEnable = Menu.AddOptionBool({"Utility", "Auto Mana Abuse"}, "Enabled", false)
function manaabuse.OnPrepareUnitOrders(orders)
	if not Heroes.GetLocal() or not Engine.IsInGame() or not Menu.IsEnabled(manaabuse.optionEnable) or not orders or orders.order ~= 5 or not orders.ability or not Entity.IsAbility(orders.ability) then return end
	local myHero = Heroes.GetLocal()
	if Entity.IsAlive(myHero) and not NPC.IsStunned(myHero) then
		local name = Ability.GetName(orders.ability)
		if manaabuse.items[name] then
			if manaabuse.dropItems[name] == true then
				changed = true
				manaabuse.dropItems[name] = false	
			end
			for i = 0, 5 do
				local item = NPC.GetItemByIndex(myHero, i)
				if item ~= 0 then
					local itemName = Ability.GetName(item)
					if manaabuse.dropItems[itemName] then
						manaabuse.dropItem(myHero, item)
					end
				end	
			end
			if changed == true then manaabuse.dropItems[name] = true changed = false end
		end
	end	
end
function manaabuse.OnUpdate()
	if not Heroes.GetLocal() or not Engine.IsInGame() or not Menu.IsEnabled(manaabuse.optionEnable) then return end
	if not Entity.IsAlive(Heroes.GetLocal()) or NPC.IsStunned(Heroes.GetLocal()) then return end
	if #manaabuse.droppedItems > 0 then
		for v, item in ipairs(manaabuse.droppedItems) do
			manaabuse.pickItem(Heroes.GetLocal(), item.item, item.vector)
			table.remove(manaabuse.droppedItems)
		end	
	end	
end
function manaabuse.dropItem(myHero, item)
	Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_DROP_ITEM, nil, Entity.GetAbsOrigin(myHero), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
	table.insert(manaabuse.droppedItems, {item = item, itemName = itemName, vector = Entity.GetAbsOrigin(myHero)})

end
function manaabuse.pickItem(myHero, item, pos)
	Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PICKUP_ITEM, nil, pos, item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
end	
return manaabuse