local autounpause = {}
autounpause.optionEnable = Menu.AddOptionBool({"Utility"}, "Auto Unpause", false)
function autounpause.OnUpdate()
	if not Heroes.GetLocal() or not Menu.IsEnabled(autounpause.optionEnable) then return end
	if GameRules.IsPaused() then
		Engine.ExecuteCommand("dota_pause")
	end	
end
return autounpause