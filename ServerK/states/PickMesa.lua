PickMesa = {}

function PickMesa:init()
	-- Buttons
	local R,C = 3,6
	local n = 1
	local bw,bh = w_w/C, w_h/R
	self.Bs = {}
	for i=0,R-1 do
		for j=0,C-1 do
			table.insert(self.Bs,newMesaButton(bw*j,bh*i,bw,bh,n))
			n = n+1
		end
	end
end

function PickMesa:enter(oldState)

end

function PickMesa:keyreleased(key)
	if key == 'escape' then love.event.quit() end
end

function PickMesa:mousereleased( x, y, button, istouch )
	for i,B in ipairs(self.Bs) do
		if _Mesas[B.txt] and isPointInRectangle(x,y,B) then B.exe(); break end
	end
end

function PickMesa:update(dt)

end

function PickMesa:draw()
	love.graphics.setFont( Fonts[2] )
	if #_Mesas==0 then
		love.graphics.setColor(Colors.white)
		love.graphics.printf( "EMPTY", 0, w_h*0.4, w_w, "center" )
	else
		love.graphics.setFont( Fonts[2] )
		for i,B in pairs(self.Bs) do
			if _Mesas[i] then
				if _Mesas[i].done then love.graphics.setColor(Colors.orange)
				else love.graphics.setColor(Colors.yellow)
				end
				drawMesaButton(B,_Mesas[i].mesa)
			end
		end
	end
end

function PickMesa:leave()

end
