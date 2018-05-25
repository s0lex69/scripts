local maphack = {}
checked = false
function maphack.OnUpdate()
	if checked == false then
		Log.Write("ver 2.0")
		checked = true
	end	
end

return maphack