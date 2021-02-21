module screens

import vraylib

pub struct Game {}

pub struct Player {
	pub mut: hi string = "hao"
}


[live]
pub fn (mut self Game) load() {
}

[live]
pub fn (self &Game) update() Next {
	if vraylib.is_mouse_button_pressed(vraylib.mouse_left_button) {
	}
	return .@none
}

[live]
pub fn (self &Game) draw() {

}

pub fn (self &Game) unload() {
}
