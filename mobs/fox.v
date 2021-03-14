module mobs




struct Fox {
	pub mut:
number_rectangle_x int
number_rectangle_y int
animation Animation

}




pub fn (mut self Fox) load() {
	number_rectangle_x = 6
	number_rectangle_y = 2
    animation = Animation {}
	self.animation.load(Fox, 200, 700, number_rectangle_x, number_rectangle_y )
}



pub fn (mut self. Fox)update(){
self.animation.update()
}

pub fn (self &Fox) draw() {
	self.animation.draw()
}

pub fn (self &Fox) unload() {
	self.animation.unload()
}
