local AutoStack = {}
AutoStack.optionEnable = Menu.AddOptionBool({"Utility", "Auto Stack"}, "Enable", false)
AutoStack.keyCampController = Menu.AddKeyOption({"Utility", "Auto Stack"}, "Camp Controller Key", Enum.ButtonCode.KEY_LALT)
AutoStack.toggleKey = Menu.AddKeyOption({"Utility", "Auto Stack"}, "Toggle Key", Enum.ButtonCode.KEY_M)
local myHero, myPlayer,myTeam
local x,y
local font = Renderer.LoadFont("Tahoma", 18, Enum.FontWeight.BOLD)
local camp = {}
--radiant bottom jungle
camp[1] = {pos = Vector(-1934.843750, -3813.125000, 256.000000), time = 56.3, ent = nil, campPos = Vector(-1855.000000, -4068.187500, 256.000000), backPos = Vector(-2022.843750, -2999.781250, 256.000000), savePos = Vector(-2656.000000, -4063.968750, 256.000000), isEnabled = Config.ReadInt("AutoStack", 1, 0)}
camp[2] = {pos = Vector(-971.812500, -3220.000000, 256.000000), time = 56.8, ent = nil, campPos = Vector(-388.437500, -3333.531250, 256.000000), backPos = Vector(-887.343750, -4438.375000, 384.000000), savePos = Vector(-928.000000, -2464.000000, 256.000000), isEnabled = Config.ReadInt("AutoStack", 2, 0)}
camp[3] = {pos = Vector(510.562500, -2096.843750, 384.000000), time = 54, ent = nil, campPos = Vector(73.875000, -1933.656250, 384.000000), backPos = Vector(1978.156250, -2337.250000, 256.000000), savePos = Vector(425.281250, -3166.750000, 384.000000), isEnabled = Config.ReadInt("AutoStack", 3, 0)}	
camp[4] = {pos = Vector(640.656250, -4264.312500, 384.000000), time = 55.6, ent = nil, campPos = Vector(419.500000, -4654.437500, 384.000000), backPos = Vector(770.125000, -3423.250000, 384.000000), savePos = Vector(-111.500000, -3815.062500, 384.000000), isEnabled = Config.ReadInt("AutoStack", 4, 0)}
camp[5] = {pos = Vector(3234.687500, -4451.406250, 256.000000), time = 53, ent = nil, campPos = Vector(2893.062500, -4609.437500, 256.000000), backPos = Vector(4189.343750, -5537.843750, 384.000000), savePos = Vector(2741.000000, -5515.000000, 384.000000), isEnabled = Config.ReadInt("AutoStack", 5, 0)}
camp[6] = {pos = Vector(4300.312500, -4042.750000, 256.000000), time = 55, ent = nil, campPos = Vector(4588.437500, -4345.750000, 256.000000), backPos = Vector(5472.000000, -3872.000000, 384.000000), savePos = Vector(4448.000000, -3232.000000, 256.000000), isEnabled = Config.ReadInt("AutoStack", 6, 0)}
--radiant top jungle
camp[7] = {pos = Vector(-4009.156250, 685.562500, 256.000000), time = 53, ent = nil, campPos = Vector(-3709.406250, 911.593750, 256.000000), backPos = Vector(-5201.281250, 1352.153320, 384.000000), savePos = Vector(-3869.125000, 81.687500, 256.000000), isEnabled = Config.ReadInt("AutoStack", 7, 0)}
camp[8] = {pos = Vector(-4689.843750, -221.750000, 256.000000), time = 56, ent = nil, campPos = Vector(-4839.125000, -462.406250, 256.000000), backPos = Vector(-3872.000000, -1376.000000, 384.000000), savePos = Vector(-3869.125000, 81.687500, 256.000000), isEnabled = Config.ReadInt("AutoStack", 8, 0)}
camp[9] = {pos = Vector(-2711.750000, -116.406250, 384.000000), time = 52.3, ent = nil, campPos = Vector(-3058.406250, -225.000000, 384.000000), backPos = Vector(-3872.000000, -1376.000000, 384.000000), savePos = Vector(-3360.000000, -736.000000, 384.000000), isEnabled = Config.ReadInt("AutoStack", 9, 0)}
--dire top jungle
camp[10] = {pos = Vector(-4177.312500, 3897.031250, 256.000000), time = 54, ent = nil, campPos = Vector(-4341.531250, 3492.718750, 256.000000), backPos = Vector(-5456.437500, 4362.343750, 384.000000), savePos = Vector(-3883.718750, 4594.125000, 256.000000), isEnabled = Config.ReadInt("AutoStack", 10, 0)}
camp[11] = {pos = Vector(-3108.406250, 4580.031250, 256.000000), time = 53, ent = nil, campPos = Vector(-2710.468750, 4583.906250, 256.000000), backPos = Vector(-3488.000000, 3104.000000, 128.000000), savePos = Vector(-3883.718750, 4594.125000, 256.000000), isEnabled = Config.ReadInt("AutoStack", 11, 0)}
camp[12] = {pos = Vector(-1538.343750, 4221.968750, 256.000000), time = 56.3, ent = nil, campPos = Vector(-2025.250000, 4247.875000, 256.000000), backPos = Vector(-1568.000000, 3296.000000, 256.000000), savePos = Vector(-1416.406250, 3107.250000, 256.000000), isEnabled = Config.ReadInt("AutoStack", 12, 0)}
camp[13] = {pos = Vector(-534.812500, 3515.781250, 256.000000), time = 55, ent = nil, campPos = Vector(-242.906250, 3427.593750, 256.000000), backPos = Vector(-1568.000000, 3296.000000, 256.000000), savePos = Vector(-1416.406250, 3107.250000, 256.000000), isEnabled = Config.ReadInt("AutoStack", 13, 0)}
camp[14] = {pos = Vector(1061.000000, 3475.781250, 384.000000), time = 54, ent = nil, campPos = Vector(1315.937500, 3290.812500, 384.000000), backPos = Vector(2207.187500, 4487.031250, 256.000000), savePos = Vector(608.000000, 2592.000000, 384.000000), isEnabled = Config.ReadInt("AutoStack", 14, 0)}
camp[15] = {pos = Vector(-565.625000, 2526.375000, 384.000000), time = 52, ent = nil, campPos = Vector(-817.656250, 2312.687500, 384.000000), backPos = Vector(1284.156250, 2201.437500, 256.281250), savePos = Vector(608.000000, 2592.000000, 384.000000), isEnabled = Config.ReadInt("AutoStack", 15, 0)}
--dire bottom jungle
camp[16] = {pos = Vector(3072.375000, 145.187500, 384.000000), time = 54, ent = nil, campPos = Vector(2506.156250, 109.812500, 384.000000), backPos = Vector(2227.687500, -810.968750, 256.000000), savePos = Vector(2777.718750, 493.406250, 384.000000), isEnabled = Config.ReadInt("AutoStack", 16, 0)}
camp[17] = {pos = Vector(4065.218750, 674.562500, 384.000000), time = 55, ent = nil, campPos = Vector(4447.812500, 804.750000, 384.000000), backPos = Vector(3322.437500, 1549.656250, 256.000000), savePos = Vector(4306.625000, 324.218750, 384.000000), isEnabled = Config.ReadInt("AutoStack", 17, 0)}
camp[18] = {pos = Vector(3448.656250, -645.093750, 256.000000), time = 53, ent = nil, campPos = Vector(3914.281250, -579.343750, 256.000000), backPos = Vector(2202.406250, -734.406250, 256.000000), savePos = Vector(4306.625000, 324.218750, 384.000000), isEnabled = Config.ReadInt("AutoStack", 18, 0)}
local moving = {}
local pulling = {}
local aggring = {}
local saving = {}
local needClear = false
local checkTick = nil
local toggled = Config.ReadString("AutoStack", "enable", "false")
function AutoStack.Init()
	myHero = Heroes.GetLocal()
	if not myHero then return end
	myPlayer = Players.GetLocal()
	myTeam = Entity.GetTeamNum(myHero)
	saving = {}
	x, y = Renderer.GetScreenSize()
	x = x * 0.59
	y = y * 0.8426
	y = y - 40
	for i = 1, #camp do
		camp[i].ent = nil
	end
	AutoStack.CheckNPC()
end
function AutoStack.OnGameStart()
	if not Menu.IsEnabled(AutoStack.optionEnable) then return end
	AutoStack.Init()
end
function AutoStack.OnModifierCreate(ent,mod)
	if not Menu.IsEnabled(AutoStack.optionEnable) or not myHero then return end
	if Entity.IsNPC(ent) and (Modifier.GetName(mod) == "modifier_illusion" or Modifier.GetName(mod) == "modifier_dominated") then
		if Modifier.GetName(mod) == "modifier_illusion" then
			if Modifier.GetDieTime(mod) - GameRules.GetGameTime() <= 10 then return end
		end
		if Entity.GetOwner(ent) == myPlayer or Entity.GetOwner(ent) == myHero then
			AutoStack.FindNearestCamp(ent)
		end
	end
end
function AutoStack.CheckNPC()
	local table = NPCs.GetAll()
	for i = 1, #table do
		if Entity.GetOwner(table[i]) == myHero or Entity.GetOwner(table[i]) == myPlayer then
			if NPC.HasModifier(table[i], "modifier_illusion") or NPC.HasModifier(table[i], "modifier_dominated") and Entity.IsAlive(table[i]) then
				AutoStack.FindNearestCamp(table[i])
			end
		end
	end
end
function AutoStack.FindNearestCamp(ent)
	local nearestCamp
	local campLength
	for i, k in pairs(camp) do
		if not k.ent and k.isEnabled == 1 then
			local tempVec = k.pos:__sub(Entity.GetAbsOrigin(ent))
			local heroesOnCamp = Heroes.InRadius(k.pos,500, myTeam, Enum.TeamType.TEAM_BOTH)
			if not campLength then
				if not heroesOnCamp then
					campLength = tempVec:Length()
					nearestCamp = k
				end
			end
			if campLength then
				if (tempVec:Length() < campLength) then
					if not heroesOnCamp then
						campLength = tempVec:Length()
						nearestCamp = k
					end
				end
			end
		end
	end
	if nearestCamp then
		nearestCamp.ent = ent
		moving[ent] = nearestCamp.pos
	end
	--Log.Write("1")
	--Log.Write(tostring(nearestCamp.index))
	--return nearestCamp
end
function AutoStack.OnModifierDestroy(ent, mod)
	if not Menu.IsEnabled(AutoStack.optionEnable) then return end
	if Modifier.GetName(mod) == "modifier_illusion" or Modifier.GetName(mod) == "modifier_dominated"  then
		if moving[ent] or aggring[ent] then
			moving[ent] = nil
			aggring[ent] = nil
		end
		for i = 1, #camp do
			if camp[i].ent == ent then
				--Log.Write("1")
				camp[i].ent = nil
				checkTick = GameRules.GetGameTime() + 0.2
			end
		end
	end
end
function Player.AttackMove(vec, npc)
	local unit
	local table = NPCs.InRadius(vec,350,4, Enum.TeamType.TEAM_BOTH)
	if table then
		for i, k in pairs(table) do
			if Entity.GetClassName(k) == "C_DOTA_BaseNPC_Creep_Neutral" and not NPC.IsWaitingToSpawn(k) and Entity.IsAlive(k) and not unit then
				unit = k
				--Log.Write(NPC.GetUnitName(unit))
			end
		end
	end
	if unit then
		Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, unit, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc, false, false)
	end
end
function Player.MovePos(vec, npc)
	Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, vec, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc, false, false)
end
function AutoStack.OnDraw( ... )
	if not Menu.IsEnabled(AutoStack.optionEnable) or not myHero then return end
	if Menu.IsKeyDownOnce(AutoStack.toggleKey) then
		if toggled == "true" then
			toggled = "false"
			Config.WriteString("AutoStack", "enable", "false")
		else
			toggled = "true"
			Config.WriteString("AutoStack", "enable", "true")
		end
	end
	if toggled == "true" then
		Renderer.SetDrawColor(90, 255, 100)
		Renderer.DrawText(font, x, y, "[Auto-Stacker: ON]")
	else
		Renderer.SetDrawColor(255, 90, 100)
		Renderer.DrawText(font, x, y, "[Auto-Stacker: OFF]")
	end	
	if Menu.IsKeyDown(AutoStack.keyCampController) then
		for i = 1, #camp do
			local x,y,vis = Renderer.WorldToScreen(camp[i].campPos)
			if vis then
				if camp[i].isEnabled == 1 then
					Renderer.SetDrawColor(0,255,0)
					Renderer.DrawFilledRect(x,y,25,25)
				else
					Renderer.SetDrawColor(255,0,0)
					Renderer.DrawFilledRect(x,y,25,25)
				end
				if Input.IsCursorInRect(x,y,25,25) and Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_LEFT) then
					if camp[i].isEnabled == 1 then
						camp[i].isEnabled = 0
						Config.WriteInt("AutoStack", i, 0)
						AutoStack.Init()
					else	
						camp[i].isEnabled = 1
						Config.WriteInt("AutoStack", i, 1)
						AutoStack.Init()
					end
				end
			end
		end
	end
end
function AutoStack.OnUpdate()
	if not Menu.IsEnabled(AutoStack.optionEnable) or not myHero or toggled == "false" then return end
	if GameRules.GetGameStartTime() < 1 then return end
	local time = GameRules.GetGameTime() - GameRules.GetGameStartTime()
	if time < 60 then return end
	if checkTick then
		if GameRules.GetGameTime() >= checkTick then
			AutoStack.CheckNPC()
		end
		checkTick = nil
	end
	time = time%60
	for i = 1, #camp do
		local k = camp[i]
		if k.ent and Entity.IsNPC(k.ent) and Entity.IsAlive(k.ent) then
			local creepsOnCamp = NPCs.InRadius(k.campPos,250,4, Enum.TeamType.TEAM_BOTH)
			local length = (k.pos:__sub(k.campPos):Length() - NPC.GetAttackRange(k.ent) + 25)/NPC.GetMoveSpeed(k.ent)
 			if (NPC.IsRanged(k.ent) and NPC.IsPositionInRange(k.ent, k.campPos, NPC.GetAttackRange(k.ent))) or length < 0 then
				length = 0
			end
			local creepsCount = 0
			if creepsOnCamp then
				for Z, X in pairs(creepsOnCamp) do
					if Entity.GetClassName(X) == "C_DOTA_BaseNPC_Creep_Neutral" then
						creepsCount = creepsCount + 1
					end
				end
			end
			if math.floor(creepsCount/4) > 0 then
				creepsCount = math.floor(creepsCount/4) * 0.5
			else
				creepsCount = 0
			end
			if time >= k.time - 1/NPC.GetAttacksPerSecond(k.ent) - creepsCount - length and time <= k.time + 15 then
				if not NPC.IsAttacking(k.ent) and not aggring[k.ent] then
					--Log.Write(i)
					Player.AttackMove(k.campPos, k.ent)
					aggring[k.ent] = true
				end
				if time >= k.time - creepsCount and not pulling[k.ent] then
					--Log.Write(k.index)
					Player.MovePos(k.backPos, k.ent)
					pulling[k.ent] = true
				end
			end
		end
	end
	if not needClear and time <= 5.1 then
		needClear = true
	end
	if needClear and time > 5.1 then
		pulling = {}
		aggring = {}
		needClear = false
	end
	for i = 1, #camp do
		if camp[i].ent and Entity.IsEntity(camp[i].ent) and Entity.IsAlive(camp[i].ent) then
			--Log.Write(tostring(pulling[camp[i].ent]))
			if time < 40 and time > 2 and not aggring[camp[i].ent] and not pulling[camp[i].ent] and not NPC.IsRunning(camp[i].ent) and not NPC.IsPositionInRange(camp[i].ent ,camp[i].savePos, 50) then
				Player.MovePos(camp[i].savePos, camp[i].ent)
				saving[camp[i].ent] = true
			end
			if time > 40 and not NPC.IsAttacking(camp[i].ent) and not aggring[camp[i].ent] and not pulling[camp[i].ent] and (not NPC.IsRunning(camp[i].ent) or saving[camp[i].ent]) and not NPC.IsPositionInRange(camp[i].ent, moving[camp[i].ent], 50) then
				--Log.Write("moving")
				saving[camp[i].ent] = false
				Player.MovePos(camp[i].pos, camp[i].ent)
			end
		end
	end
end
AutoStack.Init()
return AutoStack