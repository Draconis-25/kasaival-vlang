module plants

import vraylib
import math

const (
	deg_to_rad = math.pi / 180
)

struct Branch {
	deg       int
	start_pos C.Vector2
	end_pos   C.Vector2
	w         int
	h         int
	color     C.Color
}

pub struct Core {
	element      string = 'plant'
	pub mut:
	y f32

mut:
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
				Branch{deg, C.Vector2{px, py}, C.Vector2{nx, ny}, w, h, vraylib.green}
		}
	}
	self.current_row++
}

pub fn (mut self Core) load(x int, y int, w int, h int) {
	self.y = y
	grow_to_row := 9
	self.total_rows = 9
	self.split_chance = 5
	self.split_angle = [20, 30]
	self.grid = [][]Branch{len: self.total_rows, init: []Branch{}}
	// make a start branch
	self.grid[0] << Branch{-90, C.Vector2{x, y}, C.Vector2{x, y - h}, w, h, vraylib.green}
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
