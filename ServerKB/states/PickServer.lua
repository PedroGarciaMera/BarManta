PickServer = {}

function PickServer:init()
    -- Buttons
	self.Bs = {}; local B

	B = newButton(w_w*0.05,w_h*0.3,w_w*0.4,w_h*0.4,"K", function() 
        _S = loadServer(22122); gs.switch(PickMesa) 
    end)
	table.insert(self.Bs,B)

    B = newButton(w_w*0.55,w_h*0.3,w_w*0.4,w_h*0.4,"B", function() 
        SFX.alert = love.audio.newSource( "sounds/coin4.wav", "static" ); _S = loadServer(22124); gs.switch(PickMesa) 
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
    love.graphics.setFont( Fonts[2] )
    love.graphics.setColor(1,1,1)
    for i,B in ipairs(self.Bs) do drawButton(B) end
end

return PickServer