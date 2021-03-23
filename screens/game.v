module screens

import lyra
import player
import scenery
import stages
import vraylib
import rand
import ecs
import ui
import state

enum ToOrder {
	player
	entity
}

struct Z_Order {
	entity ToOrder
	y      f32
	i      int
}

pub struct Game {
mut:
	entities     []ecs.Entity
	entity_order []Z_Order
	player       player.Core        = player.Core{}
	ground       scenery.Ground     = scenery.Ground{}
	background   scenery.Background = scenery.Background{}
	stage        stages.StageName   = .desert
	music        C.Music
	spawners     []stages.Spawner
	hud          ui.HUD
	elapsed      int
}

fn (mut self Game) add_entity(name ecs.EntityName, state &state.State) {
	new_entity := ecs.new_entity(name)
	x, y := ecs.get_spawn_pos(state)
	new_entity.load(x, y)

	// if found blank entity (such as an entity that has died)
	// then replace it with the new entity
	mut found_blank := false
	for i, entity in self.entities {
		match entity {
			ecs.Blank {
				self.entities[i] = new_entity
				found_blank = true
				return
			}
			else {}
		}
	}
	if !found_blank {
		self.entities << new_entity
	}
}

fn (mut self Game) load_scene(scene stages.Scene, mut state state.State) {
	for mut spawner in scene.spawners {
		spawner.timer = rand.int_in_range(0, spawner.interval)
		self.spawners << spawner
	}
	self.ground.load(mut state, scene.ground.width, scene.ground.cs)
	self.player.load()
	for _ in 0 .. 10 {
		self.add_entity(.dog, state)
	}
	// load music
	self.music = vraylib.load_music_stream('resources/music/' + scene.music)
	vraylib.play_music_stream(self.music)
	// load bacground
	self.background.load(scene.background, state)
}

pub fn (mut self Game) load(mut state state.State) {
	// load current scene
	scenes := stages.get_props(self.stage)
	self.load_scene(scenes[0], mut state)
	// load hud
	self.hud = ui.HUD{}
	self.hud.load()
}

pub fn (mut self Game) update(mut state state.State) {
	defer {
		if state.exit {
			state.set_screen(&Menu{})
			state.exit = false
		}
	}
	// game time elapsed
	self.elapsed++
	if self.elapsed % (4 * lyra.fps) == 0 {
		state.score++
	}
	// music
	if !state.mute {
		vraylib.update_music_stream(self.music)
	}
	// mobs, plants. entities, player, ground, sky, scenery
	if !state.pause {
		for mut spawner in self.spawners {
			spawner.timer++
			if spawner.timer > spawner.interval {
				self.add_entity(spawner.name, state)
				spawner.timer = 0
			}
		}

		self.background.update(state)
		self.ground.update()

		self.entity_order = []Z_Order{}
		for i, mut entity in self.entities {
			if !entity.dead {
				entity.update(state)

				self.entity_order << Z_Order{.entity, entity.y, i}

				if ecs.check_collision(self.player.get_hitbox(), entity.get_hitbox()) {
					entity.collided(self.player.element, self.player.dp)
				}
			} else {
				state.score += entity.points
				self.entities[i] = &ecs.Blank{}
			}
		}

		self.player.update(mut state)
		self.ground.collide(self.player.get_hitbox(), self.player.element, self.player.dp)
		for i, p in self.player.flame.particles {
			self.entity_order << Z_Order{.player, p.y, i}
		}
		self.entity_order.sort(a.y < b.y)
	}

	// update interface
	self.hud.update(mut state)
}

pub fn (self &Game) draw(state &state.State) {
	self.background.draw(state)
	self.ground.draw(state)

	for obj in self.entity_order {
		match obj.entity {
			.player { self.player.draw(obj.i) }
			.entity { self.entities[obj.i].draw(state) }
		}
	}
	self.hud.draw(state)
}

pub fn (self &Game) unload() {
	vraylib.unload_music_stream(self.music)
	self.background.unload()
	self.ground.unload()
	self.player.unload()
	for entity in self.entities {
		entity.unload()
	}
	self.hud.unload()
}
