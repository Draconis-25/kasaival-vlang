module mobs

import lyra
import utils
import rand

pub struct Dog {
pub mut:
	y f32
mut:
	counter   int
	speed     int = 2
	x         f32
	texture   C.Texture2D
	anime     utils.Animation
	walk_time f32
	pee_time  f32
	burn_time f32
	burning   bool
	dead      bool
	w         int = 100
	h         int = 64
	points int = 30
}

pub fn (mut self Dog) load(x int, y int) {
	self.x, self.y = x, y
	states := map{
		'walk': 3
		'pee':  3
		'burn': 6
	}
	self.anime.load('dog', states, 6, self.w, self.h, 7)
	self.walk_time = 5
	self.pee_time = 3
	self.burn_time = .4
	self.counter = rand.int_in_range(0, int(self.walk_time * lyra.fps))
}

pub fn (mut self Dog) update(mut eye lyra.Eye) {
	self.counter++
	if !self.burning {
		if self.counter > self.walk_time * lyra.fps {
			self.anime.state = 'pee'
			if self.counter > self.walk_time * lyra.fps + self.pee_time * lyra.fps {
				self.counter = 0
			}
		} else {
			if self.x > eye.start_x && self.anime.direction > 0 {
				self.x -= self.speed
			} else if self.x < eye.start_x + eye.gw && self.anime.direction < 0 {
				self.x += self.speed
			} else {
				self.anime.direction *= -1
			}
			self.anime.state = 'walk'
		}
	} else {
		if self.counter > self.burn_time * lyra.fps {
			self.dead = true
		}
		self.anime.state = 'burn'
	}
	self.anime.update(self.x, self.y)
}

pub fn (self &Dog) draw(eye &lyra.Eye) {
	self.anime.draw()
}

pub fn (self &Dog) unload() {
	self.anime.unload()
}

pub fn (mut self Dog) collided(element string, dp f32) {
	if element == 'fire' {
		self.burning = true
		self.counter = 0
	}
}

pub fn (self &Dog) get_hitbox() []f32 {
	return [self.x, self.x + f32(self.w), self.y - f32(self.h) * .2, self.y]
}
