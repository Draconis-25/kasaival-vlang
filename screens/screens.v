module screens

import lyra

enum Next {
	@none
	menu
	game
}

pub struct Core {
pub mut:
	name Next
	menu   Menu
	game   Game
}

pub fn (mut self Core) set(screen_name Next) {
	self.unload()
	self.name = screen_name
	self.load()
}

pub fn (mut self Core) load() {
	match self.name {
		.menu {
			self.menu = Menu{}
			self.menu.load()
		}
		.game {
			self.game = Game{}
			self.game.load()
		}
		.@none {}
	}
}

pub fn (mut self Core) update(mut eye lyra.Eye) {
	mut next := Next{}
	defer {
		if next != .@none {
			self.set(next)
		}
	}
	match self.name {
		.menu { next = self.menu.update() }
		.game { next = self.game.update(eye) }
		.@none {}
	}
}

pub fn (mut self Core) draw() {
	match self.name {
		.menu { self.menu.draw() }
		.game { self.game.draw() }
		.@none {}
	}
}

pub fn (mut self Core) unload() {
	match self.name {
		.menu { self.menu.unload() }
		.game { self.game.unload() }
		.@none {}
	}
}
