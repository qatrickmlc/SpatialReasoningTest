shader_type spatial;
render_mode unshaded, cull_front, depth_draw_opaque;

uniform vec4 outline_color : source_color = vec4(0,0,0,1);
uniform float outline_thickness = 0.05; // world units

void vertex() {
    VERTEX += NORMAL * outline_thickness;
}

void fragment() {
    ALBEDO = outline_color.rgb;
}
//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
