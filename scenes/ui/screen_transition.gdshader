shader_type canvas_item;

uniform sampler2D wipe_image;
uniform float percent: hint_range(0.0, 1.0, 0.01);

void fragment() {
	float tex_val = texture(wipe_image, UV).r;
	
	if(tex_val <= percent){
		COLOR.a = 0.0;
	}
}
