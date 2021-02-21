module main

import vraylib
import screens

const (
	game_width  = 1920
	game_height = 1080
)

[live]
fn set_up_camera(mut camera C.Camera2D) {
	screen_width := f32(vraylib.get_screen_width())
	screen_height := f32(vraylib.get_screen_height())
	scale_x := screen_width / game_width
	scale_y := screen_height / game_height
	mut zoom := f32(1)
	mut offset_x := f32(0)
	mut offset_y := f32(0)
	if scale_x < scale_y {
		zoom = scale_x
		offset_y = (screen_height - zoom * game_height) * .5
	} else {
		zoom = scale_y
		offset_x = (screen_width - zoom * game_width) * .5
	}
	camera.zoom = zoom
	camera.offset = C.Vector2{offset_x, offset_y}
}

fn main() {
	// init
	mut camera := C.Camera2D{}
	camera.target = C.Vector2{0, 0}
	vraylib.init_window(800, 650, 'Kasaival')
	vraylib.set_target_fps(60)
	mut current := screens.Current{}
	current.set_screen(.menu)
	// loop
	for {
		if vraylib.window_should_close() {
			break
		}
		{
			// update
			set_up_camera(mut camera)
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
