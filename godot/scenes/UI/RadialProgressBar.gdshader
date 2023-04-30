shader_type canvas_item;

uniform vec4 color_background : source_color;
uniform vec4 color_bar : source_color;
uniform float progress = 0.4;
uniform float radius_inner = 0.5;

void fragment() {
	vec2 uv = 2.0 * (UV - vec2(0.5, 0.5));
	float dst = distance(uv, vec2(0.0, 0.0));
	
	if (dst <= 1.0 && dst >= radius_inner) {
		if (atan(uv.x, uv.y) + PI < progress * 2.0 * PI) {
			COLOR = color_bar;
		} else {
			COLOR = color_background;
		}
	} else {
		COLOR = vec4(color_bar.rgb, 0.0);
	}
	
}
