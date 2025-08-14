function drawButton(B)
	love.graphics.rectangle("line", B.x, B.y, B.w, B.h)
	love.graphics.printf(B.txt, B.x, B.y, B.w, "center")
end

function drawMesaButton(B,N)
	love.graphics.rectangle("line", B.x, B.y, B.w, B.h)
	love.graphics.printf(N, B.x, B.y, B.w, "center")
end

function drawButtons(Bs)
	for i,B in ipairs(Bs) do drawButton(B) end
end

function newButton(X,Y,W,H,T,F) return {x=X, y=Y, w=W, h=H, txt=T, exe=F} end

function newMesaButton(X,Y,W,H,T)
	return {x=X, y=Y, w=W, h=H, txt=T, exe=function() gs.switch(Mesa,T) end}
end

function isPointInRectangle(x,y,R)
	return (x/scalex>=R.x and x/scalex<=R.x+R.w and y/scaley>=R.y and y/scaley<=R.y+R.h)
end


function loadServer(Port)
	local S = sock.newServer("*", Port);
	S:setSerialization(bitser.dumps, bitser.loads)

	S:on("connect", function(data, client)
		print("Server: Client found this server",client:getIndex(),client:getConnectId(),data)
		client:send("ServerFound")
	end)

	S:on("alert", function(data, client) SFX.alert:stop(); SFX.alert:play() end)

	S:on("pedido", function(D, client) -- D = {m=_mesaPd;item=ITEM;n=N}
		SFX.alert:stop(); SFX.alert:play()

		local M = getMesa(D.m)

		if M then
			M.done = false
			table.insert(M,{k=D.item;n=D.n;done=false})

			--- Unir repetidos
			-- local existI = false
			-- for i,O in ipairs(M) do
			-- 	if O.k==D.item then O.n=O.n+1; O.done=false; existI=true; break end
			-- end
			-- if not existI then table.insert(M,{k=D.item;n=1;done=false}) end
		else
			local T =  { mesa=D.m;
				{k=D.item;n=D.n;done=false};
			};
			table.insert(_Mesas,T)
		end

		local currentM = gs.current().M
		if currentM and currentM.mesa==D.m then gs.current():loadButtons() end
	end)

	S:on("pedidoMesa", function(D, client) -- D = { {item=str;n=N;type=K/B}...{}; m=_mesaPd, h=history, c=comensales}
		local M = getMesa(D.m)

		SFX.alert:stop(); SFX.alert:play()

		if M then
			for _,v in ipairs(D) do
				table.insert(M,{k=v.item;n=v.n;done=false;type=v.type})
				if v.type=="B" then M.drinks=true end
			end
			if D.c then M.c = D.c end
		else
			local T =  { mesa=D.m }
			for _,v in ipairs(D) do
				table.insert(T,{k=v.item;n=v.n;done=false;type=v.type})
				if v.type=="B" then T.drinks=true end
			end
			if D.c then T.c = D.c end
			table.insert(_Mesas,T)
		end

		local currentM = gs.current().M
		if currentM and currentM.mesa==D.m then gs.current():loadButtons() end

		if not D.h then client:send("sended",D.m) end
		love.filesystem.write( "mesas.sav", TSerial.pack(_Mesas))
	end)

	S:on("cuenta", function(D, client) -- D = {N}
		SFX.alert:stop(); SFX.alert:play()

		table.insert(_Mesas,{ mesa=D, cuenta=true })
	end)

	S:on("cooked", function(data, client) client:send("cooked",_Cooked) end)


	-- S:on("eraser", function(D, client) -- D = {m=_mesaPd;type="KorB"}
	-- 	local Mi = false
	-- 	for i,v in ipairs(_Mesas) do
	-- 		if v.mesa == D.m then Mi = i; break end
	-- 	end
	--
	-- 	if Mi then
	-- 		-- SFX.alert:stop(); SFX.alert:play()
	--
	-- 		_Mesas[Mi] =  { mesa=D.m }
	--
	-- 		if gs.current()==Mesa then gs.current():loadButtons() end
	-- 	end
	-- end)

	return S
end




function getMesa(Mi) -- return false if not exist
	local existM = false

	for _,v in ipairs(_Mesas) do
		if v.mesa == Mi and not v.cuenta then existM = v; break end
	end

	return existM
end
