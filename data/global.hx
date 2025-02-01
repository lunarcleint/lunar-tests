trace("-GLOBAL RELOADED!!-" + Math.random());

static function __resizeGame(width:Float, height:Float) {
    Main.scaleMode.width = width;
    Main.scaleMode.height = height;
    
    for (camera in FlxG.cameras.list) {
        camera.width = width;
        camera.height = height;
    }

    FlxG.width = width; FlxG.height = height;
    trace(width, height);
}