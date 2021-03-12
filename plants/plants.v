module plants

fn (mut self Core) load_props(name Names) {
	match name {
		.saguaro {
			self.saguaro()
		}
		.oak {
			self.oak()
		}
		.kali {
			self.kali()
		}
	}
}

fn (mut self Core) oak() Core {
	mut plant := Core{}
	plant.cs_branch = [40, 70, 170, 202, 60, 100]
	plant.max_row = 8
	plant.split_chance = 70
	plant.split_angle = [20, 30]
	plant.grow_time = 20
	return plant
}

fn (mut self Core) saguaro()  {
	self.cs_branch = [125, 178, 122, 160, 76, 90]
	self.cs_leaf = [150, 204, 190, 230, 159, 178]
	self.change_color =[-25, -64, -50, 0]
	self.grow_time = 20
	self.max_row = 7
	self.w = 14
	self.h = 42
	self.split_chance = 40
}


fn (mut self Core) kali()  {
    self.cs_branch = [102, 128, 153, 179, 25, 50]
    self.change_color =[-50, -50, -10]
    self.grow_time = 20
    self.max_row = 5
    self.w = 22
		self.h = 22
    self.split_chance = 0
    self.split_angle = [40, 60]
		self.two_start_branches = true
}
