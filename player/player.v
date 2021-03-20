module player

import vraylib
import lyra
import math
import particles

pub struct Core {
pub:
	element string = 'fire'
pub mut:
	y     f32
	dp    f32 = 5
	flame particles.Fire
mut:
	x     f32
	scale f32 = 1
	hp    f32 = 100
	xp    f32
	lvl   int
	speed int = 10
	dead bool
}

pub fn (mut self Core) load() {

	self.x = lyra.game_width * .5
	self.y = lyra.game_height * .8
	self.flame = particles.Fire{}
	self.flame.load()
}

fn is_key_down(keys []int) bool {
	mut pressed := false
	for key in keys {
		if vraylib.is_key_down(key) {
			pressed = true
		}
	}
	return pressed
}

const (
	key_right = [vraylib.key_right, vraylib.key_d]
	key_left  = [vraylib.key_left, vraylib.key_a]
	key_up    = [vraylib.key_up, vraylib.key_w]
	key_down  = [vraylib.key_down, vraylib.key_s]
)

fn get_direction(self &Core, eye lyra.Eye) (f32, f32) {
	angle := fn (dx f64, dy f64) (f64, f64) {
		mut angle := math.atan2(dx, dy)
		if angle < 0 {
			angle += math.pi * 2
		}
		return math.sin(angle), math.cos(angle)
	}
	mut dx, mut dy := 0.0, 0.0
	if is_key_down(player.key_right) {
		dx = 1
	}
	if is_key_down(player.key_left) {
		dx = -1
	}
	if is_key_down(player.key_up) {
		dy = -1
	}
	if is_key_down(player.key_down) {
		dy = 1
	}
	if vraylib.is_mouse_button_down(vraylib.mouse_left_button) {
		mut pos := lyra.get_game_pos(vraylib.get_mouse_position())
		diff_x, diff_y := int(pos.x - self.x + eye.cx), int(pos.y - self.y)
		offset := f32(self.speed) * .5
		if diff_x > offset || diff_x < -offset || diff_y > offset || diff_y < -offset {
			dx, dy = angle(diff_x, diff_y)
		}
	}
	return f32(dx), f32(dy)
}

pub fn (mut self Core) update(mut eye lyra.Eye) {
	w, h := self.flame.get_dimensions()
	mut dx, mut dy := get_direction(self, eye)
	dx *= self.speed
	dy *= self.speed
	eye_bound := lyra.game_width / 5

	// if in eye bounds move the screen
	if (self.x + dx < eye.cx + eye_bound && eye.cx > eye.start_x)
		|| (self.x + dx > eye.cx + lyra.game_width - eye_bound
		&& eye.cx < eye.gw + eye.start_x - lyra.game_width) {
		eye.cx = eye.cx + dx
	}

	// otherwise move self.x and self.y
	if self.x + dx < eye.cx + w && dx < 0 {
		self.x = eye.cx + w
	} else if self.x + dx > eye.cx + lyra.game_width {
		self.x = eye.cx + lyra.game_width
	} else {
		self.x += dx
	}

	if self.y + dy > lyra.game_height + h * .6 && dy > 0 {
		self.y = lyra.game_height + h * .6
	} else if self.y + dy < lyra.start_y + h * .2 && dy < 0 {
		self.y = lyra.start_y + h * .2
	} else {
		self.y += dy
	}

	self.flame.update(self.x - w * .5, self.y - h)
}

pub fn (self &Core) get_hitbox() []f32 {
	w, h := self.flame.get_dimensions()
	return [self.x - w * .5, self.x + w * .5, self.y - h * .8, self.y - h * .2]
}

pub fn (self &Core) draw(i int) {
	self.flame.draw(i)
}

pub fn (self &Core) unload() {
	self.flame.unload()
}
