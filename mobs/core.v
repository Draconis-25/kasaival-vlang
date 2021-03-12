module mobs

import vraylib
import math
import lyra

enum MobName {
	dog
	@none
}


struct Sprite {
	texture     C.Texture2D
	frame_size  C.Vector2
	max_frame   int
	frames_wide int
	origin      C.Vector2
	frame       int
}




pub struct Core {
	
	mut: dog Dog
	     tipe MobName

}





pub fn (mut self Core) load(mob MobName) {
	self.tipe = mob
	match mob {
		.dog {
			self.dog = Dog{}
			self.dog.load()
		}
		.@none {}
	}
}



pub fn (mut self Core) update() {
	match self.tipe {
		.dog {
			self.dog.update()
		}
		.@none {}
	}

}


pub fn (self &Core) draw() {
	match self.tipe {
		.dog {
			self.dog.draw()
		}
		.@none {}
	}

}


pub fn ( self &Core) unload() {
	match self.tipe {
		.dog {
			self.dog.unload()
		}
		.@none {}
	}

}




