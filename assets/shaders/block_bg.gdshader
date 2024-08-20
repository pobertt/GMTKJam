shader_type canvas_item;

uniform sampler2D block_tex: repeat_enable;
uniform vec2 uv_scale;
uniform vec2 uv_offset;
uniform float uv_rotation;
uniform vec3 colour_1: source_color;
uniform vec3 colour_2: source_color;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float sine = sin(rotation);
	float cosine = cos(rotation);
	
	uv -= pivot;
	uv.x = uv.x * cosine - uv.y * sine;
	uv.y = uv.x * sine + uv.y * cosine;
	uv += pivot;
	
	return uv;
}

void fragment() {
	vec2 uv = rotateUV(UV, vec2(0.0), uv_rotation);
	float block_alpha = texture(block_tex, uv * uv_scale + (sin(TIME) * uv_offset)).a;
	COLOR.rgb = mix(colour_1, colour_2, block_alpha);
}


