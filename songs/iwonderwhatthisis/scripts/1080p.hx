
__resizeGame(1920, 1080);
function destroy() __resizeGame(1280, 720);

function postCreate() {
    // Properly account for strumline postitions!!!
    for (i => strumLine in strumLines.members) {
        var chartStrumLine = PlayState.SONG.strumLines[i];

        var strOffset:Float = chartStrumLine.strumLinePos == null ? (chartStrumLine.type == 1 ? 0.75 : 0.25) : chartStrumLine.strumLinePos;
        var startingPos:FlxPoint = chartStrumLine.strumPos == null ?
            FlxPoint.get((FlxG.width * strOffset) - ((Note.swagWidth * (chartStrumLine.strumScale == null ? 1 : chartStrumLine.strumScale)) * 2), this.strumLine.y) :
            FlxPoint.get(chartStrumLine.strumPos[0] == 0 ? ((FlxG.width * strOffset) - ((Note.swagWidth * (chartStrumLine.strumScale == null ? 1 : chartStrumLine.strumScale)) * 2)) : chartStrumLine.strumPos[0], chartStrumLine.strumPos[1]);

        for (i=>strum in strumLine.members) 
            strum.x = startingPos.x + ((Note.swagWidth * chartStrumLine.strumScale) * i);
    }

    // Scale Up Health Bar
    doIconBop = false;

    for (healthItem in [healthBarBG, healthBar, iconP1, iconP2]) {
        healthItem.scale.set(1.4, 1.4);
        healthItem.y -= 40;
        if (Std.isOfType(healthItem, HealthIcon)) {
            healthItem.scale.set(1.35, 1.35);
            healthItem.y -= 20;
        }
    }

    // Scale Up Ratings

    for(text in [scoreTxt, missesTxt, accuracyTxt]) {
        text.size += 3; text.borderSize = 1.5; text.y -= 15;
    }

    accuracyTxt.x -= 60;
}

function update(elapsed:Float) {
    iconP1.scale.set(lerp(iconP1.scale.x, 1.35, 0.33), lerp(iconP1.scale.y, 1.35, 0.33));
    iconP2.scale.set(lerp(iconP2.scale.x, 1.35, 0.33), lerp(iconP2.scale.y, 1.35, 0.33));

    iconP1.updateHitbox();
    iconP2.updateHitbox();
}

function beatHit() {
    iconP1.scale.set(1.35 + .2, 1.35 + .2);
    iconP2.scale.set(1.35 + .2, 1.35 + .2);

    iconP1.updateHitbox();
    iconP2.updateHitbox();
}