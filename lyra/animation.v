module lyra

import vraylib

pub struct Animation {
mut:
	counter    int
	texture    C.Texture2D
	frame      int
	frames     []C.Rectangle
	speed      int
	pos        C.Vector2
	burn_frame int
	burning    bool
}

pub fn (mut self Animation) load(mob string, speed int, total_frames int, frame_w int, frame_h int, burn_frame int) {
	self.burn_frame = burn_frame
	self.speed = speed
	self.texture = vraylib.load_texture('resources/mobs/' + mob + '.png')
	self.frames = []C.Rectangle{}
	mut x, mut y := 0, 0
	for y < self.texture.height {
		for x < self.texture.width {
			self.frames << C.Rectangle{x, y, frame_w, frame_h}
			if self.frames.len == total_frames {
				break
			}

			x += frame_w
		}
		x = 0
		y += frame_h
	}
}

pub fn (mut self Animation) update(x int, y int) {
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
	self.pos = C.Vector2{x, y}
}

pub fn (self &Animation) draw() {
	frame := self.frames[self.frame]
	vraylib.draw_texture_rec(self.texture, frame, self.pos, vraylib.white)
}

pub fn (self &Animation) unload() {
	vraylib.unload_texture(self.texture)
}
