local PickComensales = {}

function PickComensales:init()
	self.Bs = {}; local B
	for i=1,12 do
		B = {txt=i}
		for k,v in pairs(PosButtons[i]) do B[k]=v end
		table.insert(self.Bs,B)
	end

	self.Bs2 = {}
	-- Back
	B = newButton(0,0,w_h*0.1,w_h*0.1,"<-", function() _GS.pop() end)
	table.insert(self.Bs2,B)
	-- Delete item
	B = newPosButton(14,"BORRAR",function(SELF) _MesasCom[_mesaPd] = nil; _GS.pop(true); end)
	table.insert(self.Bs2,B)
end

function PickComensales:enter(oldState)
	love.graphics.setColor(Colors.orange)
end

function PickComensales:keyreleased(key) if key == 'escape' then _GS.pop() end end

function PickComensales:touchreleased( id, x, y, dx, dy, pressure )
	for _,B in ipairs(self.Bs2) do
		if isPointInRectangle(x,y,B) then B.exe(self); return end
	end

	for i,B in ipairs(self.Bs) do
		if isPointInRectangle(x,y,B) then 
			_MesasCom[_mesaPd] = i
			_GS.pop()
			break
		end
	end
end

function PickComensales:draw()
	love.graphics.setFont( Fonts[5] )
	drawTittle("Comensales")
	love.graphics.setFont( Fonts[4] )
	drawButtons(self.Bs2)
	if _MesasCom[_mesaPd] then
		love.graphics.setFont( Fonts[9] )
		love.graphics.printf("👥 ".._MesasCom[_mesaPd],0,w_h_2,w_w,"center")
	else
		drawButtons(self.Bs) 
	end

end

return PickComensales
