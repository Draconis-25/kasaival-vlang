module main

import lyra
import vraylib
import screens
import state

// the initiale window screen size
const (
	screen_width  = 800
	screen_height = 450
	window_title  = 'Kasaival'
)


fn main() {
	// init
	// vraylib setup
	vraylib.set_config_flags(vraylib.flag_window_resizable)
	vraylib.init_window(screen_width, screen_height, window_title)
	vraylib.set_target_fps(lyra.fps)
	vraylib.init_audio_device()

	mut state := state.State{}
	mut camera := C.Camera2D{}
	camera.zoom, camera.offset = lyra.get_game_scale()
	state.screen = screens.Menu{}
	state.screen.load(state)

	// screen.load(.game, mut state)
	mut key_timeout := 0

	// loop
	for {
		if vraylib.window_should_close() {
			break
		}
		{
			// update
			if key_timeout > 0 {
				key_timeout--
			}
			if vraylib.is_key_down(vraylib.key_f) {
				if key_timeout == 0 {
					vraylib.toggle_fullscreen()
				}
				key_timeout = 2
			}
			state.screen.update(state)

			if vraylib.is_window_resized() {
				camera.zoom, camera.offset = lyra.get_game_scale()
			}
			camera.target = C.Vector2{state.cx, 0}
			// draw
			vraylib.begin_drawing()
			vraylib.begin_mode_2d(camera)
			vraylib.clear_background(vraylib.black)
			state.screen.draw(state)
			vraylib.end_mode_2d()
			// make the rest of the screen black (outside of game)
			w := int(camera.offset.x)
			h := vraylib.get_screen_height()
			vraylib.draw_rectangle(0, 0, w, h, vraylib.black)
			x := vraylib.get_screen_width()
			vraylib.draw_rectangle(x - w, 0, w, h, vraylib.black)
			vraylib.end_drawing()
			// reset cursor
			vraylib.set_mouse_cursor(vraylib.mouse_cursor_default)
		}
	}

	// exit
	state.screen.unload()

	vraylib.close_audio_device()
	vraylib.close_window()
}
