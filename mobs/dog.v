module mobs

import lyra
import utils

pub struct Dog {
pub mut:
	y f32
mut:
	x       f32
	texture C.Texture2D
	anime   utils.Animation
}

pub fn (mut self Dog) load(x int, y int) {
	self.x, self.y = x, y
	self.anime.load('Dog', 7, 12, 46, 27, 7)
}

pub fn (mut self Dog) update() {
	self.anime.update(self.x, self.y)
}

pub fn (self &Dog) draw(eye &lyra.Eye) {
	self.anime.draw()
}

pub fn (self &Dog) unload() {
	self.anime.unload()
}

pub fn (mut self Dog) collided(element string, dp f32) {
	if element == 'fire' {
	}
}

pub fn (self &Dog) get_hitbox() []f32 {
	return [self.x, self.x, self.y, self.y]
}
