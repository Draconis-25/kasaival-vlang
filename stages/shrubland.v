module stages

import rand
import waotzi.vraylib

pub struct Shrubland {
pub mut:
	music  string
	scenes []Scene
}

fn get_scene(w int, r int, g int, b int, rr int, rg int, rb int) Scene {
	mut scene := Scene{}
	scene.width = w
	scene.color = [r + rand.intn(rr), g + rand.intn(rg), b + rand.intn(rb)]
	return scene
}

fn get_beach() Scene {
	return get_scene(1000, 200, 180, 60, 20, 10, 10)
}

fn get_shrubland() Scene {
	mut scene := get_scene(1000, 180, 120, 10, 20, 10, 5)
	for i in 0 .. 3 {
		pos_y := [360, 220, 160]
		scene.scenary << Scenary{vraylib.load_texture(path + 'shrubland/' + i.str() + '.png'), .1 * (3 - f32(i)), pos_y[i]}
	}
	return scene
}

fn get_forecave() Scene {
	mut scene := get_scene(1000, 60, 0, 40, 10, 1, 6)
	mut cave := Scenary{}
	cave.texture = vraylib.load_texture(path + 'cave.png')
	scene.scenary << cave
	return scene
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
	// add shrubland
	self.scenes << get_shrubland()
	// add cave_entrance
	self.scenes << get_forecave()
	// add end
	mut end := Scene{}
	end.color = [21, 0, 13]
	self.scenes << end

	// add cave
}
