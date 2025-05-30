public var bloom:CustomShader = null;

function create() {
    if(!Options.gameplayShaders) {
        disableScript();
        return;
    }

    bloom = new CustomShader("bloom");
    bloom.size = 0; bloom.brightness = 1;
    bloom.directions = 16; bloom.quality = 6;
    bloom.threshold = .715;
    FlxG.camera.addShader(bloom);
}

var bloomTween:FlxTween = null;
var curbloom:Float = 1;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Bloom Effect") {
        if (params[0] == false)
            setBloom(params[1]);
        else {
            if (bloomTween != null) bloomTween.cancel();
            var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);

            bloomTween = FlxTween.num(curbloom, params[1], ((Conductor.crochet / 4) / 1000) * params[2], 
            {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {setBloom(val);});
        }
    }
}

function setBloom(bloom_effect:Float) {
    var bloomGlowAmount:Float = Math.max((bloom_effect) - 1, 0)*60;
    bloom.size = Math.min(bloomGlowAmount, 100);

    bloom.directions = 16;
    if (bloomGlowAmount > 90)
        bloom.directions = 32;

    bloom.threshold = .715;
    if (bloomGlowAmount > 100) 
        bloom.threshold -= ((bloomGlowAmount-100)/10000)*2;

    bloom.brightness = Math.max(bloom_effect, 1);

    curbloom = bloom_effect;
}

function destroy() {
    // FlxG.game.removeShader(bloom);
}