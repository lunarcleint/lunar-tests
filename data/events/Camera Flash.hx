import Reflect;

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Camera Flash") {
        var camera:FlxCamera = (Reflect.getProperty(PlayState.instance, eventEvent.event.params[3]));
        //camera._fxFlashColor = eventEvent.event.params[1];
        if (eventEvent.event.params[0]) {
            camera.fade(eventEvent.event.params[1], 
                ((Conductor.crochet / 4) / 1000) * eventEvent.event.params[2],
                false, () -> {camera._fxFadeAlpha = 0;}, true
            );
        } else {
            camera.flash(
                eventEvent.event.params[1],
                ((Conductor.crochet / 4) / 1000) * eventEvent.event.params[2],
            null, true);
        }
    }
}