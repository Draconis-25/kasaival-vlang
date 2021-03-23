module state

interface Screen {
	load(&State)
	update(&State)
	draw(&State)
	unload()
}

enum ScreenList {
	menu
	carousel
	game
}

pub struct State {
pub mut:
	screen  Screen
	exit    bool
	mute    bool
	pause   bool
	start_x int = -100
	cx      f32
	gw      f32 = 1000
	gh      f32 = 400
	score   int
}

pub fn (mut state State) set_screen(screen Screen) {
	state.cx = 0
	state.screen.unload()
	state.screen = Screen(screen)
	state.screen.load(state)
}
