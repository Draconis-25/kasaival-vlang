module ui

import lyra
import vraylib

const asset_path = "resources/ui/"
const asset_ext = ".png"
const	top_left = [["exit"], ["pause", "resume"]]
const	top_right = [["music", "no_music"]]

const icon_w = 128
const icon_h = 128
const start_x = 64
const start_y = 64

struct Icon {
	mut:
	states []C.Texture2D
	state int
	x int
	y int
}

pub struct HUD {
	mut:
	icons []Icon
}


fn (mut self HUD) add_icon(states []string, x int, y int) {
	mut icon := Icon{}
	icon.x, icon.y = x, y
	for state in states {
		icon.states << vraylib.load_texture(asset_path + state + asset_ext)
	}
	self.icons << icon
}

pub fn (mut self HUD) load() {
	for i, states in top_left {
		x := start_x + i * icon_w
		y := start_y
		self.add_icon(states, x, y)
	}
	for i, states in top_right {
		x := lyra.game_width - start_x - (i + 1) * icon_w
		y := start_y
		self.add_icon(states, x, y)
	}
}

pub fn (mut self HUD) update(eye lyra.Eye) {
	mut hover := false
	mouse_pos := lyra.get_game_pos(vraylib.get_mouse_position())
	mx, my := mouse_pos.x, mouse_pos.y
	for icon in self.icons {
		if mx > icon.x && mx < icon.x + icon_w && my > icon.y && my < icon.y + icon_h {
			hover = true
		}
	}
	if hover {
		vraylib.set_mouse_cursor(vraylib.mouse_cursor_hand)
	}
	else {
		vraylib.set_mouse_cursor(vraylib.mouse_cursor_default)
	}

}

pub fn (self &HUD) draw(eye lyra.Eye) {
	for icon in self.icons {
		img := icon.states[icon.state]
		vraylib.draw_texture_ex(img, C.Vector2{icon.x + eye.cx, icon.y}, 0, 1, vraylib.white)
	}
}

pub fn (self &HUD) unload() {
	for icon in self.icons {
		for img in icon.states {
			vraylib.unload_texture(img)
		}
	}

}
