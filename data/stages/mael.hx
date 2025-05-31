
import flixel.text.FlxTextBorderStyle;

public var bloom:CustomShader;
public var glitch:CustomShader;
public var abbr:CustomShader;
public var static_shader:CustomShader;
public var glitch_wow:CustomShader;
public var fogShader:CustomShader;

public var textsGroup:FlxGroup;
public var pinkGlow:FlxSprite;

function postCreate() {
    initHealthBar();
    initShaders();

    for (i in 0...24) // avoid lag spikes
        graphicCache.cache(Paths.image('stages/mael/texts/' + Std.string(i+1)));

    textsGroup = new FlxGroup();
    insert(members.indexOf(stage.stageSprites["screens_blank"])+1, textsGroup);

    for (iy in 0...2) {
        for (ix in 0...4) {
            var text:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stages/mael/texts/' + Std.string(FlxG.random.int(1,24))));
            text.x = -890 + 955*ix; text.scrollFactor.y = 0.9;
            text.y = (-740 + 553*iy);
            textsGroup.add(text);
        }
    }

    pinkGlow = new FlxSprite(0,0).makeSolid(1920, 1080, 0xffdf38cb);
    pinkGlow.blend = 1; pinkGlow.alpha = 0.11; pinkGlow.cameras = [camHUD];
    insert(200, pinkGlow);
}

var awesomeBar:FunkinSprite;
function initHealthBar() {
    remove(healthBarBG);
    awesomeBar = new FunkinSprite();
    awesomeBar.loadSprite(Paths.image('game/TS_healthbar')); // ts??? this 2022 troubleshooting team are time travelers
    awesomeBar.addAnim("idle", "health_move", 24, true);
    awesomeBar.playAnim("idle"); awesomeBar.scale.set(1.4, 1.4);
    awesomeBar.updateHitbox();
    awesomeBar.screenCenter(0x01);
    awesomeBar.y = healthBar.y-53;
    awesomeBar.cameras = [camHUD];
    insert(members.indexOf(healthBar)+1, awesomeBar);

    for (txt in [scoreTxt, missesTxt, accuracyTxt]) {
        txt.setFormat(Paths.font("Square.ttf"), 16, 0xFFFFFFFF);

        txt.borderStyle = FlxTextBorderStyle.OUTLINE;
        txt.borderSize = 6; txt.size += 2;
        txt.borderColor = 0xFF000000;

        txt.textField.antiAliasType = 0/*ADVANCED*/;
        txt.textField.sharpness = 400/*MAX ON OPENFL*/;
    }
}

function initShaders() {
    bloom = new CustomShader("bloom");
    bloom.size = 170; bloom.brightness = 1.7;
    bloom.directions = 32; bloom.quality = 6;
    bloom.threshold = .715;

    glitch = new CustomShader("glitching");
    glitch.time = 0;
    glitch.glitchAmount = 0;

    abbr = new CustomShader("chrom");
    abbr.rOffset = [-.0007, 0]; abbr.gOffest = [0,0];
    abbr.bOffset = [.0007, 0];

    static_shader = new CustomShader("static");
	static_shader.time = 0; static_shader.strength = 1.5;
	static_shader.speed = 20;

    glitch_wow = new CustomShader("glitch_wow");
    glitch_wow.res = [150, 150];
    glitch_wow.time = 0;
    glitch_wow.glitchAmount = 0.1;
    glitch_wow.visible = true;

    fogShader = new CustomShader("gradient");
    fogShader.cameraZoom = FlxG.camera.zoom;
    fogShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
    fogShader.res = [FlxG.width, FlxG.height]; fogShader.time = 0;

    fogShader.applyY = 660;
    fogShader.applyRange = 400;

    FlxG.camera.addShader(fogShader);

    FlxG.camera.addShader(bloom);
    FlxG.camera.addShader(glitch);
    FlxG.camera.addShader(abbr);
	FlxG.camera.addShader(static_shader);

	camHUD.addShader(static_shader);

}

var __timer:Float = 0; 
function update(elapsed:Float) {
    __timer += elapsed;

    glitch.time = __timer;
    static_shader.time = __timer;
    fogShader.time = __timer;

    glitch_wow.time = __timer;

    glitch_wow.glitchAmount = lerp(glitch_wow.glitchAmount, 0, .1);
    glitch.glitchAmount = lerp(glitch.glitchAmount, 0.2, .6);
    abbr.rOffset = [lerp(abbr.rOffset[0], -.0007, .9), 0];
    abbr.bOffset = [lerp(abbr.bOffset[0], .0007, .9), 0];

    fogShader.cameraZoom = FlxG.camera.zoom;
    fogShader.cameraPosition = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];

}

function onDadHit() {
    glitch.glitchAmount = 3.8+FlxG.random.float(0.5, 1);

    glitch_wow.glitchAmount = glitch.glitchAmount;

    abbr.rOffset = [-glitch.glitchAmount*0.003, 0];
    abbr.bOffset = [glitch.glitchAmount*0.003, 0];
}

function randomizeTexts() {
    var fullSweep:Bool = FlxG.random.bool();
    for (text in textsGroup.members) {
        if (!fullSweep && FlxG.random.bool()) continue;
        FlxTween.tween(text, {"scale.y": 0}, ((Conductor.crochet / 4) / 1000) * 4, {ease: FlxEase.elasticInOut, onComplete : (twn:FlxTween) -> {
            text.loadGraphic(Paths.image('stages/mael/texts/' + Std.string(FlxG.random.int(1,24))));
            FlxTween.tween(text, {"scale.y": 1}, ((Conductor.crochet / 4) / 1000) * 4, {ease: FlxEase.elasticInOut});
        }});
    }
}

function beatHit(curBeat:Int) {
    if (curBeat > 0 && curBeat % 4 == 0) randomizeTexts();
}

