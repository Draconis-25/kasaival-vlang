module stages

import ecs

const path = 'resources/scenery/'

const (
	ocean     = [50, 60, 220]
	beach     = [200, 180, 60]
	shrubland = [180, 120, 10]
	caveland  = [60, 0, 40]
)

struct Scenary {
pub mut:
	texture C.Texture2D
	cx      f32
	y       int
}

pub struct Scene {
pub mut:
	width int
	color []int
}

pub interface Stage {
	music string
	load()
}

/*
enum StageName {
	@none
	shrubland
	grassland
}

struct Ground {
pub mut:
	width int
	cs    [][]int
}

struct Spawner {
pub mut:
	name     ecs.EntityName
	interval int
	timer    int
}


fn get_spawner(name ecs.EntityName, interval int) Spawner {
	mut spawner := Spawner{}
	spawner.interval = interval
	spawner.name = name
	return spawner
}*/
