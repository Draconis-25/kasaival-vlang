module scenery

import vraylib
import lyra

const (
	path = 'resources/scenery/desert/'
	ext  = '.png'
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

pub fn (mut self Background) load(eye &lyra.Eye) {
	self.y = 200
	self.scale = .4
	len := 6
	for i in 0 .. len {
		mut layer := Layer{}
		layer.img = vraylib.load_texture(path + (i + 1).str() + ext)
		layer.y = self.y - self.y * (len - i) / len
		w := int(layer.img.width * self.scale)
		layer.offset_x << -w
		layer.offset_x << 0
		layer.offset_x << w
		self.layers << layer
	}
}

[live]
pub fn (mut self Background) update(eye &lyra.Eye) {
	for i, mut layer in self.layers {
		w := int(layer.img.width * self.scale)
		for j in 0 .. 3 {
			x := int(eye.cx * .5 +
				eye.cx * (self.layers.len - i) / self.layers.len * .5 - w) + layer.offset_x[j]
			if x > eye.cx + w * 3 - lyra.game_width {
				layer.offset_x[j] -= w * 3
			} else if x < eye.cx - w * 3 + lyra.game_width {
				layer.offset_x[j] += w * 3
			}
		}
	}
}

[live]
pub fn (self Background) draw(eye &lyra.Eye) {
	for i, layer in self.layers {
		w := int(layer.img.width * self.scale)
		for j in 0 .. 3 {
			x := int(eye.cx * .5 +
				eye.cx * (self.layers.len - i) / self.layers.len * .5 - w) + layer.offset_x[j]
			vraylib.draw_texture_ex(layer.img, C.Vector2{x, layer.y}, 0, self.scale, vraylib.white)
		}
	}
}

pub fn (self &Background) unload() {
	for layer in self.layers {
		vraylib.unload_texture(layer.img)
	}
}
