// Washi paper: static grain and fibers, a touch of ink bleed, aged scroll edges.
// The texture only darkens, so on a dark theme it reads as deep ink mottling.

// Tweak these, save, then Ctrl+Shift+, in Ghostty. 0.0 turns an effect off.
const float BLEED = 0.12;     // how much glyph edges soften into the paper (0 - 0.3)
const float GRAIN = 0.020;    // fine speckle; higher = darker, rougher (0 - 0.08)
const float FIBERS = 0.028;   // long paper fibers; higher = darker streaks (0 - 0.10)
const float VIGNETTE = 0.30;  // darker edges like an old scroll (0 - 0.8)

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1, 0)), f.x),
               mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 px = 1.0 / iResolution.xy;
    vec4 color = texture(iChannel0, uv);

    vec3 blur = (texture(iChannel0, uv + vec2(px.x, 0)).rgb +
                 texture(iChannel0, uv - vec2(px.x, 0)).rgb +
                 texture(iChannel0, uv + vec2(0, px.y)).rgb +
                 texture(iChannel0, uv - vec2(0, px.y)).rgb) * 0.25;
    vec3 col = mix(color.rgb, blur, BLEED);

    // Fibers run mostly horizontally, slightly tilted, at two scales
    mat2 tilt = mat2(0.97, 0.24, -0.24, 0.97);
    vec2 fp = tilt * fragCoord;
    float fibers = noise(fp * vec2(0.015, 0.22)) * 0.6 + noise(fp * vec2(0.04, 0.5)) * 0.4;
    float grain = hash(floor(fragCoord));
    col = max(col - grain * GRAIN - fibers * FIBERS, 0.0);

    vec2 q = uv - 0.5;
    col *= 1.0 - dot(q, q) * VIGNETTE;

    fragColor = vec4(col, color.a);
}
