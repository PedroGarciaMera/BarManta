local loadData = {}

local IP_K = (_DEBUG and "192.168.1.72") or "192.168.1.160"; local IP_B = (_DEBUG and "192.168.1.46") or "192.168.1.153";
local P_K = (_DEBUG and 22112) or 22122; local P_B = (_DEBUG and 22114) or 22124;

local function makePedido(ITEM,N,IsKitchen)
	N = N or 1;

	if not _Mesas[_mesaPd] then
		_Mesas[_mesaPd]={
			items = {};
			info = {send2K=false;sendFK=false;sendFB=false};
		}
	end

	local M = _Mesas[_mesaPd]
	if M.items[ITEM.k] then
		M.items[ITEM.k].n=M.items[ITEM.k].n+N
	else
		M.items[ITEM.k]={n=N;txt=ITEM.s;isKitchen=IsKitchen}
	end

	M.info.send2K = IsKitchen

	love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
end

local function loadSubMenuBs(key,data)
	_SubMenuBs[key] = {}
	local B;

	for i,page in ipairs(data) do
		_SubMenuBs[key][i] = {}
		for j,item in ipairs(page) do
			if item.k==" " then
				B = newPosButton(j,item.k,function(N) end)
			else
				-- B = newPosButton(j,item.k,function(N) makePedido(item,N,data.isKitchen); _GS.pop() end)
				B = newPosButton(j,item.k,function(N) 
					_GS.push(_Gs.PickAmount,item.k,function(N) makePedido(item,N,data.isKitchen); _GS.pop() end) 
				end)
			end
			table.insert(_SubMenuBs[key][i],B)
		end
		B = newButton(0,0,w_h*0.1,w_h*0.1,"<-", function() _GS.pop() end)
		table.insert(_SubMenuBs[key][i],B)

		if i>1 then
			B = newPosButton(15,"->",function() _page=_page+1 end)
			table.insert(_SubMenuBs[key][i-1],B)

			B = newPosButton(13,"<-",function() _page=_page-1 end)
			table.insert(_SubMenuBs[key][i],B)
		end
	end
end

local function addMenuButton(I,T)
	local menuBD = {x=w_w*0.1,w=w_w*0.8,h=w_h*0.1}
	local n = #_MenusBs[I]+1
	local mY = (w_h*0.9)/(n+1)

	table.insert(_MenusBs[I],{x=menuBD.x, y=0, w=menuBD.w, h=menuBD.h, txt=T, exe=function() _GS.push(_Gs.SubMenu,T) end})

	for i,B in ipairs(_MenusBs[I]) do B.y = mY*i end
end

local function loadMenus()
	_Menus = {}; _MenusBs = {}; _SubMenuBs = {};
	local cleanName; local i; local B;

	for _,Mname in ipairs(love.filesystem.getDirectoryItems("menus")) do
		table.insert(_Menus,{}); table.insert(_MenusBs,{})

		i = #_Menus

		for _,Fname in ipairs(love.filesystem.getDirectoryItems("menus/"..Mname)) do
		  cleanName = Fname:sub(1, -5)
			_Menus[i][cleanName] = require ("menus/"..Mname.."/"..cleanName);
			if cleanName ~= "revueltos" and cleanName ~= "latas" then addMenuButton(i,cleanName) end
			loadSubMenuBs(cleanName,_Menus[i][cleanName])
		end
	end

	_MenuSel = 1;
end

function loadData:loads()
	print("Loading Files")

	I = {}; SFX = {}

	Colors = {}
	Colors.orange =	{0.8,0.4,0}
	Colors.red = {1,0,0}
	Colors.violet = {0.1,0.1,0.2}
	Colors.violet2 = {0.4,0.4,0.2}
	Colors.grey = {0.5,0.5,0.5}
	Colors.yellow = {1,1,0}
	Colors.green = {0.2,1,0.2}--{0.1,0.6,0.1}

	Fonts = {
		love.graphics.newFont(30);
		love.graphics.newFont("LemonMilk.otf",20);
		love.graphics.newFont("LemonMilk.otf",40);
		love.graphics.newFont("LemonMilk.otf",60);
		love.graphics.newFont("LemonMilk.otf",100);
		love.graphics.newFont("LemonMilk.otf",w_h*0.5);
		love.graphics.newFont("Symbola.ttf",100);
		love.graphics.newFont("Symbola.ttf",80);
		love.graphics.newFont("Symbola.ttf",200);
	}
	_FontsH = {}; for _, F in ipairs(Fonts) do table.insert(_FontsH, F:getHeight()) end

	_mesaPd = 1 -- Mesa picked
	_page = 1 -- pagina del submenu

	_TPT = false -- Touch pressed timer
	_QT = true -- Quick touch
	_TPos = {0,0} -- Last Touch Pos

	local R,C = 5,3
	local pBw, pBh = w_w/C, w_h/(R+1)
	-- local pBw_2, pBh_2 = w_w/3, w_h/6
	PosButtons = {}
	for i=1,R do
		for j=0,C-1 do
			table.insert(PosButtons,{x=pBw*j,y=pBh*i,w=pBw,h=pBh})
		end
	end

	_Mesas = {}; _ErrorM = false
	if love.filesystem.getInfo( "mesas.sav" ) then
		local okM, resultM = pcall(TSerial.unpack, love.filesystem.read("mesas.sav"))
		if okM and type(resultM) == "table" then _Mesas = resultM  else _Mesas = {}; _ErrorM = true end
	end

	_MesasHistory = {}; _ErrorHM = false
	if love.filesystem.getInfo( "mesasH.sav" ) then
		local okM, resultM = pcall(TSerial.unpack, love.filesystem.read("mesasH.sav"))
		if okM and type(resultM) == "table" then _MesasHistory = resultM  else _MesasHistory = {}; _ErrorHM = true end
	end

	_MesasCom = {}; -- Flag for comensales

	-- love.filesystem.write( "save.sav", "\n" )
	-- for i,t in ipairs(Comidas.tapas) do
	-- 	love.filesystem.append( "save.sav", "\n" )
	-- 	for j,v in ipairs(t) do
	-- 		love.filesystem.append( "save.sav", v.." = \"\";" )
	-- 		love.filesystem.append( "save.sav", "\n" )
	-- 	end
	-- end

	-- Clients
	_Cs = {}
	_Cs.K = sock.newClient(IP_K, P_K)
	_Cs.K:setSerialization(bitser.dumps, bitser.loads)
	-- _Cs.K:setTimeout(8, 1250, 7500)
	-- _Cs.K:setMessageTimeout(1000)
	_Cs.K:connect()

	_Cs.B = sock.newClient(IP_B, P_B)
	_Cs.B:setSerialization(bitser.dumps, bitser.loads)
	-- _Cs.B:setTimeout(8, 1250, 7500)
	_Cs.B:connect()

	_Cs.K:on("sended", function(Mi)
		local M = _Mesas[Mi];

		if not M then return end; if M.info.sendFK then return end;

		M.info.sendFK = true

		if M.info.sendFB then
			clearMesa(Mi,true)
			if _mesaPd==Mi and _GS.current()==_Gs.Mesa then _GS.pop() end
		end

		love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
	end)

	_Cs.B:on("sended", function(Mi)
		local M = _Mesas[Mi]; 
		
		if not M then return end; if M.info.sendFB then return end

		M.info.sendFB = true

		if M.info.send2K then
			if M.info.sendFK then
				clearMesa(Mi,true)
				if _mesaPd==Mi and _GS.current()==_Gs.Mesa then _GS.pop() end
			end
		else
			clearMesa(Mi,true)
			if _mesaPd==Mi and _GS.current()==_Gs.Mesa then _GS.pop() end
		end

		love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
	end)

	
	_Cooked = {fing=false} -- {{m=X; n=Y; s=""},{...}...}
	_Cs.K:on("cooked", function(data) _Cooked = data; _Cooked.fing = false; end)

	loadMenus();

	print("Files loaded")
end

function loadData:init() self:loads() end

function loadData:update(dt) _GS.switch(_Gs.PickMesa) end

return loadData
