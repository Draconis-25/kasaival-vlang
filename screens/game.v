module screens

import vraylib
import player
import ground
import background
import stages
import lyra

pub struct Game {
mut:
	player        player.Core = player.Core{}
	ground        ground.Core = ground.Core{}
	background    background.Core = background.Core{}
	current_stage stages.StageName = .desert
}

pub fn (mut self Game) load() {
	props := stages.get_props(self.current_stage)
	width := props[0].add_width
	cs := props[0].color_scheme
	self.background.load()
	self.ground.load(width, cs)
	self.player.load()
}

pub fn (mut self Game) update(mut eye lyra.Eye) Next {
	self.background.update()
	self.ground.update()
	self.player.update(eye)
	return .@none
}

pub fn (self &Game) draw() {
	self.background.draw()
	self.ground.draw()
	self.player.draw()
}

pub fn (self &Game) unload() {
	self.background.unload()
	self.ground.unload()
	self.player.unload()
}
