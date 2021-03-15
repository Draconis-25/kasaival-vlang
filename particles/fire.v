module particles

import vraylib
import rand

struct Particle {
	pub mut:
	position C.Vector2

	mut:
	lifetime int
	vel_start C.Vector2
	vel_end C.Vector2
	color C.Color
	color_start C.Color
	color_end C.Color
}

pub struct Fire {
	p_time int = 22
	pub:
		amount int = 100

	mut:
		position C.Vector2
	pub mut:
		texture C.Texture2D
		particles []Particle
}

fn (self &Fire) get_particle() Particle {
	mut p := Particle{}
	p.lifetime = self.p_time + rand.intn(2)
	p.position = self.position
	vel_x := rand.int_in_range(-3, 3)
	p.vel_start = C.Vector2{vel_x, -5}
	p.vel_end = C.Vector2{f32(rand.int_in_range(-vel_x - 2, -vel_x + 2))* 1.2, -3}
	p.color_start = C.Color{180, 30, 40, 200}
	p.color_end = C.Color{0, 30, 20, 0}
	p.color = p.color_start
	return p
}

pub fn (mut self Fire) load() {
	self.texture = vraylib.load_texture('resources/spark_flame.png')

}


pub fn (mut self Fire) update(x f32, y f32) {
	if self.particles.len < self.amount {
		self.particles << self.get_particle()
	}
	for i, mut p in self.particles {
			p.lifetime--
			if p.lifetime == 0 {
				self.particles[i] = self.get_particle()
			}
			pp := f32(p.lifetime) / self.p_time
			p.position.x += p.vel_start.x * pp + p.vel_end.x * (1 - pp)
			p.position.y += p.vel_start.y * pp + p.vel_end.y * (1 - pp)

			p.color.r = byte(p.color_start.r * pp + p.color_end.r * (1 - pp))
			p.color.g = byte(p.color_start.g * pp + p.color_end.g * (1 - pp))
			p.color.b = byte(p.color_start.b * pp + p.color_end.b * (1 - pp))
			p.color.a = byte(p.color_start.a * pp + p.color_end.a * (1 - pp))
	}
	self.position.x, self.position.y = x, y
}


pub fn (self &Fire) draw(i int) {
	p := self.particles[i]
	vraylib.draw_texture_ex(self.texture,  p.position, 0, .4, p.color)
}

pub fn (self &Fire) unload() {
	vraylib.unload_texture(self.texture)
}
