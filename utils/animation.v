module utils

import vraylib

pub struct Animation {
pub mut:
	state string
	direction int

mut:
	x         f32
	y         f32
	w         int
	h         int
	counter   int
	texture   C.Texture2D
	frame     int
	frames    [][]int
	speed     int
	pos       C.Vector2
	burning   bool
	states    map[string]int
}

pub fn (mut self Animation) load(mob string, states map[string]int, speed int, frame_w int, frame_h int, burn_frame int) {
	self.states = &states
	self.direction = 1
	self.speed = speed
	self.texture = vraylib.load_texture('resources/mobs/' + mob + '.png')
	self.frames = [][]int{}
	self.w, self.h = frame_w, frame_h
	mut x, mut y := 0, 0

	for y < self.texture.height {
		for x < self.texture.width {
			self.frames << [x, y]
			if self.frames.len == 12 {
				break
			}

			x += frame_w
		}
		x = 0
		y += frame_h
	}
}

pub fn (mut self Animation) update(x f32, y f32) {
	self.counter++
	if self.counter >= 60 / self.speed {
		self.frame++

		mut start_frame := 0
		mut state_frames := 0
		for state, frames in &self.states {
			if self.state == state {
				state_frames = frames
				break
			}
			start_frame += frames
		}
		if self.frame >= start_frame + state_frames || self.frame < start_frame {
			self.frame = start_frame
		}
		self.counter = 0
	}
	self.x, self.y = x, y
}

fn (self &Animation) get_rect() C.Rectangle {
	frame := self.frames[self.frame]
	return C.Rectangle{frame[0], frame[1], self.w * self.direction, self.h}
}

fn (self &Animation) get_pos() C.Vector2 {
	return C.Vector2{self.x, self.y - self.h}
}

pub fn (self &Animation) draw() {
	vraylib.draw_texture_rec(self.texture, self.get_rect(), self.get_pos(), vraylib.white)
}

pub fn (self &Animation) unload() {
	vraylib.unload_texture(self.texture)
}