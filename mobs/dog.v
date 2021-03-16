module mobs




struct Dog {
	pub mut:
animation Animation

}




pub fn (mut self Dog) load(x int, y int) {
	number_rectangle_x := 3
	number_rectangle_y := 4
	unburnfactor:= 2
    self.animation = Animation {}
	self.animation.load("Dog", x, y, number_rectangle_x, number_rectangle_y, 7, unburnfactor)
}



pub fn (mut self Dog)update(collided bool){
self.animation.update(collided)
}

pub fn (self &Dog) draw() {
	self.animation.draw()
}

pub fn (self &Dog) unload() {
	self.animation.unload()
}
