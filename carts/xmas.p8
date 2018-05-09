pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function _init()
	cls()
	--[[
	d_lines()
	d_bk()
	d_chars()
	print(time())
	--]]
end

function _update()

end

function _draw()
	--print("end",0,0,7)

	cls()
	d_lines()
	d_bk()
	d_chars()
	print(time(),0,0,7)

end
-->8
--draw chars

function d_chars()
	d_rscore(1225,94,16,3)
	d_chains(96,26,1)
end

function d_chains(x,y,ml)
	local wd=5*ml
	local st=5*ml+1*ml
	sspr(8,0,5,5,x,y,wd,wd)
	sspr(16,0,5,5,x+st,y,wd,wd)
	sspr(24,0,5,5,x+2*st,y,wd,wd)
	sspr(32,0,5,5,x+3*st,y,wd,wd)
	sspr(40,0,5,5,x+4*st,y,wd,wd)
end

function d_rscore(s,x,y,ml)
	local t={}
	local ss=tostr(s)
	while #ss>0 do
		local ns=sub(ss,1,1)
		if ns=="0" then add(t,{48,0})
		elseif ns=="1" then add(t,{56,0})
		elseif ns=="2" then add(t,{64,0})
		elseif ns=="3" then add(t,{72,0})
		elseif ns=="4" then add(t,{80,0})
		elseif ns=="5" then add(t,{88,0})
		elseif ns=="6" then add(t,{96,0})
		elseif ns=="7" then add(t,{104,0})
		elseif ns=="8" then add(t,{112,0})
		elseif ns=="9" then add(t,{120,0})		
		end
		ss=sub(ss,2,#ss)
	end
	local wd=5*ml
	local st=5*ml+1*ml
	for i=1,#t do
		sspr(t[i][1],t[i][2],5,5,x-(#t-i+1)*st,y,wd,wd)
	end
end
-->8
--draw lines
dots={
	{0,24},
	{20,64,7},
	{107,64,7},
	{127,104,7}
	}
function d_lines()
	dp_lines(dots)
end
function dp_lines(dt)
	for i=2,#dt do
		line(dt[i-1][1],dt[i-1][2],
			dt[i][1],dt[i][2],dt[i][3])
	end
end

-->8
--draw background
function d_bk()
	rectfill(0,0,127,23,8)
	rectfill(0,105,127,127,3)
	rectfill(20,24,127,63,8)
	rectfill(0,65,107,104,3)
	dp_bk(19,40,8)
	dp_bk(127,70,8)
	dp_bk(0,40,3)
	dp_bk(110,90,3)
end

function dp_bk(sx,sy,cl)
	local fr={{sx,sy}}
	local v={}
	while #fr>0 do
		--print(#fr)
		local nx=fr[1][1]
		local ny=fr[1][2]
		pset(nx,ny,cl)
		del(fr,fr[1])
		if pget(nx-1,ny)<=0 and nx>0 and not lookup(fr,{nx,ny})then
			add(fr,{nx-1,ny}) end
		if pget(nx+1,ny)<=0 and nx<127 and not lookup(fr,{nx,ny}) then
			add(fr,{nx+1,ny}) end
		if pget(nx,ny-1)<=0 and ny>0 and not lookup(fr,{nx,ny}) then
			add(fr,{nx,ny-1}) end
		if pget(nx,ny+1)<=0 and ny<127 and not lookup(fr,{nx,ny}) then
			add(fr,{nx,ny+1}) end
	end
end

function lookup(tb,v)
	for i=1,#tb do
		if tb[i][1]==v[1] and tb[i][2]==v[2] then
			return true
		end
	end
	return false
end
__gfx__
00000000777770007000700077777000777770007770700077777000007000007777700077777000700070007777700077777000777770007777700077777000
00000000700000007000700070007000007000007070700070007000007000000000700000007000700070007000000070000000000070007000700070007000
00700700700000007777700070007000007000007070700070007000007000007777700077777000777770007777700077777000000070007777700077777000
00077000700000007000700077777000007000007070700070007000007000007000000000007000000070000000700070007000000070007000700000007000
00077000777770007000700070007000777770007077700077777000007000007777700077777000000070007777700077777000000070007777700077777000
