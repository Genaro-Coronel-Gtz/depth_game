shader_type canvas_item;

uniform float grain_strength : hint_range(0.0, 1.0) = 0.05;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.5;
uniform float desaturation : hint_range(0.0, 1.0) = 0.3;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.1;
uniform float time_speed = 1.0;

void fragment() {
    vec2 uv = UV;
    vec4 color = texture(TEXTURE, uv);

    // 1. Desaturación
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(color.rgb, vec3(gray), desaturation);

    // 2. Film grain
    float noise = fract(sin(dot(uv * TIME * 100.0 * time_speed, vec2(12.9898,78.233))) * 43758.5453);
    color.rgb += (noise - 0.5) * grain_strength;

    // 3. Vignette
    float dist = distance(uv, vec2(0.5));
    float vignette = smoothstep(0.5, vignette_strength + 0.5, dist);
    color.rgb *= 1.0 - vignette;

    // 4. Scanlines
    float scanline = sin(uv.y * 800.0);
    color.rgb -= scanline * scanline_strength;

    COLOR = color;
}
