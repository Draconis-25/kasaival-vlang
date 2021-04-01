module stages

import rand
import vraylib

pub struct Shrubland {
	pub mut:
	music string
	scenes []Scene
}

fn get_scene(w int, r int, g int, b int, rr int, rg int, rb int) Scene {
	mut scene := Scene{}
	scene.width = w
	scene.color = [r + rand.intn(rr), g + rand.intn(rg), b + rand.intn(rb)]
	return scene
}

fn get_shrubland() Scene {
	return get_scene(600, 190, 130, 10, 20, 10, 5)
}

fn get_beach() Scene {
	return get_scene(600, 200, 180, 60, 20, 10, 10)
}

pub fn (mut self Shrubland) load() {
	self.music = 'spring/maintheme.ogg'
	// add ocean
	mut ocean := Scene{}
	ocean.width = 1500
	ocean.color = [50, 60, 220]
	self.scenes << ocean
	// add beach
	self.scenes << get_beach()
	self.scenes << get_beach()
	// add shrubland
	self.scenes << get_shrubland()
	self.scenes << get_shrubland()
	// add cave_entrance
	mut cave := Scene{}
	cave.width = 1920
	cave.color = [180, 150, 20]
	cave.scenary = Scenary{vraylib.load_texture(path + 'cave.png'), .8}
	self.scenes << cave
	// add end
	mut end := Scene{}
	end.color = [140, 110, 40]
	self.scenes << end

	// add cave
}
