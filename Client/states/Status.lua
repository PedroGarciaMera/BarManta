local Status = {}

function Status:init() end

function Status:enter(oldState)
  
end

function Status:keyreleased(key)
	if key == 'escape' then love.event.quit() end
end


function Status:update(dt)
    if _Cs.K:isDisconnected() then _Cs.K:connect() end
    if _Cs.B:isDisconnected() then _Cs.B:connect() end
end

function Status:draw()
	local FH = Fonts[3]:getHeight();
    love.graphics.setFont( Fonts[3] );
	love.graphics.setColor(1,1,1);
	love.graphics.printf("Cliente/s desconectado/s",0,FH,w_w,"center")
	love.graphics.setColor(Colors.orange);
	love.graphics.printf("Cocina => ".._Cs.K:getState().." | ".._Cs.K:getRoundTripTime(),0,FH*3,w_w,"center")
	love.graphics.printf("Barra => ".._Cs.B:getState().." | ".._Cs.B:getRoundTripTime(),0,FH*4,w_w,"center")
end

return Status
