Cooked = { Font=8 }

function Cooked:init()
	self.Bs = {}; local B

	-- Back
	table.insert(self.Bs,newButton(0,0,w_h*0.1,w_h*0.1,"⬅",
		function() _GS.pop() end
	))

	-- Refresh
	table.insert(self.Bs,newButton(w_w-w_w*0.2,0,w_w*0.2,w_w*0.2,"🔃",
		function() self:fetchFood() end
	))
end

function Cooked:enter(oldState)
	love.graphics.setFont( Fonts[self.Font] )
	self:fetchFood()
end


function Cooked:fetchFood()
	if not _Cooked.fing then _Cooked.fing = true; _Cs.K:send("cooked") end
end


function Cooked:keyreleased(key)
	if key == 'escape' then _GS.pop() end
end

function Cooked:touchreleased( id, x, y, dx, dy, pressure )
	for _,B in ipairs(self.Bs) do
		if isPointInRectangle(x,y,B) then B.exe(); break end
	end
end

-- function Cooked:update(dt)

-- end

function Cooked:draw()
	love.graphics.setColor(Colors.yellow)
	if _Cooked.fing then 
		love.graphics.printf("⌛", 0, _FontsH[self.Font], w_w, "center")
	else
		local y = w_h*0.1 + _FontsH[self.Font]
		for i = #_Cooked, 1, -1 do
			love.graphics.printf(_Cooked[i].m.."] ".._Cooked[i].n.."  ".._Cooked[i].s, 0, y, w_w, "left")
			y=y+_FontsH[self.Font]
		end
	end


	-- Title, Back, refresh
	love.graphics.setColor(Colors.orange)
	drawTittle("COOKED")
	drawButtons(self.Bs)
end

function Cooked:leave()
	_Cooked.fing = false
end


return Cooked
