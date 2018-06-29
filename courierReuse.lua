local courierReuse = {}

courierReuse.OptionEnabled = Menu.AddOptionBool({"Utility", "Courier"}, "Enabled", false)
courierReuse.optionKey = Menu.AddKeyOption({ "Utility", "Courier"}, "Toggle Key to reuse", Enum.ButtonCode.KEY_T)
courierReuse.optionMuteFilter = Menu.AddOptionBool({"Utility", "Courier"}, "Mute Filter", false)
courierReuse.players = {}
courierReuse.muted = {}
local needInit = true
local myHero
local myTeam
local bReuse
local x,y,font
function courierReuse.OnGameStart()
	needInit = true
end
function courierReuse.Init()
	myHero = Heroes.GetLocal()
	bReuse = false
	myTeam = Entity.GetTeamNum(myHero)
	needInit = false
	x,y = Renderer.GetScreenSize()
	x = x * 0.8785
	y = y * 0.879
	font = Renderer.LoadFont("Tahoma", 18, Enum.FontWeight.BOLD)
end
function courierReuse.OnDraw()
	if not Heroes.GetLocal() then return end
	if bReuse then
		Renderer.SetDrawColor(0,255,0)
		Renderer.DrawText(font,x,y,"сReuse")
	end
end
function courierReuse.OnUpdate()
  	if not Engine.IsInGame() or not Heroes.GetLocal() then
    	for i = 0, 10 do
     	 	if courierReuse.players[i] then
        		Menu.RemoveOption(courierReuse.players[i]) courierReuse.players[i] = nil
      		end
    	end
  	end
  	if not Menu.IsEnabled(courierReuse.OptionEnabled) then return end
  	if needInit then
  		courierReuse.Init()
  	end
  	if not myHero then return end
  	if Menu.IsKeyDownOnce(courierReuse.optionKey) then
  		if bReuse then
  			bReuse = false
  		else
  			bReuse = true	
  		end
  	end
  	for i = 1, Players.Count() do
    	local player = Players.Get(i)
    	if Player.IsMuted(player) then
     		courierReuse.muted[Player.GetPlayerID(player)] = Player.GetPlayerID(player)
    	else
      		courierReuse.muted[Player.GetPlayerID(player)] = nil
    	end
  	end
  	for i = 1, Heroes.Count() do
    	local hero = Heroes.Get(i)
    	if courierReuse.muted[Hero.GetPlayerID(hero)] then
      		courierReuse.muted[hero] = true
    	else
      		courierReuse.muted[hero] = false
    	end
    	if Entity.IsSameTeam(myHero, hero) and hero ~= myHero and not courierReuse.players[Hero.GetPlayerID(hero)] then
      		courierReuse.players[Hero.GetPlayerID(hero)] = Menu.AddOptionBool({"Utility", "Courier"}, string.upper(string.sub(NPC.GetUnitName(hero), 15)), false)
    	end
    	if Entity.IsSameTeam(myHero, hero) and hero ~= myHero then
      		if Menu.IsEnabled(courierReuse.players[Hero.GetPlayerID(hero)]) then
        		courierReuse.muted[hero] = true
      		else
        		courierReuse.muted[hero] = false
      		end
    	end
  	end
  	for i = 1, Couriers.Count() do
    	local index_npc = Couriers.Get(i)
    	if index_npc ~= nil then
      		if Entity.IsSameTeam(index_npc, myHero) and Entity.IsAlive(index_npc) then
        		local courierEnt = Courier.GetCourierStateEntity(index_npc)
        		local reuse = NPC.GetAbilityByIndex(index_npc, 4)
        		local reuse_2 = NPC.GetAbilityByIndex(index_npc, 3)
        		local go_home = NPC.GetAbilityByIndex(index_npc, 0)
        		if bReuse and courierEnt ~= myHero then
        			local hasItem = false
        			for i = 0, 8 do
        				if NPC.GetItemByIndex(index_npc,i) and NPC.GetItemByIndex(index_npc,i) ~= 0 and Item.GetPlayerOwnerID(NPC.GetItemByIndex(index_npc,i)) == Hero.GetPlayerID(myHero) then
        					hasItem = true
        					break
        				end
        			end
        			if hasItem then        			
          				Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_NO_TARGET, myHero, Vector(0, 0, 0), reuse, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, index_npc)
          			end
        		end
        		if courierEnt and courierReuse.players[Hero.GetPlayerID(courierEnt)] then
          			if (Menu.IsEnabled(courierReuse.optionMuteFilter) and courierReuse.muted[Hero.GetPlayerID(courierEnt)] and Hero.GetPlayerID(courierEnt) == courierReuse.muted[Hero.GetPlayerID(courierEnt)] ) or Menu.IsEnabled(courierReuse.players[Hero.GetPlayerID(courierEnt)]) then
            			Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_NO_TARGET, myHero, Vector(0, 0, 0), go_home, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, index_npc)
          			end
        		end
      		end
    	end
  	end
end
return courierReuse