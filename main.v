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
	vraylib.set_target_fps(30)
	vraylib.set_window_state(vraylib.flag_window_resizable)
	vraylib.init_audio_device()
	mut screen := screens.Core{}
	mut eye := lyra.Eye{}
	eye.update_camera()
	screen.load(.game, mut eye)
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
			screen.update(mut eye)
			eye.update_camera()
			// draw
			vraylib.begin_drawing()
			vraylib.begin_mode_2d(eye.camera)
			vraylib.clear_background(vraylib.black)
			screen.draw(eye)
			vraylib.end_mode_2d()
			// make the rest of the screen black (outside of game)
			w := int(eye.camera.offset.x)
			h := vraylib.get_screen_height()
			vraylib.draw_rectangle(0, 0, w, h, vraylib.black)
			x := vraylib.get_screen_width()
			vraylib.draw_rectangle(x - w, 0, w, h, vraylib.black)
			vraylib.end_drawing()
		}
	}
	screen.unload()
	vraylib.close_audio_device()
	vraylib.close_window()
}
