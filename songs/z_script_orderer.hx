//
import haxe.io.Path;
// ! DO NOT FUCK WITH THIS SCRIPT AS IT INSURES THE SCRIPTS CAN INTERACT WITH EACHOTHER PROPERLY -lunar
// ! Also its named z_ with the start so it can be rand last by the engine

var oldScripts:Array<Script> = PlayState.instance.scripts.scripts;
PlayState.instance.scripts.scripts = [];

var debug_Scripts:Array<Script> = [];
var event_Scripts:Array<Script> = [];
var util_Scripts:Array<Script> = [];
var ui_Scripts:Array<Script> = [];
var stage_Scripts:Array<Script> = [];
var modchart_Scripts:Array<Script> = [];
var note_Scripts:Array<Script> = [];
var song_Scripts:Array<Script> = [];
var other_Scripts:Array<Script> = [];

// ! SORTS SCRIPTS INTO DA ARRAYS ABOVE
for (script in oldScripts) {
    if (script.fileName == "z_script_orderer.hx") continue;

    function startsWith(str:String, start:String):Bool 
        return StringTools.startsWith(str, start);

    switch (Path.directory(script.path)) {
        case "assets/data/stages": stage_Scripts.push(script);
        case "assets/data/events": event_Scripts.push(script);
        case "assets/data/notes": note_Scripts.push(script);
        case "songs/" + PlayState.SONG.meta.name + "/scripts":
            if (startsWith(script.fileName, "modchart_")) modchart_Scripts.push(script);
            else song_Scripts.push(script);
        case "songs":
            if (startsWith(script.fileName, "debug_")) debug_Scripts.push(script);
            else if (startsWith(script.fileName, "util_")) util_Scripts.push(script);
            else if (startsWith(script.fileName, "ui_")) ui_Scripts.push(script);
            else if (startsWith(script.fileName, "stage_")) stage_Scripts.push(script);
            else other_Scripts.push(script);
        default: other_Scripts.push(script);
    }
}

var finalScripts:Array<Script> = [];
for (scripts in [debug_Scripts, event_Scripts, util_Scripts, ui_Scripts, stage_Scripts, modchart_Scripts, note_Scripts, song_Scripts, other_Scripts])
    for (script in scripts) finalScripts.push(script);
// for (script in finalScripts) trace(script.fileName);
PlayState.instance.scripts.scripts = finalScripts;

// destroy scripts
__script__.didLoad = __script__.active = false;