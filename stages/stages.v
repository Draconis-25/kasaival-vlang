module stages

enum StageName {
	@none
	desert
	grassland
}

struct Scene {
pub mut:
	add_width    int
	color_scheme [][]int
}

pub fn get_props(stage_name StageName) []Scene {
	match stage_name {
		.desert { return desert_props() }
		.grassland { return []Scene{} }
		.@none { return []Scene{} }
	}
}
