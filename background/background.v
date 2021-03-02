module background

import vraylib
import lyra
import os

const (
	path = "resources/scenery/desert/"
	files = 6
	ext = ".png"
)

pub struct Core {
	mut: items []C.Texture2D
}

pub fn (mut self Core) load() {
	for i in 1..6 {
		self.items << vraylib.load_texture(path + i.str() + ext)
	}
}

[live]
pub fn (mut self Core) update() {
}

[live]
pub fn (self &Core) draw() {
	for item in self.items {
		vraylib.draw_texture_ex(item, C.Vector2{0, 0}, 0, 1, vraylib.white)
	}
}

pub fn (self &Core) unload() {
	for item in self.items {
		vraylib.unload_texture(item)
	}
}
