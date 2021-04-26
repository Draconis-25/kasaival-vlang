module particles

import waotzi.vraylib
import rand

struct Particle {
pub mut:
	y f32
mut:
	position      C.Vector2
	lifetime      int
	vel_start     C.Vector2
	vel_end       C.Vector2
	color         C.Color
	color_start   C.Color
	color_end     C.Color
	scale         f32
	shrink_factor f32
}

pub struct Fire {
	lifetime int = 60
mut:
	position C.Vector2
	color    C.Color
	amount   int
	radius   int
pub mut:
	scale     f32
	particles []Particle
}

fn (self &Fire) get_particle() Particle {
	mut p := Particle{}
	p.lifetime = self.lifetime
	p.position = self.position
	vel_x := rand.int_in_range(-3, 3)
	p.vel_start = C.Vector2{vel_x, -3}
	p.vel_end = C.Vector2{f32(rand.int_in_range(-vel_x - 2, -vel_x + 2)) * 1.6, -3}
	p.color_start = self.color
	p.color_end = C.Color{0, 30, 20, 0}
	p.color = p.color_start
	p.scale = self.scale
	p.shrink_factor = rand.f32_in_range(0.95, .99)
	// the start y, used for z sorting
	p.y = self.position.y + f32(self.radius) * .8 * self.scale
	return p
}

pub fn (mut self Fire) load() {
	self.radius = 48
	self.color = C.Color{180, 30, 40, 200}
	self.amount = self.lifetime
	self.scale = .7
}

pub fn (self &Fire) get_dimensions() (f32, f32) {
	return self.radius * self.scale, self.radius * self.scale
}

pub fn (mut self Fire) update(x f32, y f32) {
	self.position.x, self.position.y = x, y
	if self.particles.len < self.amount {
		self.particles << self.get_particle()
	}
	for i, mut p in self.particles {
		if p.lifetime == 0 {
			self.particles[i] = self.get_particle()
		}
		pp := f32(p.lifetime) / self.lifetime
		if p.lifetime < self.lifetime {
			p.position.x += p.vel_start.x * pp + p.vel_end.x * (1 - pp)
			p.position.y += p.vel_start.y * pp + p.vel_end.y * (1 - pp)
		}
		// println(p.positon['x'])

		p.color.r = byte(p.color_start.r * pp + p.color_end.r * (1 - pp))
		p.color.g = byte(p.color_start.g * pp + p.color_end.g * (1 - pp))
		p.color.b = byte(p.color_start.b * pp + p.color_end.b * (1 - pp))
		p.color.a = byte(p.color_start.a * pp + p.color_end.a * (1 - pp))

		p.scale *= p.shrink_factor
		p.lifetime--
	}
}

pub fn (self &Fire) draw(i int) {
	p := self.particles[i]
	x := p.position.x - self.radius * p.scale * .5
	vraylib.draw_circle(int(x), int(p.position.y), self.radius * p.scale, p.color)
}

pub fn (self &Fire) unload() {
}
