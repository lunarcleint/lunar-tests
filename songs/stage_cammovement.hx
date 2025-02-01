//
import flixel.math.FlxBasePoint;
import flixel.addons.util.FlxSimplex;

static var camMoveOffset:Float = 40;
static var camAngleOffset:Float = .3;

static var camFollowChars:Bool = true;
static var camAngleChars:Bool = true;

var movement = new FlxBasePoint();
var angle:Float = 0;

function create() {camFollowChars = true; camAngleChars = true; camMoveOffset = 15; camAngleOffset = .3;}

function postCreate() {
    var cameraStart = strumLines.members[curCameraTarget].characters[0].getCameraPosition();
    cameraStart.y -= 100; FlxG.camera.focusOn(cameraStart);
}

var speedizer:Float = 0;
var xoffset:Float = 0;
var yoffset:Float = 0;
var angleoffset:Float = 0;
static function shake(traumatizerr:Float = 0.3, speedizerr:Float = 0.02) {
    t = traumatizerr;
    speedizer = speedizerr;
    xoffset = FlxG.random.float(-100, 100);
    yoffset = FlxG.random.float(-100, 100);
    angleoffset = FlxG.random.float(-100, 100);
}

var t:Float = 0;
var peakAngle:Float = 0;
function updateShake(elapsed:Float) {
    t = FlxMath.bound(t - (speedizer * elapsed), 0, 1);
    camGame.angle += 1.5 * (t * t) * FlxSimplex.simplex(t * 25.5, t * 25.5 + angleoffset);
    camGame.scroll.x += 50 * (t * t) * FlxSimplex.simplex(t * 100 + xoffset, 10);
    camGame.scroll.y += 50 * (t * t) * FlxSimplex.simplex(10, t * 100 + yoffset);

    if (peakAngle < Math.abs(camGame.angle))
        peakAngle = Math.abs(camGame.angle);
}

function onCameraMove(camMoveEvent) {
    if (camFollowChars) {
        if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null) {
            switch (camMoveEvent.strumLine.characters[0].animation.name) {
                case "singLEFT" + camMoveEvent.strumLine.animSuffix: movement.set(-camMoveOffset, 0); angle = -camAngleOffset;
                case "singDOWN" + camMoveEvent.strumLine.animSuffix: movement.set(0, camMoveOffset);
                case "singUP" + camMoveEvent.strumLine.animSuffix: movement.set(0, -camMoveOffset);
                case "singRIGHT" + camMoveEvent.strumLine.animSuffix: movement.set(camMoveOffset, 0); angle = camAngleOffset;
                default: movement.set(0,0); angle = 0;
            };
            camMoveEvent.position.x += movement.x;
			camMoveEvent.position.y += movement.y;
        }
    }
}

function update(elapsed:Float) {
    if (camAngleChars)
        camGame.angle = CoolUtil.fpsLerp(camGame.angle, angle, 1/10);
    updateShake(elapsed);
}


function destroy() {camFollowChars = true; camMoveOffset = 15; camAngleOffset = .3;}