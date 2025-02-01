var scrollTween:FlxTween = null;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Change Scroll Speed") {
        if (params[0] == false)
            PlayState.instance.scrollSpeed = params[1];
        else {
            if (scrollTween != null) scrollTween.cancel();

            var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);
            scrollTween = FlxTween.tween(PlayState.instance, {scrollSpeed: params[1]}, ((Conductor.crochet / 4) / 1000) * params[2], {ease: Reflect.field(FlxEase, flxease)});
        }
    }
}