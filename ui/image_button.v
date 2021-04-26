module ui

import waotzi.vraylib
import state

pub struct ImageButton {
mut:
	texture C.Texture2D
	x       int
	y       int
	scale   int
}

pub fn (self &ImageButton) mouse_on_button(state &state.State) bool {
	w, h := self.texture.width * self.scale, self.texture.height * self.scale
	if state.mouse.x > self.x && state.mouse.x < self.x + w {
		if state.mouse.y > self.y && state.mouse.y < self.y + h {
			vraylib.set_mouse_cursor(vraylib.mouse_cursor_hand)
			return true
		}
	}
	return false
}

pub fn (self &ImageButton) draw(state &state.State) {
	vraylib.draw_texture_ex(self.texture, C.Vector2{self.x + state.cx, self.y}, 0, self.scale,
		vraylib.white)
}

pub fn (self &ImageButton) unload() {
	vraylib.unload_texture(self.texture)
}
