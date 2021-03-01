module main

import vraylib
import screens
import lyra


fn main() {
	// init
	mut camera := C.Camera2D{}
	camera.target = C.Vector2{0, 0}
	vraylib.init_window(800, 650, 'Kasaival')
	vraylib.set_target_fps(60)
	mut current := screens.Current{}
	current.set_screen(.game)
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
			current.update()
			// draw
			vraylib.begin_drawing()
			vraylib.begin_mode_2d(camera)
			vraylib.clear_background(vraylib.black)
			current.draw()
			vraylib.end_mode_2d()
			vraylib.end_drawing()
		}
	}
	current.unload()
	vraylib.close_window()
}
