//

var hudTween:FlxTween;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Change HUD Alpha") {
        if (params[0] == false)
            camHUD.alpha = params[1];
        else {
            if (hudTween != null) hudTween.cancel();

            var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);
            hudTween = FlxTween.tween(camHUD, {alpha: params[1]}, ((Conductor.crochet / 4) / 1000) * params[2], {ease: Reflect.field(FlxEase, flxease)});
        }
    }
}