module stages

import rand
import waotzi.vraylib

pub struct Shrubland {
pub mut:
	music  string
	scenes []Scene
}

pub fn (mut self Shrubland) load() {
	self.music = 'spring/maintheme.ogg'

	// add start
	self.scenes << Scene{1500,  [21, 0, 13]}

	// add ocean
	self.scenes << Scene{1500, ocean}
	// add beach
	self.scenes << Scene{1000, beach}
	// add shrubland
	self.scenes << Scene{7000, shrubland}
	// add beach
	self.scenes << Scene{1000, beach}
	// add ocean
	self.scenes << Scene{1500, ocean}
	// add end
	mut end := Scene{}
	end.color = [21, 0, 13]
	self.scenes << end

	// add cave
}
