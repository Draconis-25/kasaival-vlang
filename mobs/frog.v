module mobs

import lyra
import utils

pub struct Frog {
pub mut:
	y f32
mut:
	x       f32
	texture C.Texture2D
	anime   utils.Animation
}


pub fn (mut self Frog) load(x int, y int) {
	self.x, self.y = x, y
	self.anime.load('Frog', 12, 8, 64, 64, 0)
}

pub fn (mut self Frog) update() {
	self.anime.update(self.x, self.y)
}

pub fn (self &Frog) draw(eye &lyra.Eye) {
	self.anime.draw()
}

pub fn (self &Frog) unload() {
	self.anime.unload()
}


pub fn (mut self Frog) collided(element string, dp f32) {
	if element == 'fire' {
	}
}


pub fn (self &Frog) get_hitbox() []f32 {
	return [self.x, self.x, self.y, self.y]
}
