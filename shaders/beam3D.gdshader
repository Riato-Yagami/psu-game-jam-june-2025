shader_type spatial;
render_mode unshaded, cull_disabled;

uniform int beams = 2;
uniform float energy = 3.0;
uniform int roughness = 3;
uniform int frequency = 10;
uniform float speed = 1.0;
uniform float thickness = 0.006;
uniform float outline_thickness = 0.03;
uniform float beam_difference = 0.0;
uniform float glow = 0.0;
uniform float outline_glow = 0.0;
uniform vec4 color : source_color = vec4(0.91, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.5, 1.0, 0.96, 1.0);
uniform float progress = 1.0;
uniform float y_offset = 0.0;
uniform float fixed_edge_size = 0.05;
uniform vec2 noise_scale = vec2(1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));
    vec2 blur = smoothstep(0.0, 1.0, uv_fract);
    return mix(a, b, blur.x) + (c - a) * blur.y * (1.0 - blur.x) + (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv, float time) {
    int octaves = roughness;
    float amp = 0.01 * energy * progress;
    float freq = float(frequency);
    float value = 0.0;
    for(int i = 0; i < 10; i++) {
        if(i >= octaves) break;
        value += amp * noise(freq * vec2(uv.x, uv.y + time));
        amp *= 0.5;
        freq *= 2.0;
    }
    return value;
}

vec4 difference(vec4 base, vec4 blend){
    return abs(base - blend);
}

vec4 bolt(vec2 uv, float time, float i)
{
    float falloff = smoothstep(0.0, fixed_edge_size, uv.x) * smoothstep(0.0, fixed_edge_size, 1.0 - uv.x);
    vec4 clouds = vec4(fbm((uv + vec2(i)) * noise_scale, time * speed)) * falloff;
    vec4 diff_clouds = difference(clouds, vec4(uv.y - 0.5 + y_offset + (uv.y * falloff * 0.02 * energy * progress)));
    vec4 clouds2 = vec4(fbm((uv * 2.0) * noise_scale, time * 1.)) * 5.0;
    diff_clouds += smoothstep(0.0, 0.8, clouds2) * 0.1 * (1.-progress);
    float thickness2 =  1. - ( thickness / (min(i + beam_difference, 1.0) + (1.0-beam_difference))) * progress ;
    vec4 beam = clamp(smoothstep(thickness2, thickness2 + 0.005 * progress, 1.0 - diff_clouds), vec4(0.0), vec4(1.0));
    vec4 beam_outline;
    float outline = thickness2 - (outline_thickness * progress);
    beam_outline = clamp(smoothstep(outline, outline + 0.04, 1.0 - diff_clouds), 0.0, 1.0);
    beam_outline = clamp(beam_outline - beam, 0.0, 1.0);
    return (beam * (color + vec4(glow, glow, glow, 0.))) + (beam_outline * (outline_color + vec4(outline_glow, outline_glow, outline_glow, 0.)));
}

void fragment() {
    vec2 uv = UV;
    vec4 beam = vec4(0.0);
    for (int i = 0; i < 10; i++){
        if(i >= beams) break;
        beam = max(beam, bolt(uv, TIME, float(i)));
    }
    ALBEDO = beam.rgb;
    ALPHA = beam.a;
}