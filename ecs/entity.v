module ecs

import plants
import mobs
import lyra

interface Entity {
	y f32
	dead bool
	load(int, int)
	update()
	unload()
	draw(lyra &lyra.Eye)
	collided(string, f32)
	get_hitbox() []f32
}

enum EntityName {
	// mobs
	dog
	frog
	fox
	// plants
	saguaro
	kali
	oak
}

pub fn new_entity(name EntityName) Entity {
	match name {
		// mobs
		.dog {
			return &mobs.Dog{}
		}
		.frog {
			return &mobs.Frog{}
		}
		.fox {
			return &mobs.Fox{}
		}
		// plants
		.saguaro {
			return &plants.Saguaro{}
		}
		.kali {
			return &plants.Kali{}
		}
		.oak {
			return &plants.Oak{}
		}
	}
}
