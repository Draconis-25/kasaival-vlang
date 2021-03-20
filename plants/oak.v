module plants

import lyra

pub struct Oak {
mut:
	algo Algo
	y    f32
	dead bool
}

pub fn (mut self Oak) load(x int, y int) {
	self.y = y
	self.algo = Algo{
		cs_branch: [40, 70, 170, 202, 60, 100]
		max_row: 8
		split_chance: 70
		split_angle: [20, 30]
		grow_time: 20
	}
	self.algo.load(x, y)
}

pub fn (mut self Oak) update(eye &lyra.Eye) {
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
