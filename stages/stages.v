module stages

import ecs

const path = 'resources/scenery/'

struct Scenary {
pub mut:
	texture C.Texture2D
	cx      f32
	y       int
}

pub struct Scene {
pub mut:
	width   int
	color   []int
	scenary []Scenary
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
