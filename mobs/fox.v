module mobs

import lyra

pub struct Fox {
pub mut:
	y int
mut:
	x       int
	texture C.Texture2D
	anime   lyra.Animation
}

pub fn (mut self Fox) load(x int, y int) {
	self.x, self.y = x, y
	self.anime = lyra.Animation{}
	self.anime.load('Fox', 20, 12, 153, 139, 0)
}

pub fn (mut self Fox) update() {
	self.anime.update(self.x, self.y)
}

pub fn (self &Fox) draw() {
	self.anime.draw()
}

pub fn (self &Fox) unload() {
	self.anime.unload()
}
