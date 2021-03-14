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





pub fn (mut self Core) load(mob MobName, x int y int) {
	self.tipe = mob
	match mob {
		.dog {
			self.dog = Dog{}
			self.dog.load()
		}
		.frog {
			self.frog = Frog{}
			self.frog.load()
		}
		.fox {
			self.fox = Fox{}
			self.fox.load()
		}
		.@none {}
	}
}



pub fn (mut self Core) update() {
	match self.tipe {
		.dog {
			self.dog.update()
		}
		.frog{
			self.frog.update()
		}
		.fox {
			self.fox.update()
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




