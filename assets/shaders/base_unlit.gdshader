shader_type spatial;
render_mode unshaded;

uniform sampler2D palette_texture: filter_nearest;

void fragment() {
	ALBEDO = texture(palette_texture, UV).rgb;
}

