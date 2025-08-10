PickServer = {}

local P_K = (_DEBUG and 22112) or 22122; local P_B = (_DEBUG and 22114) or 22124;

function PickServer:init()
    -- Buttons
	self.Bs = {}; local B

	B = newButton(w_w*0.05,w_h*0.05,w_w*0.4,w_h*0.4,"🥘", function() 
        _S = loadServer(P_K); gs.switch(PickMesa) 
    end)
	table.insert(self.Bs,B)

    B = newButton(w_w*0.55,w_h*0.05,w_w*0.4,w_h*0.4,"🍺", function() 
        SFX.alert = love.audio.newSource( "sounds/coin4.wav", "static" ); _S = loadServer(P_B); gs.switch(PickMesa) 
    end)
	table.insert(self.Bs,B)

    B = newButton(w_w*0.3,w_h*0.55,w_w*0.4,w_h*0.4,"📃", function() 
        love.graphics.setBackgroundColor(0.1,0.1,0.2); gs.switch(Cooked) 
    end)
	table.insert(self.Bs,B)
end

function PickServer:enter(oldState)
    
end

function PickServer:keyreleased(key)
	if key == 'escape' then love.event.quit() end
end

function PickServer:mousereleased( x, y, button, istouch )
    for i,B in ipairs(self.Bs) do
        if isPointInRectangle(x,y,B) then B.exe(self); return end
    end
end

function PickServer:update(dt)

end

function PickServer:draw()   
    if _ErrorM then 
        love.graphics.setColor(1,0,0)
        love.graphics.printf("Couldn't load 'mesas.sav'",0,0,w_w,"right")        
    end

    love.graphics.setFont( Fonts[6] )
    love.graphics.setColor(1,1,1)
    for i,B in ipairs(self.Bs) do drawButton(B) end

    love.graphics.setFont( Fonts[4] ); love.graphics.setColor(0.5,0.5,1); love.graphics.print(_V);
end

return PickServer