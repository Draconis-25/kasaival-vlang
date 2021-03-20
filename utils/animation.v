module utils

import vraylib

pub struct Animation {
mut:
	x f32
	y f32
	w int
	h int
	counter    int
	texture    C.Texture2D
	frame      int
	frames     [][]int
	speed      int
	pos        C.Vector2
	burn_frame int
	burning    bool
}

pub fn (mut self Animation) load(mob string, speed int, total_frames int, frame_w int, frame_h int, burn_frame int) {
	self.burn_frame = burn_frame
	self.speed = speed
	self.texture = vraylib.load_texture('resources/mobs/' + mob + '.png')
	self.frames = [][]int{}
	self.w, self.h = frame_w, frame_h
	mut x, mut y := 0, 0
	for y < self.texture.height {
		for x < self.texture.width {
			self.frames << [x, y]
			if self.frames.len == total_frames {
				break
			}

			x += frame_w
		}
		x = 0
		y += frame_h
	}
}

pub fn (mut self Animation) update(x f32, y f32) {
	mut rm_frames := 0
	if !self.burning {
		rm_frames = self.burn_frame
	}
	self.counter++
	if self.counter >= 60 / self.speed {
		self.frame++

		if self.frame == self.frames.len - rm_frames {
			self.frame = 0
		}
		self.counter = 0
	}
	self.x, self.y = x, y
}

fn (self &Animation) get_rect() C.Rectangle {
	frame := self.frames[self.frame]
	return C.Rectangle{frame[0], frame[1], self.w, self.h}
}

fn (self &Animation) get_pos() C.Vector2 {
		return C.Vector2{self.x + f32(self.w) * .5, self.y - self.h}
}

pub fn (self &Animation) draw() {

	vraylib.draw_texture_rec(self.texture, self.get_rect(), self.get_pos(), vraylib.white)
}

pub fn (self &Animation) unload() {
	vraylib.unload_texture(self.texture)
}
