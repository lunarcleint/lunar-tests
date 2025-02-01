#pragma header

uniform float grayness;

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec4 color = flixel_texture2D(bitmap, uv);
    vec3 greyScale = vec3(dot(color.rgb, vec3(.25)));
    gl_FragColor = vec4((color.rgb*abs(1.-grayness))+(greyScale*grayness), color.a);
}