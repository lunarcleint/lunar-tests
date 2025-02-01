var preloadedCharacters:Map<String, Character> = [];

function postCreate() {
    for (event in PlayState.SONG.events)
        if (event.name == "Change Character" && !preloadedCharacters.exists(event.params[1])) {
            // Look for character that alreadly exists
            var foundPreExisting:Bool = false;
            for (strum in strumLines)
                for (char in strum.characters)
                    if (char.curCharacter == event.params[1]) {
                        preloadedCharacters.set(event.params[1], char);
                        graphicCache.cache(Paths.image("icons/" + char.getIcon()));
                        foundPreExisting = true; break;
                    }
            if (foundPreExisting) continue;

            // Create New Character
            var oldCharacter = strumLines.members[event.params[0]].characters[0];
            var newCharacter = new Character(oldCharacter.x, oldCharacter.y, event.params[1], oldCharacter.isPlayer);
            newCharacter.active = newCharacter.visible = false;
            newCharacter.drawComplex(FlxG.camera); // Push to GPU
            preloadedCharacters.set(event.params[1], newCharacter);
            graphicCache.cache(Paths.image("icons/" + newCharacter.getIcon()));

            //Adjust Camera Offset to Accomedate Stage Offsets
            if(newCharacter.isGF) {
                newCharacter.cameraOffset.x += stage.characterPoses["gf"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["gf"].camyoffset;
            } else if(newCharacter.playerOffsets){
                newCharacter.cameraOffset.x += stage.characterPoses["boyfriend"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["boyfriend"].camyoffset;
            } else {
                newCharacter.cameraOffset.x += stage.characterPoses["dad"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["dad"].camyoffset;
            }
        }
}

function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Change Character") {
        // Change Character
        var oldCharacter = strumLines.members[params[0]].characters[0];
        var newCharacter = preloadedCharacters.get(params[1]);
        if (oldCharacter.curCharacter == newCharacter.curCharacter) return;

        insert(members.indexOf(oldCharacter), newCharacter);
        newCharacter.active = newCharacter.visible = true;
        remove(oldCharacter);

        newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
        newCharacter.playAnim(oldCharacter.animation.name);
        newCharacter.animation?.curAnim?.curFrame = oldCharacter.animation?.curAnim?.curFrame;
        strumLines.members[params[0]].characters[0] = newCharacter;

        // Change Icon
        var oldIcon = oldCharacter.isPlayer ? dustiniconP1 : dustiniconP2;
        oldIcon.loadGraphicFromSprite(createHealthIcon(newCharacter.getIcon(), oldCharacter.isPlayer));
        if(Options.colorHealthBar && healthBarColors != null && newCharacter.iconColor != null) {
            var i:Int = oldCharacter.isPlayer ? 1 : 0;
            ogHealthColors[i] = healthBarColors[i] = newCharacter.iconColor;
        }
    }
}