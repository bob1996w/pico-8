pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function fib(n)
	if n==0 then return 0
	elseif n==1 then return 1
	else return fib(n-1)+fib(n-2)
	end
end
for i=1,40 do
	print(""..i..":"..fib(i))
end
