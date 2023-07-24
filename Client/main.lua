sock = require "sock"
bitser = require "spec.bitser"

require "libs/Tserial"

--Game States
_GS = require "libs/gamestate"

require "Fs"

local function getGsStates()
	local Gs = {}

	local files = love.filesystem.getDirectoryItems("states")
	local Fname,packageN
	for _, file in ipairs(files) do
		Fname=file:sub(0,-5); packageN="states."..file:sub(0,-5)
		Gs[Fname] = require(packageN)
	end

	return Gs
end



function love.load()
	w_w = 1080 ; w_h = 1920 ; w_w_2 = w_w/2 ; w_h_2 = w_h/2
    realw_w, realw_h = love.graphics.getDimensions( )
    scalex = (realw_w/w_w) ; scaley = (realw_h/w_h)

	_Gs = getGsStates()

	_GS.registerEvents({ 'update', 'keypressed', 'keyreleased', 'touchpressed', 'touchreleased' }); 
	_GS.switch(_Gs.loadData)
end

function love.keyreleased(key)
	if key=='r' then love.event.quit("restart")
	elseif key=='t' then
		for _,C in pairs(_Cs) do C:disconnectNow() end
	end
end

function love.mousepressed( x, y, button, istouch )
	if not istouch then love.touchpressed( button, x, y ) end
end
function love.mousereleased( x, y, button, istouch )
	if not istouch then love.touchreleased( button, x, y ) end
end

function love.touchpressed( id, x, y, dx, dy, pressure ) _TPT=0; _QT=true; _TPos={x,y} end
function love.touchreleased( id, x, y, dx, dy, pressure ) _TPT=false end

local function areBothClientConnected() return _Cs.K:isConnected() and _Cs.B:isConnected() end
function love.update(dt)
	if _Cs and _Cs.B and _Cs.K then
		if _GS.current() == _Gs.Status then
			if areBothClientConnected() then _GS.switch(_Gs.PickMesa) end
		else 
			if not areBothClientConnected() then _GS.switch(_Gs.Status) end
		end

		if dt>2 then
			for _,C in pairs(_Cs) do C:disconnectNow() end
		end

		for _,C in pairs(_Cs) do pcall(function() C:update() end) end
	end

	if _TPT then
		_TPT=_TPT+dt
		if _TPT>0.4 then _QT=false; _TPT=false
			if _GS.current().longTouch then _GS.current():longTouch() end
		end
	end
end


function love.draw()
	love.graphics.scale(scalex,scaley)
	love.graphics.setColor(Colors.orange)

	if _Cs and _Cs.B and _Cs.K then
		if _GS.current().draw then _GS.current():draw()	end
	else
		love.graphics.print("Fatal server error")
	end

	love.graphics.setColor(Colors.violet)
	love.graphics.setFont( Fonts[1] ); love.graphics.print("\n v1.4");
end

function love.quit() return false end
