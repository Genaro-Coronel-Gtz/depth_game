shader_type canvas_item;

uniform float blur_size : hint_range(0.0, 10.0) = 5.0;

void fragment() {
    vec4 color = vec4(0.0);
    vec2 offsets[9] = vec2[](vec2(-1.0, 1.0), vec2(0.0, 1.0), vec2(1.0, 1.0),
                             vec2(-1.0, 0.0), vec2(0.0, 0.0), vec2(1.0, 0.0),
                             vec2(-1.0, -1.0), vec2(0.0, -1.0), vec2(1.0, -1.0));

    float weight[9] = float[](1.0, 2.0, 1.0,
                              2.0, 4.0, 2.0,
                              1.0, 2.0, 1.0);

    float totalWeight = 16.0;

    for (int i = 0; i < 9; i++) {
        color += texture(TEXTURE, UV + offsets[i] * blur_size / SCREEN_PIXEL_SIZE) * (weight[i] / totalWeight);
    }

    COLOR = color;
}
