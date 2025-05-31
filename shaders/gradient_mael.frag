#pragma header

uniform vec2 res;
uniform float cameraZoom;
uniform vec2 cameraPosition;

uniform float applyRange;
uniform float applyY;

float brightness(vec3 color) {
    return (color.r + color.g + color.b)/3.;
}

void main()
{
    vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);

    vec2 screenSize = openfl_TextureSize.xy;
    vec2 normalizedCoord = gl_FragCoord.xy / screenSize;
    vec2 ndc = normalizedCoord * 2.0 - 1.0;
    ndc /= cameraZoom;
    
    // took too long to fix fullscreen
    vec2 zoomedScreenCoord = (ndc + 1.0) * 0.5 * res;
    vec2 worldCoord = zoomedScreenCoord + cameraPosition;
    
    float gradient = 0.0;

    // for debug
    
    /*
    if (abs(worldCoord.y - applyY) < 1.0) {
        gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0); // green
        return;
    }
    */

    if ((worldCoord.y <= applyY && worldCoord.y >= applyY - applyRange) && col.a > 0.5) {
        float dist = applyY - worldCoord.y;
        gradient = 1.0 - (dist / applyRange);

        vec3 bottomColor = vec3(0., 0., 0.); 
        vec3 topColor = vec3(2.0, 0.2, 0.3);    
        vec3 gradientCol = mix(bottomColor, topColor, gradient);

        col += vec4(gradientCol*2, 1.0)*(gradient*.06) *col.a;
    }

    gl_FragColor = col;
}