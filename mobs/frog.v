module mobs




struct Frog {
	pub mut:
number_rectangle_x int
number_rectangle_y int
animation Animation

}




pub fn (mut self Frog) load(x int, y int ) {
	number_rectangle_x := 4
	number_rectangle_y := 2
	unburnfactor := 0
    self.animation = Animation {}
	self.animation.load("Frog", x, y, number_rectangle_x, number_rectangle_y, 12, unburnfactor)
}



pub fn (mut self Frog)update(collided bool){
self.animation.update(collided)
}

pub fn (self &Frog) draw() {
	self.animation.draw()
}

pub fn (self &Frog) unload() {
	self.animation.unload()
}
