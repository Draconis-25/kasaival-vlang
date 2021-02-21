module screens

enum Next {
	@none
	menu
	game
}

pub struct Current {
pub mut:
	screen Next
	menu   Menu
	game   Game
}

pub fn (mut current Current) set_screen(screen_name Next) {
	current.unload()
	current.screen = screen_name
	current.load()
}

pub fn (mut current Current) load() {
	match current.screen {
		.menu {
			current.menu = Menu{}
			current.menu.load()
		}
		.game {
			current.game = Game{}
			current.game.load()
		}
		.@none {}
	}
}

pub fn (mut current Current) update() {
	match current.screen {
		.menu {
			next := current.menu.update()
			if next != .@none {
				current.set_screen(next)
			}
		}
		.game {
			next := current.game.update()
			if next != .@none {
				current.set_screen(next)
			}
		}
		.@none {}
	}
}

pub fn (mut current Current) draw() {
	match current.screen {
		.menu { current.menu.draw() }
		.game { current.game.draw() }
		.@none {}
	}
}

pub fn (mut current Current) unload() {
	match current.screen {
		.menu { current.menu.unload() }
		.game { current.game.draw() }
		.@none {}
	}
}
