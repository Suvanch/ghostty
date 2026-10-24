// Bloom: bright pixels softly glow onto their neighbors.

const float STRENGTH = 0.09;   // overall glow amount
const float THRESHOLD = 0.2;   // minimum brightness that glows
const float SPREAD = 1.8;      // glow radius in pixels per sample ring
const int SAMPLES = 24;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    vec3 glow = vec3(0.0);

    for (int i = 0; i < SAMPLES; i++) {
        float fi = float(i);
        float angle = fi * 2.39996;               // golden angle spiral
        float radius = sqrt(fi + 0.5) * SPREAD;
        vec2 offset = vec2(cos(angle), sin(angle)) * radius / iResolution.xy;
        vec3 s = texture(iChannel0, uv + offset).rgb;
        float lum = dot(s, vec3(0.2126, 0.7152, 0.0722));
        float weight = 1.0 - fi / float(SAMPLES);
        glow += s * smoothstep(THRESHOLD, 1.0, lum) * weight;
    }

    fragColor = vec4(color.rgb + glow * STRENGTH, color.a);
}
