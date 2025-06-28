local Status = {}

function Status:init() 
	-- Buttons
	self.Bs = {}; local B

	B = newButton(0,0,w_h*0.1,w_h*0.1,"⬅️", function() _GS.pop() end)
	table.insert(self.Bs,B)
end

function Status:enter(oldState)
  love.graphics.setFont( Fonts[7] );
end

function Status:keyreleased(key)
	if key == 'escape' then _GS.pop() end
end

function Status:touchreleased( id, x, y, dx, dy, pressure )
	for i,B in ipairs(self.Bs) do
		if isPointInRectangle(x,y,B) then B.exe(self); return end
	end
end


function Status:update(dt)
    if _Cs.K:isDisconnected() then _Cs.K:connect() end
    if _Cs.B:isDisconnected() then _Cs.B:connect() end
end

function Status:draw()
	love.graphics.setColor(1,1,1);
	-- love.graphics.printf("Cliente/s desconectado/s",0,_FontsH[7],w_w,"center")
	love.graphics.setColor(Colors.orange);
	love.graphics.printf("K => ".._Cs.K:getState().." | ".._Cs.K:getRoundTripTime(),0,_FontsH[7]*3,w_w,"center")
	love.graphics.printf("B => ".._Cs.B:getState().." | ".._Cs.B:getRoundTripTime(),0,_FontsH[7]*4,w_w,"center")

	for i,B in ipairs(self.Bs) do drawButton(B) end

	-- Version
	love.graphics.setColor(0.8,0.8,0.8)
	-- love.graphics.setFont( Fonts[1] ); 
	love.graphics.print(_V,0,w_h-_FontsH[7]);
end

return Status
