//
var screenVignette:CustomShader;
var curStrength:Float = 0.1;
var curAmount:Float = 0.1;

function create() {
    if(!Options.gameplayShaders) {
        disableScript();
        return;
    }

    screenVignette = new CustomShader("coloredVignette");
    screenVignette.strength = 0.1;
    screenVignette.amount = 0.1;
    FlxG.camera.addShader(screenVignette);
}

var strengthTween:FlxTween = null;
var amountTween:FlxTween = null;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Screen Vignette") {
        if (params[0] == false) {
            screenVignette.amount = curAmount = params[1];
            screenVignette.strength = curStrength = params[2];
        } else {
            var flxease:String = params[4] + (params[4] == "linear" ? "" : params[5]);

            if (strengthTween != null) strengthTween.cancel();
            strengthTween = FlxTween.num(curStrength, params[2], ((Conductor.crochet / 4) / 1000) * params[3],
            {onComplete: function(_) _ = null, ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {screenVignette.strength = curStrength = val;});

            if (amountTween != null) amountTween.cancel();
            amountTween = FlxTween.num(curAmount, params[1], ((Conductor.crochet / 4) / 1000) * params[3],
            {onComplete: function(_) _ = null, ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {screenVignette.amount = curAmount = val;});
        }
    }
}



function destroy()
    FlxG.game.removeShader(screenVignette);