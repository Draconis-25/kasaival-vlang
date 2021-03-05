module plants

import vraylib
import math
import lyra

const (
	deg_to_rad = math.pi / 180
)

struct Branch {
	deg       int
	start_pos C.Vector2
	end_pos   C.Vector2
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
	total_rows   int
	current_row  int
	split_chance int
	split_angle  []int
}

fn (mut self Core) grow() {
	split := vraylib.get_random_value(0, 10)
	// previous row
	index := self.current_row
	prev_row := self.grid[index]
	for prev_branch in prev_row {
		px, py := prev_branch.end_pos.x, prev_branch.end_pos.y
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
			self.grid[index + 1] <<
				Branch{deg, C.Vector2{px, py}, C.Vector2{nx, ny}, w, h, lyra.get_color(self.cs)}
		}
	}
	self.current_row++
}

fn (mut branch Branch) burn(power f32) {
	mut r, mut g, mut b := branch.color.r, branch.color.g, branch.color.b
	b = 0
	if r < 200 {
		r += 2
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
	x1, y1 := b.start_pos.x, b.start_pos.y
	x2, y2 := b.end_pos.x, b.end_pos.y
	return [x1, x2, y2, y1]
}

pub fn (mut self Core) load(x int, y int, w int, h int, cs []int) {
	self.cs = cs
	self.y = y
	grow_to_row := 9
	self.total_rows = 9
	self.split_chance = 5
	self.split_angle = [20, 30]
	self.grid = [][]Branch{len: self.total_rows, init: []Branch{}}
	// make a start branch
	self.grid[0] << Branch{-90, C.Vector2{x, y}, C.Vector2{x, y - h}, w, h, lyra.get_color(self.cs)}
	// grow to current size
	for i in 1 .. grow_to_row {
		self.grow()
	}
}

pub fn (mut self Core) update() {
}

pub fn (self &Core) draw() {
	for row in self.grid {
		for branch in row {
			vraylib.draw_line_ex(branch.start_pos, branch.end_pos, branch.w, branch.color)
		}
	}
}

pub fn (self &Core) unload() {
}
