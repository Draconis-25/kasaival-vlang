module stages

import ecs

pub struct Scene {
	pub:
	width int
	color   []int
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
