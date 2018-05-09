pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--a test cart fot
--touch screen use-ability

function _init()
	poke(0x5f2d,1)
end

last=0
function getmousestat()
	local thisstat={
		c=stat(34),
		x=stat(32),
		y=stat(33),
		initclick=false
	}
	if last<=0 and thisstat.c>0 then
		thisstat.initclick=true
	else
		thisstat.initclick=false
	end
	last=thisstat.c
	return thisstat
end

function _update()
	m=getmousestat()
	if m.initclick then
		print(m.c.." "..m.x.." "..m.y)
	end
end

function _draw()
	
end
