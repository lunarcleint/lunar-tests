#pragma header
uniform float[] a;

function main() {
	vec2 uv = openfl_TextureCoordv;
	float x = uv.x * 1280;
	float y = uv.y * 1280;
	float line = a[int(x)];
	gl_FragColor = openfl_TextureCoordv;
	if (line == y) gl_FragColor.g = 1;
}