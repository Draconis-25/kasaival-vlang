module plants

fn (mut self Core) oak() {
	self.cs = [40, 70, 170, 202, 60, 100]
	self.max_row = 8
	self.split_chance = 70
	self.split_angle = [20, 30]
	self.grow_time = 20
}
