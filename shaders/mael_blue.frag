#pragma header

uniform float time;

float hash(float n) { return fract(sin(n) * 1e4); }
float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    
    vec3 col = vec3(0.0, 0.1, 0.5);
    
    float scanlines = 0.8 + 0.2*sin(uv.y*800.0);
    col *= scanlines;
    
    float vHold = 0.5 + 0.5*sin(time*0.5 + uv.y*20.0);
    uv.y += 0.01*vHold*sin(time*3.0 + uv.y*30.0);
    
    float bleed = 0.03*sin(time*2.0 + uv.y*50.0);
    vec3 bleedCol = vec3(0.0, 0.0, col.b*0.7);
    col = mix(col, bleedCol, bleed);
    
    float staticNoise = noise(uv*500.0 + time*10.0);
    col += vec3(0.0, 0.0, 0.2)*staticNoise;
    
    float tear = smoothstep(0.9, 1.0, fract(uv.y*10.0 + time*0.5));
    col = mix(col, vec3(0.0), tear*0.7);
    
    uv = (uv - 0.5) * 2.0;
    float dist = dot(uv, uv);
    uv *= 1.0 + dist * 0.1;
    uv = (uv + 1.0) * 0.5;
    
    float vignette = 1.0 - 0.5*dot(uv-0.5, uv-0.5);
    col *= vignette;
    
    col = pow(col, vec3(1.0/2.2));
    gl_FragColor = vec4(col, 1.0);
}