module plants

import lyra

pub struct Kali {
mut:
	algo Algo
	y    f32
}

pub fn (mut self Kali) load(x int, y int) {
	self.y = y
	self.algo = Algo{}
	self.algo.cs_branch = [140, 170, 160, 190, 25, 50]
	self.algo.change_color = [-70, -100, -10]
	self.algo.grow_time = 20
	self.algo.max_row = 5
	self.algo.w = 22
	self.algo.h = 22
	self.algo.split_chance = 100
	self.algo.split_angle = [40, 60]
	self.algo.two_start_branches = true
	self.algo.load(x, y)
}

pub fn (mut self Kali) update() {
	self.algo.update()
}

pub fn (self &Kali) draw(eye &lyra.Eye) {
	self.algo.draw(eye)
}

pub fn (self &Kali) unload() {
}

pub fn (mut self Kali) collided(element string, dp f32) {
	self.algo.collided(element, dp)
}

pub fn (self &Kali) get_hitbox() []f32 {
	return self.algo.get_hitbox()
}
