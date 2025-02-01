#pragma header

uniform float time;
uniform float strength;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(float c){
	return rand(vec2(c,1.0));
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;

    gl_FragColor = flixel_texture2D(bitmap, uv);
    gl_FragColor.xyz *= (1.0+(rand(uv+time*.01)-.2)*(strength*.15));	
}