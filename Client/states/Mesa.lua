local Mesa = { Font=8 }

function Mesa:init()
	self.Bs = {}; local B

	-- Back
	table.insert(self.Bs,newButton(0,w_h-w_w*0.2,w_w*0.2,w_w*0.2,"⬅️",
		function() _GS.pop() end
	))
	-- Clear
	table.insert(self.Bs,newButton(w_w*0.4,w_h-w_w*0.2,w_w*0.2,w_w*0.2,"🚮",
		function() clearMesa(_mesaPd); _GS.pop() end
	))
	-- -- Cuenta
	-- table.insert(self.Bs,newButton(w_w-w_w*0.2,w_h-w_w*0.2,w_w*0.2,w_w*0.2,"📜",
	-- 	function() 
	-- 		_Cs.B:send("cuenta",_mesaPd)
	-- 		_GS.pop() 
	-- 	end
	-- ))


	-- Send Mesa
	table.insert(self.Bs,newButton(w_w*0.8,0,w_w*0.2,w_w*0.2,"📩",
		function()
			local type;

			if self.M then
				local MesaToSendK = {m=_mesaPd}
				local MesaToSendB = {m=_mesaPd}
				for _,item in pairs(self.M.items) do
					type = "B";
					if item.isKitchen then type="K"; table.insert(MesaToSendK,{item=item.txt;n=item.n;type=type}) end
					table.insert(MesaToSendB,{item=item.txt;n=item.n;type=type})
				end

				if _MesasCom[_mesaPd] then MesaToSendK.c = _MesasCom[_mesaPd]; MesaToSendB.c = _MesasCom[_mesaPd]; end

				if not self.M.info.sendFK and #MesaToSendK>0 then _Cs.K:send("pedidoMesa",MesaToSendK) end
				if not self.M.info.sendFB and #MesaToSendB>0 then _Cs.B:send("pedidoMesa",MesaToSendB) end
			end

			_GS.pop()
		end
	))
end
function Mesa:enter(oldState,longT) self.M=_Mesas[_mesaPd]; self.longT=longT end

function Mesa:keyreleased(key) if key == 'escape' then _GS.pop() end end

function Mesa:touchreleased( id, x, y, dx, dy, pressure )
	if self.longT then self.longT=false; return end

	for i,B in ipairs(self.Bs) do
		if isPointInRectangle(x,y,B) then B.exe(); break end
	end
end

function Mesa:draw()
	-- Items
	local y = _FontsH[self.Font];

	-- Mesa nº
	love.graphics.setFont( Fonts[10] )
	love.graphics.setColor(1,1,1,0.2)
	love.graphics.printf(_mesaPd, 0, w_h*0.25, w_w, "center")

	if self.M then
		love.graphics.setFont( Fonts[self.Font] )
		-- Bebidas
		love.graphics.setColor(Colors.yellow)
		for _,item in pairs(self.M.items) do
			if not item.isKitchen then
				love.graphics.printf(item.n.."  "..item.txt, 0, y, w_w*2, "left")
				-- love.graphics.line(0,y+self._D.th,w_w,y+self._D.th)

				y=y+_FontsH[self.Font]
			end
		end
		-- Separador
		love.graphics.setColor(Colors.green)
		love.graphics.printf("COMIDAS", 0, y, w_w, "center")
		y=y+_FontsH[self.Font]
		love.graphics.line(0,y,w_w,y)
		-- Comidas
		love.graphics.setColor(Colors.yellow)
		for _,item in pairs(self.M.items) do
			if item.isKitchen then
				love.graphics.printf(item.n.."  "..item.txt, 0, y, w_w*2, "left")
				-- love.graphics.line(0,y+self._D.th,w_w,y+self._D.th)

				y=y+_FontsH[self.Font]
			end
		end
	end
	-- Back, clear and send
	love.graphics.setFont( Fonts[7] )
	love.graphics.setColor(Colors.orange)
	drawButtons(self.Bs)
end

return Mesa
