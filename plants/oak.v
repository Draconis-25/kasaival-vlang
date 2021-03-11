module plants

pub fn oak() Core {
	mut plant := Core{}
	plant.cs = [40, 70, 170, 202, 60, 100]
	plant.max_row = 8
	plant.split_chance = 70
	plant.split_angle = [20, 30]
	plant.grow_time = 20
	return plant
}
