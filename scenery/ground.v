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
	get_color := fn (cs [][]int, x int, start_x int, end_x int) C.Color {
		mut id := f32(cs.len * (x - start_x)) / f32((end_x - start_x))
		r := id - int(id)
		id = vraylib.get_random_value(int(r * 10), 10) / 10 + id
		if id > cs.len - 1 {
			id = cs.len - 1
		}
		return lyra.get_color(cs[int(id)])
	}
	mut y := lyra.start_y
	gh := lyra.game_height - y
	w := gh / self.rows
	h := w
	self.tile_size = h
	eye.gw = width
	eye.start_x = int( - f32(eye.gw) * .5 + lyra.game_width * .5)
	end_x := eye.start_x + eye.gw + w
	self.grid = [][]Tile{len: self.rows, init: []Tile{}}
	for i in 0 .. self.rows {
		self.pos_y << y
		mut x := eye.start_x
		for x < end_x {
			mut c := get_color(cs, x, eye.start_x,int(end_x))
			self.grid[i] << Tile{C.Vector2{x - f32(w) * .5, y}, C.Vector2{x, y + h}, C.Vector2{x +
				f32(w) * .5, y}, c, c}
			c = get_color(cs, x, eye.start_x, int(end_x))
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
		b++
	}
	if g != o_g {
		g++
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

fn (tile &Tile) get_lr(i int) (f32, f32) {
	mut l := f32(-1)
	if i % 2 == 0 {
		l = tile.p1.x
	} else {
		l = tile.p2.x
	}
	return l, tile.p3.x
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
			l, r := tile.get_lr(j)
			if l < b[1] && r > b[0] {
				if element == 'fire' {
					self.grid[i][j].burn(power)
				}
			}
		}
	}
}

[live]
pub fn (self &Ground) draw(eye &lyra.Eye) {
	for row in self.grid {
		for i, tile in row {
			l, r := tile.get_lr(i)
			w := r - l
			if l + w > eye.cx && r < eye.cx + lyra.game_width + w {
				vraylib.draw_triangle(tile.p1, tile.p2, tile.p3, tile.color)
			}
		}
	}
}

[live]
pub fn (self &Ground) unload() {
}
