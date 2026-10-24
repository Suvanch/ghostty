// Cursor trail: a tapered streak from the previous cursor position to the
// current one, in the cursor's color, that retracts and fades out.

const float DURATION = 0.25; // seconds the trail stays visible
const float OPACITY = 0.65;

vec2 cursorCenter(vec4 c) {
    // xy = top-left corner (y grows upward), zw = width/height
    return c.xy + vec2(c.z, -c.w) * 0.5;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 term = texture(iChannel0, fragCoord / iResolution.xy);

    vec2 head = cursorCenter(iCurrentCursor);
    vec2 tail = cursorCenter(iPreviousCursor);
    vec2 ba = head - tail;
    float len2 = dot(ba, ba);

    float t = iTime - iTimeCursorChange;
    float progress = smoothstep(0.0, DURATION, t);

    // Position along the tail->head segment (0 = tail, 1 = head)
    float h = clamp(dot(fragCoord - tail, ba) / max(len2, 1e-4), 0.0, 1.0);

    // Thin at the tail, cursor-sized at the head
    float radius = mix(1.0, min(iCurrentCursor.z, iCurrentCursor.w) * 0.5, h);
    float d = length(fragCoord - tail - ba * h) - radius;

    float alpha = 1.0 - smoothstep(-1.0, 1.5, d);
    alpha *= step(progress, h);        // tail retracts toward the head
    alpha *= 1.0 - progress;           // and fades
    alpha *= step(4.0, sqrt(len2));    // skip tiny moves (normal typing)

    // Never paint over the cursor cell itself
    vec2 lo = vec2(iCurrentCursor.x, iCurrentCursor.y - iCurrentCursor.w);
    vec2 hi = vec2(iCurrentCursor.x + iCurrentCursor.z, iCurrentCursor.y);
    if (all(greaterThanEqual(fragCoord, lo)) && all(lessThanEqual(fragCoord, hi))) {
        alpha = 0.0;
    }

    fragColor = vec4(mix(term.rgb, iCurrentCursorColor.rgb, alpha * OPACITY), term.a);
}
