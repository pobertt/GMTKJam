shader_type spatial;
render_mode unshaded;

uniform sampler2D cross_texture: filter_linear_mipmap;
uniform vec2 uv_scale;
uniform vec2 uv_speed;
uniform vec3 colour: source_color;

void fragment() {
	float cross_alpha = texture(cross_texture, UV * uv_scale + (TIME * uv_speed)).r;
	float alpha = mix(0.3, 0.2, cross_alpha);
	ALPHA = alpha;
	ALBEDO = colour;
}


