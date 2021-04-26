module scenery

import waotzi.vraylib
import state

pub struct Sky {
mut:
	bg []C.Texture2D
}

pub fn (mut self Sky) load() {
	self.bg << vraylib.load_texture('resources/sky/planets.jpg')
	self.bg << vraylib.load_texture('resources/sky/nebula.png')
}

pub fn (mut self Sky) update(state &state.State) {
}

pub fn (self &Sky) draw(state &state.State) {
	for bg in self.bg {
		vraylib.draw_texture(bg, int(state.cx), 0, vraylib.white)
	}
}

pub fn (self &Sky) unload() {
	for bg in self.bg {
		vraylib.unload_texture(bg)
	}
}
