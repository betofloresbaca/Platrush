shader_type canvas_item;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR.rgba = vec4(0,0,0, tex_color.a * 0.5);
}
