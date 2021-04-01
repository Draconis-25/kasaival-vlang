module scenery

import vraylib
import lyra
import utils
import rand
import state

const rows = 9

struct Tile {
	p1        C.Vector2
	p2        C.Vector2
	p3        C.Vector2
	org_color C.Color
mut:
	color C.Color
}

pub struct Ground {
mut:
	grid      [][]Tile = [][]Tile{len: rows, init: []Tile{}}
	pos_y     []f32
	tile_size f32
	tick int
	pub mut:
	start_x int
}

 fn get_color (gr [][]int, x f32, start_x f32, width int) C.Color {
	mut rat := (x - start_x) / width
	/*r := id - int(id)
	id = rand.f32_in_range(r, 1) + id
	if id > cs.len - 1 {
		id = cs.len - 1
	}
	return utils.get_color(cs[int(id)])*/

	if rat < 0 {
		rat = 0
	}
	if rat > 1 {
		rat = 1
	}
	r := gr[0][0] * (1 - rat) + gr[1][0] * rat
	g := gr[0][1] * (1 - rat) + gr[1][1] * rat
	b := gr[0][2] * (1 - rat) + gr[1][2] * rat

	return C.Color{byte(r), byte(g), byte(b), 255}
}

pub fn (mut self Ground) add(width int, gradient [][]int) {
	mut y := lyra.start_y
	gh := lyra.game_height - y
	w := gh / rows
	h := w
	self.tile_size = h
	end_x := self.start_x + width + w
	for i in 0 .. rows {
		if self.pos_y.len < rows {
			self.pos_y << y
		}
		mut x := self.start_x - int(f32(w) * .5)
		for x < end_x  + int(f32(w) * .5){

			mut c := get_color(gradient, x - f32(w) * .5, self.start_x, width)
			self.grid[i] << Tile{C.Vector2{x - f32(w) * .5, y}, C.Vector2{x, y + h}, C.Vector2{x +
				f32(w) * .5, y}, c, c}
			c = get_color(gradient, x, self.start_x, width)
			self.grid[i] << Tile{C.Vector2{x + f32(w) * .5, y}, C.Vector2{x, y + h}, C.Vector2{x + w,
				y + h}, c, c}
			x += w
		}
		y += h
	}
	self.start_x += width + w
}

fn (mut tile Tile) heal() {
	mut r, mut g, mut b := tile.color.r, tile.color.g, tile.color.b
	o_r, o_g, o_b := tile.org_color.r, tile.org_color.g, tile.org_color.b

	if r != o_r {
		r--
	}
	if b != o_b {
		b++
	}
	if g != o_g {
		g++
	}
	tile.color = C.Color{r, g, b, 255}
}

pub fn (mut self Ground) update() {
	self.tick++

	if self.tick > .5 * lyra.fps {
		for mut row in self.grid {
			for mut tile in row {
				tile.heal()
			}
		}
		self.tick = 0
	}
}

fn (mut tile Tile) burn(power f32) f32 {
	dmg := power * .5
	o_r, o_g, _ := tile.org_color.r, tile.org_color.g, tile.org_color.b

	_, t_g, _ := tile.color.r, tile.color.g, tile.color.b
	mut r, mut g, mut b := tile.color.r, tile.color.g, tile.color.b

	if g > o_g - 30 {
		g -= byte(dmg)
	}
	if r < o_r + 20 {
		r += byte(dmg)
	}
	tile.color = C.Color{r, g, b, 255}
	return t_g - g - f32(b) * .05
}

fn (tile &Tile) get_lr(i int) (f32, f32) {
	mut l := f32(-1)
	if i % 2 == 0 {
		l = tile.p1.x
	} else {
		l = tile.p2.x
	}
	return l, tile.p3.x
}

pub fn (mut self Ground) collide(b []f32, element string, power f32) f32 {
	mut fuel := f32(0)
	mut index := []int{}
	for i, y in self.pos_y {
		if y < b[3] && y + self.tile_size > b[2] {
			index << i
		}
	}
	for i in index {
		for j, tile in self.grid[i] {
			l, r := tile.get_lr(j)
			if l < b[1] && r > b[0] {
				if element == 'fire' {
					fuel += self.grid[i][j].burn(power)
				}
			}
		}
	}
	return fuel
}

pub fn (self &Ground) draw(state &state.State) {
	for row in self.grid {
		for i, tile in row {
			l, r := tile.get_lr(i)
			w := r - l
			if l + w > state.cx && r < state.cx + lyra.game_width + w {
				vraylib.draw_triangle(tile.p1, tile.p2, tile.p3, tile.color)
			}
		}
	}
}

pub fn (self &Ground) unload() {
}
