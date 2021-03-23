module screens

import vraylib
import ui
import state

const start_x = 200

const start_y = 500

const stages = ['desert', 'grassland']

const stages_id = [0, 1]

const path = 'resources/stages/'

const ext = '.jpg'

pub struct Carousel {
mut:
	background C.Texture2D
	stages     []ui.ImageButton
}

pub fn (mut self Carousel) load(mut state state.State) {
	state.cx = 0
	self.background = vraylib.load_texture('resources/menu.jpg')

	mut w := 0
	mut off_x := 100
	for i, stage in screens.stages {
		img := vraylib.load_texture(screens.path + stage + screens.ext)
		x := screens.start_x + w + off_x * i
		y := screens.start_y
		self.stages << ui.ImageButton{img, x, y, 1}
		w = img.width
	}
}

pub fn (mut self Carousel) update(mut state state.State) {
	pressed := vraylib.is_mouse_button_pressed(vraylib.mouse_left_button)
	for i, stage in self.stages {
		if stage.mouse_on_button() {
			if pressed {
				match i {
					0 {
						state.set_screen(&Game{
							stage: .desert
						})
					}
					1 {
						state.set_screen(&Game{
							stage: .grassland
						})
					}
					else {}
				}
			}
		}
	}
}

pub fn (self &Carousel) draw(state &state.State) {
	vraylib.draw_texture_ex(self.background, C.Vector2{0, 0}, 0, 1, vraylib.white)
	vraylib.draw_text('KASAIVAL', 480, 160, 200, vraylib.maroon)
	for stage in self.stages {
		stage.draw(state)
	}
}

pub fn (self &Carousel) unload() {
	vraylib.unload_texture(self.background)
	for stage in self.stages {
		stage.unload()
	}
}
