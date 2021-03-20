module plants

import lyra

pub struct Oak {
mut:
	algo Algo
	y    f32
}

pub fn (mut self Oak) load(x int, y int) {
	self.y = y
	self.algo = Algo{}
	self.algo.cs_branch = [40, 70, 170, 202, 60, 100]
	self.algo.max_row = 8
	self.algo.split_chance = 70
	self.algo.split_angle = [20, 30]
	self.algo.grow_time = 20
	self.algo.load(x, y)
}

pub fn (mut self Oak) update() {
	self.algo.update()
}

pub fn (self &Oak) draw(eye &lyra.Eye) {
	self.algo.draw(eye)
}

pub fn (self &Oak) unload() {
}

pub fn (mut self Oak) collided(element string, dp f32) {
	self.algo.collided(element, dp)
}

pub fn (self &Oak) get_hitbox() []f32 {
	return self.algo.get_hitbox()
}
