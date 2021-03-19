module mobs

import utils

pub struct Frog {
pub mut:
	y int
mut:
	x       int
	texture C.Texture2D
	anime   utils.Animation
}

pub fn (mut self Frog) load(x int, y int) {
	self.x, self.y = x, y
	self.anime = utils.Animation{}
	self.anime.load('Frog', 12, 8, 64, 64, 0)
}

pub fn (mut self Frog) update() {
	self.anime.update(self.x, self.y)
}

pub fn (self &Frog) draw() {
	self.anime.draw()
}

pub fn (self &Frog) unload() {
	self.anime.unload()
}
