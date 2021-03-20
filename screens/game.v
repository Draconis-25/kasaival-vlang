module screens

import lyra
import player
import scenery
import stages
import vraylib
import rand
import ecs
import ui

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
	entities      []ecs.Entity
	entity_order  []Z_Order
	player        player.Core        = player.Core{}
	ground        scenery.Ground     = scenery.Ground{}
	background    scenery.Background = scenery.Background{}
	current_stage stages.StageName   = .desert
	music         C.Music
	mute          bool
	key_timeout   int
	spawners      []stages.Spawner
	hud 					ui.HUD
}

fn get_spawn_pos(eye &lyra.Eye) (int, int) {
	x := rand.int_in_range(eye.start_x, int(eye.start_x + eye.gw))
	y := rand.int_in_range(lyra.start_y, lyra.game_height)
	return x, y
}

fn (mut self Game) add_entity(name ecs.EntityName, eye lyra.Eye) {
	entity := ecs.new_entity(name)
	x, y := get_spawn_pos(eye)
	entity.load(x, y)
	self.entities << entity
}

fn (mut self Game) load_scene(scene stages.Scene, mut eye lyra.Eye) {
	for mut spawner in scene.spawners {
		spawner.timer = rand.int_in_range(0, spawner.interval)
		self.spawners << spawner
	}
	self.ground.load(mut eye, scene.ground.width, scene.ground.cs)
	self.player.load()
	for _ in 0 .. 10 {
		self.add_entity(.dog, eye)
	}
}

pub fn (mut self Game) load(mut eye lyra.Eye) {
	// load current scene
	scenes := stages.get_props(self.current_stage)
	self.load_scene(scenes[0], mut eye)
	// load bacground
	self.background.load(eye)
	// load music
	self.music = vraylib.load_music_stream('resources/music/spring/simple_desert.ogg')
	vraylib.play_music_stream(self.music)
	self.mute = true
	// load hud
	self.hud = ui.HUD{}
	self.hud.load()
}

fn check_collision(a []f32, b []f32) bool {
	if a[0] < b[1] && a[1] > b[0] && a[2] < b[3] && a[3] > b[2] {
		return true
	} else {
		return false
	}
}

fn toggle(v bool) bool {
	if v {
		return false
	} else {
		return true
	}
}

pub fn (mut self Game) update(mut eye lyra.Eye) {
	for mut spawner in self.spawners {
		spawner.timer++
		if spawner.timer > spawner.interval {
			self.add_entity(spawner.name, eye)
			spawner.timer = 0
		}
	}

	if self.key_timeout > 0 {
		self.key_timeout--
	}
	if vraylib.is_key_down(vraylib.key_m) {
		if self.key_timeout == 0 {
			self.mute = toggle(self.mute)
		}
		self.key_timeout = 2
	}
	if !self.mute {
		vraylib.update_music_stream(self.music)
	}
	self.background.update(eye)
	self.ground.update()

	self.entity_order = []Z_Order{}

	for i, mut entity in self.entities {
		if !entity.dead {
			entity.update(eye)

			self.entity_order << Z_Order{.entity, entity.y, i}

			if check_collision(self.player.get_hitbox(), entity.get_hitbox()) {
				entity.collided(self.player.element, self.player.dp)
			}
		}
	}

	self.player.update(mut eye)
	self.ground.collide(self.player.get_hitbox(), self.player.element, self.player.dp)
	for i, p in self.player.flame.particles {
		self.entity_order << Z_Order{.player, p.y, i}
	}
	self.entity_order.sort(a.y < b.y)
	self.hud.update(eye)
}

pub fn (self &Game) draw(eye &lyra.Eye) {
	self.background.draw(eye)
	self.ground.draw(eye)

	for obj in self.entity_order {
		match obj.entity {
			.player { self.player.draw(obj.i) }
			.entity { self.entities[obj.i].draw(eye) }
		}
	}
	self.hud.draw(eye)
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
