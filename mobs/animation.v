module mobs

import vraylib


pub struct Animation {
	mut : texture   C.Texture2D
	      current_frame_x int 
		  current_frame_y int
          frames_counter int
		  frame_rec C.Rectangle
		  position C.Vector2
		  frames_speed int
}




pub fn (mut self Animation) load(mob string, x int, y int,number_rectangle_x int, number_rectangle_y int) {
	self.frames_speed = 8
	self.texture = vraylib.load_texture('resources/mobs/'+mob+'.png')
    self.position = C.Vector2{x, y}
    self.frame_rec =C.Rectangle {0, 0, f32(self.texture.width)/f32(number_rectangle_x), f32(self.texture.height)/f32(number_rectangle_y)}
}



pub fn (mut self Animation) update(number_rectangle_x int, number_rectangle_y int) {
	self.frames_counter++

	if self.frames_counter>= 60/self.frames_speed
	{
	self.frames_counter = 0
	self.current_frame_x++

	if self.current_frame_x >(f32(number_rectangle_x)-1)
	 {self.current_frame_x = 0 
	 self.current_frame_y++}

    if self.current_frame_y >(f32(number_rectangle_y)-1)
	{self.current_frame_y = 0}
	self.frame_rec.y = f32(self.current_frame_y)*f32(self.texture.height)/f32(number_rectangle_x)

	self.frame_rec.x = f32(self.current_frame_x)*f32(self.texture.width)/f32(number_rectangle_y)
	}

}

pub fn (self &Animation) draw() {
	vraylib.draw_texture_rec(self.texture, self.frame_rec, self.position, vraylib.white)
	
}


pub fn (self &Animation) unload() {
	vraylib.unload_texture(self.texture)
}