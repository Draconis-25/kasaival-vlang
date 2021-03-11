module plants

pub fn  saguaro() Core {
	mut plant := Core{}
	plant.cs_branch = [125, 178, 122, 160, 76, 90]
	plant.cs_leaf = [150, 204, 190, 230, 159, 178]
	plant.change_color = [-10, -25, -20]
	plant.grow_time = 20
	plant.max_row = 7
	plant.w = 14
	plant.h = 42
	plant.split_chance = 40
	return plant
}
