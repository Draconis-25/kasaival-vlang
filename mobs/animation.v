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
		  number_rectangle_x int
		  number_rectangle_y int
		  unburnfactor int 
}




pub fn (mut self Animation) load(mob string, x int, y int, number_rectangle_x int, number_rectangle_y int, speed int, unburnfactor int) {
	self.frames_speed = speed
	self.texture = vraylib.load_texture('resources/mobs/'+mob+'.png')
    self.position = C.Vector2{x, y}
    self.frame_rec =C.Rectangle {0, 0, f32(self.texture.width)/f32(number_rectangle_x), f32(self.texture.height)/f32(number_rectangle_y)}
    self.number_rectangle_x = number_rectangle_x 
	self.number_rectangle_y = number_rectangle_y 
	self.current_frame_x = 0
	self.current_frame_y = 0
	self.unburnfactor = unburnfactor

}



pub fn (mut self Animation) update(collided bool) {

	self.frames_counter++
	

	if self.frames_counter>= 60/self.frames_speed
	{
	self.frames_counter = 0
	self.current_frame_x++


	

	if self.current_frame_x >(f32(self.number_rectangle_x)-1)
	 {self.current_frame_x = 0 
	 self.current_frame_y++
	 
	 }

    if self.current_frame_y >(f32(self.number_rectangle_y)-1-f32(self.unburnfactor))
	{self.current_frame_y = 0
	if collided {
		self.unburnfactor = 0
	 self.current_frame_y=self.current_frame_y+2}}

	 


	self.frame_rec.y = f32(self.current_frame_y)*f32(self.texture.height)/f32(self.number_rectangle_y)
	
	self.frame_rec.x = f32(self.current_frame_x)*f32(self.texture.width)/f32(self.number_rectangle_x)
	}

}

pub fn (self &Animation) draw() {
	vraylib.draw_texture_rec(self.texture, self.frame_rec, self.position, vraylib.white)
	
}


pub fn (self &Animation) unload() {
	vraylib.unload_texture(self.texture)
}