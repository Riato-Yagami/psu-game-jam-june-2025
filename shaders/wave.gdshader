shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float sin_amp = 0.05;      // Amplitude of the wave
uniform float sin_freq = 10.0;     // Frequency of the wave
uniform float sin_speed = 1.0;     // Animation speed

uniform float stripe_thickness = 0.1; // Half-height of the stripe
uniform float outline_size = 0.02;    // Outline thickness

uniform vec4 color : source_color = vec4(0.91, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.5, 1.0, 0.96, 1.0);

void fragment() {
	vec2 uv = UV;

	// Apply sinusoidal distortion to vertical UV
	uv.y += sin_amp * sin(uv.x * sin_freq * 2.0 * PI + TIME * sin_speed);

	float center = 0.5;

	// Main stripe
	float stripe = smoothstep(center - stripe_thickness, center, uv.y) *
	               (1.0 - smoothstep(center, center + stripe_thickness, uv.y));
	
	float outline = smoothstep(center - outline_size, center, uv.y) *
	(1.0 - smoothstep(center, center + outline_size, uv.y));
	// Outline just outside the stripe
	//float outline = smoothstep(center - stripe_thickness, center, uv.y)+
	                //smoothstep(center, center + stripe_thickness, uv.y);
	//float outline = 0.5;
	// Combine base and outline colors
	vec4 final_color = vec4(0.0);
	if (outline > 0.0) {
		final_color = mix(final_color, outline_color, outline);
	}
	if (stripe > 0.0) {
		final_color = mix(final_color, color, stripe);
	}

	ALBEDO = final_color.rgb;
	ALPHA = final_color.a;
}
