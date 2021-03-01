module player

import vraylib
import lyra

pub struct Core {
mut:
	x       f32
	y       f32
	scale   f32 = 1
	hp      f32 = 100
	xp      f32 = 0
	lvl     int = 0
	speed   int = 2
	texture C.Texture2D
}

pub fn (mut self Core) load() {
	self.texture = vraylib.load_texture('resources/spark_flame.png')
	self.x = lyra.game_width * .5 - f32(self.texture.width) * .5
	self.y = lyra.game_height * .5 - f32(self.texture.height) * .5
}

[live]
pub fn (mut self Core) update() {
	if vraylib.is_key_down(vraylib.key_right) {
		self.x += self.speed
	}
	if vraylib.is_key_down(vraylib.key_left) {
		self.x -= self.speed
	}
	if vraylib.is_key_down(vraylib.key_up) {
		self.y -= self.speed
	}
	if vraylib.is_key_down(vraylib.key_down) {
		self.y += self.speed
	}
}

[live]
pub fn (self &Core) draw() {
	vraylib.draw_texture_ex(self.texture, C.Vector2{self.x, self.y}, 0, 1, vraylib.white)
}

[live]
pub fn (self &Core) unload() {
	vraylib.unload_texture(self.texture)
}
