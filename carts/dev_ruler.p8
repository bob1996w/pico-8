pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--a ruler for measuring pixels
--by bob1996w
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

function _init()
dr_i(true)
end

function _update()
cls()
dr_u(true)
end
