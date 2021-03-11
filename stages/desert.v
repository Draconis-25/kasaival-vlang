module stages

fn desert_props() []Scene {
	mut one := Scene{}
	one.add_width = 3000
	one.color_scheme = [

	// desert
		[190, 200, 130, 150, 80, 105],
		[170, 200, 115, 140, 80, 84],
		[200, 220, 115, 140, 75, 80],
		[220, 230, 105, 122, 54, 80]
	]
	return [one]
}
