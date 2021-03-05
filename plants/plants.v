module plants

import vraylib
import math
import lyra

const (
	deg_to_rad = math.pi / 180
)

struct Branch {
	deg       int
	x1 f32
	y1 f32
	x2 f32
	y2 f32
	w         int
	h         int
	mut:
	color     C.Color
}

pub struct Core {
	element      string = 'plant'
pub mut:
	y            f32
mut:
	cs []int
	grid         [][]Branch
	max_row   int
	current_row  int
	split_chance int
	split_angle  []int
	grow_timer int
	grow_time int
}

fn (mut self Core) grow() {
	split := vraylib.get_random_value(0, 10)
	// previous row
	prev_row := self.grid[self.current_row]
	self.current_row++
	for prev_branch in prev_row {
		px, py := prev_branch.x2, prev_branch.y2
		w, h := int(f32(prev_branch.w) * .9), int(f32(prev_branch.h) * .9)
		mut degs := []int{}
		if split > self.split_chance {
			degs << prev_branch.deg -
				vraylib.get_random_value(self.split_angle[0], self.split_angle[1])
			degs << prev_branch.deg +
				vraylib.get_random_value(self.split_angle[0], self.split_angle[1])
		} else {
			degs << prev_branch.deg
		}
		for deg in degs {
			nx := int(px + math.cos(f32(deg) * deg_to_rad) * h)
			ny := int(py + math.sin(f32(deg) * deg_to_rad) * h)
			c := lyra.get_color(self.cs)
			self.grid[self.current_row] << Branch{deg, px, py, nx, ny, w, h, c}
		}
	}
}

fn (mut branch Branch) burn(power f32) {
	mut r, mut g, mut b := branch.color.r, branch.color.g, branch.color.b
	b = 0
	if r < 200 {
		r += byte(power * 2)
	}
	if g > 100 {
		g -= 2
	}
	branch.color = C.Color{r, g, b, 255}
}

pub fn (self &Core) collided(element string, dp f32) {
	for row in self.grid {
		for mut branch in row {
			branch.burn(dp)
		}
	}
}

pub fn (self &Core) get_hitbox() []f32 {
	b := self.grid[0][0]
	return [b.x1, b.x2, b.y2, b.y2]
}

pub fn (mut self Core) load(x int, y int, w int, h int, cs []int) {
	self.cs = cs
	self.y = y
	self.max_row = 9
	self.split_chance = 5
	self.split_angle = [20, 30]
	self.grid = [][]Branch{len: self.max_row, init: []Branch{}}
	// make a start branch
	self.grid[0] << Branch{-90, x, y, x, y - h, w, h, lyra.get_color(self.cs)}
	// grow to current size
	grow_to_row := vraylib.get_random_value(1, self.max_row)
	for _ in 1 .. grow_to_row {
		self.grow()
	}
	self.grow_time = 100
	self.grow_timer = vraylib.get_random_value(0, self.grow_time)
}

pub fn (mut self Core) update() {
	if self.current_row < self.max_row - 1 {
		self.grow_timer--
		if self.grow_timer == 0 {
			self.grow()
			self.grow_timer = self.grow_time
		}
	}
}

pub fn (self &Core) draw() {
	for i, row in self.grid {
		for branch in row {
			x1, y1 := branch.x1, branch.y1
			mut x2, mut y2 := branch.x2, branch.y2
			if i == self.current_row {
				get_next_pos := fn(self &Core, a f32, b f32) f32 {
					return b + (a - b) * self.grow_timer / self.grow_time
				}
				x2 = get_next_pos(self, x1, x2)
				y2 = get_next_pos(self, y1, y2)
			}
			vraylib.draw_line_ex(C.Vector2{x1, y1}, C.Vector2{x2, y2}, branch.w, branch.color)
		}
	}
}
