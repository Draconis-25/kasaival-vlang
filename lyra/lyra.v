module lyra

import vraylib

pub const (
	game_width  = 1920
	game_height = 1080
	start_x     = -100
	start_y     = 540
)

pub struct Eye {
pub mut:
	cx f32
	gw f32 = 1000
	gh f32 = 400
}

pub fn get_game_scale() (f32, C.Vector2) {
	screen_width := f32(vraylib.get_screen_width())
	screen_height := f32(vraylib.get_screen_height())
	scale_x := screen_width / game_width
	scale_y := screen_height / game_height
	mut scale := f32(1)
	mut offset_x, mut offset_y := f32(0), f32(0)
	if scale_x < scale_y {
		scale = scale_x
		offset_y = (screen_height - scale * game_height) * .5
	} else {
		scale = scale_y
		offset_x = (screen_width - scale * game_width) * .5
	}
	return scale, C.Vector2{offset_x, offset_y}
}

pub fn get_game_pos(pos C.Vector2) C.Vector2 {
	scale, offset := get_game_scale()
	mut x, mut y := pos.x, pos.y
	x = (x - offset.x) / scale
	y = (y - offset.y) / scale
	return C.Vector2{int(x), int(y)}
}
