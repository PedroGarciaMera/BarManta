loadData = {}

function loadData:loads()
	print("Loading Files")
	I = {}; SFX = {}

	SFX.alert = love.audio.newSource( "sounds/relic14.mp3", "static" )
	
	Colors = {
		orange = {0.8,0.4,0};
		red = {1,0,0};
		yellow = {1,1,0};
		green = {0,1,0};
		violet = {0.1,0.1,0.2};
		grey = {0.5,0.5,0.5};
		white = {0.9,0.9,0.9};
	}

	Fonts = {
		love.graphics.newFont("LemonMilk.otf",40);
		love.graphics.newFont("LemonMilk.otf",140);
		love.graphics.newFont("LemonMilk.otf",w_h*0.7);
		love.graphics.newFont(16);
		love.graphics.newFont("Symbola.ttf",w_h*0.1);
		love.graphics.newFont("Symbola.ttf",w_h*0.4);
	}
	_FontsH = {}; for _, F in ipairs(Fonts) do table.insert(_FontsH, F:getHeight()) end

	_Mesas = {
		-- { mesa=28;
		-- 	{k="test";n=1;done=false};
		-- };
	}
	if love.filesystem.getInfo( "mesas.sav" ) then
		_Mesas = TSerial.unpack( love.filesystem.read( "mesas.sav" ) )
	end

	_Cooked = {} -- {{m=X; n=Y; s=""},{...}...}
	if love.filesystem.getInfo( "cooked.sav" ) then
		_Cooked = TSerial.unpack( love.filesystem.read( "cooked.sav" ) )
	end

	-- for k,v in pairs(MtoB) do print(k,v) end

	print("Files loaded")
end

function loadData:init() self:loads() end

function loadData:update(dt) gs.switch(PickServer) end
