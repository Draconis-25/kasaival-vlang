module scenery

import vraylib
import lyra

const (
	path = "resources/scenery/desert/"
	ext = ".png"
)

pub struct Background {
	mut: items []C.Texture2D
	scx f32
	num int
}

pub fn (mut self Background) load() {
	// how much eye.cx should affect the background
	self.scx = .5
	self.num = 6
	for i in 1..self.num + 1 {
		println(i)
		self.items << vraylib.load_texture(path + i.str() + ext)
	}
}

[live]
pub fn (mut self Background) update() {
}

[live]
pub fn (self &Background) draw(eye &lyra.Eye) {
	for i, item in self.items {
		vraylib.draw_texture_ex(item, C.Vector2{lyra.start_x + eye.cx * self.scx * (i + 1) / self.num, 0}, 0, 1, vraylib.white)
	}
}

pub fn (self &Background) unload() {
	for item in self.items {
		vraylib.unload_texture(item)
	}
}
