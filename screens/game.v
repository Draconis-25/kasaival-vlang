module screens

import waotzi.vraylib

import lyra
import player
import scenery
import stages
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
	stage        stages.Shrubland
	entities     []ecs.Entity
	entity_order []Z_Order
	player       player.Core = player.Core{}
	ground       scenery.Ground
	background   scenery.Background = scenery.Background{}
	sky          scenery.Sky        = scenery.Sky{}
	music        C.Music
	hud          ui.HUD
	elapsed      f32
}

fn (mut self Game) add_entity(name ecs.EntityName, start_x int, end_x int) {
	mut obj := ecs.new_entity(name)
	x, y := ecs.get_spawn_pos(start_x, end_x)
	obj.load(x, y)
	// if found blank entity (such as an entity that has died)
	// then replace it with the new entity
	mut found_blank := false
	for i, entity in self.entities {
		match entity {
			ecs.Blank {
				self.entities[i] = obj
				found_blank = true
				return
			}
			else {}
		}
	}
	if !found_blank {
		self.entities << obj
	}
}

fn (mut self Game) load_stage(mut state state.State) {
	// load stage
	self.stage = stages.Shrubland{}
	self.stage.load()
	// load music
	self.music = vraylib.load_music_stream('resources/music/' + self.stage.music)
	vraylib.play_music_stream(self.music)
	// setup state of stage
	state.gw = 0

	for scene in self.stage.scenes {
		state.gw += scene.width
	}
	state.start_x = int(-f32(state.gw) * .5 + lyra.game_width * .5)
	for mut obj in self.stage.spawners {
		obj.start_x += state.start_x
		obj.end_x += state.start_x
	}

	// load ground
	self.ground = scenery.Ground{}
	// add ground for each scene
	scenes := self.stage.scenes
	mut x := f32(state.start_x)
	for i, scene in scenes {
		if i < scenes.len - 1 {
			dire := if i < f32(scenes.len) * .5 { 1 } else { 0 }
			x = self.ground.add_section(x, scene.width, [scenes[i].color, scenes[i + 1].color],
				dire)
		}
	}

	// load player
	self.player.load()
	self.sky.load()

	/*
	for _ in 0 .. 10 {
		self.add_entity(.dog, state)
	}
	*/
}

pub fn (mut self Game) load(mut state state.State) {
	self.load_stage(mut state)
	// load hud
	self.hud = ui.HUD{}
	self.hud.load()
	state.cx = 0
	state.mute = false
}

pub fn (mut self Game) update(mut state state.State) {
	delta := vraylib.get_frame_time()
	self.elapsed += delta

	defer {
		if state.exit {
			state.set_screen(&Title{})
			state.exit = false
		}
	}

	// music
	if !state.mute {
		vraylib.update_music_stream(self.music)
	}
	// mobs, plants. entities, player, ground, sky, scenery
	if !state.pause {
		for mut obj in self.stage.spawners {
			obj.timer += delta
			if obj.timer >= obj.interval {
				self.add_entity(obj.name, obj.start_x, obj.end_x)
				obj.timer = 0
			}
		}
		self.background.update(state)
		self.sky.update(state)
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
		fuel := self.ground.collide(self.player.get_hitbox(), self.player.element, self.player.dp)
		self.player.burn(fuel)
		for i, p in self.player.flame.particles {
			self.entity_order << Z_Order{.player, p.y, i}
		}
		self.entity_order.sort(a.y < b.y)
	}

	// update interface
	self.hud.update(mut state)
}

pub fn (mut self Game) draw(state &state.State) {
	self.background.draw(state)
	self.sky.draw(state)
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
	self.sky.unload()
	self.ground.unload()
	self.player.unload()
	for entity in self.entities {
		entity.unload()
	}
	self.hud.unload()
}
