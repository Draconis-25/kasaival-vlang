module ui

import lyra
import waotzi.vraylib
import state

pub struct ImageButton {
mut:
	texture C.Texture2D
	x       int
	y       int
	scale   int
}

pub fn (self &ImageButton) mouse_on_button() bool {
	mouse_pos := lyra.get_game_pos(vraylib.get_mouse_position())
	w, h := self.texture.width * self.scale, self.texture.height * self.scale
	if mouse_pos.x > self.x && mouse_pos.x < self.x + w {
		if mouse_pos.y > self.y && mouse_pos.y < self.y + h {
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
