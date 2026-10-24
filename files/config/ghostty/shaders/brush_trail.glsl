// Brush trail: the cursor block smears from its old position to its new one
// like a loaded brush, with bristle streaks, then the tail dries up.

const float DURATION = 0.3;  // seconds the stroke stays visible
const float OPACITY = 0.85;
const int STEPS = 24;        // samples along the stroke

float hash(float n) {
    return fract(sin(n * 91.345) * 47453.5453);
}

// Signed distance to a box centered at the origin
float sdBox(vec2 p, vec2 halfSize) {
    vec2 d = abs(p) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 cursorCenter(vec4 c) {
    // xy = top-left corner (y grows upward), zw = width/height
    return c.xy + vec2(c.z, -c.w) * 0.5;
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

    // Sweep the cursor box along the stroke; the brush is thinner at the tail
    // and the tail retracts toward the head as time passes
    float start = smoothstep(0.0, 1.0, progress);
    float d = 1e9;
    for (int i = 0; i <= STEPS; i++) {
        float s = mix(start, 1.0, float(i) / float(STEPS));
        vec2 size = halfSize * mix(0.35, 1.0, s);
        d = min(d, sdBox(fragCoord - (tail + ba * s), size));
    }

    float alpha = 1.0 - smoothstep(-1.0, 1.0, d);

    // Bristle streaks run along the stroke direction
    float across = dot(fragCoord - tail, vec2(-dir.y, dir.x));
    alpha *= 0.55 + 0.45 * hash(floor(across * 0.6));

    // Ink runs out: fade over time, and more toward the tail
    float along = clamp(dot(fragCoord - tail, dir) / len, 0.0, 1.0);
    alpha *= (1.0 - progress) * mix(0.5, 1.0, along);

    // Never paint over the cursor cell itself
    if (sdBox(fragCoord - head, halfSize) < 0.0) alpha = 0.0;

    fragColor = vec4(mix(term.rgb, iCurrentCursorColor.rgb, alpha * OPACITY), term.a);
}
