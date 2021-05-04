module scenery

import waotzi.vraylib
import state
import lyra
import rand

struct Star {
	mut:
	elapsed f32
	time f32
	x int
	y int
	r int
	pc C.Color
	nc C.Color
}

pub struct Sky {
mut:
	nebula C.Texture2D
	bg []C.Texture2D
	stars []Star
}

fn rand_byte(a int, n int) byte {
	return byte(a + rand.intn(n))
}

fn star_color() C.Color {
	 	return C.Color{rand_byte(200, 50), rand_byte(150, 50), rand_byte(90, 50), 255}
}

pub fn (mut self Sky) load() {
	self.bg << vraylib.load_texture('resources/sky/planets.jpg')
	self.nebula = vraylib.load_texture('resources/sky/nebula.png')
	for i := 0; i < 100; i++ {
		x := rand.intn(lyra.game_width)
		y := rand.intn(lyra.game_height)
		mut r := rand.int_in_range(4, 15)
		c := star_color()
		if i == 80 {
			r = 50
		}
		if i == 20 {
			r = 150
		}
		time := f32(.5)
		elapsed := rand.f32n(.5)
		self.stars << Star{elapsed, time, x, y, r, c, star_color()}
	}
}

fn (star &Star) get_current_color(rat f32) C.Color {
	pc := star.pc
	nc := star.nc
	r := pc.r * (1 - rat) + nc.r * rat
	g := pc.g * (1 - rat) + nc.g * rat
	b := pc.b * (1 - rat) + nc.b * rat
	return C.Color{byte(r), byte(g), byte(b), 245}
}

pub fn (mut self Sky) update(state &state.State) {
	for mut star in self.stars {
		star.elapsed += vraylib.get_frame_time()
		if star.elapsed > star.time {
			star.pc = star.nc
			star.nc = star_color()
			star.elapsed = 0
			star.y --
			star.x += rand.int_in_range(-2, 2)
			if star.y + star.r < 0 {
				star.y += lyra.game_height
			}
		}
	}
}

pub fn (self &Sky) draw(state &state.State) {
	for bg in self.bg {

		vraylib.draw_texture(bg, int(state.cx), 0, vraylib.white)
	}
	for star in self.stars {
		r := star.elapsed / star.time
		c := star.get_current_color(r)

		vraylib.draw_circle(star.x + int(state.cx), star.y, star.r, c)
	}
	vraylib.draw_texture(self.nebula, int(state.cx), 0, vraylib.white)

}

pub fn (self &Sky) unload() {
	for bg in self.bg {
		vraylib.unload_texture(bg)
	}
	vraylib.unload_texture(self.nebula)
}
