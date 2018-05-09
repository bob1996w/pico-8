pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--a simple file explorer in
--pico-8, which make no sense

function _init()
	
end

function _update()

end

function _draw()
	cls()
	draw_ui()
	print_dummy(1,0,0)
	print_dummy(30,0,8)
end
-->8
function print_all()
	dirlist=ls()
	for k,v in pairs(dirlist) do
		print(k.." "..v)
	end
end

function draw_ui()
	line(0,6,127,6,7)
	line(0,121,127,121,7)
end

function print_dummy(n,x,y)
	for i=1,n do
		print(i.." dummy",x,y+(i-1)*6)
	end
end
