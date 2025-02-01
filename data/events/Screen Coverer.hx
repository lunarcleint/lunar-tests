//
var screenCoverer:FunkinSprite;

function create() {
    screenCoverer = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFFFFFFFF);
    screenCoverer.scrollFactor.set(0, 0);
    screenCoverer.zoomFactor = 0;

    screenCoverer.colorTransform.color = 0xFF000000;
    screenCoverer.colorTransform.alphaMultiplier = 0;
}

var alphaTween:FlxTween = null;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Screen Coverer") {
        remove(screenCoverer);
        insert(params[7] == 'front' ? members.length-1 : 0, screenCoverer);  // Sometimes add() plays bad jokes as not always places the object as last (and no, remove(obj, true) doesnt work either)  - Nex
        screenCoverer.cameras = [params[6] == "camGame" ? camGame : camHUD];  // Avoiding Reflect with also hasField cuz its kinda slow  - Nex

        screenCoverer.colorTransform.color = params[1];
        if (params[0] == false)
            screenCoverer.colorTransform.alphaMultiplier = params[2];
        else {
            if (alphaTween != null) alphaTween.cancel();

            var flxease:String = params[4] + (params[4] == "linear" ? "" : params[5]);
            alphaTween = FlxTween.tween(screenCoverer.colorTransform, {alphaMultiplier: params[2]}, ((Conductor.crochet / 4) / 1000) * params[3], {ease: Reflect.field(FlxEase, flxease)});
        }
    }
}