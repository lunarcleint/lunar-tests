#pragma header

#define PI 3.1415927
#define TWO_PI 6.283185

#define ANIMATION_SPEED 0.6
#define MOVEMENT_SPEED 0.5
#define MOVEMENT_DIRECTION vec2(0.0, 1.0)

#define PARTICLE_SIZE 0.002

#define PARTICLE_SCALE (vec2(0.5, 1.6))
#define PARTICLE_SCALE_VAR (vec2(0.25, 0.2))

#define PARTICLE_BLOOM_SCALE (vec2(0.5, 0.8))
#define PARTICLE_BLOOM_SCALE_VAR (vec2(0.3, 0.1))

#define SPARK_COLOR vec3(1.0, 1.0, 0.122) * 1.5
#define BLOOM_COLOR vec3(1.0, 0.161, 0.161) * 0.8
#define SMOKE_COLOR vec3(1.0, 0.43, 0.1) * 0.0

#define SIZE_MOD 1.1
#define ALPHA_MOD 0.9
#define LAYERS_COUNT 10

uniform float iTime;

float hash1_2(in vec2 p)
{
    vec3 p3  = fract(p.xyx * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

vec2 hash2_2(in vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

vec2 noise2_2(in vec2 FUCK) {
    return vec2(noise1(FUCK.x), noise1(FUCK.y));
}

float noise1_2(in vec2 FUCK) {
    return (noise1(FUCK.x) * noise1(FUCK.y)) / 2;
}

float layeredNoise1_2(in vec2 uv, in float sizeMod, in float alphaMod, in int layers, in float animation)
{
 	float noise = 0.3;
    float alpha = 1.0;
    float size = 1.0;
    vec2 offset;
    for (int i = 0; i < layers; i++)
    {
        offset += hash2_2(vec2(alpha, size)) * 10.0;
        
        //Adding noise with movement
     	noise += noise1_2(uv * (size + iTime) * animation * 8.0 * MOVEMENT_DIRECTION * MOVEMENT_SPEED + offset) * alpha;
        alpha *= alphaMod;
        size *= sizeMod;
    }
    
    noise *= (1.0 - alphaMod)/(1.0 - pow(alphaMod, float(layers)));
    return noise;
}

//Rotates point around 0,0
vec2 rotate(in vec2 point, in float deg)
{
 	float s = sin(deg);
    float c = cos(deg);
    return mat2x2(s, c, -c, s) * point;
}

//Cell center from point on the grid
vec2 voronoiPointFromRoot(in vec2 root, in float deg)
{
  	vec2 point = hash2_2(root) - 0.5;
    float s = sin(deg);
    float c = cos(deg);
    point = mat2x2(s, c, -c, s) * point * 0.66;
    point += root + 0.5;
    return point;
}

//Voronoi cell point rotation degrees
float degFromRootUV(in vec2 uv)
{
 	return iTime * ANIMATION_SPEED * (hash1_2(uv) - 0.5) * 2.0;   
}

vec2 randomAround2_2(in vec2 point, in vec2 range, in vec2 uv)
{
 	return point + (hash2_2(uv) - 0.5) * range;
}


vec3 fireParticles(in vec2 uv, in vec2 originalUV)
{
    vec3 particles = vec3(0.0);
    vec2 rootUV = floor(uv);
    float deg = degFromRootUV(rootUV);
    vec2 pointUV = voronoiPointFromRoot(rootUV, deg);
    float dist = 2.0;
    float distBloom = 0.0;
   
   	//UV manipulation for the faster particle movement
    vec2 tempUV = uv + (noise2_2(uv * 2.0) - 0.5) * 0.1;
    tempUV += -(noise2_2(uv * 3.0 + iTime) - 0.5) * 0.07;

    //Sparks sdf
    dist = length(rotate(tempUV - pointUV, 0.7) * randomAround2_2(PARTICLE_SCALE, PARTICLE_SCALE_VAR, rootUV));
    
    //Bloom sdf
    distBloom = length(rotate(tempUV - pointUV, 0.7) * randomAround2_2(PARTICLE_BLOOM_SCALE, PARTICLE_BLOOM_SCALE_VAR, rootUV));

    //Add sparks
    particles += (1.0 - smoothstep(PARTICLE_SIZE * 0.6, PARTICLE_SIZE * 3.0, dist)) * SPARK_COLOR;
    
    //Add bloom
    particles += pow((1.0 - smoothstep(0.0, PARTICLE_SIZE * 6.0, distBloom)) * 1.0, 3.0) * BLOOM_COLOR;

    //Upper disappear curve randomization
    float border = (hash1_2(rootUV) - 0.5) * 2.0;
 	float disappear = 1.0 - smoothstep(border, border + 0.5, originalUV.y);
	
    //Lower appear curve randomization
    border = (hash1_2(rootUV + 0.214) - 1.8) * 0.7;
    float appear = smoothstep(border, border + 0.4, originalUV.y);
    
    return particles * disappear * appear;
}


//Layering particles to imitate 3D view
vec3 layeredParticles(in vec2 uv, in float sizeMod, in float alphaMod, in int layers, in float smoke) 
{ 
    vec3 particles = vec3(0);
    float size = 1.0;
    float alpha = 1.0;
    vec2 offset = vec2(0.0);
    vec2 noiseOffset;
    vec2 bokehUV;
    
    for (int i = 0; i < layers; i++)
    {
        //Particle noise movement
        noiseOffset = (noise2_2(uv * size * 2.0 + 0.5) - 0.5) * 0.15;
        
        //UV with applied movement
        bokehUV = (uv * size + iTime * MOVEMENT_DIRECTION * MOVEMENT_SPEED) + offset + noiseOffset; 
        
        //Adding particles								if there is more smoke, remove smaller particles
		particles += fireParticles(bokehUV, uv) * alpha * (1.0 - smoothstep(0.0, 1.0, smoke) * (float(i) / float(layers)));
        
        //Moving uv origin to avoid generating the same particles
        offset += hash2_2(vec2(alpha, alpha)) * 10.0;
        
        alpha *= alphaMod;
        size *= sizeMod;
    }
    
    return particles;
}

void main()
{
    vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize.xy;
    vec2 uv = (2.0 * fragCoord - openfl_TextureSize.xy) / openfl_TextureSize.x;
    
    float vignette = 1.0 - smoothstep(0.4, 1.4, length(uv + vec2(0.0, 0.3)));
    
    uv *= 1.8;
    
    float smokeIntensity = 0.0;
    vec3 smoke = smokeIntensity * SMOKE_COLOR * 0.8 * vignette;

    vec3 particles = layeredParticles(uv, SIZE_MOD, ALPHA_MOD, LAYERS_COUNT, smokeIntensity);
    
    //vec3 col = particles;
    vec3 col = particles + smoke + SMOKE_COLOR * 0.02;
    
    col = smoothstep(-0.08, 1.0, col);

    gl_FragColor = vec4(col, float(col));
}