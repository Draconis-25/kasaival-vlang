module main

import vraylib
import screens
import lyra

// the initiale window screen size
const (
	screen_width = 800
	screen_height = 450
)

fn main() {
	// init
	mut camera := C.Camera2D{}
	vraylib.init_window(screen_width, screen_height, 'Kasaival')
	vraylib.set_target_fps(60)
	mut screen := screens.Core{}
	mut eye := lyra.Eye{}
	screen.load(.game, mut eye)
	// loop
	for {
		if vraylib.window_should_close() {
			break
		}
		{
			// update
			if vraylib.is_key_down(vraylib.key_f) {
				vraylib.toggle_fullscreen()
			}
			camera.zoom, camera.offset = lyra.get_game_scale()
			screen.update(mut eye)
			camera.target = C.Vector2{eye.cx, 0}
			// draw
			vraylib.begin_drawing()
			vraylib.begin_mode_2d(camera)
			vraylib.clear_background(vraylib.black)
			screen.draw(eye)
			vraylib.end_mode_2d()
			vraylib.end_drawing()
		}
	}
	screen.unload()
	vraylib.close_window()
}
