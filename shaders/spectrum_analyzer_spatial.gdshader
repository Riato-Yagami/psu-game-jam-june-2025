shader_type spatial; // or "mesh" if using Godot 4.4+

const int VU_COUNT = 26;
const float segment_count = 10.0;

uniform float[VU_COUNT] freq_data;

void fragment() {
	vec2 uv = UV;
	uv.y = 1.0 - uv.y; // flip y axis to match vertical logic

	float vu_count = float(VU_COUNT);
	vec2 pos = vec2(floor(uv.x * vu_count) / vu_count,
	                floor(uv.y * segment_count) / segment_count);

	float fft = freq_data[int(clamp(uv.x * vu_count, 0.0, vu_count - 1.0))];

	vec3 color = mix(vec3(0.0, 2.0, 1.0), vec3(2.0, 0.0, 0.0), sqrt(uv.y));
	float mask = pos.y < fft ? 1.0 : 0.1;

	vec2 dist = fract((uv - pos) * vec2(vu_count, segment_count)) - 0.5;
	float led = smoothstep(0.5, 0.35, abs(dist.x)) * smoothstep(0.5, 0.35, abs(dist.y));

	ALBEDO = led * color * mask;
}
