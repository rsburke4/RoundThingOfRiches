shader_type canvas_item;
uniform vec4 color_out: source_color = vec4(1.0, 1.0, 0.2, 1.0);
uniform float speed = 5;
uniform float amp = 0.5;



void fragment() {
	COLOR = texture(TEXTURE, UV) + texture(TEXTURE, UV) * abs(sin(TIME*speed))*amp*color_out;
}
