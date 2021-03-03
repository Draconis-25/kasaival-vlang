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

pub fn (mut self Core) load(screen_name Next, mut eye lyra.Eye) {
	// make sure no screen is loaded
	self.unload()
	// set new screen
	self.name = screen_name
	// load new screen
	match self.name {
		.menu {
			self.menu = Menu{}
			self.menu.load()
		}
		.game {
			self.game = Game{}
			self.game.load(mut eye)
		}
		.@none {}
	}
}

pub fn (mut self Core) update(mut eye lyra.Eye) {
	mut next := Next{}
	defer {
		if next != .@none {
			self.load(next, mut eye)
		}
	}
	match self.name {
		.menu { next = self.menu.update() }
		.game { next = self.game.update(mut eye) }
		.@none {}
	}
}

pub fn (mut self Core) draw(eye lyra.Eye) {
	match self.name {
		.menu { self.menu.draw() }
		.game { self.game.draw(eye) }
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
