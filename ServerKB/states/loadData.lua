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
	}

	_Mesas = {
		-- { mesa=28;
		-- 	{k="test";n=1;done=false};
		-- };
	}
	if love.filesystem.getInfo( "mesas.sav" ) then
		_Mesas = TSerial.unpack( love.filesystem.read( "mesas.sav" ) )
	end

	-- for k,v in pairs(MtoB) do print(k,v) end

	print("Files loaded")
end

function loadData:init() self:loads() end

function loadData:update(dt) gs.switch(PickMesa) end
