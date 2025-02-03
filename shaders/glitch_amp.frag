#pragma header
// CONVERTED AND CHANGED BY LUNAR (OG AT: https://www.shadertoy.com/view/3llBDS)

uniform bool visible;

uniform bool beatMode;
uniform float bpm;

uniform float time;
uniform float amp;
uniform float sinnerSpeed;

vec2 uvp(vec2 uv) {
	return clamp(uv, 0.0, 1.0);
}

float outCirc(float t) {
    return sqrt(-t * t + 2.0 * t);
}

float rand(vec2 co) {
	return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    if (!visible) {
        gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
        return;
    }

    vec3 col;
    float _true_amp = amp;
    
    if (beatMode)
        _true_amp = (1.0 - outCirc(fract((time/60.0)*bpm)));

    for (int i = 0; i < 3; i++) {
    	vec2 uv = openfl_TextureCoordv;
        uv += vec2(sin(time + float(i) + _true_amp) * sinnerSpeed, cos(time + float(i) + _true_amp) * sinnerSpeed) * _true_amp * 0.2;
        vec3 texOrig = flixel_texture2D(bitmap, uvp(uv)).rgb;
        
        uv.x += (rand(vec2(uv.y + float(i), time)) * 2.0 - 1.0) * _true_amp * 0.8 * (texOrig[i] + 0.2);
        uv.y += (rand(vec2(uv.x, time + float(i))) * 2.0 - 1.0) * _true_amp * 0.1 * (texOrig[i] + 0.2);
        
        vec3 tex = flixel_texture2D(bitmap, uvp(uv)).rgb;
        tex += abs(tex[i] - texOrig[i]);
        
        tex *= rand(uv) * _true_amp + 1.0;
        tex = fract(tex);
        col[i] = tex[i];
    }
    
    gl_FragColor = vec4(col,1.0);
}