shader_type canvas_item;

uniform vec4 base_color : source_color;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR.rgba = vec4(base_color.r, base_color.g, base_color.b, tex_color.a);
}
