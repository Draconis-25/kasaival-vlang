module main

import screens
import lyra
import vraylib


// the initiale window screen size
const (
	screen_width  = 800
	screen_height = 450
)

fn main() {
	// init

	vraylib.init_window(screen_width, screen_height, 'Kasaival')
	vraylib.set_target_fps(60)
	vraylib.set_window_state(vraylib.flag_window_resizable)
	vraylib.init_audio_device()
	mut screen := screens.Core{}
	mut eye := lyra.Eye{}
	eye.update_camera()

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
			if vraylib.is_window_resized() {
				eye.update_camera()
			}
			screen.update(mut eye)
			eye.camera.target = C.Vector2{eye.cx, 0}
			// draw
			vraylib.begin_drawing()
			vraylib.begin_mode_2d(eye.camera)
			vraylib.clear_background(vraylib.black)
			screen.draw(eye)
			vraylib.end_mode_2d()
			vraylib.end_drawing()
		}
	}
	screen.unload()
	vraylib.close_audio_device()
	vraylib.close_window()
}
