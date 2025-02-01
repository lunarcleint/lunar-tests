//
public var curSpeed:Float = 1;
static var curBotplay:Bool = false;
static var devControlBotplay:Bool = true;

function update() {
    if (startingSong || !canPause || paused || health <= 0) return;
    
    if (FlxG.keys.justPressed.TWO) curSpeed -= 0.1;
    if (FlxG.keys.justPressed.THREE) curSpeed = 1;
    if (FlxG.keys.justPressed.FOUR) curSpeed += 0.1;
    curSpeed = FlxMath.bound(curSpeed, 0.1, 2);
    
    if (FlxG.keys.justPressed.SIX) curBotplay = !curBotplay;
    if (devControlBotplay) player.cpu = FlxG.keys.pressed.FIVE || curBotplay;
    updateSpeed(FlxG.keys.pressed.FIVE ? 20 : curSpeed);
}

function updateSpeed(speed:Float)
    FlxG.timeScale = inst.pitch = vocals.pitch = speed;

function onGamePause() {updateSpeed(1);}
function onSongEnd() {updateSpeed(1);}
function destroy() {FlxG.timeScale = 1;FlxG.sound.muted = false;}