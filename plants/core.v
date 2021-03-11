module plants

import vraylib
import math
import lyra

const (
	deg_to_rad = math.pi / 180
)

struct Branch {
	deg   int
	x1    f32
	y1    f32
	x2    f32
	y2    f32
	w     f32
	h     f32
mut:
	color C.Color
}


pub struct Core {
	element        string = 'plant'
pub mut:
	y              f32
	left_x f32
	right_x f32
mut:
	w int
	h int
	cs             []int = [90, 130, 170, 202, 60, 100]
	cs_branch []int
	cs_leaf []int
	change_color []int
	grid           [][]Branch
	max_row        int = 8
	current_row    int
	split_chance   int = 50
	split_angle    []int = [20, 30]
	grow_timer     int
	grow_time      int = 200
	burning        int
	burn_intensity f32
}


pub fn (mut self Core) load(x int, y int) {
	self.y = y
	self.grow_timer = vraylib.get_random_value(0, self.grow_time)
	self.grid = [][]Branch{len: self.max_row, init: []Branch{}}
	// make a start branch
	self.grid[0] << Branch{-90, x, y, x, y - self.h, self.w, self.h, lyra.get_color(self.cs)}
	// grow to current size
	grow_to_row := vraylib.get_random_value(1, self.max_row)
	for _ in 1 .. grow_to_row {
		self.grow()
	}
}

fn (mut self Core) shrink() {
	for i in 0 .. self.grid[self.current_row].len {
		self.grid[self.current_row][i] = Branch{}
	}
	self.current_row--
}

fn (mut self Core) grow() {
	// previous row
	prev_row := self.grid[self.current_row]
	for prev_branch in prev_row {
		split := vraylib.get_random_value(0, 100)
		px, py := prev_branch.x2, prev_branch.y2
		w, h := prev_branch.w * .9, prev_branch.h * .95
		mut degs := []int{}
		if self.split_chance > split {
			get_angle := fn (self &Core) int {
				return vraylib.get_random_value(self.split_angle[0], self.split_angle[1])
			}
			degs << prev_branch.deg - get_angle(self)
			degs << prev_branch.deg + get_angle(self)
		} else {
			degs << prev_branch.deg
		}
		for deg in degs {
			nx := int(px + math.cos(f32(deg) * deg_to_rad) * h)
			ny := int(py + math.sin(f32(deg) * deg_to_rad) * h)
			c := lyra.get_color(self.cs)
			self.grid[self.current_row + 1] << Branch{deg, px, py, nx, ny, w, h, c}
		}
	}
	self.current_row++
}

fn (mut branch Branch) burn_color(self &Core) {
	mut r, mut g, mut b := branch.color.r, branch.color.g, branch.color.b
	b = 0
	if r < 200 {
		r += byte(self.burn_intensity * 2)
	}
	if g > 100 {
		g -= 2
	}
	branch.color = C.Color{r, g, b, 255}
}

pub fn (mut self Core) collided(element string, dp f32) {
	if element == 'fire' {
		self.burning = 100
		self.burn_intensity = dp
	}
}

pub fn (self &Core) get_hitbox() []f32 {
	b := self.grid[0][0]
	return [b.x1, b.x2, b.y2, b.y1]
}


pub fn (mut self Core) update() {
	if self.burning > 0 {
		for row in self.grid {
			for mut branch in row {
				branch.burn_color(self)
			}
		}
		if self.current_row >= 0 {
			if self.grow_timer >= self.grow_time {
				self.shrink()
				self.grow_timer = 0
			}
			self.grow_timer += int(self.burn_intensity)
		}
	} else {
		if self.current_row < self.max_row - 1{
			self.grow_timer--
			if self.grow_timer < 0 {
				self.grow()
				self.grow_timer = self.grow_time
			}
		}
	}
}

pub fn (self &Core) draw(eye &lyra.Eye) {
	for i, row in self.grid {
		for branch in row {
			x1, y1 := branch.x1, branch.y1
			mut x2, mut y2 := branch.x2, branch.y2
			if i == self.current_row && self.grow_timer > 0 {
				get_next_pos := fn (self &Core, a f32, b f32) f32 {
					return b + (a - b) * self.grow_timer / self.grow_time
				}
				x2 = get_next_pos(self, x1, x2)
				y2 = get_next_pos(self, y1, y2)
			}
			if (x1 > eye.cx || x2 > eye.cx) && (x1 < eye.cx + lyra.game_width || x2 < eye.cx + lyra.game_width) {
				vraylib.draw_line_ex(C.Vector2{x1, y1}, C.Vector2{x2, y2}, branch.w, branch.color)
			}
		}
	}
}
