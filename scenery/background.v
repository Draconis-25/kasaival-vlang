module scenery

import vraylib
import lyra

const (
	path = "resources/scenery/desert/"
	files = 6
	ext = ".png"
)

pub struct Background {
	mut: items []C.Texture2D
}

pub fn (mut self Background) load() {
	for i in 1..6 {
		self.items << vraylib.load_texture(path + i.str() + ext)
	}
}

[live]
pub fn (mut self Background) update() {
}

[live]
pub fn (self &Background) draw(eye &lyra.Eye) {
	for item in self.items {
		vraylib.draw_texture_ex(item, C.Vector2{lyra.start_x - 10, 0}, 0, 1, vraylib.white)
	}
}

pub fn (self &Background) unload() {
	for item in self.items {
		vraylib.unload_texture(item)
	}
}
