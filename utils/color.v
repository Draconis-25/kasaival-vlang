module utils

import rand

pub fn get_color(cs []int) C.Color {
	grv := rand.int_in_range
	r := grv(cs[0], cs[1])
	g := grv(cs[2], cs[3])
	b := grv(cs[4], cs[5])
	return C.Color{byte(r), byte(g), byte(b), 255}
}
