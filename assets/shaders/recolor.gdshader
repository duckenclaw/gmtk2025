shader_type canvas_item;

uniform vec4 color: source_color;
uniform vec4 modulate_color: source_color = vec4(1.0);

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	if (original.a > 0.0) {
		COLOR = mix(original, color, 0.5);
		COLOR = COLOR * modulate_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
