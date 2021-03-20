module ui

import lyra
import vraylib

const (
	exit_button = 0
	pause_button = 1
	music_button = 2
	)

const asset_path = "resources/ui/"
const asset_ext = ".png"
const	top_left = [["exit"], ["pause", "resume"]]
const	top_right = [["music", "no_music"]]


// icon x, y, w, h
const icon_w = 128
const icon_h = 128
const start_x = 64
const start_y = 64

// state of button
struct State {
	texture C.Texture2D
	execute fn(&lyra.Eye)
}

// the icon / button
struct Icon {
	mut:
	states []State
	state int
	x int
	y int
}

// the head over display
pub struct HUD {
	mut:
	key_timeout   int
	icons []Icon
}

// get the function to provoke if button activated
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

// add an icon button
fn (mut self HUD) add_icon(states []string, x int, y int) {
	mut icon := Icon{}
	icon.x, icon.y = x, y
	for state in states {
		icon.states << State{vraylib.load_texture(asset_path + state + asset_ext), get_fn(state)}
	}
	self.icons << icon
}

// load hud
pub fn (mut self HUD) load() {
	// top left row of icons
	for i, states in top_left {
		x := start_x + i * icon_w
		y := start_y
		self.add_icon(states, x, y)
	}
	// top right row of icons
	for i, states in top_right {
		x := lyra.game_width - start_x - (i + 1) * icon_w
		y := start_y
		self.add_icon(states, x, y)
	}
}


// update hud
pub fn (mut self HUD) update(mut eye lyra.Eye) {
	// change icon state
	update_state := fn (mut icon Icon, mut eye lyra.Eye) {
		// updates button state
		if icon.states.len > 1 {
			icon.state++
			if icon.state > icon.states.len - 1 {
				icon.state = 0
			}
		}
		// execute the function
		icon.states[icon.state].execute(eye)
	}

	// key pressed
	if self.key_timeout > 0 {
		self.key_timeout--
	}
	if vraylib.is_key_down(vraylib.key_m) {
		if self.key_timeout == 0 {
			update_state(mut self.icons[music_button], mut eye)
		}
		self.key_timeout = 2
	}


	// icons
	pressed := vraylib.is_mouse_button_pressed(vraylib.mouse_left_button)
	mut hover := false
	mouse_pos := lyra.get_game_pos(vraylib.get_mouse_position())
	mx, my := mouse_pos.x, mouse_pos.y
	for mut icon in self.icons {
		if mx > icon.x && mx < icon.x + icon_w && my > icon.y && my < icon.y + icon_h {
			hover = true
			if pressed {
				update_state(mut icon, mut eye)
			}
		}
	}
	if hover {
		vraylib.set_mouse_cursor(vraylib.mouse_cursor_hand)
	}
}

// draw hud
pub fn (self &HUD) draw(eye lyra.Eye) {
	for icon in self.icons {
		img := icon.states[icon.state].texture
		vraylib.draw_texture_ex(img, C.Vector2{icon.x + eye.cx, icon.y}, 0, 1, vraylib.white)
	}
}


// unload hud
pub fn (self &HUD) unload() {
	for icon in self.icons {
		for state in icon.states {
			vraylib.unload_texture(state.texture)
		}
	}

}
