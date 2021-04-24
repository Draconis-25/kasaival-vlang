module main

import waotzi.vraylib
import lyra
import screens
import state

fn max(a f32, b f32) f32 {
	return if a > b { a } else { b }
}

fn min(a f32, b f32) f32 {
	return if a < b { a } else { b }
}

// Clamp Vector2 value with min and max and return a new vector2
// NOTE: Required for virtual mouse, to clamp inside virtual game size
fn clamp_value(value C.Vector2, min C.Vector2, max C.Vector2) C.Vector2 {
	mut result := value
	result.x = if result.x > max.x { max.x } else { result.x }
	result.x = if result.x < min.x { min.x } else { result.x }
	result.y = if result.y > max.y { max.y } else { result.y }
	result.y = if result.y < min.y { min.y } else { result.y }
	return result
}

// Constant Variables Definition
const (
	game_screen_width  = 1920
	game_screen_height = 1080
	screen_width       = 800
	screen_height      = 450
	window_title       = 'Kasaival'
)

//--------------------------------------------------------------------------------------
// Main entry point
//--------------------------------------------------------------------------------------
fn main() {
	// Initialization
	//--------------------------------------------------------------------------------------
	// Enable config flags for resizable window and vertical synchro
	vraylib.set_config_flags(vraylib.flag_window_resizable | vraylib.flag_vsync_hint)
	vraylib.init_window(screen_width, screen_height, window_title)

	// Render texture initialization, used to hold the rendering result so we can easily resize it
	target := vraylib.load_render_texture(game_screen_width, game_screen_height)
	vraylib.set_texture_filter(target.texture, vraylib.filter_bilinear)

	vraylib.init_audio_device()

	mut state := state.State{}
	mut camera := C.Camera2D{}
	state.screen = screens.Title{}
	state.screen.load(state)

	mut key_timeout := 0

	vraylib.set_target_fps(60)

	// Main game loop
	for {
		if vraylib.window_should_close() {
			break
		}
		{
			// Update
			//----------------------------------------------------------------------------------
			// Compute required framebuffer scaling
			scale := min(f32(vraylib.get_screen_width()) / game_screen_width, f32(vraylib.get_screen_height()) / game_screen_height)

			if key_timeout > 0 {
				key_timeout--
			}
			if vraylib.is_key_down(vraylib.key_f) {
				if key_timeout == 0 {
					vraylib.toggle_fullscreen()
				}
				key_timeout = 2
			}
			state.screen.update(state)

			camera.target = C.Vector2{state.cx, 0}
			camera.zoom = 1

			// Update virtual mouse (clamped mouse value behind game screen)
			mouse := vraylib.get_mouse_position()
			mut virtual_mouse := C.Vector2{}
			virtual_mouse.x = (mouse.x - (vraylib.get_screen_width() - (game_screen_width * scale)) * .5) / scale
			virtual_mouse.y = (mouse.y - (vraylib.get_screen_height() - (game_screen_height * scale)) * .5) / scale
			state.mouse = clamp_value(virtual_mouse, C.Vector2{}, C.Vector2{game_screen_width, game_screen_height})

			// Apply the same transformation as the virtual mouse to the real mouse (i.e. to work with raygui)
			//vraylib.set_mouse_offset(int(-(vraylib.get_screen_width() - (game_screen_width*scale))*0.5), int(-(vraylib.get_screen_height() - (game_screen_height*scale))*0.5))
			//vraylib.set_mouse_scale(1/scale, 1/scale)
			//----------------------------------------------------------------------------------

			// Draw
			//----------------------------------------------------------------------------------
			vraylib.begin_drawing()
			{
				vraylib.clear_background(vraylib.black)
				// Draw everything in the render texture, note this will not be rendered on screen, yet
				vraylib.begin_texture_mode(target)
				{
					vraylib.begin_mode_2d(camera)
					{

						vraylib.clear_background(vraylib.raywhite)
						state.screen.draw(state)
					}
					vraylib.end_mode_2d()

				}
				vraylib.end_texture_mode()
				// Draw RenderTexture2D to window, properly scaled
				vraylib.draw_texture_pro(target.texture, C.Rectangle{0, 0, f32(target.texture.width), f32(-target.texture.height)},
					C.Rectangle{(vraylib.get_screen_width() - game_screen_width * scale) * .5, (vraylib.get_screen_height() - (game_screen_height * scale)) * 0.5, f32(game_screen_width) * scale, f32(game_screen_height) * scale},
					C.Vector2{}, 0.0, vraylib.white)
			}
			vraylib.end_drawing()

			// reset cursor
			vraylib.set_mouse_cursor(vraylib.mouse_cursor_default)
		}
	}

	// De-Initialization
	//--------------------------------------------------------------------------------------
	vraylib.unload_render_texture(target) // Unload render texture
	state.screen.unload()

	vraylib.close_audio_device()
	vraylib.close_window() // Close window and OpenGL context
	//--------------------------------------------------------------------------------------
}
