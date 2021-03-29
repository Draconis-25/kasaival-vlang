module stages

pub struct Shrubland {
	pub mut:
	music string
	scenes []Scene
}

const ocean_cs = [[40, 50, 40, 60, 200, 220], [20, 30, 60, 80, 200, 220]]
const beach_cs = [[180, 200, 190, 220, 40, 60], [200, 220, 190, 220, 40, 60]]
const shrubland_cs =  [[180, 190, 220, 250, 40, 60]]
const cave_cs = [[180, 200, 150, 180, 60, 90]]

pub fn (mut self Shrubland) load() {
	self.music = 'spring/maintheme.ogg'
	// add ocean
	self.scenes << Scene{1000, ocean_cs}
	// add beach
	self.scenes << Scene{1600, beach_cs}
	// add shrubland
	self.scenes << Scene{2400, shrubland_cs}
	// add cave
	self.scenes << Scene{1920, cave_cs}
}
