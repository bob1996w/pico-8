pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
x=6y=6l={{8,8}}d=1m=128s=pset::a::cls()
h=l[1]for i=0,3 do if(btn(i))d=i end
if(x==h[1]and y==h[2])add(l,{l[#l][1],l[#l][2]})x=flr(rnd(m))y=flr(rnd(m))
for i=#l,2,-1 do j=l[i]j[1]=l[i-1][1] j[2]=l[i-1][2]s(j[1],j[2])end
r=d<2 and 1or 2h[r]=d%2==0 and(h[r]-1)%m or(h[r]+1)%m
s(x,y)s(h[1],h[2])flip()goto a
