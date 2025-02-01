//
var characterTweens:Map<Int, Array<FlxTween>> = [];

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Change Character Offset") {
        var params:Array = eventEvent.event.params;
        var flxease:String = params[5] + (params[5] == "linear" ? "" : params[6]);

        var character:Character = strumLines.members[params[1]].characters[0];
        if (params[0]) {
            if (characterTweens[params[1]] != null)
                for (tween in characterTweens[params[1]])
                    if (tween != null) tween.cancel();

            characterTweens[params[1]] = [
                FlxTween.num(character.cameraOffset.x, character.cameraOffset.x + params[2], ((Conductor.crochet / 4) / 1000) * params[4], 
                    {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {character.cameraOffset.x = val;}),
                FlxTween.num(character.cameraOffset.y, character.cameraOffset.y + params[3], ((Conductor.crochet / 4) / 1000) * params[4], 
                {ease: Reflect.field(FlxEase, flxease)}, (val:Float) -> {character.cameraOffset.y = val;})
            ];
        } else {
            character.cameraOffset.x += params[2]; character.cameraOffset.y += params[3];
        }
    }
}