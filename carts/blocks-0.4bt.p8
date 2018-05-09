pico-8 cartridge // http://www.pico-8.com
version 11
__lua__
--a tetris, you know.
--
--this version is for testing purposes.
--initpos={x=4,y=3}
version="v0.4b_test"
spd_drop={60,50,40,35,30,27,24,21,18,15,12,10,8,6,5,4,3,2,1,0}
spd_lock={50}
t=true
f=false
debug=f
--[[
block icons can be changed
spr in {none, i,j,l,o,s,t,z} order
then by their ghost pieces
each has 8 consecutive colors
blkicons[n]->spr[n+0 .. n+7]
--]]

blkicons={0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120}
--[[
playarea:
  x,y=the top left coord
  h,w=how many blocks
  sh=viewable area start
  h~=hold area
  n~=next area
  playarea=5~24
  hc=hold color
  nc=next color
--]]
pa={x=31,y=4,h=24,w=10,sh=5,
    hx=2,hy=10,hw=27,hh=20,
    nx=92,ny=10,nw=27,nh=60,
    hc=13,nc=7}
--[[
settings:
  spin:
    true:o for counter-clockwise
         x for clockwise
    spin  btnp  bool output
    ====  ====  ==== ======
    true   4      t  false (cc)
    true   5      f  true  (c)
    false  4      t  true  (c)
    false  5      f  false (cc)
  s_~:
    set skin for each dsiplay:
      [1]: the piece you are controlling
      [2]: the play area pieces
      [3]: the holding piece
      [4]: the next pieces
      [5]: the ghost piece
  viewnext:
    how much "next" blocks can be seen
  displine:
    display lines that will be deleted


  setdisp:
    each of option display
    {hint, true, false}
    {hint, 0, 1, 2, 3}
--]]
set={
  selcolor=9,
  notselcolor=7,
  spin=t,
  viewnext=3,
  hold=true,
  skin={1,1,1,1,2},
  harddrop=true,
  blkcnt=true,
  startframe=60,
  lockspeed=f
}
setdisp={
  {"start frame :"},
  {"lock speed :","unused","unused"},
  {"rotation :","\x8e=counterclk","\x8e=clockwise"},
  {"next blocks :","hidden","1","2","3"},
  {"hold :","on","off"},
  {"hard drop :","on","off"},
  {"block counter :","on","off"}
}
skindisp={"now :"," board :","hold :","next :","ghost :"}

block={
  {
    --i
    sp=1,
    s=4,
    rot=1,
    b={
      {{f,f,f,f},{t,t,t,t},{f,f,f,f},{f,f,f,f}},
      {{f,f,t,f},{f,f,t,f},{f,f,t,f},{f,f,t,f}},
      {{f,f,f,f},{f,f,f,f},{t,t,t,t},{f,f,f,f}},
      {{f,t,f,f},{f,t,f,f},{f,t,f,f},{f,t,f,f}}
    }
  },
  {
    --j
    sp=2,
    s=3,
    rot=1,
    b={
      {{t,f,f},{t,t,t},{f,f,f}},
      {{f,t,t},{f,t,f},{f,t,f}},
      {{f,f,f},{t,t,t},{f,f,t}},
      {{f,t,f},{f,t,f},{t,t,f}}
    }
  },
  {
    --l
    sp=3,
    s=3,
    rot=1,
    b={
      {{f,f,t},{t,t,t},{f,f,f}},
      {{f,t,f},{f,t,f},{f,t,t}},
      {{f,f,f},{t,t,t},{t,f,f}},
      {{t,t,f},{f,t,f},{f,t,f}}
    }
  },
  {
    --o
    sp=4,
    s=2,
    rot=1,
    b={
      {{t,t},{t,t}},
      {{t,t},{t,t}},
      {{t,t},{t,t}},
      {{t,t},{t,t}}
    }
  },
  {
    --s
    sp=5,
    s=3,
    rot=1,
    b={
      {{f,t,t},{t,t,f},{f,f,f}},
      {{f,t,f},{f,t,t},{f,f,t}},
      {{f,f,f},{f,t,t},{t,t,f}},
      {{t,f,f},{t,t,f},{f,t,f}}
    }
  },
  {
    --t
    sp=6,
    s=3,
    rot=1,
    b={
      {{f,t,f},{t,t,t},{f,f,f}},
      {{f,t,f},{f,t,t},{f,t,f}},
      {{f,f,f},{t,t,t},{f,t,f}},
      {{f,t,f},{t,t,f},{f,t,f}}
    }
  },
  {
    --z
    sp=7,
    s=3,
    rot=1,
    b={
      {{t,t,f},{f,t,t},{f,f,f}},
      {{f,f,t},{f,t,t},{f,t,f}},
      {{f,f,f},{t,t,f},{f,t,t}},
      {{f,t,f},{t,t,f},{t,f,f}}
    }
  }
}

--preset tiles
ptiles={
  {
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    --10 lines
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {1,1,1,1,1,1,1,1,0,0},
    {1,1,1,1,1,1,1,0,0,0},
    {1,1,1,1,1,1,1,0,1,1},
    {1,1,1,1,1,1,1,0,0,1},
    {1,1,1,1,1,1,1,0,1,1}
  },
  {

  }
}

--se library
se={
  --spin clockwise
  spinc=1,
  --spin counterclk.
  spinr=1,
  --hard drop
  dhard=2,
  --softdrop
  dsoft=0,
  --hold switch
  hold=3,
  --move
  move=8,
  --clr line
  clrl=9,

  musica=0
}

--settings start draw y
sety=15
--skin sel start draw y
skiny=70


--the conrtol tweaks
--how many frames between each movement
ctrl={
  down=4,
  lefts=8,
  left=4,
  rights=8,
  right=4
}
--frame until next move
t_d=ctrl.down
--if the button was pressed on last frame
dlast=false
t_l=ctrl.lefts
llast=false
--if the initial time has passed
lstart=false
t_r=ctrl.rights
rlast=false
lstart=false


function _init()
  poke(0x5f80,1)
  cartdata("bob_blocks")
		--inithi()
  t=0
  sel=1
  s_menu()
end

function s_menu()
  hiboard=readhi()
  _update60=u_menu
  _draw=d_menu
end

function u_menu()
  --call s_game
  t+=1
  if(btnp(2) and sel>1)sel-=1
  if(btnp(3) and sel<#setdisp+5)sel+=1

  if sel==1 then
    if(btnp(0) and set.startframe>0)set.startframe-=1
    if(btnp(1) and set.startframe<120)set.startframe+=1
  elseif sel==2 then
    if(btnp(0) or btnp(1))set.lockspeed=not set.lockspeed
  elseif sel==3 then
    if(btnp(0) or btnp(1))set.spin=not set.spin
  elseif sel==4 then
    if(btnp(0) and set.viewnext>0)set.viewnext-=1
    if(btnp(1) and set.viewnext<3)set.viewnext+=1
  elseif sel==5 then
    if(btnp(0) or btnp(1))set.hold=not set.hold
  elseif sel==6 then
    if(btnp(0) or btnp(1))set.harddrop=not set.harddrop
  elseif sel==7 then
    if(btnp(0) or btnp(1))set.blkcnt=not set.blkcnt
  elseif sel>=#setdisp+1 and sel<=#setdisp+5 then
    if(btnp(0))then set.skin[sel-#setdisp]-=1 end
    if(btnp(1))then set.skin[sel-#setdisp]+=1 end
    if(set.skin[sel-#setdisp]<1)set.skin[sel-#setdisp]=#blkicons
    if(set.skin[sel-#setdisp]>#blkicons)set.skin[sel-#setdisp]=1
  end

  if(btnp(4))s_game()
  if(btnp(5))s_control()
end

function d_menu()
  cls()
  print("simple blocks",37,0,10)
  line(0,6,127,6,10)
  drawsettings(sel)
  drawskins(sel)
  line(0,121,127,121,10)
  print("\x8estart \x97others",33,123,10)
  rprint(version,127,0,12)
end

function drawsettings(sel)
  print("options",48,13,7)
  local nowopt={set.startframe,set.lockspeed,set.spin,set.viewnext,set.hold,set.harddrop,set.blkcnt}
  for i=1,#setdisp do
    local nowcolor=7
    if i==sel then
      nowcolor=set.selcolor
    else
      nowcolor=set.notselcolor
    end
    rprint(setdisp[i][1],64,sety+i*6,nowcolor)
    if i==1 then
      print(nowopt[i],69,sety+i*6,nowcolor)
    elseif i==4 then
      print(setdisp[i][nowopt[i]+2],69,sety+i*6,nowcolor)
    else
      if nowopt[i] then
        print(setdisp[i][2],69,sety+i*6,nowcolor)
      else
        print(setdisp[i][3],69,sety+i*6,nowcolor)
      end
    end
  end
end

function drawskins(sel)
  print("skins",52,68,7)
  for i=1,#set.skin do
    local nowcolor=7
    if i+#setdisp==sel then
      nowcolor=set.selcolor
    else
      nowcolor=set.notselcolor
    end
    rprint(skindisp[i],46,skiny+8*i,nowcolor)
    print(set.skin[i],51,skiny+8*i,nowcolor)
    spr(blkicons[set.skin[i]],60,skiny+8*i,8,1)
  end
end

function rprint(s,x,y,c)
  print(s,x-#s*4+1,y,c)
end

function s_control()
  ctrlpage=1
  _update60=u_control
  _draw=d_control
end

function u_control()
  if(btnp(0) and ctrlpage==2)ctrlpage=1
  if(btnp(1) and ctrlpage==1)ctrlpage=2
  if(btnp(5) and (ctrlpage==1 or ctrlpage==2))s_menu()
  if(btnp(2) and ctrlpage==1)ctrlpage=3
  if btnp(4) and ctrlpage==3  then
    inithi()
    hiboard=readhi()
    ctrlpage=1
  end
  if(btnp(5) and ctrlpage==3)ctrlpage=1
end

function d_control()
  cls()
  line(0,6,127,6,10)
  --nprint({52,53,54,3,4,5},0,0,9)

  line(0,121,127,121,10)
  if ctrlpage==1 then
    print("highscore",45,0,10)
    print("\x94clear data",0,123,8)
    rprint("controls\x91 ",127,123,10)
    print("\x97back",52,123,10)
    --print("under construction",27,62,7)
    disphi(hiboard,10)
  elseif ctrlpage==2 then
    print("controls",48,0,10)
    print("\x8bhighscore",0,123,10)
    print("\x97back",52,123,10)
    for i=1,#controlmes do
      print(controlmes[i][1],0,9+(i-1)*6,controlmes[i][2])
    end
    print("* the rotating direction can be",0,109,11)
    print("  set in options",0,115,11)
  elseif ctrlpage==3 then
    rect(20,50,107,77,8)
    print("really?",50,52,10)
    print("clear all highscores?",22,58,10)
    print("\x8eyes,wipe them all.",22,65,8)
    print("\x97no,take me back.",22,71,7)
  end
end

controlmes={
  {"\x8b(left arrow,s) : move left",7},
  {"\x91(right arrow,f) : move right",7},
  {"\x94(up arrow,e) : hard drop",7},
  {"\x83(down arrow,d) : soft drop",7},
  {"\x8e(z,c,n) : rotation 1",11},
  {"\x97(x,v,m) : rotation 2",11},
  {"tab,left shift : hold",7}
}

function initgame()
  holdstat=false
  b=initboard()
  --bags of next blocks
  bag=newbag()
  --now piece
  np=nextblk()
  hold=0
  gh=getghost(np)
  dummytile()
  --presettile(ptiles[1])
  --frames to next auto drop
  t_drop=set.startframe
  --frames to lock piece
  t_lock=spd_lock[1]
  sc={
    --score in 32-bit integer
    s=0,
    --level
    level=set.startlevel,
    --lines
    lines=0,
    --lines to next level
    nextlines=0,
    --combo
    combo=-1
    --all indicators
  }
  --block counter
  blkcnt={0,0,0,0,0,0,0}
  music(se.musica)
end

--fill board with empty slots
function initboard()
  local b={}
  for i=1,pa.h+4 do
    local br={}
    for j=1,pa.w do
      add(br,0)
    end
    add(b,br)
  end
  return b
end

--produces a new bag of blocks
--* should be called when bag<4
function newbag()
  local bg={1,2,3,4,5,6,7}
  local newbg={}
  while #bg>0 do
    local n=flr(rnd(#bg))+1
    add(newbg,bg[n])
    del(bg,bg[n])
  end
  return newbg
end

function s_game()
  initgame()
  cls()
  d_game()
  for i=1,60 do
    flip()
  end
  _update60=u_game
  _draw=d_game
end

function u_game()
  if scangameover() then
    s_gameover()
  end
  if np.sp==nil then
    np=nextblk()
  end
  controls()
  gh=getghost(np)
  updatetimer()
  if t_lock<=0 then
    blockplaced()
    deln=detectlines(b)
    sfx(se.dhard)
    if #deln>0 then
      sfx(se.clrl)
      sc.combo+=1
      removelines(deln)
      calcs(#deln,sc)
      sc.lines+=#deln
      sc.nextlines+=#deln
      --[[
      if not set.lockspeed and sc.nextlines>=10 and sc.level<20 then
        sc.nextlines-=10
        sc.level+=1
      end
      --]]
    else
      sc.combo=-1
    end
  end
end

function d_game()
  cls()
  drawframe()
  --print(#b.." "..#b[1],0,60,8)
  drawboard()
  drawghost()
  if np.sp!=nil then
    drawblk(np,pa.x+(np.x-1)*6,pa.y+(np.y-1)*6,1)
  end
  drawhold()
  drawnext()
  --print(stat(0),2,120,7)
  if debug then
    print(np.x.." "..np.y,3,50,7)
    print(gh.x.." "..gh.y,3,56,7)
    print("rot "..np.rot,3,62,7)
    print(""..spd_drop[sc.level],3,68,7)
  end
  rprint("frm:"..set.startframe,125,80,11)
  rprint("s: -1",125,86,7)
  rprint("f: +1",125,92,7)
  rprint("e: +5",125,98,7)
  rprint("d: -5",125,104,7)
end

function drawframe()
  --play area
  rect(0,0,127,127,7)
  rect(pa.x-1,pa.y-1,pa.x+pa.w*6,pa.y+(pa.h-pa.sh+1)*6,6)
  --hold area
  rect(pa.hx,pa.hy,pa.hx+pa.hw,pa.hy+pa.hh,pa.hc)
  print("hold",pa.hx+(pa.hw/2)-7,pa.hy-7,pa.hc)
  --next area
  rect(pa.nx,pa.ny,pa.nx+pa.nw,pa.ny+pa.nh,pa.nc)
  print("next",pa.nx+(pa.nw/2)-7,pa.ny-7,pa.nc)
  --score
  rprint("score",125,113,7)
  rprint(gets(sc.s),125,119,7)
  --combo
  if sc.combo>0 then
    rprint(""..sc.combo,pa.x-2,34,9)
    rprint("combo!",pa.x-2,40,9)
  end
  --level
  --rprint("lv "..sc.level,pa.x-2,113,7)
  --total lines
  rprint("ln "..sc.lines,pa.x-2,119,7)
  if(set.blkcnt)drawblkcnt(2,64,pa.x-2)
end

function drawblkcnt(x1,y1,x2)
  rect(x1,y1,x2,y1+44,3)
  for i=1,7 do
    spr(192+i,x1+2,y1+1+(i-1)*6)
    rprint(""..blkcnt[i],x2-2,y1+2+(i-1)*6,7)
  end
end

function drawblk(blk,x,y,type)
  local rot=1
  if(type==1 or type==5)rot=blk.rot
  for r=1,blk.s do
    for c=1,blk.s do
      if blk.b[rot][r][c] then
        if (type==1 or type==5) then
          if blk.y+r-1>=pa.sh then
            spr(blkicons[set.skin[type]]+blk.sp,x+(c-1)*6,y+(r-1-(pa.sh-1))*6)
          end
        else
          spr(blkicons[set.skin[type]]+blk.sp,x+(c-1)*6,y+(r-1)*6)
        end
      end
    end
  end
  --spr(192,x,y)
end

function drawboard()
  for r=pa.sh,pa.h do
    for c=1,pa.w do
      spr(blkicons[set.skin[2]]+b[r][c],(c-1)*6+pa.x,(r-1-(pa.sh-1))*6+pa.y)
    end
  end
end

function drawnext()
  if set.viewnext==0 then return end
  if set.viewnext>=3 then
    drawblk(block[bag[3]],pa.nx+2,pa.ny+44,4) end
  if set.viewnext>=2 then
    drawblk(block[bag[2]],pa.nx+2,pa.ny+24,4) end
  if set.viewnext>=1 then
    drawblk(block[bag[1]],pa.nx+2,pa.ny+4,4) end
end

function drawhold()
  if hold!=0 then
    drawblk(block[hold],pa.hx+2,pa.hy+4,3)
  end
  if not set.hold then
    local dist=min(pa.hw,pa.hh)
    line(pa.hx+pa.hw,pa.hy,pa.hx+pa.hw-dist,pa.hy+dist,pa.hc)
    line(pa.hx,pa.hy+pa.hh,pa.hx+dist,pa.hy,pa.hc)
  end
end

function drawghost()
  drawblk(gh,pa.x+(gh.x-1)*6,pa.y+(gh.y-1)*6,5)
end

function nextblk()
  local next=copyblk(block[bag[1]])
  del(bag,bag[1])
  if #bag<4 then
    local nb=newbag()
    while #nb>0 do
      add(bag,nb[1])
      del(nb,nb[1])
    end
  end
  local npos=initpos(next.sp)
  next.x=npos.x
  next.y=npos.y
  next.rot=1
  holdstat=false
  return next
end

function initpos(sp)
  local pos={x=0,y=0}
  if pos.sp==1 then
    pos.x=4
  elseif pos.sp==4 then
    pos.x=5
  else
    pos.x=4
  end
  pos.y=3
  return pos
end

--[[
move the block
0:left
1:right
2:hard drop
3:soft drop
4:for when t_drop=0, instant to ghost, but don't set t_lock
userc: user controlled the block(for scoring)
--]]
function moveblk(mv,userc)
  local new=copyblk(np)
  if mv==0 then
    new.x-=1
    if not (sidecoll(new) or boardcoll(new) )then
      np.x-=1
      if(userc)sfx(se.move)
    end
  elseif mv==1 then
    new.x+=1
    if not (sidecoll(new) or boardcoll(new)) then
      np.x+=1
      if(userc)sfx(se.move)
    end
  elseif mv==2 then
    if (userc!=nil)adds(abs(gh.y-np.y),2)
    np.x=gh.x
    np.y=gh.y
    t_lock=1
  elseif mv==3 then
    if not (np.x==gh.x and np.y==gh.y) then
      np.y+=1
      if(userc!=nil)adds(1)
    end
  elseif mv==4 then
    np.x=gh.x
    np.y=gh.y
  end
  gh=getghost(np)
end

--[[
spin the block
true:clockwise
false:counterclockwise
--]]
function spinblk(spn)
  --[[
  if spn then
    np.rot+=1
    if(np.rot>4)np.rot=1
  else
    np.rot-=1
    if(np.rot<1)np.rot=4
  end
  local s=sidecoll(np)
  while s!=nil do
    if s==1 then
      np.x+=1
      s=sidecoll(np)
    elseif s==2 then
      np.x-=1
      s=sidecoll(np)
    end
  end
  --]]
  np=wallkick(np,np.rot,nextrot(np.rot,spn))
end

function nextrot(rot,spn)
  local rotr=rot
  if spn then
    rotr+=1
    if(rotr>4)rotr=1
  else
    rotr-=1
    if(rotr<1)rotr=4
  end
  return rotr
end

wallkickdata={
  --i
  {
    {
      --0->0
      {},
      --0->1
      {{0,0},{-2,0},{1,0},{-2,1},{1,-2}},
      --0->2
      {},
      --0->3
      {{0,0},{-1,0},{2,0},{-1,-2},{2,1}}
    },
    {
      --1->0
      {{0,0},{2,0},{-1,0},{2,-1},{-1,2}},
      {},
      {{0,0},{-1,0},{2,0},{-1,-2},{2,1}},
      {}
    },
    {
      -->2->0
      {},
      {{0,0},{1,0},{-2,0},{1,2},{-2,-1}},
      {},
      {{0,0},{2,0},{-1,0},{2,-1},{-1,2}}
    },
    {
      {{0,0},{1,0},{-2,0},{1,2},{-2,-1}},
      {},
      {{0,0},{-2,0},{1,0},{-2,1},{1,-2}},
      {}
    }
  },
  --j,l,s,t,z
  {
    {
      --0->0
      {},
      {{0,0},{-1,0},{-1,-1},{0,2},{-1,2}},
      {},
      {{0,0},{1,0},{1,-1},{0,2},{1,2}}
    },
    {
      --1->0
      {{0,0},{1,0},{1,-1},{0,2},{1,2}},
      {},
      {{0,0},{1,0},{1,1},{0,-2},{1,-2}},
      {}
    },
    {
      --2->0
      {},
      {{0,0},{-1,0},{-1,-1},{0,2},{-1,2}},
      {},
      {{0,0},{1,0},{1,-1},{0,2},{1,2}}
    },
    {
      --3->0
      {{0,0},{-1,0},{-1,1},{0,-2},{-1,-2}},
      {},
      {{0,0},{-1,0},{-1,1},{0,-2},{-1,-2}},
      {}
    }
  }
}
--check if wallkick works when rot1 -> rot2
function wallkick(blk,rot1,rot2)
  if blk.sp==1 then
    --i
    for test=1,5 do
      local testblk=copyblk(blk)
      testblk.rot=rot2
      testblk.x+=wallkickdata[1][rot1][rot2][test][1]
      testblk.y+=wallkickdata[1][rot1][rot2][test][2]
      if not (boardcoll(testblk) or sidecoll2bin(testblk) )then
        return testblk
      end
    end
    return blk
  elseif blk.sp==4 then
    return blk
  else
    --j, l, s, t, z
    for test=1,5 do
      local testblk=copyblk(blk)
      testblk.rot=rot2
      testblk.x+=wallkickdata[2][rot1][rot2][test][1]
      testblk.y+=wallkickdata[2][rot1][rot2][test][2]
      if not ( boardcoll(testblk) or sidecoll2bin(testblk) )then
        return testblk
      end
    end
    return blk
  end
end

function holdblk()
  if hold==0 then
    hold=np.sp
    np=nextblk()
    sfx(se.hold)
    holdstat=true
  elseif holdstat==false then
    sfx(se.hold)
    local temp=hold
    hold=np.sp
    holdstat=true
    np=copyblk(block[temp])
    local npos=initpos(np.sp)
    np.x=npos.x
    np.y=npos.y
    np.rot=1
  end
end

function getghost(blk)
  local gho=copyblk(blk)
  for r=blk.y,pa.h do
    gho.y=r
    if boardcoll(gho) then
      gho.y-=1
      break
    end
  end
  return gho
end

function controls()
  --lastposition: for determine whether sound should play
  local lp
  --left
  if btn(0,0) then
    if not llast then
      moveblk(0,t)
      llast=true
      t_l-=1
    elseif not lstart and t_l<0 then
      t_l=ctrl.left
      lstart=true
      moveblk(0,t)
    elseif lstart and t_l<0 then
      t_l=ctrl.left
      moveblk(0,t)
    else
      t_l-=1
    end
  else
    t_l=ctrl.lefts
    llast=false
    lstart=false
  end
  --right
  if btn(1,0) then
    if not rlast then
      moveblk(1,t)
      rlast=true
      t_r-=1
    elseif not rstart and t_r<0 then
      t_r=ctrl.right
      rstart=true
      moveblk(1,t)
    elseif rstart and t_r<0 then
      t_r=ctrl.right
      moveblk(1,t)
    else
      t_r-=1
    end
  else
    t_r=ctrl.rights
    rlast=false
    rstart=false
  end
  --hard
  if btnp(2,0) and set.harddrop then
    moveblk(2,t)
    sfx(se.dhard)
  end
  --soft
  if btn(3,0) then
    if not dlast then
      moveblk(3,t)
      sfx(se.dsoft)
      t_d-=1
      dlast=true
    elseif t_d<0 then
      t_d=ctrl.down
      moveblk(3,t)
    else
      t_d-=1
    end
  else
    t_d=ctrl.down
    dlast=false
  end
  --rotate1
  if btnp(4,0) then
    spinblk(xor(true,set.spin))
    se_spin(xor(true,set.spin))
  end
  --rotate2
  if btnp(5,0) then
    spinblk(xor(false,set.spin))
    se_spin(xor(false,set.spin))
  end
  --hold
  if btnp(4,1) and set.hold then
    holdblk()
  end
  --2p control changes speed
  if btnp(0,1) and set.startframe>0 then
    set.startframe-=1
  elseif btnp(1,1) and set.startframe<120 then
    set.startframe+=1
  elseif btnp(3,1) and set.startframe>4 then
    set.startframe-=5
  elseif btnp(2,1) and set.startframe<116 then
    set.startframe+=5
  end
end

function se_spin(spn)
  if spn then
    sfx(se.spinc)
  else
    sfx(se.spinr)
  end
end

function sidecoll2bin(blk)
  local r=sidecoll(blk)
  if r==nil then return false
  else return true end
end

function sidecoll(blk)
  for r=1,blk.s do
    for c=1,blk.s do
      if blk.b[blk.rot][r][c] then
        if blk.x+(c-1)<1 then
          return 1
        elseif blk.x+(c-1)>pa.w then
          return 2
        end
      end
    end
  end
  return nil
end

function boardcoll(blk)
  for r=1,blk.s do
    for c=1,blk.s do
      if blk.b[blk.rot][r][c] then
        if blk.y+r-1>pa.h then
          return true
        elseif (blk.x+(c-1)<1 or blk.x+(c-1)>pa.w) then
          return true
        elseif b[blk.y+r-1][blk.x+c-1]>0 then
          return true
        end
      end
    end
  end
  return false
end

function xor(x1,x2)
  if x1==x2 then return false
  else return true end
end

function copyblk(blk)
  local newblk={}
  newblk.sp=blk.sp
  newblk.s=blk.s
  newblk.b=blk.b
  if(blk.x!=nil)newblk.x=blk.x
  if(blk.y!=nil)newblk.y=blk.y
  if(blk.rot!=nil)newblk.rot=blk.rot
  return newblk
end

--calls when a block is locked on the board
function blockplaced()
  updateboard(np)
  blkcnt[np.sp]+=1
  np=nextblk()
  t_lock=spd_lock[1]
end

function updatetimer()
  if np.x==gh.x and np.y==gh.y then
    t_lock-=1
    t_drop=set.startframe
  else
    t_lock=spd_lock[1]
    t_drop-=1
    if set.startframe==0 then
      moveblk(4)
    elseif t_drop<=0 then
      moveblk(3)
      t_drop=set.startframe
    end
  end
end

function updateboard(blk)
  for r=1,blk.s do
    for c=1,blk.s do
      if blk.b[blk.rot][r][c]  then
        b[blk.y+r-1][blk.x+c-1]=blk.sp
      end
    end
  end
end

function detectlines(board)
  local lines={}
  for r=pa.h,1,-1 do
    local flag=true
    for c=1,pa.w do
      if board[r][c]<=0 then flag=false end
    end
    if flag then
      add(lines,r)
    end
  end
  return lines
end

function removelines(lines)
  for r in all(lines) do
    del(b,b[r])
  end

  b=prepend2board(#lines)
end

--prepend a new row to board
function prepend2board(n)
  local newb={}
  for i=1,n do
    local newr={}
    for c=1,pa.w do
      add(newr,0)
    end
    add(newb,newr)
  end
  for r in all(b) do
    add(newb,r)
  end
  return newb
end

function scangameover()
  for r=1,pa.sh-1 do
    for c=1,pa.w do
      if b[r][c]>0 then
        return true
      end
    end
  end
  return false
end

--for invisible bocks under the screen
function dummytile()
  for r=pa.h+1,pa.h+4 do
    for c=1,pa.w do
      b[r][c]=1
    end
  end
end

function presettile(tiles)
  for r=pa.sh,pa.h do
    for c=1,pa.w do
      if(tiles[r-4][c]>0)b[r][c]=tiles[r-4][c]
    end
  end
end

--calc score to add
function calcs(lines,sc)
  if lines==1 then
    adds(100,sc.level)
  elseif lines==2 then
    adds(300,sc.level)
  elseif lines==3 then
    adds(500,sc.level)
  elseif lines==4 then
    adds(800,sc.level)
  end
  if sc.combo>0 then
    if lines==1 then
      adds(20,sc.combo,sc.level)
    else
      adds(50,sc.combo,sc.level)
    end
  end
end
--add score and convert to 32-bit int
function adds(val,mul1,mul2)
  if(mul1==nil)mul1=1
  if(mul2==nil)mul2=1
  local s=shr(val,16)
  s*=mul1
  s*=mul2
  sc.s+=s
end

--get score
function gets(val)
  if(val==0)return "0"
  local s=""
  local v=abs(val)
  while (v!=0) do
    s=shl(v%0x0.000a,16)..s
    v/=10
  end
  if (val<0) s="-"..s
  return s
end

function s_gameover()
  t=0
  _update60=u_gameover
  _draw=d_gameover
end

function u_gameover()
  t+=1
  if btnp(4) then
    if checkhi(sc.s) then
      s_hi()
    else
      s_menu()
    end
    music(-1)
  end
end

function d_gameover()
  rectfill(pa.x+10,pa.y+16,pa.x+50,pa.y+26,0)
  rect(pa.x+10,pa.y+16,pa.x+50,pa.y+26,7)
  print("game over",pa.x+13,pa.y+19,t%16)
end

--[[
for persistent data
0x5e00~, 256 bytes
{name[8 bytes],score[4 bytes]}*5

--]]

c_da={sp=208}
c_zhong={sp=209}
c_tian={sp=210}
c_nul={sp=211}
chars={c_nul,"a","b","c","d",
"e","f","g","h","i","j","k",
"l","m","n","o","p","q","r",
"s","t","u","v","w","x","y",
"z","0","1","2","3","4","5",
"6","7","8","9",".",",","/",
"\\","\'","\"","!","@","#",
"$","%","^","&","*","+","=",
"(",")","[","]","{","}","~","`",
c_da,c_zhong,c_tian,"_","-"," "}

function savehi(tb)
  for i=1,5 do
    for j=1,8 do
      poke(0x5e00+(i-1)*12+j-1,tb[i][1][j])
    end
    --local score=tb[i][2]
    local sct=splitscore(tb[i][2])
    for j=1,4 do
      poke(0x5e00+(i-1)*12+j+7,sct[j])
    end
  end
end

function inithi()
  for i=1,5 do
    for j=1,12 do
      poke(0x5e00+(i-1)*12+j-1,0)
    end
  end
end

function readhi()
  local hitable={}
  for i=1,5 do
    local name={}
    for j=1,8 do
      local d=peek(0x5e00+(i-1)*12+j-1)
      add(name,d)
    end
    local s=0
    s+=shl(peek(0x5e00+(i-1)*12+8),8)
    s+=shr(peek(0x5e00+(i-1)*12+9),0)
    s+=shr(peek(0x5e00+(i-1)*12+10),8)
    s+=shr(peek(0x5e00+(i-1)*12+11),16)
    local item={}
    add(item,name)
    add(item,s)
    add(hitable,item)
  end
  return hitable
end

function disphi(tb,y)
  --print("highscores",x,y,7)
  --print(""..#tb,x+50,y,7)
  for i=1,#tb do
    nprint(tb[i][1],20,y+10*(i-1),7)
    rprint(gets(tb[i][2]),107,y+10*(i-1),7)
  end
end

function nprint(n,x,y,c)
  for i=1,#n do
    if type(chars[n[i]])=="string" then
      print(chars[n[i]],x+(i-1)*4,y,c)
    elseif type(chars[n[i]])=="table" then
      pal(7,c)
      spr(chars[n[i]].sp,x+(i-1)*4,y)
      pal()
    else
      print("-",x+(i-1)*4,y,c)
    end
  end
end

function checkhi(val)
  return val>hiboard[5][2]
end

function s_hi()
  add(hitable,{{0,0,0,0,0,0,0,0},0})
  hi_place=5
  hi_pos=1
  while sc.s>hiboard[hi_place-1][2] do
    for i=1,8 do
      hiboard[hi_place][1][i]=hiboard[hi_place-1][1][i]
    end
    hiboard[hi_place][2]=hiboard[hi_place-1][2]
    hi_place-=1
    if(hi_place==1)break
  end
  for i=1,8 do
    hiboard[hi_place][1][i]=#chars
  end
  hiboard[hi_place][2]=sc.s
  _update60=u_hi
  _draw=d_hi
end

function u_hi()
  if(btnp(0) and hi_pos>1)hi_pos-=1
  if(btnp(1) and hi_pos<8)hi_pos+=1
  if btnp(2) then
    if hiboard[hi_place][1][hi_pos]<=1 then
      hiboard[hi_place][1][hi_pos]=#chars
    else
      hiboard[hi_place][1][hi_pos]-=1
    end
  end
  if btnp(3) then
    if hiboard[hi_place][1][hi_pos]>=#chars then
      hiboard[hi_place][1][hi_pos]=1
    else
      hiboard[hi_place][1][hi_pos]+=1
    end
  end
  if btnp(4) then
    savehi(hiboard)
    s_menu()
  end
end

function d_hi()
  cls()
  local x=20
  local y=10
  print("high score!",40,0,10)
  line(0,6,127,6,10)
  disphi(hiboard,10)
  rect(x+4*(hi_pos-1)-1,y-1+10*(hi_place-1),x+4*(hi_pos)-1,y+5+10*(hi_place-1),8)
  line(0,121,127,121,10)
  print("\x94\x83chars",0,123,10)
  rprint("cursor\x8b\x91  ",127,123,10)
  print("\x8eok",56,123,10)
end

function splitscore(sc)
  local r={}
  local up=flr(sc)
  local down=shl(sc-flr(sc),16)
  add(r,flr(shr(up,8)))
  add(r,(up%0xff))
  add(r,flr(shr(down,8)))
  add(r,shr(down%0xff))
  return r
end

function saveset()

end

function readset()

end
__gfx__
00000000cccccc001111110099999900aaaaaa00bbbbbb002222220088888800000000000c0c0c0001010100090909000a0a0a000b0b0b000202020008080800
00000000cccccc001111110099999900aaaaaa00bbbbbb00222222008888880000000000c0c0c0001010100090909000a0a0a000b0b0b0002020200080808000
00000000cccccc001111110099999900aaaaaa00bbbbbb002222220088888800000000000c0c0c0001010100090909000a0a0a000b0b0b000202020008080800
00000000cccccc001111110099999900aaaaaa00bbbbbb00222222008888880000000000c0c0c0001010100090909000a0a0a000b0b0b0002020200080808000
00000000cccccc001111110099999900aaaaaa00bbbbbb002222220088888800000000000c0c0c0001010100090909000a0a0a000b0b0b000202020008080800
00000000cccccc001111110099999900aaaaaa00bbbbbb00222222008888880000000000c0c0c0001010100090909000a0a0a000b0b0b0002020200080808000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000c00000001000000090000000a0000000b00000002000000080000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccc001111110099999900aaaaaa00bbbbbb0022222200888888000000000000cc0000001100000099000000aa000000bb00000022000000880000
00000000c0000c001000010090000900a0000a00b0000b002000020080000800000000000c00c00001001000090090000a00a0000b00b0000200200008008000
00000000c0000c001000010090000900a0000a00b0000b00200002008000080000000000c0000c001000010090000900a0000a00b0000b002000020080000800
00000000c0000c001000010090000900a0000a00b0000b00200002008000080000000000c0000c001000010090000900a0000a00b0000b002000020080000800
00000000c0000c001000010090000900a0000a00b0000b002000020080000800000000000c00c00001001000090090000a00a0000b00b0000200200008008000
00000000cccccc001111110099999900aaaaaa00bbbbbb0022222200888888000000000000cc0000001100000099000000aa000000bb00000022000000880000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cc0000001100000099000000aa000000bb000000220000008800000000000077777700777777007777770077777700777777007777770077777700
0000000000cc0000001100000099000000aa000000bb000000220000008800000000000077777700777777007777770077777700777777007777770077777700
00000000cccccc001111110099999900aaaaaa00bbbbbb0022222200888888000000000077777700777777007777770077777700777777007777770077777700
00000000cccccc001111110099999900aaaaaa00bbbbbb0022222200888888000000000077777700777777007777770077777700777777007777770077777700
0000000000cc0000001100000099000000aa000000bb000000220000008800000000000077777700777777007777770077777700777777007777770077777700
0000000000cc0000001100000099000000aa000000bb000000220000008800000000000077777700777777007777770077777700777777007777770077777700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777007777770077777700777777007777770077777700777777000000000077777700777777007777770077777700777777007777770077777700
00000000700007007000070070000700700007007000070070000700700007000000000070000700700007007000070070000700700007007000070070000700
00000000707707007077070070770700707707007077070070770700707707000000000070000700700007007000070070000700700007007000070070000700
00000000707707007077070070770700707707007077070070770700707707000000000070000700700007007000070070000700700007007000070070000700
00000000700007007000070070000700700007007000070070000700700007000000000070000700700007007000070070000700700007007000070070000700
00000000777777007777770077777700777777007777770077777700777777000000000077777700777777007777770077777700777777007777770077777700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006665660066666600555555007777770055555500666666006666660000000000cc0000001100000000990000aaaa000000bbbb002222220088880000
000000006566660065555600566665007555570056666500677756006666660000000000cc0000001100000000990000aaaa000000bbbb002222220088880000
000000006666660065775600566665007555570056776500676656006655660000000000cc0000001100000000990000aaaa0000bbbb00000022000000888800
000000005666650065775600566665007555570056776500676656006655660000000000cc0000001100000000990000aaaa0000bbbb00000022000000888800
000000006656660065555600566665007555570056666500655556006666660000000000cc000000111100009999000000000000000000000000000000000000
000000006666560066666600555555007777770055555500666666006666660000000000cc000000111100009999000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c00cc00001100000009990000aa00000b0b0b000222000008008800000000007ccccc00788888007ccccc007ccccc007ccccc007ccccc0078888800
00000000cc0c000001ee1000009009000a00a0000b0b0b002000200088e2280000000000c7777c0087788800c77ccc00c7777c00c77ccc00c7777c0087788800
0000000000800c001e00e100090c0900a0440a00b0b0b00020e020000ee9200000000000c7777c0087888800c7cccc00c7777c00c7cccc00c7777c0087888800
000000000c0c80001011010090c090000a00a000b0b0b00020020000029ee00000000000c7777c0088888800cccccc00c7777c00cccccc00c7777c0088888800
00000000c0080000011110009009000000aa0000b3b3b30002000800822e880000000000c7777c0088888800cccccc00c7777c00cccccc00c7777c0088888800
00000000c0c00c000011000099900000000000003b3b3b00002280008800800000000000cccccc0088888800cccccc00cccccc00cccccc00cccccc0088888800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0c0c00080808000c0c0c000c0c0c000c0c0c000c0c0c00080808000000000000000000000000000000000000000000000000000000000000000000
00000000c000000080000000c0000000c0000000c0000000c0000000800000000000000000000000000000000000000000000000000000000000000000000000
0000000000000c000000080000000c0000000c0000000c0000000c00000008000000000000000000000000000000000000000000000000000000000000000000
00000000c000000080000000c0000000c0000000c0000000c0000000800000000000000000000000000000000000000000000000000000000000000000000000
0000000000000c000000080000000c0000000c0000000c0000000c00000008000000000000000000000000000000000000000000000000000000000000000000
00000000c0c0c00080808000c0c0c000c0c0c000c0c0c000c0c0c000808080000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0077000000000000000011009900000000aaaa0000bbbb0000220000888800000000000000000000000000000000000000000000000000000000000000000000
0077000000000000000011009900000000aaaa0000bbbb0000220000888800000000000000000000000000000000000000000000000000000000000000000000
77777700cccccccc111111009999990000aaaa00bbbb000022222200008888000000000000000000000000000000000000000000000000000000000000000000
77777700cccccccc111111009999990000aaaa00bbbb000022222200008888000000000000000000000000000000000000000000000000000000000000000000
00770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000070000007770000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700000777000000700000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000777000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000777000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000070000007070000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000d0d00dd0d000dd0000000066666666666666666666666666666666666666666666666666666666666666000000770077707070777000000000000007
70000000d0d0d0d0d000d0d000000060000000000000000000000000000000000000000000000000000000000006000000707070007070070000000000000007
70000000ddd0d0d0d000d0d000000060000000000000000000000000000000000000000000000000000000000006000000707077000700070000000000000007
70000000d0d0d0d0d000d0d000000060000000000000000000000000000000000000000000000000000000000006000000707070007070070000000000000007
70000000d0d0dd00ddd0ddd000000060000000000000000000000000000000000000000000000000000000000006000000707077707070070000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70dddddddddddddddddddddddddddd60000000000000000000000000000000000000000000000000000000000006777777777777777777777777777700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111110000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111110000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111110000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111110000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111110000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111110000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111111111111111110000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111111111111111110000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111111111111111110000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111111111111111110000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111111111111111110000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006701111111111111111110000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70d00000000000000000000000000d60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70dddddddddddddddddddddddddddd60000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000002222220000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000002222220000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000002222220000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000002222220000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000002222220000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000002222220000000000000700000007
70000000000000000000000000000060000000000000000000000000000009999990000000000000000000000006702222222222222222220000000700000007
70000000000000000000000000000060000000000000000000000000000009999990000000000000000000000006702222222222222222220000000700000007
70000000000000000000000000000060000000000000000000000000000009999990000000000000000000000006702222222222222222220000000700000007
70000000000000000000000000000060000000000000000000000000000009999990000000000000000000000006702222222222222222220000000700000007
70000000000000000000000000000060000000000000000000000000000009999990000000000000000000000006702222222222222222220000000700000007
70000000000000000000000000000060000000000000000000000000000009999990000000000000000000000006702222222222222222220000000700000007
70000000000000000000000000000060000000000000000009999999999999999990000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000009999999999999999990000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000009999999999999999990000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000009999999999999999990000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000009999999999999999990000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000009999999999999999990000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670000000bbbbbbbbbbbb0000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670000000bbbbbbbbbbbb0000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670000000bbbbbbbbbbbb0000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670000000bbbbbbbbbbbb0000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670000000bbbbbbbbbbbb0000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670000000bbbbbbbbbbbb0000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670bbbbbbbbbbbb0000000000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670bbbbbbbbbbbb0000000000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670bbbbbbbbbbbb0000000000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670bbbbbbbbbbbb0000000000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670bbbbbbbbbbbb0000000000000700000007
7000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000670bbbbbbbbbbbb0000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006700000000000000000000000000700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006777777777777777777777777777700000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000909090000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000009090900000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000909090000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000009090900000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000000909090000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000000000000009090900000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000909090909090909090000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000009090909090909090900000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000909090909090909090000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000009090909090909090900000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000000909090909090909090000000000000000000000006000000000000000000000000000000000007
70000000000000000000000000000060000000000000000009090909090909090900000000000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccccccccc0000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccccccccc0000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccccccccc0000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccccccccc0000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccccccccc0000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccccccccc0000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc0000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc0000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc0000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc0000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc0000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc0000000000000000006000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000000000cccccc6000000000000000000000000000000000007
7000000000000070007070000077006cccccccccccccccccccccccccccccccccccccccccc000000000000cccccc6000000000000000770077007707770777007
7000000000000070007070000007006cccccccccccccccccccccccccccccccccccccccccc000000000000cccccc6000000000000007000700070707070700007
7000000000000070007070000007006cccccccccccccccccccccccccccccccccccccccccc000000000000cccccc6000000000000007770700070707700770007
7000000000000070007770000007006cccccccccccccccccccccccccccccccccccccccccc000000000000cccccc6000000000000000070700070707070700007
7000000000000077700700000077706cccccccccccccccccccccccccccccccccccccccccc000000000000cccccc6000000000000007700077077007070777007
7000000000000000000000000000006cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000000007
7000000000000070007700000077706cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000777007
7000000000000070007070000070706cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000007007
7000000000000070007070000070706cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000777007
7000000000000070007070000070706cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000700007
7000000000000077707070000077706cccccccccccccccccccccccccccccccccccccccccc000000cccccccccccc6000000000000000000000000000000777007
70000000000000000000000000000066666666666666666666666666666666666666666666666666666666666666000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0102000036040320402e0402904024040200401e0401b040110400f0401500013000100000e0000b0000a00007000040000100000000000000000000000000000000000000000000000000000000000000000000
00020000180401b0401e04021040240402a0403004035040370401400016000190001d0001f00023000260002e000340003700031000000000000000000000000000000000000000000000000000000000000000
000200001c6401a640186401764016640146400000012600126001160011600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040000303703237034370353701d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d3001d300
010a00002835028350280002800023350280002435000000263500000028350263502435000000233500000021350213500000000000213500000024350000002835028350000000000026350000002435000000
010a00002335023350000000000023350000002435000000263502635000000000002835028350000000000024350243500000000000213502135000000000002135021350000000000023350000002435000000
010a000000000000002635026350000000000029350000002d3502d35000000000002b3500000029350000002d3502d3500000000000283500000028350000002835028350293502835026350000002435000000
010a00002335023350000000000023350000002435000000263502635000000000002835028350000000000024350243500000000000213502135000000000002135021350213502135000000000000000000000
000400002604026040260402604025000240002400023000220002200022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001025011250132501525017250182501a2501c2501f250232502625025100291002b1002b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001c7501c7501c7501c7001c7501c7501e7501e750207502075020750207501c7501c7501c7501c700187501875018750000001c7501c7501c750000001875018750187500000015750157501575000000
010a0000177501775017750000001c7501c7501c750000001475014750147500000017750177501775000000187501875018750000001c7501c7501c750000001575015750157501575015750157501575000000
010a00001d7501d7501d750000001d7501d7501d750000001a7501a7501a750000001a7501a7501a750000001c7501c7501c750000001c7501c7501c750000001875018750187500000015750157501575000000
010a00001c7501c7501c750000001c7501c7501c750000001a7501a7501a750000001775017750177500000018750187501875000000157501575015750157001575015750157501570015750157501575000000
010a00001c3501c3501c3501c3501c3501c3501c3501830018350183501835018350183501835018350173001a3501a3501a3501a3501a3501a3501a350153001735017350173501735017350173501735017300
010a00001835018350183501835018350183501835000000153501535015350153501535015350153500000014350143501435014350143501435014350000001735017350173501735017350173501735000000
010a0000183501835018350000001c3501c3501c3501c300213502135021350000002135021350213500000020350203502035020350203502035020350203502035020350203502035000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 04424344
00 054b4344
00 06424344
00 07424344
00 040a4344
00 050b4344
00 060c4344
00 070d4344
00 0e424344
00 0f424344
00 0e424344
02 10424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
