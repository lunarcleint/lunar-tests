//https://www.shadertoy.com/view/wld3WN
#pragma header

uniform float time;
uniform vec2 res;

#define CRT

#define DURATION 5.
#define AMT .5 

#define SS(a, b, x) (smoothstep(a, b, x) * smoothstep(b, a, x))

// Hash by David_Hoskins
vec3 hash33(vec3 p)
{
    p = fract(p * vec3(443.8975, 397.2973, 491.1871)); // Randomizing factors
    p += dot(p, p.yxz + 19.19);
    return fract(vec3(p.x * p.y, p.y * p.z, p.z * p.x));
}

// Gradient noise by iq
float gnoise(vec3 x)
{
    // grid
    vec3 p = floor(x);
    vec3 w = fract(x);
    
    // quintic interpolant
    vec3 u = w * w * w * (w * (w * 6. - 15.) + 10.);
    
    // gradients
    vec3 ga = hash33(p + vec3(0., 0., 0.));
    vec3 gb = hash33(p + vec3(1., 0., 0.));
    vec3 gc = hash33(p + vec3(0., 1., 0.));
    vec3 gd = hash33(p + vec3(1., 1., 0.));
    vec3 ge = hash33(p + vec3(0., 0., 1.));
    vec3 gf = hash33(p + vec3(1., 0., 1.));
    vec3 gg = hash33(p + vec3(0., 1., 1.));
    vec3 gh = hash33(p + vec3(1., 1., 1.));
    
    // projections
    float va = dot(ga, w - vec3(0., 0., 0.));
    float vb = dot(gb, w - vec3(1., 0., 0.));
    float vc = dot(gc, w - vec3(0., 1., 0.));
    float vd = dot(gd, w - vec3(1., 1., 0.));
    float ve = dot(ge, w - vec3(0., 0., 1.));
    float vf = dot(gf, w - vec3(1., 0., 1.));
    float vg = dot(gg, w - vec3(0., 1., 1.));
    float vh = dot(gh, w - vec3(1., 1., 1.));
	
    // interpolation
    float gNoise = va + u.x * (vb - va) + 
           		u.y * (vc - va) + 
           		u.z * (ve - va) + 
           		u.x * u.y * (va - vb - vc + vd) + 
           		u.y * u.z * (va - vc - ve + vg) + 
           		u.z * u.x * (va - vb - ve + vf) + 
           		u.x * u.y * u.z * (-va + vb + vc - vd + ve - vf - vg + vh);
    
    return 2. * gNoise;
}

// gradient noise in range [0, 1]
float gnoise01(vec3 x)
{
	return .5 + .5 * gnoise(x);   
}

// warp uvs for the crt effect
vec2 crt(vec2 uv)
{
    float tht  = atan(uv.y, uv.x);
    float r = length(uv);
    // curve without distorting the center
    r /= (1. - .1 * r * r);
    uv.x = r * cos(tht);
    uv.y = r * sin(tht);
    return .5 * (uv + 1.);
}


void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 trueFragCoord = gl_FragCoord.xy * (res / openfl_TextureSize);

    float t = time;
    // smoothed interval for which the glitch gets triggered
    float glitchAmount = SS(DURATION * .001, DURATION * AMT, mod(t, DURATION));  
	float displayNoise = 0.;
    vec4 ogTex =  flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
    vec3 col = ogTex.rgb;
    vec2 eps = vec2(5. / res.x, 0.);
    vec2 st = vec2(0.);

	uv = crt(uv * 2. - 1.); // warped uvs
    ++displayNoise;
    
    float skibdi = uv.y * res.y;
    // white noise + scanlines
    displayNoise = clamp(displayNoise, 0., .11);
    col += (.15 + .65 * glitchAmount) * (hash33(vec3(trueFragCoord, mod(float(time*.240), 1000.))).r) * displayNoise;
    col -= (.25 + .75 * glitchAmount) * (sin(4. * t + skibdi * 1.75))* displayNoise;

    gl_FragColor = vec4(col, ogTex.a);
}