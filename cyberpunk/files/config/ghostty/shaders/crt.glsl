// CRT: soft scanlines and a dark vignette over the whole window.

// Tweak these, save, then Ctrl+Shift+, in Ghostty. 0.0 turns an effect off.
const float SCANLINES = 0.05;   // horizontal line darkening (0 - 0.2)
const float VIGNETTE = 0.35;    // darker corners (0 - 0.8)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 term = texture(iChannel0, uv);
    vec3 color = term.rgb;

    color *= 1.0 - SCANLINES * (0.5 + 0.5 * sin(fragCoord.y * 3.14159));

    float v = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y) * 16.0;
    color *= mix(1.0 - VIGNETTE, 1.0, pow(v, 0.3));

    fragColor = vec4(color, term.a);
}
