#pragma header

uniform float minBrightness;
uniform vec3 color;
uniform float ratio;

float brightness(vec3 color) {
    return (color.r + color.g + color.b)/3.;
}

vec3 lerpcolor(vec3 color, vec3 lerpColor, float ratio) {
    vec3 newColor = vec3(0., 0., 0.);
    newColor.r = mix(color.r, lerpColor.r, ratio);
    newColor.g = mix(color.g, lerpColor.g, ratio);
    newColor.b = mix(color.b, lerpColor.b, ratio);
    return newColor;
}

void main() {
    vec4 flixelColor = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
    float brightness = brightness(flixelColor.rgb);

    if (brightness > minBrightness) 
        gl_FragColor = vec4(lerpcolor(flixelColor.rgb, color, ratio), flixelColor.a);
    else gl_FragColor = flixelColor;
}