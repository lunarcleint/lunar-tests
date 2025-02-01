#pragma header

uniform float blockSize;
uniform vec2 res;

void main() {
    vec2 blocks = ((res + vec2(0.5, 0.5)) / blockSize) - vec2(0.5, 0.5);
    vec2 texCoords = (openfl_TextureCoordv * blocks) + (0.5 / res);
    gl_FragColor = flixel_texture2D(bitmap, floor(texCoords) / blocks);
}