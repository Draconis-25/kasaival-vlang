module scenery

import vraylib
import lyra

struct Tile {
	p1        C.Vector2
	p2        C.Vector2
	p3        C.Vector2
	org_color C.Color
mut:
	color     C.Color
}

pub struct Ground {
mut:
	tiles     []Tile
	grid      [][]Tile
	pos_y     []f32
	rows      int = 9
	tile_size f32
}

pub fn (mut self Ground) load(mut eye lyra.Eye, width int, cs [][]int) {
	mut y := lyra.start_y
	gh := lyra.game_height - y
	w := gh / self.rows
	h := w
	self.tile_size = h
	start_x := lyra.start_x - w
	end_x := lyra.start_x + width + w
	eye.gw = start_x + end_x
	self.grid = [][]Tile{len: self.rows, init: []Tile{}}
	for i in 0 .. self.rows {
		self.pos_y << y
		mut x := start_x
		for x < end_x {
			mut cs_i := cs.len * (x - start_x) / (end_x - start_x)
			r := cs_i - int(cs_i)
			cs_i = vraylib.get_random_value(int(r * 10), 10) / 10 + cs_i
			if cs_i > cs.len - 1 {
				cs_i = cs.len - 1
			}
			mut c := lyra.get_color(cs[int(cs_i)])
			self.grid[i] << Tile{C.Vector2{x - f32(w) * .5, y}, C.Vector2{x, y + h}, C.Vector2{x +
				f32(w) * .5, y}, c, c}
			c = lyra.get_color(cs[int(cs_i)])
			self.grid[i] << Tile{C.Vector2{x + f32(w) * .5, y}, C.Vector2{x, y + h}, C.Vector2{x +
				w, y + h}, c, c}
			x += w
		}
		y += h
	}
}

fn (mut tile Tile) heal() {
	mut r, mut g, mut b := tile.color.r, tile.color.g, tile.color.b
	_, o_g, o_b := tile.org_color.r, tile.org_color.g, tile.org_color.b
	if b != o_b {
		b += byte(f32(o_b - b) * .05)
	}
	if g != o_g {
		g += byte(f32(o_g - g) * .05)
	}
	tile.color = C.Color{r, g, b, 255}
}

[live]
pub fn (mut self Ground) update() {
	for row in self.grid {
		for mut tile in row {
			tile.heal()
		}
	}
}

fn (mut tile Tile) burn(power f32) {
	mut r, mut g, mut b := tile.color.r, tile.color.g, tile.color.b
	b = 0
	if g > 100 {
		g -= 2
	}
	tile.color = C.Color{r, g, b, 255}
}

pub fn (mut self Ground) collide(b []f32, element string, power f32) {
	mut index := []int{}
	for i, y in self.pos_y {
		if y < b[3] && y + self.tile_size > b[2] {
			index << i
		}
	}
	for i in index {
		for j, tile in self.grid[i] {
			mut l := f32(-1)
			if j % 2 == 0 {
				l = tile.p1.x
			} else {
				l = tile.p2.x
			}
			r := tile.p3.x
			if l < b[1] && r > b[0] {
				if element == 'fire' {
					self.grid[i][j].burn(power)
				}
			}
		}
	}
}

[live]
pub fn (self &Ground) draw() {
	for row in self.grid {
		for tile in row {
			vraylib.draw_triangle(tile.p1, tile.p2, tile.p3, tile.color)
		}
	}
}

[live]
pub fn (self &Ground) unload() {
}
