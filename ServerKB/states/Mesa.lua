Mesa = {}

function Mesa:loadButtons()
	self.Bs = {}; self.hudBs = {}; self.upB = false local B
	local y = 0

	-- Back
	table.insert(self.hudBs,newButton(0,self._D.tty,w_w*0.2,w_h-self._D.tty,"<-",
		function()
			love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
			gs.switch(PickMesa)
		end
	))
	-- Clear
	table.insert(self.hudBs,newButton(w_w*0.4,self._D.tty,w_w*0.2,w_h-self._D.tty,"X",
		function()
			self:CheckUnDones()
			self:addCooked({n=0,k="- X -"})
			self.M=nil; table.remove(_Mesas,self.pos);
			love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
			gs.switch(PickMesa)
		end
	))
	-- Scroll Up
	self.upB = newButton(w_w-w_w*0.1,w_h*0.2,w_w*0.1,w_h*0.2,"^",
		function() self.Y = self.Y + self.move end
	)
	-- Scroll Down
	table.insert(self.hudBs,newButton(w_w-w_w*0.1,w_h*0.6,w_w*0.1,w_h*0.2,"v",
		function() self.Y = self.Y - self.move end
	))

	-- Items	
	if self.M then
		for i,T in ipairs(self.M) do
			if T.type=="B" then
				B = newButton(0,y,w_w*0.8,self._D.th," ",function()
					T.done = not T.done
					if not T.done then self.M.done=false
					elseif self:isMesaDone() then self.M.done=true
					end
				end)
				table.insert(self.Bs,B);

				y=y+self._D.th
			end
		end
		if self.M.drinks then y=y+self._D.th end
		for i,T in ipairs(self.M) do
			if T.type=="K" then
				B = newButton(0,y,w_w*0.8,self._D.th," ",function()
					T.done = not T.done
					if not T.done then 
						self.M.done=false
						self:rmvCooked(T)
					else
						self.M.done=self:isMesaDone()
						self:addCooked(T)
					end
				end)
				table.insert(self.Bs,B);

				y=y+self._D.th
			end
		end
	end
end

function Mesa:isMesaDone()
	for i,T in ipairs(self.M) do
		if not T.done then return false end
	end
	return true
end

function Mesa:CookUnDones()
	for i,T in ipairs(self.M) do
		if not T.done then 
			table.insert(_Cooked, {m=self.M.mesa; n=item.n; s=item.k}) 
			if #_Cooked > 16 then table.remove(_Cooked, 1) end
		end
	end
end
function Mesa:addCooked(item)
	table.insert(_Cooked, {m=self.M.mesa; n=item.n; s=item.k})

	if #_Cooked > 16 then
        table.remove(_Cooked, 1)  -- Remove oldest (bottom)
    end

	love.filesystem.write( "cooked.sav", TSerial.pack(_Cooked))
end
function Mesa:rmvCooked(item)
	if #_Cooked==0 then return end

	local last = _Cooked[#_Cooked]

	if last.m==self.M.mesa and last.n==item.n and last.s==item.k then
		table.remove(_Cooked, #_Cooked)
		love.filesystem.write( "cooked.sav", TSerial.pack(_Cooked))
	end
end

function Mesa:init()
	self._D = {th=50; tty=w_h-60}
	self.move = 40
end

function Mesa:enter(oldState,Pos)
	self.Y = 0
	self.M = _Mesas[Pos]
	self.pos = Pos
	self:loadButtons()
end

function Mesa:keyreleased(key)
	if key == 'escape' then gs.switch(PickMesa) end
end

function Mesa:mousereleased( x, y, button, istouch )
	if isPointInRectangle(x,y,self.upB) then self.upB.exe(); return end

	for i,B in ipairs(self.hudBs) do
		if isPointInRectangle(x,y,B) then B.exe(); return end
	end
	for i,B in ipairs(self.Bs) do
		if isPointInRectangle(x,y-self.Y*scaley,B) then B.exe(); return end
	end
end

function Mesa:update(dt)

end

function Mesa:draw()
	-- Items
	local y = self.Y; local It;
	if self.M then
		-- Mesa num
		love.graphics.setFont( Fonts[3] )
		love.graphics.setColor(Colors.red)
		-- love.graphics.printf(self.M, 0, 0, w_w, "center")
		love.graphics.printf(self.M.mesa, 0, 0, w_w, "center")

		love.graphics.setFont( Fonts[1] )

		-- Start Line
		-- love.graphics.setColor(Colors.green)
		-- love.graphics.line(0,y,w_w,y)
		
		-- Bebidas
		for i,T in ipairs(self.M) do
			if T.type=="B" then
				if T.done then love.graphics.setColor(Colors.orange) else love.graphics.setColor(Colors.yellow) end
				-- drawButton(self.Bs[i+2])
				love.graphics.printf(T.n.."\t"..T.k, 0, y, w_w, "left")

				y=y+self._D.th
			end
		end

		if self.M.drinks then
			-- Separador
			love.graphics.setColor(Colors.green)
			love.graphics.printf("Comidas", 0, y, w_w, "center")
			y=y+self._D.th
			love.graphics.line(0,y,w_w,y)
		end

		-- Comidas
		for i,T in ipairs(self.M) do
			if T.type=="K" then
				if T.done then love.graphics.setColor(Colors.orange) else love.graphics.setColor(Colors.yellow) end
				-- drawButton(self.Bs[i+2])
				love.graphics.printf(T.n.."\t"..T.k, 0, y, w_w, "left")

				y=y+self._D.th
			end
		end

		-- End Line
		-- love.graphics.setColor(Colors.green)
		-- love.graphics.line(0,y,w_w,y)
	end
	-- Back and clear
	love.graphics.setFont( Fonts[1] )
	love.graphics.setColor(Colors.orange)
	drawButtons(self.hudBs)

	-- Scroll UP
	if self.Y < 0 then love.graphics.setColor(Colors.yellow) end
	drawButton(self.upB)
end

function Mesa:leave()

end
