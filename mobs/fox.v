module mobs




struct Fox {
	pub mut:
animation Animation

}




pub fn (mut self Fox) load(x int, y int) {
	number_rectangle_x := 6
	number_rectangle_y := 2
	unburnfactor := 0
    self.animation = Animation {}
	self.animation.load('Fox', x, y, number_rectangle_x, number_rectangle_y, 20, unburnfactor)
}



pub fn (mut self Fox)update(collided bool){
self.animation.update(collided)
}

pub fn (self &Fox) draw() {
	self.animation.draw()
}

pub fn (self &Fox) unload() {
	self.animation.unload()
}
