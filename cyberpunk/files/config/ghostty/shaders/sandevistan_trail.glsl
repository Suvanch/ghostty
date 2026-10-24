// Sandevistan trail: when the cursor jumps it leaves a fast, thin afterimage
// that splits into purple and indigo ghosts, sliced by glitch lines, then fades.

const float DURATION = 0.22;  // seconds the afterimage stays visible
const float OPACITY = 0.8;
const int STEPS = 20;         // samples along the trail
const float SPLIT = 3.0;      // pixel offset between the purple and indigo ghosts
const vec3 PURPLE = vec3(0.6, 0.4, 0.8);     // #9966cc
const vec3 INDIGO = vec3(0.36, 0.36, 0.78);  // #5c5cc7

float hash(float n) {
    return fract(sin(n * 91.345) * 47453.5453);
}

float sdBox(vec2 p, vec2 halfSize) {
    vec2 d = abs(p) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 cursorCenter(vec4 c) {
    // xy = top-left corner (y grows upward), zw = width/height
    return c.xy + vec2(c.z, -c.w) * 0.5;
}

// Coverage of the trail swept from tail to head at this pixel
float trail(vec2 p, vec2 tail, vec2 ba, vec2 halfSize, float start) {
    float d = 1e9;
    for (int i = 0; i <= STEPS; i++) {
        float s = mix(start, 1.0, float(i) / float(STEPS));
        vec2 size = halfSize * vec2(mix(0.2, 1.0, s), mix(0.15, 0.9, s));
        d = min(d, sdBox(p - (tail + ba * s), size));
    }
    return 1.0 - smoothstep(-0.5, 0.5, d);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 term = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = term;

    float progress = (iTime - iTimeCursorChange) / DURATION;
    if (progress >= 1.0) return;

    vec2 head = cursorCenter(iCurrentCursor);
    vec2 tail = cursorCenter(iPreviousCursor);
    vec2 ba = head - tail;
    float len = length(ba);
    if (len < 1.0) return;

    vec2 halfSize = iCurrentCursor.zw * 0.5;
    vec2 dir = ba / len;
    vec2 off = vec2(-dir.y, dir.x) * SPLIT;
    float start = progress * progress;

    float c = trail(fragCoord + off, tail, ba, halfSize, start);
    float m = trail(fragCoord - off, tail, ba, halfSize, start);

    // Glitch slices: thin horizontal bands drop out
    float band = floor(fragCoord.y / 3.0) + floor(iTime * 30.0) * 7.0;
    float slice = step(0.25, hash(band));

    float along = clamp(dot(fragCoord - tail, dir) / len, 0.0, 1.0);
    float fade = (1.0 - progress) * mix(0.35, 1.0, along) * slice * OPACITY;

    // Never paint over the cursor cell itself
    if (sdBox(fragCoord - head, halfSize) < 0.0) fade = 0.0;

    vec3 glow = PURPLE * c + INDIGO * m * (1.0 - c * 0.5);
    fragColor = vec4(mix(term.rgb, min(glow, 1.0), clamp(max(c, m) * fade, 0.0, 1.0)), term.a);
}
