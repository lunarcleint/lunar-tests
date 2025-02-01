//
var eccoSettings:Map<Int, Dynamic> = [];
var eccoChars:Map<Int, Character> = [];

var defPosition:FlxPoint = FlxPoint.get(0,0); // chache point
function create() {
    for (i=>strumLine in strumLines.members) {
        eccoSettings.set(i, {
            ecco_scale: strumLine.characters[0].scale.x,
            ecco_color: 0xFFFFFFFF,
            ecco_alpha: 0,
            ecco_anchor: "middle-bottom"
        });
        eccoChars.set(i, strumLine.characters[0]);

        strumLine.characters[0].onDraw = (basic:FlxSprite) -> {
            var eccoCharConfig:Dynamic = eccoSettings.get(i);
            if (eccoCharConfig.ecco_alpha == 0) {
                basic.draw(); return;
            }

            defPosition.set(basic.x, basic.y);  var ogCharScale:Float = basic.scale.x;
            var ogCharColor:Float = basic.color; var ogCharAlpha:Float = basic.alpha;

            basic.scale.set(eccoCharConfig.ecco_scale, eccoCharConfig.ecco_scale);
            basic.color = eccoCharConfig.ecco_color;

            switch (eccoCharConfig.ecco_anchor) {
                case "middle-bottom":
                    basic.y -= ((basic.frameHeight*basic.scale.y) - basic.frameHeight)/2;

                    switch(basic.curCharacter) {
                        case "sans_perseverance": basic.y += 26*basic.scale.y; // yeah ill unhardcode this one day -lunar
                    }
                case "middle": // automatic (SO COOL HAXEFLIXER!!!)
            }
            basic.alpha = eccoCharConfig.ecco_alpha; basic.draw();

            basic.x = defPosition.x; basic.y = defPosition.y; basic.color = ogCharColor;
            basic.scale.set(ogCharScale, ogCharScale); basic.alpha = ogCharAlpha;
            basic.draw();
        }
    }
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Character Ecco") {
        var eccoCharConfig:Dynamic = eccoSettings.get(eventEvent.event.params[0]);
        eccoCharConfig.ecco_color = eventEvent.event.params[1];
        eccoCharConfig.ecco_anchor = eventEvent.event.params[5];

        FlxTween.num(eccoChars.get(eventEvent.event.params[0]).scale.x, eventEvent.event.params[4], (Conductor.stepCrochet / 1000) * eventEvent.event.params[2], {ease: FlxEase.circOut}, (val:Float) -> {eccoCharConfig.ecco_scale = val;});
        FlxTween.num(eventEvent.event.params[3], 0, ((Conductor.stepCrochet / 1000) * eventEvent.event.params[2]) * 0.4, {ease: FlxEase.quad, startDelay: ((Conductor.stepCrochet / 1000) * eventEvent.event.params[2]) * 0.2}, (val:Float) -> {eccoCharConfig.ecco_alpha = val;});
    }
}

function destroy() {defPosition?.put();}