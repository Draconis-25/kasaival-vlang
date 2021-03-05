module screens

import lyra
import plants
import player
import scenery
import stages
import vraylib

type Entity = plants.Core | player.Core

struct Z_Order{
	i int
	y f32
	entity Entity
}

pub struct Game {
mut:
	entities      []Entity
	entity_order []Z_Order
	ground        scenery.Ground = scenery.Ground{}
	background    scenery.Background = scenery.Background{}
	current_stage stages.StageName = .desert
}

fn get_spawn_pos(eye &lyra.Eye) (int, int) {
	x := vraylib.get_random_value(lyra.start_x, int(lyra.start_x + eye.gw))
	y := vraylib.get_random_value(lyra.start_y, lyra.game_height)
	return x, y
}

fn (mut self Game) add_plant(eye &lyra.Eye) {
	mut plant := plants.Core{}
	x, y := get_spawn_pos(eye)
	w := vraylib.get_random_value(20, 30)
	h := vraylib.get_random_value(40, 50)
	plant.load(x, y, w, h)
	self.entities << plant
}

pub fn (mut self Game) load(mut eye lyra.Eye) {
	props := stages.get_props(self.current_stage)
	width := props[0].add_width
	cs := props[0].color_scheme
	self.background.load()
	self.ground.load(mut eye, width, cs)
	mut player := player.Core{}
	player.load()
	self.entities << player
	for _ in 0 .. 10 {
		self.add_plant(eye)
	}
}


pub fn (mut self Game) update(mut eye lyra.Eye) Next {
	self.background.update()
	self.ground.update()
	self.entity_order = []Z_Order{}
	for mut i, entity in self.entities {
		if mut entity is plants.Core {
			entity.update()
			self.entity_order << Z_Order{i, entity.y, &entity}
		}
		if mut entity is player.Core {
			entity.update(mut eye)
			self.ground.collide(entity.get_hitbox(), entity.element, entity.dp)
			self.entity_order << Z_Order{i, entity.y, &entity}
		}
	}
	self.entity_order.sort(a.y < b.y)
	return .@none
}

pub fn (self &Game) draw(eye &lyra.Eye) {
	self.background.draw(eye)
	self.ground.draw()
	for z_order in self.entity_order {
		if z_order.entity is plants.Core {
			z_order.entity.draw()
		}
		if z_order.entity is player.Core {
			z_order.entity.draw()
		}
	}
}

pub fn (self &Game) unload() {
	self.background.unload()
	self.ground.unload()
	for entity in self.entities {
		if entity is player.Core {
			entity.unload()
		}
	}
}
