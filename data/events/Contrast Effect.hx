var saturation:CustomShader;

function create() {
    if(!Options.gameplayShaders) {
        disableScript();
        return;
    }

    saturation = new CustomShader("saturation");
    saturation.contrast = 1;
    saturation.sat = 1;
    FlxG.camera.addShader(saturation);
    camHUD.addShader(saturation);
}

var saturationTween:FlxTween = null;
var curSaturation:Float = 1;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Contrast Effect") {
        if (params[0] == false)
            saturation.contrast = curSaturation = params[1];
        else {
            if (saturationTween != null) saturationTween.cancel();
            var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);

            saturationTween = FlxTween.num(curSaturation, params[1], ((Conductor.crochet / 4) / 1000) * params[2], 
            {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {saturation.contrast = curSaturation = val;});
        }
    }
}

function destroy()
    FlxG.game.removeShader(saturation);