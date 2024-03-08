pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
camera(0,0)

-- Define the player's position
player = { x= 64, y= 64, sprite= 1, step = 0, state = 0, look = nil }
farm = {}

Selector =  {}
Selector.__index = Selector

-- Una clase para crear un selector
function Selector.new(x, y, sprite)
	local self = setmetatable({}, Selector)
	self.x = x
	self.y = y
	self.sprite = sprite
	return self
end

selector = Selector.new(30, 30, 7)

function Selector:draw()
	spr(self.sprite, self.x, self.y)
end

function set_selector(x, y, look)
	local tile_x = flr((x + 4) / 8)
	local tile_y = flr((y + 4) / 8)
	local new_x = tile_x
	local new_y = tile_y
	
	if look == "right" then
		new_x = tile_x + 1
	elseif look == "left" then
		new_x = tile_x - 1
	elseif look == "up" then
		new_y = tile_y - 1
	elseif look == "down" then
		new_y = tile_y + 1
	end
	
	if look != nil then
		selector.x = new_x * 8 
		selector.y = new_y * 8
	end
	-- Detexta si el tile es el numero 35
	if btnp(4) then
			-- Cambia el tile en la posiciれはn del selector
			-- mset(new_x, new_y, 35)
            if(mget(new_x, new_y) == 48) then
                plow_farm(new_x, new_y, 35)
            elseif(mget(new_x, new_y) == 35) then
                plow_farm(new_x, new_y, 36)
            end
	end	
end

function create_farm(pos_x, pos_y, tile_x, tile_y)
    local farm = {}
    for x = 0, tile_x do
        for y = 0, tile_y do
            add(farm, {x = pos_x + x, y = pos_y + y, sprite = 48})
        end
    end
    return farm
end

function plow_farm(x, y, sprite)
    for i = 1, #farm do
        if farm[i].x == x and farm[i].y == y then
            farm[i].sprite = sprite
        end
    end
end

function draw_farm()
    for i = 1, #farm do
        mset(farm[i].x, farm[i].y, farm[i].sprite)
    end
end

function set_anim(opt)
	if opt==0 then -- Izquierda
		return flr(player.step / 10) % 2 == 0 and 16 or 17 
	end
	if opt==1 then -- Derecha
		return flr(player.step / 10) % 2 == 0 and 1 or 2
	end
	if opt==2 then -- Arriba
		return flr(player.step / 10) % 2 == 0 and 3 or 4
	end
	if opt==3 then -- Abajo
		return flr(player.step / 10) % 2 == 0 and 5 or 6
	end
	return flr(player.step / 10) % 2 == 0 and 1 or 2
end

function move_player()
	player.step += 1
	local new_x = player.x
	local new_y = player.y
	player.sprite = set_anim(player.state)
	if btn(0) then -- Izquierda
		new_x -= 1
		player.state = 0
		player.look = "left"
	elseif btn(1) then -- Derecha
	   new_x += 1 
	   player.state = 1
	   player.look = "right"
	elseif btn(2) then -- Arriba
		new_y -= 1 
		player.state = 2
		player.look = "up"
	elseif btn(3) then -- Abajo
		new_y += 1 
		player.state = 3
		player.look = "down"
	end
	player.x = new_x
	player.y = new_y
	set_selector(player.x, player.y, player.look)
end

function _init()
    farm = create_farm(8, 8, 5, 5)
end

function _update()
 move_player()
end

function _draw()
 cls()
 map(0,0)
 spr(player.sprite, player.x, player.y)
 draw_farm()
 selector:draw()
end

	
__gfx__
00000000000000000000000000000000000000000000000000000000777007770000000000000000000000000000000000000000bbb2bbbbbbb2bbbb00111100
0000000000022e0000022e000002e0000002e0000022e0000022e000700000070770077000000000000000000000000000004000bbb24bbbbbb24b9b01bbbb10
00000000002222e0002222e000122e0000122e0002222e0002222e00700000070700007000000000000000000000000000004000bbb24bbbb2b24b9b1bbbbbb1
0000000000261f1000261f100012220000122200021ff1e0021ff1e0000000000000000000000000000000000000000000024000bbb24b9bbb224b9b13bbbbb1
00000000002ffff0002ffff0012222e0012222e002ffff2002ffff20000000000000000000000000000000000000000000024000b2b249bbb2b249bb1333bbb1
000000000225510f022551000f222200002222f00f555100005551f0700000070700007000000000000000000000000000024000bb224bbbbb224bbb13333bb1
000000000f11cc000011ccf00095ccf00f15c9000011ccf00f11cc00700000070770077000000000000000000000000000011000bbb11bbbbbb11bbb01111110
00000000009009000009090000000900009000000000090000900000777007770000000000000000000000000000000000055000bbb55bbbbbb55bbb55555555
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbb4bbbbbbb4bbbbbbb4b4bbb1111bb
0022e0000022e000000000000000000000000000000000000000000000000000000000000000000000000000b6ffff6bb6ff4f6bb6ff4f6bb6f24f4bb1bb8b1b
02222e0002222e00000000000000000000000000000000000000000000000000000000000000000000000000bffffffbbff24ffbbff24f4bb2f24f4b1b8bbb81
01f1620001f16200007ccc000000000000000000000000000000000000000000000000000000000000000000bfff4ffbbff24ffbb2f244fbb2f244fb13bbbbb1
0ffff2000ffff200077111c0007ccc0000000000000000000000000000000000000000000000000000000000bff24ffbbff24ffbbf224ffbbf224ffb12338bb1
f01552e0001552e07c16661c077111c000000000000000000000000000000000000000000000000000000000bff55ffbbff55ffbbff55ffbbff55ffb13323bb1
00cc11f00fcc11007c11667c7c11667c00000000000000000000000000000000000000000000000000000000b6ffff6bb6ffff6bb6ffff6bb6ffff6bb111111b
0090090000909000cccccccccccccccc00000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb55555555
bbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000111100
bbbbb3bbe82bbbbbbbbbbbbbb6ffff6bb544445b0000000000000000000000000000000000000000000000000000000000000000000000000000000001bbab10
bbbb3b3bb1bbb8bbbbbbbbbbbffffffbb444444b000000000000000000000000000000000000000000000000000000000000000000000000000000001babbba1
bbbbbbbbb3bbe82bbbbbbbbbbffffffbb444444b0000000000000000000000000000000000000000000000000000000000000000000000000000000013bbbbb1
bbbbbbbb3b3bb1bbbbbbbbbbbffffffbb444444b000000000000000000000000000000000000000000000000000000000000000000000000000000001a33abb1
bbb3bbbbb3bbb3bbbbbbbbbbbffffffbb444444b00000000000000000000000000000000000000000000000000000000000000000000000000000000133a3bb1
bb3bbbbbbbbb3b3bbbbbbbbbb6ffff6bb544445b0000000000000000000000000000000000000000000000000000000000000000000000000000000001111110
bbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000066666666
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100
bbbb3bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001bb9b10
b3bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001b9bbb91
bbbbbb3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013bbbbb1
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000019339bb1
bbbb3bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013393bb1
b3bbbb3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111110
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001bbeb10
002222e0002222e000122e0000122e0000222e0000222e000000000000000000000000000000000000000000000000000000000000000000000000001bebbbe1
0026cfc00026cfc0001222000012220000cffc0000cffc0000000000000000000000000000000000000000000000000000000000000000000000000013bbbbb1
000ffff0000ffff0002222000022220000ffff0000ffff000000000000000000000000000000000000000000000000000000000000000000000000001e33ebb1
0005510f00055100001555f00f115500005551f00f555100000000000000000000000000000000000000000000000000000000000000000000000000133e3bb1
0f11cc000011ccf00f15cc000015ccf00f11cc000011ccf000000000000000000000000000000000000000000000000000000000000000000000000001111110
09a009a000a009a000900a0000900a0000900a0000900a0000000000000000000000000000000000000000000000000000000000000000000000000066666666
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001556510
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000015655561
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012555551
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016226551
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012262551
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111110
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022
22222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022
00002200220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022
22222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221222222222022222222222221202200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222222222222222221f2222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
222222222122222222211f0e1f22222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222220222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2220222221222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222212200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222202222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222212222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222022222222222220222222212200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000210500000018050000001c0500000021050000001d05000000190500000011050000001d050000000c050000001c050000001f0500000018050000000c050000001c050000001f050000001805000000
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
001000000c050000001c050000001f0500000018050000000c050000001c050000001f05000000180500000011050000002105000000180500000011050000001f050000001d0500000021050000001f05000000
__music__
07 14424344

