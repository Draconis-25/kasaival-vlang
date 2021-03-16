module mobs




struct Dog {
	pub mut:
number_rectangle_x int
number_rectangle_y int
animation Animation

}




pub fn (mut self Dog) load() {
	number_rectangle_x = 3
	number_rectangle_y = 4
    animation = Animation {}
	self.animation.load(Dog, 200, 700, number_rectangle_x, number_rectangle_y )
}



pub fn (mut self. Dog)update(){
self.animation.update()
}

pub fn (self &Dog) draw() {
	self.animation.draw()
}

pub fn (self &Dog) unload() {
	self.animation.unload()
}
