#pragma header

#define PI 3.1415926535897932384626433832795
#define TWO_PI (PI * 2.0)

uniform float brightness; // Strength of the bloom
uniform float threshold;  // Minimum brightness for bloom to apply
uniform float directions; // Number of radial blur directions
uniform int quality;      // Number of blur samples per direction
uniform float size;       // Bloom spread size

void main(void) {
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 color = flixel_texture2D(bitmap, uv);
    
    if (brightness <= 0.0 || size <= 0.0) {
        gl_FragColor = color;
        return;
    }

    vec4 bloom = vec4(0.0);
    float weightSum = 0.0;

    // Extract bright areas only
    vec4 highlight = max(color - threshold, 0.0);

    for (float d = 0.0; d < TWO_PI; d += TWO_PI / directions) {
        for (float i = 1.0; i <= float(quality); i++) {
            float offset = (i / float(quality)) * size;
            float x_offset = (sin(d) * offset) / openfl_TextureSize.y;
            float y_offset = (cos(d) * offset) / openfl_TextureSize.x;
            vec2 sampleUV = clamp(uv + vec2(x_offset, y_offset), vec2(0.0), vec2(1.0));

            // Sample only the highlight areas
            vec4 sampleColor = max(flixel_texture2D(bitmap, sampleUV) - threshold, 0.0);
            float weight = exp(-2.0 * (i / float(quality))); // Smooth falloff
            bloom += sampleColor * weight;
            weightSum += weight;
        }
    }

    if (weightSum > 0.0) {
        bloom /= weightSum;
    }

    // Blend bloom smoothly with the original color
    gl_FragColor = color + (bloom * brightness);
}
