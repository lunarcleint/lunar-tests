function postCreate() {camZoomingStrength = 0; player.cpu = false;}

function stepHit(curStep:Int) {
    switch(curStep) {
        case 128: camZoomingStrength = 1;
		case 240: camZoomingStrength = 0;
        case 256: camZoomingStrength = 1.25; camZoomingInterval = 1;
        case 384: camZoomingStrength = 0;
        case 388: camZoomingStrength = 1.35; FlxG.camera.flash();
        case 512: camZoomingStrength = 0;
        case 516: camZoomingStrength = 1.45; FlxG.camera.flash();
        case 640: camZoomingStrength = 0;
        case 646: camZoomingStrength = 1.5; FlxG.camera.flash();
        case 750: camZoomingStrength = 0;
        case 768: camZoomingInterval = camZoomingStrength = 1; stageZoom += 0.05;
        case 1024: camZoomingStrength = 1.75; stageZoom -= 0.1;
		case 1152: camZoomingStrength = 2; stageZoom -= 0.2;
		case 1264: camZoomingStrength = 0; stageZoom += 0.2;
		case 1280: camZoomingStrength = 1.5;
		case 1536: camZoomingStrength = 1; camZoomingInterval = 2; stageZoom += 0.05;
		case 1648: camZoomingStrength = 2; camZoomingInterval = 1;
		case 1664: camZoomingStrength = 0;
    }

    // Still do the normal bumps cause they cool
    if (camZoomingStrength > 0 && camZoomingInterval != 4) {
        if (camZooming && FlxG.camera.zoom < maxCamZoom && curStep % 16 == 0)
            {
                FlxG.camera.zoom += 0.015 * camZoomingStrength;
                camHUD.zoom += 0.03 * camZoomingStrength;
            }
    }
}