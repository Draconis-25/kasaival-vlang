module mobs

import vraylib
import math
import lyra

pub enum MobName {
	dog
	frog
	fox
	@none
}







pub struct Core {
	
	mut: dog Dog
	     frog Frog
		 fox  Fox
	     tipe MobName

}





pub fn (mut self Core) load(mob MobName, x int, y int) {
	self.tipe = mob
	match mob {
		.dog {
			self.dog = Dog{}
			self.dog.load(x,y)
		}
		.frog {
			self.frog = Frog{}
			self.frog.load(x, y)
		}
		.fox {
			self.fox = Fox{}
			self.fox.load(x ,y)
		}
		.@none {}
	}
}



pub fn (mut self Core) update(collided bool) {
	match self.tipe {
		.dog {
			self.dog.update(collided)
		}
		.frog{
			self.frog.update(collided)
		}
		.fox {
			self.fox.update(collided)
		}
		.@none {}
	}

}


pub fn (self &Core) draw() {
	match self.tipe {
		.dog {
			self.dog.draw()
		}
		.frog{
			self.frog.draw()
		}
		.fox {
			self.fox.draw()
		}
		.@none {}
	}

}


pub fn ( self &Core) unload() {
	match self.tipe {
		.dog {
			self.dog.unload()
		}
		.frog{
			self.frog.unload()
		}
		.fox {
			self.fox.unload()
		}
		.@none {}
	}

}




