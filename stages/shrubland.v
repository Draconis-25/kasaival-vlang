module stages

pub struct Shrubland {
	pub mut:
	music string
	scenes []Scene
}

pub fn (mut self Shrubland) load() {
	self.music = 'spring/maintheme.ogg'
	// add ocean
	self.scenes << Scene{1500, [50, 60, 220]}
	// add beach
	self.scenes << Scene{1500, [210, 200, 60]}
	// add shrubland
	self.scenes << Scene{1500, [170, 160, 20]}
	// add cave_entrance
	self.scenes << Scene{1920, [180, 180, 20]}
	// add end
	self.scenes << Scene{0, [150, 120, 40]}
}
