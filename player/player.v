module player

import vraylib
import lyra
import math

pub struct Core {
mut:
	x       f32
	y       f32
	scale   f32 = 1
	hp      f32 = 100
	xp      f32 = 0
	lvl     int = 0
	speed   int = 10
	texture C.Texture2D
}

pub fn (mut self Core) load() {
	self.texture = vraylib.load_texture('resources/spark_flame.png')
	self.x = lyra.game_width * .5 - f32(self.texture.width) * .5
	self.y = lyra.game_height * .5 - f32(self.texture.height) * .5
}

fn get_direction(self &Core, eye lyra.Eye) (f32, f32) {
	mut dx, mut dy := 0.0, 0.0
	if vraylib.is_key_down(vraylib.key_right) {
		dx = 1
	}
	if vraylib.is_key_down(vraylib.key_left) {
		dx = -1
	}
	if vraylib.is_key_down(vraylib.key_up) {
		dy = -1
	}
	if vraylib.is_key_down(vraylib.key_down) {
		dy = 1
	}
	if vraylib.is_mouse_button_down(vraylib.mouse_left_button) {
		mut pos := lyra.get_game_pos(vraylib.get_mouse_position())
		mut angle := math.atan2(pos.x - self.x + eye.cx, pos.y - self.y)
		if angle < 0 {
			angle += math.pi * 2
		}
		dx = math.sin(angle)
		dy = math.cos(angle)
	}
	return f32(dx), f32(dy)
}

[live]
pub fn (mut self Core) update(mut eye lyra.Eye) {
	mut dx, mut dy := get_direction(self, eye)
	ground_height := 400
	dx *= self.speed
	dy *= self.speed
	x, y := self.x + dx, self.y + dy
	if (x < eye.cx + lyra.game_width / 5 && eye.cx > lyra.start_x) || (x > eye.cx + lyra.game_width - (lyra.game_width / 5) && eye.cx < eye.gw + lyra.start_x - lyra.game_width) {
		eye.cx = eye.cx + dx
	}
    if x < eye.cx + lyra.start_x + self.texture.width || x > eye.cx + lyra.game_width - f32(self.texture.width) * .5{
		dx = 0
	}
    if y > lyra.game_height {
        self.y = lyra.game_height
		dy = 0
    } else if y < lyra.game_height - self.texture.height - 42 - eye.gh {
        self.y = lyra.game_height - self.texture.height - 42 - eye.gh
		dy = 0
    }
	self.x += dx
	self.y += dy
}

[live]
pub fn (self &Core) draw() {
	w, h := self.texture.width, self.texture.height
	vraylib.draw_texture_ex(self.texture, C.Vector2{self.x - f32(w) * .5, self.y - h}, 0, 1, vraylib.white)
}

[live]
pub fn (self &Core) unload() {
	vraylib.unload_texture(self.texture)
}
