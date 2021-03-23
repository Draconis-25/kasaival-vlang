module scenery

import vraylib
import lyra
import state

const (
	path = 'resources/scenery/'
	ext  = '.png'
	num  = 6
)

struct Layer {
mut:
	img      C.Texture2D
	y        int
	offset_x []int
	layer    int
}

pub struct Background {
mut:
	y      int
	sx     f32
	scale  f32
	layers []Layer
}

pub fn (mut self Background) load(scene string, state &state.State) {
	self.y = 200
	self.scale = .4
	len := 6
	for i in 0 .. len {
		mut layer := Layer{}
		layer.img = vraylib.load_texture(scenery.path + scene + '/' + (i + 1).str() + scenery.ext)
		layer.y = self.y - self.y * (len - i) / len
		w := int(layer.img.width * self.scale)
		for j in 0 .. scenery.num {
			layer.offset_x << -lyra.start_y + w * j
		}
		self.layers << layer
	}
}

pub fn (mut self Background) update(state &state.State) {
	for i, mut layer in self.layers {
		w := int(layer.img.width * self.scale)
		for j in 0 .. scenery.num {
			x := layer.offset_x[j] + int(state.cx * .5 +
				state.cx * (self.layers.len - i) / self.layers.len * .5 - w)
			if x > state.cx + w * scenery.num + lyra.game_width {
				layer.offset_x[j] -= w * scenery.num
			} else if x < state.cx - w * scenery.num - lyra.game_width {
				layer.offset_x[j] += w * scenery.num
			}
		}
	}
}

pub fn (self Background) draw(state &state.State) {
	for i, layer in self.layers {
		w := int(layer.img.width * self.scale)
		for j in 0 .. scenery.num {
			x := layer.offset_x[j] + int(state.cx * .5 +
				state.cx * (self.layers.len - i) / self.layers.len * .5 - w)
			vraylib.draw_texture_ex(layer.img, C.Vector2{x, layer.y}, 0, self.scale, vraylib.white)
		}
	}
}

pub fn (self &Background) unload() {
	for layer in self.layers {
		vraylib.unload_texture(layer.img)
	}
}
