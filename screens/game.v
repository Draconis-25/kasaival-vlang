module screens

import vraylib
import player
import scenery
import stages
import lyra

pub struct Game {
mut:
	player        player.Core = player.Core{}
	ground        scenery.Ground = scenery.Ground{}
	background    scenery.Background = scenery.Background{}
	current_stage stages.StageName = .desert
}

pub fn (mut self Game) load(eye &lyra.Eye) {
	props := stages.get_props(self.current_stage)
	width := props[0].add_width
	cs := props[0].color_scheme
	self.background.load()
	self.ground.load(eye, width, cs)
	self.player.load()
}

pub fn (mut self Game) update(eye &lyra.Eye) Next {
	self.background.update()
	self.ground.update()
	self.player.update(eye)
	return .@none
}

pub fn (self &Game) draw(eye &lyra.Eye) {
	self.background.draw(eye)
	self.ground.draw()
	self.player.draw()
}

pub fn (self &Game) unload() {
	self.background.unload()
	self.ground.unload()
	self.player.unload()
}
