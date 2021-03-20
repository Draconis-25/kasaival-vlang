module plants

import lyra

pub struct Saguaro {
mut:
	algo Algo
	y    f32
	dead bool
}

pub fn (mut self Saguaro) load(x int, y int) {
	self.y = y
	self.algo = Algo{
		w: 14
		h: 42
		max_row: 7
		cs_branch: [125, 178, 122, 160, 76, 90]
		cs_leaf: [150, 204, 190, 230, 159, 178]
		change_color: [-25, -64, -50, 0]
		grow_time: 20
		split_chance: 40
	}
	self.algo.load(x, y)
}

pub fn (mut self Saguaro) update(eye &lyra.Eye) {
	self.algo.update()
}

pub fn (self &Saguaro) draw(eye &lyra.Eye) {
	self.algo.draw(eye)
}

pub fn (self &Saguaro) unload() {
}

pub fn (mut self Saguaro) collided(element string, dp f32) {
	self.algo.collided(element, dp)
}

pub fn (self &Saguaro) get_hitbox() []f32 {
	return self.algo.get_hitbox()
}
