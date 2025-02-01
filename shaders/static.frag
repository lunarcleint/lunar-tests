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
    
    // Sample the texture color
    vec4 color = flixel_texture2D(bitmap, uv);
    
    float brightness = abs(1.-dot(color.rgb, vec3(0.299, 0.587, 0.114)))*1;
    // float brightness = dot(color.rgb, vec3(0.299, 0.587, 0.114))*.2;

    float noise = (rand(uv + time * 0.01) - 0.2) * strength * 0.15 * brightness;
    
    color.rgb *= (1.0-noise);
    
    gl_FragColor = color;
}
