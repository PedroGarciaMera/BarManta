_DEBUG = false; _V = "v1.50"

sock = require "sock"
bitser = require "spec.bitser"

require "libs/Tserial"

--Game States
_GS = require "libs/gamestate"

require "Fs"

local KT, BT = 0, 0

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
	love.graphics.setBackgroundColor(0.1,0.1,0.2)
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
		-- if _GS.current() == _Gs.Status then
		-- 	if areBothClientConnected() then _GS.switch(_Gs.PickMesa) end
		-- else 
		-- 	if not areBothClientConnected() then _GS.switch(_Gs.Status) end
		-- end

		if dt>2 then
			for _,C in pairs(_Cs) do 
				C:disconnectNow() 
				KT = 64; BT = 128
			end
		end

		if KT > 0 then KT = KT - 1; if KT == 0 then _Cs.K:connect() end end
		if BT > 0 then BT = BT - 1; if BT == 0 then _Cs.B:connect() end end

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

	if _Cs and _Cs.B and _Cs.K then		
		if _Cs.K:isConnected() then love.graphics.setColor(0,0.8,0)
		elseif _Cs.K:isConnecting() then love.graphics.setColor(0.8,0.8,0)
		else love.graphics.setColor(0.8,0,0)
		end
		love.graphics.printf("\nK", 0, 0, w_w, "right")

		if _Cs.B:isConnected() then love.graphics.setColor(0,0.8,0)
		elseif _Cs.B:isConnecting() then love.graphics.setColor(0.8,0.8,0)
		else love.graphics.setColor(0.8,0,0)
		end
		love.graphics.printf("\n\nB", 0, 0, w_w, "right")
	else
		love.graphics.setColor(0,0,0)
		love.graphics.printf("\nK\nB", 0, 0, w_w, "right")
	end
	

	love.graphics.setColor(Colors.orange)

	if _Cs and _Cs.B and _Cs.K then
		if _GS.current().draw then _GS.current():draw()	end
	else
		love.graphics.print("Fatal server error")
	end
end

function love.quit() return false end
