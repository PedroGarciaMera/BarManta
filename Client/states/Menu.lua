local Menu = {}

function Menu:init()
	self.MBs = {}

	-- Next Menu
	self.MBs.NM = newButton(0,0,w_w*0.2,w_w*0.2,"🔃", function()
		_MenuSel=_MenuSel+1; if _MenuSel>#_Menus then _MenuSel=1 end
	end)

	-- Mesa title
	self.MBs.Mesa = newButton(w_w*0.3,0,w_w*0.4,w_w*0.2,"Error",
		function() _GS.push(_Gs.Mesa) end
	)

	-- Sound Alert
	self.MBs.SFX = newButton(w_w-w_w*0.2,0,w_w*0.2,w_w*0.2,"🔊",
		function() _Cs.K:send("alert") end
	)

	-- Comensales
	self.MBs.Com = newButton(w_w*0.4,w_h-(w_w*0.2),w_w*0.2,w_w*0.2,"👥",
		function() _GS.push(_Gs.PickComensales) end
	)

	-- Cuenta
	self.MBs.C = newButton(w_w-w_w*0.2,w_h-(w_w*0.2),w_w*0.2,w_w*0.2,"📜",
		function() 
			_Cs.B:send("cuenta",_mesaPd); 
			_MesasCom[_mesaPd] = false; 
		end
	)
end
function Menu:enter(oldState)
	self.MBs.Mesa.txt = "Mesa ".._mesaPd
	if _MesasCom[_mesaPd] then self.MBs.Com.txt = "👥\n".._MesasCom[_mesaPd] end
	love.graphics.setFont( Fonts[7] )
end
function Menu:resume(delCom) 
	if delCom then self.MBs.Com.txt = "👥" end
	if _MesasCom[_mesaPd] then self.MBs.Com.txt = "👥\n".._MesasCom[_mesaPd] end

	love.graphics.setFont( Fonts[7] ) 
end

function Menu:keyreleased(key)
	if key == 'escape' then _GS.switch(_Gs.PickMesa) end
end

function Menu:longTouch()
	if isPointInRectangle(_TPos[1],_TPos[2],self.MBs.Mesa) then _GS.switch(_Gs.PickMesa,true)
	elseif isPointInRectangle(_TPos[1],_TPos[2],self.MBs.Com) then _MesasCom[_mesaPd] = nil; self.MBs.Com.txt = "👥"
	else _QT=true
	end
end

function Menu:touchreleased( id, x, y, dx, dy, pressure )
	if _QT then
		for _,B in ipairs(_MenusBs[_MenuSel]) do
			if isPointInRectangle(x,y,B) then B.exe(); break end
		end
		for _,B in pairs(self.MBs) do 
			if isPointInRectangle(x,y,B) then B.exe(); break end
		end
	end
end

function Menu:update(dt) end

function Menu:draw()
	love.graphics.setColor(Colors.orange)
	drawButtons(_MenusBs[_MenuSel])
	
	for k,B in pairs(self.MBs) do 
		love.graphics.setColor(Colors.orange)
		if k == "Mesa" and _Mesas[_mesaPd] then love.graphics.setColor(Colors.yellow) end
		if k == "Com" and _MesasCom[_mesaPd] then love.graphics.setColor(Colors.yellow) end
		drawButton(B) 
	end
end

function Menu:leave() end


return Menu
