module screens

import waotzi.vraylib
import state

pub struct Title {
mut:
	background C.Texture2D
}

pub fn (mut self Title) load(mut state state.State) {
	self.background = vraylib.load_texture('resources/menu.jpg')
}

pub fn (mut self Title) update(mut st state.State) {
	if vraylib.is_mouse_button_pressed(vraylib.mouse_left_button) || vraylib.get_key_pressed() > 0 {
		st.set_screen(&Carousel{})
	}
}

pub fn (self &Title) draw(state &state.State) {
	vraylib.draw_texture_ex(self.background, C.Vector2{0, 0}, 0, 1, vraylib.white)
	vraylib.draw_text('KASAIVAL', 480, 160, 200, vraylib.maroon)
	vraylib.draw_text('an out of control flame trying to survive', 350, 640, 60, vraylib.maroon)
	vraylib.draw_text('touch anywhere to start burning', 480, 1000, 60, vraylib.beige)
}

pub fn (self &Title) unload() {
	vraylib.unload_texture(self.background)
}
