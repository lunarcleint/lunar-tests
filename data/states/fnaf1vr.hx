import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.primitives.CubeGeometry;
import away3d.materials.ColorMaterial;
import away3d.cameras.lenses.PerspectiveLens;
import away3d.loaders.parsers.AWDParser;
import away3d.loaders.Loader3D;
import funkin.backend.utils.MemoryUtil;
import flx3d.FlxView3D;
import away3d.controllers.FirstPersonController;
import away3d.debug.AwayStats;
import away3d.materials.lightpickers.StaticLightPicker;

import Reflect;

// 3D internal
var view:View3D = null;
var loader:Loader3D = null;
var _loadedAssets:Array<Dynamic> = [];

var stats:AwayStats = null;

// 3D Camera
var _cameraController:FirstPersonController = null;

var _lastPanAngle:Float = 0.0;
var _lastTiltAngle:Float = 0.0;
var _lastMousePos:FlxPoint = FlxPoint.get(FlxG.stage.mouseX, FlxG.stage.mouseY);

// 3D Lighting 
var _lights:Array<Dynamic> = [];
var lightPicker:StaticLightPicker = null;

function create() {
    if (FlxG.sound.music != null) FlxG.sound.music.stop();

    // 3D
    view = new View3D();
    view.width = FlxG.width; view.height = FlxG.height;
    view.backgroundAlpha = 0; view.antiAlias = 4;
    view.visible = true;
    FlxG.stage.addChild(view);

    stats = new AwayStats(view);
    FlxG.stage.addChild(stats);
    
    FlxG.camera.bgColor = FlxColor.TRANSPERENT;

    loader = new Loader3D();
    loader.addEventListener("assetComplete", assetComplete);
    loader.addEventListener("resourceComplete", resourceComplete);

    loader.loadData(Assets.getBytes(Paths.awd("fnaf map part0 (walls)")), null, null, new AWDParser());
    loader.loadData(Assets.getBytes(Paths.awd("fnaf map part1 (office)")), null, null, new AWDParser());
    loader.loadData(Assets.getBytes(Paths.awd("fnaf map part2 (party room)")), null, null, new AWDParser());

    // 3D cam
    FlxG.mouse.useSystemCursor = FlxG.mouse.visible = true;
    _cameraController = new FirstPersonController(view.camera, 0, 0, -90, 90);
}

function assetComplete(away3DEvent) {
    _loadedAssets.push(away3DEvent.asset);
    switch (Std.string(away3DEvent.asset.assetType).toLowerCase()) {
        case "material": away3DEvent.asset.mipmap = away3DEvent.asset.smooth = true;
        case "camera": view.camera = _cameraController.targetObject = away3DEvent.asset;
        case "mesh":
            var mesh:Mesh = away3DEvent.asset;
            
            mesh.scaleY = mesh.scaleX = mesh.scaleZ = 0.2;
            FlxTween.tween(mesh, {scaleX: 1, scaleY: 1, scaleZ: 1}, 0.2, {ease: FlxEase.bounceOut});
            FlxG.sound.play(Paths.sound("pop"));

            view.scene.addChild(mesh);
        case "light": _lights.push(away3DEvent.asset);
    }
}

var filesCounter:Int = 0;
var filesToLoad:Int = 3;

function resourceComplete(away3DEvent) {
    filesCounter++;
    if (filesCounter >= filesToLoad) {
        /*
        lightPicker = new StaticLightPicker(_lights);

        for (asset in _loadedAssets) {
            switch (Std.string(asset.assetType).toLowerCase()) {
                case "material": asset.lightPicker = lightPicker;
            }
        }
        */
    }
}

function draw(drawEvent) view.render();

function onDestroy() {
    // 3D
    FlxView3D.dispose(loader);

    for (asset in _loadedAssets) {
        FlxView3D.dispose(asset);
        switch (Std.string(asset.assetType).toLowerCase()) {
            case "texture": asset?._bitmapData?.dispose(); // dispose bitmaps
        }
    }

    FlxG.stage.removeChild(stats);

    FlxG.stage.removeChild(view);
    view.dispose();

    MemoryUtil.clearMajor();
    FlxG.camera.bgColor = FlxColor.BLACK;
}

function update(elapsed:Float) {
    if (FlxG.mouse.justPressed) {
        _lastPanAngle = _cameraController.panAngle;
        _lastTiltAngle = _cameraController.tiltAngle;
        _lastMousePos.put();
        _lastMousePos = FlxPoint.get(FlxG.stage.mouseX, FlxG.stage.mouseY);
    }

    if (FlxG.mouse.pressed)
    {
        _cameraController.panAngle = 0.3 * (FlxG.stage.mouseX - _lastMousePos.x) + _lastPanAngle;
        _cameraController.tiltAngle = 0.3 * (FlxG.stage.mouseY - _lastMousePos.y) + _lastTiltAngle;
    }

    if (controls.BACK) {
        FlxG.switchState(new FreeplayState());
    }
}