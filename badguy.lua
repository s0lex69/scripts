local badguy = {}
badguy.optionEnable = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Enable", false)
badguy.optionEnableAutoFeed = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Auto-Feed", false)
badguy.optionEnableAutoLaugh = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Auto Laugh", false)
badguy.optionSliderAutoLaugh = Menu.AddOptionSlider({"Utility", "Bad Guy"}, "Laugh delay", 15,100,15)
badguy.optionToxicFlame = Menu.AddOptionBool({"Utility", "Bad Guy"}, "Toxic Flame", false)
badguy.optionLanguage = Menu.AddOptionCombo({"Utility","Bad Guy"}, "Language", {"Русский", "English"}, 0)
badguy.phrase = {
	"vk.com/cheats_dota",
	"uc.zone",
	"Что-то ты слишком изи",
	"Как два пальца",
	"Слишком легко для меня"
}
badguy.engphrase = {
	"vk.com/cheats_dota",
	"uc.zone",
	"fuck you cunt",
	"yeah you are bad.",
	"how's hell looks like?"
}
lastlaugh = nil
laughed = false
aliveHeroes = {}
function badguy.OnGameStart()
	aliveHeroes = {}
	lastlaugh = nil
	laughed = false
end
function badguy.OnGameEnd()
	aliveHeroes = {}
	lastlaugh = nil
	laughed = false
end
function badguy.OnUpdate()
	if not Heroes.GetLocal() or not Menu.IsEnabled(badguy.optionEnable) then lastlaugh = nil aliveHeroes = {} return end
	if Menu.IsEnabled(badguy.optionEnableAutoFeed) then
		badguy.autofeed()
	end
	if Menu.IsEnabled(badguy.optionEnableAutoLaugh) then
		badguy.autolaugh()
	end
	if Menu.IsEnabled(badguy.optionToxicFlame) then
		badguy.toxicFlame()
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
	if math.floor(lastlaugh) == math.floor(GameRules.GetGameTime()) and laughed == false then
		Engine.ExecuteCommand("say /laugh")
		lastlaugh = lastlaugh + Menu.GetValue(badguy.optionSliderAutoLaugh)
		laughed = true
	else
		laughed = false	
	end	
end
function badguy.toxicFlame()
	local myHero = Heroes.GetLocal()
	for i = 1, Heroes.Count() do
		local hero = Heroes.Get(i)
		if Entity.IsAlive(hero) and not aliveHeroes[Hero.GetPlayerID(hero)] then
			aliveHeroes[Hero.GetPlayerID(hero)] = hero
		end	
	end
	if #aliveHeroes > 0 then
		for i, hero in pairs(aliveHeroes) do
			if not Entity.IsAlive(hero) and aliveHeroes[Hero.GetPlayerID(hero)] and not Entity.IsSameTeam(myHero, hero) then
				for i = 1, Players.Count() do
					local player = Players.Get(i)
					if Player.GetPlayerID(player) == Hero.GetPlayerID(hero) and not Entity.IsSameTeam(myHero, hero) then
						local language = Menu.GetValue(badguy.optionLanguage)
						if language == 0 then
							Engine.ExecuteCommand("say "..Player.GetName(player).." "..badguy.phrase[math.random(#badguy.phrase)])
						else
							Engine.ExecuteCommand("say "..Player.GetName(player).." "..badguy.engphrase[math.random(#badguy.engphrase)])
						end	
						aliveHeroes[Hero.GetPlayerID(hero)] = nil
					end	
				end
			end	
		end	
	end	
end
return badguy