module stages

fn desert_props() []Scene {
	mut one := Scene{}
	one.add_width = 2200
	one.color_scheme = [[200, 220, 115, 140, 75, 80],
		[220, 230, 105, 122, 54, 80],
	]
	return [one]
}
