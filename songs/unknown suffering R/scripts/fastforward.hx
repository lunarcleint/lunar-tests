function update() {
    if (startingSong || !canPause || paused || health <= 0) return;
    updateSpeed(FlxG.keys.pressed.TWO);
}

function updateSpeed(fast:Bool) {
    FlxG.timeScale = inst.pitch = vocals.pitch = (player.cpu = fast) ? 10 : 1;
    FlxG.sound.muted = fast;
    health = !(canDie != fast) ? 2 : health;
}

function onGamePause() {updateSpeed(false);}
function onSongEnd() {updateSpeed(false);}
function destroy() {FlxG.timeScale = 1;FlxG.sound.muted = false;}
