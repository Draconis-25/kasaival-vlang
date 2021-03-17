module main

import lyra
import vraylib
import screens

// the initiale window screen size
const (
	screen_width  = 800
	screen_height = 450
	target_fps = 30
	window_title = "Kasaival"
)

type Screens = screens.Game | screens.Menu

interface Screen {
	load(&lyra.Eye)
	update(&lyra.Eye)
	draw(&lyra.Eye)
	unload()
}


fn main() {
	// init
	// vraylib setup
	vraylib.set_config_flags(vraylib.flag_window_resizable)
	vraylib.init_window(screen_width, screen_height, window_title)
	vraylib.set_target_fps(target_fps)
	vraylib.init_audio_device()


	mut eye := lyra.Eye{}
	eye.camera.zoom, eye.camera.offset = lyra.get_game_scale()
	eye.state = .menu
	mut current := eye.state

	mut scrs := []Screen{}

	mut menu := screens.Menu{}
	scrs << menu
	scrs[0].load(eye)


	//screen.load(.game, mut eye)
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

			if current != eye.state {
				scrs[0].unload()
				match eye.state {
						.game {
							game := screens.Game{}
							scrs[0] = game
							scrs[0].load(eye)
						}
						.menu {
							menu = screens.Menu{}
							scrs[0] = menu
							scrs[0].load(eye)
						}
					}
					current = eye.state
			}
			scrs[0].update(eye)


			if vraylib.is_window_resized() {
				eye.camera.zoom, eye.camera.offset = lyra.get_game_scale()
			}
			eye.camera.target = C.Vector2{eye.cx, 0}
			// draw
			vraylib.begin_drawing()
			vraylib.begin_mode_2d(eye.camera)
			vraylib.clear_background(vraylib.black)
			scrs[0].draw(eye)
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

	// exit
	scrs[0].unload()

	vraylib.close_audio_device()
	vraylib.close_window()
}
