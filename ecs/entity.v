module ecs

import plants
import mobs
import lyra
import rand
import state

interface Entity {
	y f32
	dead bool
	points int
	load(int, int)
	update(state &state.State)
	unload()
	draw(state &state.State)
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

pub fn get_spawn_pos(state &state.State) (int, int) {
	x := rand.int_in_range(state.start_x, int(state.start_x + state.gw))
	y := rand.int_in_range(lyra.start_y, lyra.game_height)
	return x, y
}

pub fn check_collision(a []f32, b []f32) bool {
	if a[0] < b[1] && a[1] > b[0] && a[2] < b[3] && a[3] > b[2] {
		return true
	} else {
		return false
	}
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
			return Entity(plants.saguaro())
		}
		.kali {
			return Entity(plants.kali())
		}
		.oak {
			return Entity(plants.oak())
		}
	}
}
