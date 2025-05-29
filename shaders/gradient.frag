#pragma header

uniform vec2 res;
uniform float cameraZoom;
uniform vec2 cameraPosition;
uniform float time;

uniform float applyRange;
uniform float applyY;

const vec3 FOG_COLOR = vec3(161./255., 61./255., 156./255.);
const vec3 BG = vec3(0.0, 0.0, 0.0);
const float ZOOM = 3.0;
const int OCTAVES = 4;
const float INTENSITY = 1.54;

// Noise functions from the fog shader
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9818,79.279)))*43758.5453123);
}

vec2 random2(vec2 st){
    st = vec2(dot(st,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(st) * 43759.34517123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // smootstep
    vec2 u = f*f*(3.0-2.0*f);

    return mix(mix(dot(random2(i + vec2(0.0,0.0)), f - vec2(0.0,0.0)),
               dot(random2(i + vec2(1.0,0.0)), f - vec2(1.0,0.0)), u.x),
           mix(dot(random2(i + vec2(0.0,1.0)), f - vec2(0.0,1.0)),
               dot(random2(i + vec2(1.0,1.0)), f - vec2(1.0,1.0)), u.x), u.y);
}

float fractal_brownian_motion(vec2 coord) {
    float value = 0.0;
    float scale = 0.5;
    for (int i = 0; i < OCTAVES; i++) {
        value += noise(coord) * scale;
        coord *= 2.0;
        scale *= 0.5;
    }
    return value + 0.2;
}

void main()
{
    vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
    
    vec2 screenSize = openfl_TextureSize.xy;
    vec2 normalizedCoord = gl_FragCoord.xy / screenSize;
    vec2 ndc = normalizedCoord * 2.0 - 1.0;
    ndc /= cameraZoom;
    vec2 zoomedScreenCoord = (ndc + 1.0) * 0.5 * res;
    vec2 worldCoord = zoomedScreenCoord + cameraPosition;
    
    vec2 st = worldCoord.xy / res.xy;
    st *= res.xy / res.y;    
    vec2 pos = vec2(st * ZOOM);
    
    vec2 motion = vec2(fractal_brownian_motion(pos + vec2(time * -0.2, time * -0.2)));
    float fogAmount = fractal_brownian_motion(pos + motion) * INTENSITY;
    
    if (worldCoord.y <= applyY && worldCoord.y >= applyY - applyRange && col.a != 0.0) {
        float dist = applyY - worldCoord.y;
        float gradient = 1.0 - (dist / applyRange);
        
        vec3 fogEffect = mix(BG, FOG_COLOR, fogAmount * gradient);
        col.rgb += fogEffect * vec3(gradient * fogAmount, gradient * fogAmount, gradient * fogAmount);
    }
    
    gl_FragColor = col;
}