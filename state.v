module state

interface Screen {
	mut:
	load(mut State)
	update(mut State)
	draw(&State)
	unload()
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
	mouse   C.Vector2
}

pub fn (mut state State) set_screen(screen Screen) {
	state.cx = 0
	state.screen.unload()
	state.screen = Screen(screen)
	state.screen.load(mut state)
}
