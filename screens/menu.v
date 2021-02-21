module screens

import vraylib

pub struct Menu {
mut:
	background C.Texture2D
}

[live]
pub fn (mut self Menu) load() {
	self.background = vraylib.load_texture('resources/menu.jpg')
}

[live]
pub fn (self &Menu) update() Next {
	if vraylib.is_mouse_button_pressed(vraylib.mouse_left_button) || vraylib.get_key_pressed() > 0 {
		return .game
	}
	return .@none
}

[live]
pub fn (self &Menu) draw() {
	vraylib.draw_texture_ex(self.background, C.Vector2{0, 0}, 0, 1, vraylib.white)
	vraylib.draw_text('KASAIVAL', 480, 160, 200, vraylib.maroon)
	vraylib.draw_text('an out of control flame trying to survive', 350, 640, 60, vraylib.maroon)
	vraylib.draw_text('touch anywhere to start burning', 480, 1000, 60, vraylib.beige)
}

pub fn (self &Menu) unload() {
	vraylib.unload_texture(self.background)
}
