pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--connect 5
--by bob1996w
function new_board()
	local bd={}
	for i=1,18 do
		local row={}
		for j=1,18 do
			add(row,0)
		end
		add(bd,row)
	end
	return bd
end
-->8
--draws

function d_board()
	rectfill(0,0,127,127,15)
	rect(4,4,123,123,5)
	for i=4,123,7 do
		line(i,4,i,123,5)
		line(4,i,123,i,5)
	end
	for by=1,18 do
		for bx=1,18 do
			d_dotb(bd[by][bx],bx,by)
		end
	end
end

function d_dotb(s,bx,by)
	pal(1,0)
	spr(s+1,bc2sc(bx),bc2sc(by))
	pal()
end
function d_dot(s,x,y)
	pal(1,0)
	spr(s+1,x,y)
	pal()
end
function d_curm(s,x,y)
	pal(1,0)
	spr(s+15,x,y)
	pal()
end
function d_curs(s,bx,by)
	pal(1,0)
	spr(s+17,bc2sc(bx),bc2sc(by))
	pal()
end
function d_cur_inv(s,bx,by)
	spr(20,bc2sc(bx),bc2sc(by))
end
--put effect
function d_peff(s,bx,by)
	spr(4,bc2sc(bx)-3,bc2sc(by)-3)
	spr(5,bc2sc(bx)+4,bc2sc(by)+4)
end
-->8
--main
function _init()
	debug=false
	poke(0x5f2d,1)
	dr_i(debug)
	s_game()
end

function s_game()
	_update=u_game
	_draw=d_game
	i_game()
end
function i_game()
	bd=new_board()
	pl=1
	pl_max=2
	ns={bx=9,by=9}--current selection
	m_last=false
	invalid=false--indicate invalid move
end
function u_game()
	cls()
	invalid=false
	m=get_mouse(m_last)
	m_last=m.cn
	ns.bx=m.bx
	ns.by=m.by
	if bd[ns.by][ns.bx]==0 then
		if m.c then
			d_ani_put(pl,ns.bx,ns.by)
			bd[ns.by][ns.bx]=pl
			pl+=1
			if pl>pl_max then
				pl=1
			end
		end
	else
		invalid=true
	end
end

function d_game()
	d_board()
	if invalid then
		d_cur_inv(pl,ns.bx,ns.by)
	else
		d_curs(pl,ns.bx,ns.by)
	end
	d_curm(pl,m.x,m.y)
	dr_u(debug)
end

--where does each pl dot fly from
ani_s={
	{bx=21,by=21},
	{bx=-2,by=-2}
}
function d_ani_put(pl,bx,by)
	local tm=0
	local tmax=15
	while tm<tmax do
		cls()
		d_board()
		d_dot(pl,
			bc2sc(ani_s[pl].bx)+(bc2sc(bx)-bc2sc(ani_s[pl].bx))*tm/tmax,
			bc2sc(ani_s[pl].by)+(bc2sc(by)-bc2sc(ani_s[pl].by))*tm/tmax
		)
		flip()
		tm+=1
	end
	for i=1,2 do
		cls()
 	d_board()
 	d_dotb(pl,bx,by)
		d_peff(pl,bx,by)
		flip()
	end
end
-->8
--utility
function dr_i(s)
if s then
poke(0x5f2d,1)
dr_t=0
end
end
function dr_u(s)
if s then
dr_t=dr_t==0 and 1 or 0
dr_x=stat(32)
dr_y=stat(33)
dr_c=dr_t==0 and 5 or 7
line(0,dr_y,127,dr_y,dr_c)
line(dr_x,0,dr_x,127,dr_c)
dr_x1=dr_x<64 and dr_x+2 or dr_x-14
dr_y1=dr_y<64 and dr_y+2 or dr_y-14
rectfill(dr_x1,dr_y1,dr_x1+12,dr_y1+12,7)
print(dr_x,dr_x1+1,dr_y1+1,5)
print(dr_y,dr_x1+1,dr_y1+7)
end
end
function get_mouse(m_last)
	local x=stat(32)
	local y=stat(33)
	local cl=stat(34)
	local cn=stat(34)>0
	local c=false
	if (not m_last)and cn then
	 c=true
	else
		c=false
	end
	return {
		x=stat(32),
		y=stat(33),
		bx=c2bc(x),
		by=c2bc(y),
		c=c,
		cn=cn}
end
--x to bx, y to by
function c2bc(c)
	local r=flr((c-3)/7)+1
	if(r>18)r=18
	if(r<1)r=1
	return r
end
--get sprite draw coords
function bc2sc(bc)
	return 1+(bc-1)*7
end
__gfx__
00000000000000000000000000000000090090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000077700000111000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000711170001777100090090900000009900000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000711170001777100990999000009990900000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000711170001777100999000009900990900000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000077700000111000900000000090909900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000099909900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000
77000000110000007770777011101110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
71700000171000007000007010000010080008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
71170000177100007011107010777010008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
71117000177710000011100000777000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
71177000177110007011107010777010008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700000111000007000007010000010080008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007770777011101110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
