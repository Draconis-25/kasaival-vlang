module stages

import ecs

enum StageName {
	@none
	desert
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

struct Scene {
pub mut:
	ground   Ground = Ground{}
	spawners []Spawner
}

fn get_spawner(name ecs.EntityName, interval int) Spawner {
	mut spawner := Spawner{}
	spawner.interval = interval
	spawner.name = name
	return spawner
}

pub fn get_props(stage_name StageName) []Scene {
	match stage_name {
		.desert { return desert() }
		.grassland { return []Scene{} }
		.@none { return []Scene{} }
	}
}
