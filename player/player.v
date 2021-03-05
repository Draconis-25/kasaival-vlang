module player

import vraylib
import lyra
import math

pub struct Core {
pub:
	element string = 'fire'
pub mut:
	y       f32
	dp      f32 = 5
mut:
	x       f32
	scale   f32 = 1
	hp      f32 = 100
	xp      f32
	lvl     int
	speed   int = 10
	texture C.Texture2D
}

pub fn (mut self Core) load() {
	self.texture = vraylib.load_texture('resources/spark_flame.png')
	self.x = lyra.game_width * .5 - f32(self.texture.width) * .5
	self.y = lyra.game_height * .8
}

fn is_key_down(keys []int) bool {
	mut rtn := false
	for key in keys {
		if vraylib.is_key_down(key) {
			rtn = true
		}
	}
	return rtn
}

const (
	key_right = [vraylib.key_right]
	key_left  = [vraylib.key_left]
	key_up    = [vraylib.key_up]
	key_down  = [vraylib.key_down]
)

fn get_direction(self &Core, eye lyra.Eye) (f32, f32) {
	mut dx, mut dy := 0.0, 0.0
	if is_key_down(key_right) {
		dx = 1
	}
	if is_key_down(key_left) {
		dx = -1
	}
	if is_key_down(key_up) {
		dy = -1
	}
	if is_key_down(key_down) {
		dy = 1
	}
	if vraylib.is_mouse_button_down(vraylib.mouse_left_button) {
		mut pos := lyra.get_game_pos(vraylib.get_mouse_position())
		diff_x, diff_y := int(pos.x - self.x + eye.cx), int(pos.y - self.y)
		if diff_x > 4 || diff_x < -4 || diff_y > 4 || diff_y < -4 {
			mut angle := math.atan2(diff_x, diff_y)
			if angle < 0 {
				angle += math.pi * 2
			}
			dx = math.sin(angle)
			dy = math.cos(angle)
		}

	}
	return f32(dx), f32(dy)
}

[live]
pub fn (mut self Core) update(mut eye lyra.Eye) {
	w, h := self.texture.width * self.scale * .5, self.texture.height * self.scale * .5
	mut dx, mut dy := get_direction(self, eye)
	dx *= self.speed
	dy *= self.speed
	x, y := self.x + dx, self.y + dy
	if (x < eye.cx + lyra.game_width / 5 &&
		eye.cx > lyra.start_x) || (x > eye.cx + lyra.game_width -
		(lyra.game_width / 5) &&
		eye.cx < eye.gw + lyra.start_x - lyra.game_width) {
		eye.cx = eye.cx + dx
	}
	b := self.get_hitbox()
	if (b[0] + dx < eye.cx && dx < 0) || (b[1] + dx > eye.cx + lyra.game_width) {
		dx = 0
	}
	if (b[3] + dy > lyra.game_height && dy > 0) || (b[2] + dy < lyra.start_y && dy < 0) {
		dy = 0
	}
	self.x += dx
	self.y += dy
}

pub fn (self &Core) get_hitbox() []f32 {
	w, h := self.texture.width * self.scale * .5, self.texture.height * self.scale * .3
	return [self.x - w * .5, self.x + w * .5, self.y, self.y]
}

[live]
pub fn (self &Core) draw() {
	w, h := self.texture.width * self.scale, self.texture.height * self.scale - 32
	vraylib.draw_texture_ex(self.texture, C.Vector2{self.x - w * .5, self.y - h}, 0, 1,
		vraylib.white)
}

[live]
pub fn (self &Core) unload() {
	vraylib.unload_texture(self.texture)
}
