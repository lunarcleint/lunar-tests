//
import funkin.game.ComboRating;

var pixel_vig:CustomShader;
var pixel_vig:CustomShader;

var tape_noise:CustomShader;
var crt_shader:CustomShader;

var bloom_legacy:CustomShader;

var glitch_amp:CustomShader;
var glitch_wow:CustomShader;

var camcharacters:FlxCamera;

function create() {
    static_shader = new CustomShader("static");
	static_shader.time = 0; static_shader.strength = 6;
	static_shader.speed = 20;
	FlxG.game.addShader(static_shader);

    /*
    pixel_vig = new CustomShader("pixel_vig");
    pixel_vig.res = [FlxG.width, FlxG.height];
    pixel_vig.uBlocksize = [10, 10];
    pixel_vig.inner = 0.; pixel_vig.outer = 40;
    pixel_vig.strength = .9; pixel_vig.curvature = .1;
	FlxG.camera.addShader(pixel_vig);
    */

    tape_noise = new CustomShader("tapenoise");
    tape_noise.res = [FlxG.width, FlxG.height];
    tape_noise.time = 0;
    FlxG.camera.addShader(tape_noise);

    crt_shader = new CustomShader("crt");
    crt_shader.res = [FlxG.width, FlxG.height];
    crt_shader.time = 0;
    FlxG.camera.addShader(crt_shader);

    bloom_legacy = new CustomShader("bloom_legacy");
    camHUD.addShader(bloom_legacy);

    /*
    glitch_amp = new CustomShader("glitch_amp");
    glitch_amp.beatMode = false; glitch_amp.bpm = 0;
    glitch_amp.time = 0; glitch_amp.amp = .02;
    glitch_amp.sinnerSpeed = .2;
    glitch_amp.visible = true;
    */ 
    //stage.stageSprites["nosexi"].shader = glitch_amp;
    // camHUD.addShader(glitch_amp);

    glitch_wow = new CustomShader("glitch_wow");
    glitch_wow.res = [FlxG.width, FlxG.height];
    glitch_wow.time = 0;
    glitch_wow.glitchAmount = .2;
    glitch_wow.visible = true;

    // gradient = stage.stageSprites["GRADIENT"];
    // FlxGradient.overlayGradientOnBitmapData(
    //     gradient.pixels,
    //     gradient.width,
    //     gradient.height,
    //     [0xFF000000,0xFF000000, 0xFF000000, 0xFF000000,0xFF000000, 0xFF260F0F, 0xFFA71717, 0xFFD90808]
    // );
    // gradient.blend = 0 /*ADD*/ ;

    var gradientShader:CustomShader = new CustomShader("gradient");
    dad.shader = gradientShader;

    comboRatings = [
        new ComboRating(0, "F", 0xFF333333),   // Dark Gray
        new ComboRating(0.5, "E", 0xFF555555), // Slightly Lighter Gray
        new ComboRating(0.7, "D", 0xFF777777), // Medium Gray
        new ComboRating(0.8, "C", 0xFF888888), // Neutral Gray
        new ComboRating(0.85, "B", 0xFFAAAAAA), // Light Gray
        new ComboRating(0.9, "A", 0xFFBBBBBB), // Brighter Gray
        new ComboRating(0.95, "S", 0xFFD0D0D0), // Almost White Gray
        new ComboRating(1, "S++", 0xFFEAEAEA), // Very Light Gray
    ];

    camcharacters = new FlxCamera();

    for (strum in strumLines)
        for (char in strum.characters)
            char.cameras = [camcharacters];

    camcharacters.bgColor = 0x00000000; 
    FlxG.cameras.add(camcharacters, false);
    camcharacters.addShader(glitch_wow);
}

function update(elapsed:Float) {
    tape_noise.time += elapsed;
    crt_shader.time += elapsed;
    // glitch_amp.time += elapsed;
    glitch_wow.time += elapsed;
    if (FlxG.random.bool(70))
        static_shader.time += elapsed;

    camcharacters.scroll = FlxG.camera.scroll;
    camcharacters.zoom = FlxG.camera.zoom;
    camcharacters.angle = FlxG.camera.angle;
}

function destroy() {
    FlxG.game.removeShader(static_shader);
}

function onOpponentHit() {
    shake();
}