//

var static_shader:CustomShader;
var pixel_vig:CustomShader;

function create() {
    static_shader = new CustomShader("static");
	static_shader.time = 0; static_shader.strength = 1.4;
	static_shader.speed = 20;
	FlxG.game.addShader(static_shader);

    pixel_vig = new CustomShader("pixel_vig");
    pixel_vig.res = [FlxG.width, FlxG.height];
    pixel_vig.uBlocksize = [10, 10];
    pixel_vig.inner = 0.; pixel_vig.outer = 40;
    pixel_vig.strength = .9; pixel_vig.curvature = .1;
	// FlxG.camera.addShader(pixel_vig);

}

function update(elapsed:Float) {
    if (FlxG.random.bool(20))
        static_shader.time += elapsed;
}

function destroy() {
    FlxG.game.removeShader(static_shader);
}