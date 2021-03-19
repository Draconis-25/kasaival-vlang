module mobs

import lyra

pub struct Dog {
pub mut:
	y int
mut:
	x       int
	texture C.Texture2D
	anime   lyra.Animation
}

pub fn (mut self Dog) load(x int, y int) {
	self.x, self.y = x, y
	self.anime = lyra.Animation{}
	self.anime.load('Dog', 7, 12, 46, 27, 7)
}

pub fn (mut self Dog) update() {
	self.anime.update(self.x, self.y)
}

pub fn (self &Dog) draw() {
	self.anime.draw()
}

pub fn (self &Dog) unload() {
	self.anime.unload()
}
