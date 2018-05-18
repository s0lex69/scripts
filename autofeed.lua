local autofeed = {}
autofeed.optionEnable = Menu.AddOptionBool({"Awareness", "Auto Feed"}, "Enable", false)
function autofeed.OnUpdate()
	if not Menu.IsEnabled(autofeed.optionEnable) or not Heroes.GetLocal() or not Engine.IsInGame() then return end
	local myHero = Heroes.GetLocal()
	local radiant = Vector(-7317.406250, -6815.406250, 512.000000)
	local dire = Vector(7264.000000, 6560.000000, 512.000000)
	local myTeam = Entity.GetTeamNum(myHero)
	if Entity.IsAlive(myHero) then
		if myTeam == 2 then 
			Player.PrepareUnitOrders(Players.GetLocal(),Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION,nil,dire,nil,Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,myHero)
		else
			Player.PrepareUnitOrders(Players.GetLocal(),Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION,nil,radiant,nil,Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY,myHero)
		end	
	end
end
return autofeed