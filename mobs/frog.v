module mobs




struct Frog {
	pub mut:
number_rectangle_x int
number_rectangle_y int
animation Animation

}




pub fn (mut self Frog) load() {
	number_rectangle_x = 4
	number_rectangle_y = 2
    animation = Animation {}
	self.animation.load(Frog, 200, 700, number_rectangle_x, number_rectangle_y )
}



pub fn (mut self. Frog)update(){
self.animation.update()
}

pub fn (self &Frog) draw() {
	self.animation.draw()
}

pub fn (self &Frog) unload() {
	self.animation.unload()
}
