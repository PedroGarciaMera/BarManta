_V = "v1.4"

sock = require "sock"
bitser = require "spec.bitser"

require "libs/Tserial"

--Game States
gs = require "libs/gamestate"
require "states/loadData"
require "states/PickMesa"
require "states/Mesa"
require "states/PickServer"


require "Fs"


function love.load()
	w_w = 1136 ; w_h = 640
    realw_w, realw_h = love.graphics.getDimensions( )
    scalex = (realw_w/w_w) ; scaley = (realw_h/w_h)

	gs.registerEvents()
	gs.switch(loadData)
end

function love.keyreleased(key)
	if key=='r' then love.event.quit("restart") end
end

function love.update(dt)
	if pcall(function() _S:update() end) then
		love.graphics.setBackgroundColor(0.1,0.1,0.2)
	else
		love.graphics.setBackgroundColor(0.4,0.1,0.2)
	end
end

function love.draw() 
	love.graphics.scale(scalex,scaley)
	love.graphics.setFont( Fonts[4] ); love.graphics.setColor(0.5,0.5,1); love.graphics.print(_V);
end

function love.resize( w, h )
	realw_w, realw_h = w, h
	scalex = (realw_w/w_w) ; scaley = (realw_h/w_h)
end

function love.quit()
	love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
	return false
end
