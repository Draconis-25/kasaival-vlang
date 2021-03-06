module scenery

import vraylib
import lyra

const (
	path = 'resources/scenery/desert/'
	ext  = '.png'
)

pub struct Background {
mut:
	y int
	items []C.Texture2D
	sx   f32
	scale f32
}

pub fn (mut self Background) load() {
	self.y = 200
	self.scale = .4
	for i in 0 .. 6{
		self.items << vraylib.load_texture(path + (i + 1).str() + ext)
	}
}

[live]
pub fn (mut self Background) update() {
}

[live]
pub fn (self &Background) draw(eye &lyra.Eye) {

	l := self.items.len
	for i, item in self.items {
		x := lyra.start_x + eye.cx * .5 + eye.cx * (l - i) /  l  * .5
		y := self.y - self.y * (l - i) / l
		w := item.width * self.scale

		vraylib.draw_texture_ex(item, C.Vector2{x, y}, 0, self.scale, vraylib.white)
		vraylib.draw_texture_ex(item, C.Vector2{x + w, y}, 0, self.scale, vraylib.white)
	}
}

pub fn (self &Background) unload() {
	for item in self.items {
		vraylib.unload_texture(item)
	}
}
