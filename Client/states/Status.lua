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
    love.graphics.setFont( Fonts[3] );
	love.graphics.printf("Cliente/s desconectado/s",0,0,w_w,"center")
	love.graphics.printf("Cocina => ".._Cs.K:getState().." | ".._Cs.K:getRoundTripTime(),0,Fonts[3]:getHeight(),w_w,"center")
	love.graphics.printf("Barra => ".._Cs.B:getState().." | ".._Cs.B:getRoundTripTime(),0,Fonts[3]:getHeight()*2,w_w,"center")
end

return Status
