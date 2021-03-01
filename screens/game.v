module screens

import vraylib
import player
import ground
import stages

pub struct Game {
mut:
	player        player.Core = player.Core{}
	ground        ground.Core = ground.Core{}
	current_stage stages.StageName = .desert
}

pub fn (mut self Game) load() {
	props := stages.get_props(self.current_stage)
	width := props[0].add_width
	cs :=  props[0].color_scheme
	self.ground.load(width, cs)
	self.player.load()
}

pub fn (mut self Game) update() Next {
	self.ground.update()
	self.player.update()
	return .@none
}

pub fn (self &Game) draw() {
	self.ground.draw()
	self.player.draw()
}

pub fn (self &Game) unload() {
	self.ground.unload()
	self.player.unload()
}
