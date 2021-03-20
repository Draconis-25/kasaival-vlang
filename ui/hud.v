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

struct State {
	texture C.Texture2D
	execute fn(&lyra.Eye)
}

struct Icon {
	mut:
	states []State
	state int
	x int
	y int
}

pub struct HUD {
	mut:
	icons []Icon
}

fn get_fn(state string) fn(&lyra.Eye) {
	match state {
		"exit" {
			return fn(mut eye lyra.Eye) {
				eye.state = .menu
			}
		}
		"pause" {
			return fn(mut eye lyra.Eye) {
				eye.pause = false
			}
		}
		"resume" {
			return fn(mut eye lyra.Eye) {
				eye.pause = true
			}
		}
		"music" {
			return fn(mut eye lyra.Eye) {
				eye.mute = false
			}
		}
		"no_music" {
			return fn(mut eye lyra.Eye) {
				eye.mute = true
			}
		}
		else {
			return fn(mut eye lyra.Eye) {}
		}
	}
}

fn (mut self HUD) add_icon(states []string, x int, y int) {
	mut icon := Icon{}
	icon.x, icon.y = x, y
	for state in states {
		icon.states << State{vraylib.load_texture(asset_path + state + asset_ext), get_fn(state)}
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

pub fn (mut self HUD) update(mut eye lyra.Eye) {
	pressed := vraylib.is_mouse_button_pressed(vraylib.mouse_left_button)
	mut hover := false
	mouse_pos := lyra.get_game_pos(vraylib.get_mouse_position())
	mx, my := mouse_pos.x, mouse_pos.y
	for mut icon in self.icons {
		if mx > icon.x && mx < icon.x + icon_w && my > icon.y && my < icon.y + icon_h {
			hover = true
			if pressed {
				if icon.states.len > 1 {
					icon.state++
					if icon.state > icon.states.len - 1 {
						icon.state = 0
					}
				}
				icon.states[icon.state].execute(eye)
			}
		}
	}
	if hover {
		vraylib.set_mouse_cursor(vraylib.mouse_cursor_hand)
	}

}

pub fn (self &HUD) draw(eye lyra.Eye) {
	for icon in self.icons {
		img := icon.states[icon.state].texture
		vraylib.draw_texture_ex(img, C.Vector2{icon.x + eye.cx, icon.y}, 0, 1, vraylib.white)
	}
}

pub fn (self &HUD) unload() {
	for icon in self.icons {
		for state in icon.states {
			vraylib.unload_texture(state.texture)
		}
	}

}
