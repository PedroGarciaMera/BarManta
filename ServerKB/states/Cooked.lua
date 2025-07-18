Cooked = { Font=5; Timer=1.2 }

local IP_K = (_DEBUG and "192.168.1.46") or "192.168.1.160";

function Cooked:init()
	-- Refresh button
	self.RB = newButton(w_w*0.9,0,w_w*0.1,w_w*0.1,"🔃",
		function() self:fetchFood() end
	)
end

function Cooked:enter(oldState)
	self.K = sock.newClient(IP_K, 22122)
	self.K:setSerialization(bitser.dumps, bitser.loads)
	self.K:connect()

	self.K:on("connect", function(data) _Cooked.fing = self.Timer end)
	self.K:on("cooked", function(data) _Cooked = data; _Cooked.fing = false; end)

	self.FH = _FontsH[self.Font]
end


function Cooked:fetchFood()
	if self.K:isConnected() then 
		if not _Cooked.fing then _Cooked.fing = self.Timer end
	elseif self.K:isConnecting() then return
	else self.K:connect()
	end	
end


function Cooked:keyreleased(key)
	if key == 'escape' then love.event.quit() end
end

function Cooked:mousereleased( x, y, button, istouch )
	if not _Cooked.fing and isPointInRectangle(x,y,self.RB) then self.RB.exe() end
end

function Cooked:update(dt)
	if dt>2 then
		self.K:disconnectNow()
		return
	end

	if self.K:isDisconnected() then self.K:connect() end

	pcall(function() self.K:update() end)

	if _Cooked.fing and _Cooked.fing > 1 then 
		_Cooked.fing = _Cooked.fing - dt
		if _Cooked.fing <= 1 then self.K:send("cooked") end	
	end
end

function Cooked:draw()
	love.graphics.setFont( Fonts[self.Font] )
	love.graphics.setColor(Colors.yellow)
	if _Cooked.fing then 
		love.graphics.printf("⌛", 0, self.FH, w_w, "center")
	else
		local y = 0
		for i = #_Cooked, 1, -1 do
			--love.graphics.printf(_Cooked[i].m.."] ".._Cooked[i].n.."  ".._Cooked[i].s, 0, y, w_w*0.9, "left")

			love.graphics.printf({Colors.green,_Cooked[i].m.."] ",Colors.yellow,_Cooked[i].n.."  ".._Cooked[i].s},0, y, w_w*0.9, "left")
			y=y+self.FH
		end
	end


	-- Refresh
	if self.K:isConnected() then love.graphics.setColor(0,0.8,0)
	elseif self.K:isConnecting() then love.graphics.setColor(0.8,0.8,0)
	else love.graphics.setColor(0.8,0,0)
	end
	-- drawTittle("COOKED")
	drawButton(self.RB)
end

function Cooked:leave()
	_Cooked.fing = false
end
