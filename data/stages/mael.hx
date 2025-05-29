public var bloom:CustomShader;
public var glitch:CustomShader;
public var abbr:CustomShader;
public var static_shader:CustomShader;
public var glitch_wow:CustomShader;
public var gradientShader:CustomShader;

function create() {
    bloom = new CustomShader("bloom");
    bloom.size = 200; bloom.brightness = 1.8;
    bloom.directions = 32; bloom.quality = 6;
    bloom.threshold = .715;

    glitch = new CustomShader("glitching");
    glitch.time = 0;
    glitch.glitchAmount = .2;

    abbr = new CustomShader("chrom");
    abbr.rOffset = [-.0007, 0]; abbr.gOffest = [0,0];
    abbr.bOffset = [.0007, 0];

    static_shader = new CustomShader("static");
	static_shader.time = 0; static_shader.strength = 1.5;
	static_shader.speed = 20;

    glitch_wow = new CustomShader("glitch_wow");
    glitch_wow.res = [FlxG.width, FlxG.height];
    glitch_wow.time = 0;
    glitch_wow.glitchAmount = 0.1;
    glitch_wow.visible = true;

    gradientShader = new CustomShader("gradient");
    gradientShader.cameraZoom = FlxG.camera.zoom;
    gradientShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    gradientShader.res = [FlxG.width, FlxG.height]; gradientShader.time = 0;

    gradientShader.applyY = 660;
    gradientShader.applyRange = 400;
    FlxG.camera.addShader(gradientShader);

    FlxG.camera.addShader(bloom);
    FlxG.camera.addShader(glitch);
    FlxG.camera.addShader(abbr);
	FlxG.camera.addShader(static_shader);
}

var __timer:Float = 0; 
function update(elapsed:Float) {
    __timer += elapsed;

    glitch.time = __timer;
    static_shader.time = __timer;
    gradientShader.time = __timer;

    glitch_wow.time = Math.floor(__timer/4)*4;

    glitch_wow.glitchAmount = lerp(glitch_wow.glitchAmount, 0.1, .1);
    glitch.glitchAmount = lerp(glitch.glitchAmount, 0.2, .75);
    abbr.rOffset = [lerp(abbr.rOffset[0], -.0007, .9), 0];
    abbr.bOffset = [lerp(abbr.bOffset[0], .0007, .9), 0];

    gradientShader.cameraZoom = FlxG.camera.zoom;
    gradientShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
}

function onDadHit() {
    glitch.glitchAmount = 3.8+FlxG.random.float(0.5, 2);
    glitch_wow.glitchAmount = -FlxG.random.float(.5, .8)*1;
    abbr.rOffset = [-glitch.glitchAmount*0.003, 0];
    abbr.bOffset = [glitch.glitchAmount*0.003, 0];
}

