module plants

import lyra

pub struct Kali {
mut:
	algo Algo
	y    f32
	dead bool
}

pub fn (mut self Kali) load(x int, y int) {
	self.y = y
	self.algo = Algo{
		w: 22 h: 22
		max_row: 5
		grow_time: 20
		cs_branch: [140, 170, 160, 190, 25, 50]
		change_color: [-70, -100, -10]
		split_chance: 100
		split_angle: [40, 60]
		two_start_branches: true
	}
	self.algo.load(x, y)
}

pub fn (mut self Kali) update() {
	self.algo.update()
}

pub fn (self &Kali) draw(eye &lyra.Eye) {
	self.algo.draw(eye)
}

pub fn (mut self Kali) collided(element string, dp f32) {
	self.algo.collided(element, dp)
}

pub fn (self &Kali) get_hitbox() []f32 {
	return self.algo.get_hitbox()
}

pub fn (self &Kali) unload() {
}
