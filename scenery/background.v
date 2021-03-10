module scenery

import vraylib
import lyra

const (
	path = 'resources/scenery/desert/'
	ext  = '.png'
)

struct Item {
	mut:
	img C.Texture2D
	x int
	y int
}

pub struct Background {
mut:
	y int
	items []Item
	sx    f32
	scale f32
}

pub fn (mut self Background) load(eye &lyra.Eye) {
	self.y = 200
	self.scale = .4
	len := 6
	for i in 0 .. len {
		mut item := Item{}
		item.img = vraylib.load_texture(path + (i + 1).str() + ext)
		item.y = self.y - self.y * (len - i) / len
		w := int(item.img.width * self.scale)
		item.x = int(eye.cx * .5 + eye.cx * (len - i) / len * .5 - w)
		self.items << item
		item.x += w
		self.items << item
		item.x += w
		self.items << item
	}
}

[live]
pub fn (mut self Background) update(eye &lyra.Eye) {
	for i, mut item in self.items {
		w := int(item.img.width * self.scale)

		if item.x > eye.cx + w * 3 - lyra.game_width {
			item.x -= w * 3
		}
		else if item.x < eye.cx - w * 3 + lyra.game_width {
			item.x += w * 3
		}
	}
}

[live]
pub fn (self Background) draw(eye &lyra.Eye) {
	for i, item in self.items {
		vraylib.draw_texture_ex(item.img, C.Vector2{item.x, item.y}, 0, self.scale, vraylib.white)

	}
}

pub fn (self &Background) unload() {
	for item in self.items {
		vraylib.unload_texture(item.img)
	}
}
