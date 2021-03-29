module stages

pub struct Shrubland {
	pub mut:
	music string
	scenes []Scene
}

const ocean_gr = [[40, 40, 220], [70, 120, 190]]
const beach_gr = [[70, 120, 190], [220, 220, 60]]
const shrubland_gr =  [[220, 220, 60], [190, 250, 60]]
const cave_gr = [[190, 250, 60], [200, 180, 90]]

pub fn (mut self Shrubland) load() {
	self.music = 'spring/maintheme.ogg'
	// add ocean
	self.scenes << Scene{1000, ocean_gr}
	// add beach
	self.scenes << Scene{1600, beach_gr}
	// add shrubland
	self.scenes << Scene{2400, shrubland_gr}
	// add cave
	self.scenes << Scene{1920, cave_gr}
}
