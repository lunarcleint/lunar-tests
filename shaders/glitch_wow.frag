#pragma header

uniform bool visible;

uniform float time;
uniform vec2 res;

uniform float glitchAmount;

vec4 posterize(vec4 color, float numColors)
{
    return floor(color * numColors - 0.5) / numColors;
}

vec2 quantize(vec2 v, float steps)
{
    return floor(v * steps) / steps;
}

float dist(vec2 a, vec2 b)
{
    return sqrt(pow(b.x - a.x, 2.0) + pow(b.y - a.y, 2.0));
}

void main()
{   
    if (!visible) {
        gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
        return;
    }
    
	vec2 uv = openfl_TextureCoordv.xy;
    float amount = pow(glitchAmount, 2.0);
    vec2 pixel = 1.0 / res.xy;    
    vec4 color = flixel_texture2D(bitmap, uv);

    float t = mod(mod(time, amount * 100.0 * (amount - 0.5)) * 109.0, 1.0);
    vec4 postColor = posterize(color, 16.0);
    vec4 a = posterize(flixel_texture2D(bitmap, quantize(uv, 64.0 * t) + pixel * (postColor.rb - vec2(.5)) * 100.0), 5.0).rbga;
    vec4 b = posterize(flixel_texture2D(bitmap, quantize(uv, 32.0 - t) + pixel * (postColor.rg - vec2(.5)) * 1000.0), 4.0).gbra;
    vec4 c = posterize(flixel_texture2D(bitmap, quantize(uv, 16.0 + t) + pixel * (postColor.rg - vec2(.5)) * 20.0), 16.0).bgra;
    gl_FragColor = mix(
        			flixel_texture2D(bitmap, 
                              uv + amount * (quantize((a * t - b + c - (t + t / 2.0) / 10.0).rg, 16.0) - vec2(.5)) * pixel * 100.0),
                    (a + b + c) / 3.0,
                    (0.5 - (dot(color, postColor) - 1.5)) * amount);
}