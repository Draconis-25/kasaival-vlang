module mobs

import vraylib



pub struct Dog {
	element        string = 'mob'
	mut : texture   C.Texture2D
	      current_frame int 
          frames_counter int
		  frame_rec C.Rectangle
		  position C.Vector2
		  frames_speed int
}

pub fn (mut self Dog) load() {
	self.frames_speed = 8
	self.texture = vraylib.load_texture('resources/mobs/dog_sprite.png')
    self.position = C.Vector2{100, 600}
    self.frame_rec =C.Rectangle {0, 0, f32(self.texture.width)/3, f32(self.texture.height)/4}
}

pub fn (mut self Dog) update() {
	self.frames_counter++

	if self.frames_counter>= 60/self.frames_speed
	{
	self.frames_counter = 0
	self.current_frame++

	if self.current_frame >2
	 {self.current_frame = 0}

	self.frame_rec.x = f32(self.current_frame)*f32(self.texture.width)/3
	}

}

pub fn (self &Dog) draw() {
	vraylib.draw_texture_rec(self.texture, self.frame_rec, self.position, vraylib.white)
	
}


pub fn (self &Dog) unload() {
	vraylib.unload_texture(self.texture)
}
