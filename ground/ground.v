module ground

import vraylib
import lyra

struct Tile {
	p1 C.Vector2
	p2 C.Vector2
	p3 C.Vector2
	color C.Color
}

pub struct Core {
mut:
	tiles  []Tile
	rows   int = 9
	height f32
}

pub fn (mut self Core) load() {
	gh := f32(lyra.game_height)
	self.height = gh * .5
	mut y := gh - self.height
	w := self.height / self.rows
	h := w
	start_x := 0 - w
	end_x := 0 + 2000 + w
	for y < gh + h {
		mut x := start_x
		for x < end_x {
			self.tiles << Tile{C.Vector2{x - w * .5, y}, C.Vector2{x, y + h}, C.Vector2{x + w * .5, y}, C.Color{80, 255, 40, 255}}
			self.tiles << Tile{C.Vector2{x + w * .5, y}, C.Vector2{x, y + h}, C.Vector2{x + w, y + h}, C.Color{80, 0, 40, 255}}
			x += w
		}
		y += h
	}
}

[live]
pub fn (mut self Core) update() {
}


[live]
pub fn (self &Core) draw() {
	for tile in self.tiles {
		vraylib.draw_triangle(tile.p1, tile.p2, tile.p3, tile.color)
	}
}

[live]
pub fn (self &Core) unload() {
}
