module screens

import vraylib
import player
import ground

pub struct Game {
mut:
	player player.Core = player.Core{}
	ground ground.Core = ground.Core{}
}

pub fn (mut self Game) load() {
	self.ground.load()
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
