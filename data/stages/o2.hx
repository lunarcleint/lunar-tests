static var stageZoom:Float = 0;
static var camAngleOffset:Float = 0;

// ! Cam Zooming
function stepHit() {
    defaultCamZoom = curCameraTarget == 0 ? 1.05 : 0.95;
    defaultCamZoom += stageZoom;
}

// ! Cam Rotation
function postUpdate(elapsed:Float) {
    camGame.angle = FlxMath.lerp(camGame.angle, (curCameraTarget == 0 ? limeCamAngle : bfCamAngle) + camAngleOffset, 0.0325);
}