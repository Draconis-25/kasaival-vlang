module screens

import lyra
import plants
import player
import scenery
import stages
import vraylib
import rand

enum Entity {
	player
	plant
}

struct Z_Order {
	entity Entity
	y      f32
	i      int
}

pub struct Game {
mut:
	plants        []plants.Core
	entity_order  []Z_Order
	player        player.Core = player.Core{}
	ground        scenery.Ground = scenery.Ground{}
	background    scenery.Background = scenery.Background{}
	current_stage stages.StageName = .desert
	music         C.Music
	mute          bool
	key_timeout   int
	spawners      []stages.Spawner
}

fn get_spawn_pos(eye &lyra.Eye) (int, int) {
	x := rand.int_in_range(eye.start_x, int(eye.start_x + eye.gw))
	y := rand.int_in_range(lyra.start_y, lyra.game_height)
	return x, y
}

fn (mut self Game) add_plant(name plants.Names, eye &lyra.Eye) {
	mut plant := plants.Core{}
	x, y := get_spawn_pos(eye)
	plant.load(name, x, y)
	self.plants << plant
}

fn (mut self Game) load_scene(scene stages.Scene, mut eye lyra.Eye) {
	for mut spawner in scene.spawners {
		spawner.timer = rand.int_in_range(0, spawner.interval)
		self.spawners << spawner
	}
	self.ground.load(mut eye, scene.ground.width, scene.ground.cs)
	self.player.load()
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

pub fn (mut self Game) update(mut eye lyra.Eye) Next {
	for mut spawner in self.spawners {
		spawner.timer++
		if spawner.timer > spawner.interval {
			self.add_plant(spawner.name, eye)
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
	for i, mut plant in self.plants {
		plant.update()
		self.entity_order << Z_Order{.plant, plant.y, i}
		if check_collision(self.player.get_hitbox(), plant.get_hitbox()) {
			plant.collided(self.player.element, self.player.dp)
		}
	}
	self.player.update(mut eye)
	self.ground.collide(self.player.get_hitbox(), self.player.element, self.player.dp)
	self.entity_order << Z_Order{.player, self.player.y, -1}
	self.entity_order.sort(a.y < b.y)
	return .@none
}

pub fn (self &Game) draw(eye &lyra.Eye) {
	self.background.draw(eye)
	self.ground.draw(eye)
	for obj in self.entity_order {
		match obj.entity {
			.plant { self.plants[obj.i].draw(eye) }
			.player { self.player.draw() }
		}
	}
}

pub fn (self &Game) unload() {
	vraylib.unload_music_stream(self.music)
	self.background.unload()
	self.ground.unload()
	self.player.unload()
}
