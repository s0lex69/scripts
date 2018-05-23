local badguy = {}
badguy.optionEnable = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Enable", false)
badguy.optionEnableAutoFeed = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Auto-Feed", false)
badguy.optionEnableAutoLaugh = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Auto Laugh", false)
badguy.optionSliderAutoLaugh = Menu.AddOptionSlider({"Utility", "Bad Guy"}, "Laugh delay", 15,100,15)
lastlaugh = nil
function badguy.OnUpdate()
	if not Heroes.GetLocal() or not Menu.IsEnabled(badguy.optionEnable) then lastlaugh = nil return end
	if Menu.IsEnabled(badguy.optionEnableAutoFeed) then
		badguy.autofeed()
	end
	if Menu.IsEnabled(badguy.optionEnableAutoLaugh) then
		badguy.autolaugh()
	end	
end	
function badguy.autofeed()
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
function badguy.autolaugh()
	if not Entity.IsAlive(Heroes.GetLocal()) then return end
	if not lastlaugh then
		lastlaugh = GameRules.GetGameTime()
	end	
	if math.floor(lastlaugh) == math.floor(GameRules.GetGameTime()) then
		Engine.ExecuteCommand("say /laugh")
		lastlaugh = lastlaugh + Menu.GetValue(badguy.optionSliderAutoLaugh)
	end	
end
return badguy