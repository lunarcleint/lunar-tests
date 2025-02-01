import flixel.FlxG;
import flixel.tweens.FlxTween;
import funkin.game.Strum;
import funkin.game.StrumLine;
import funkin.system.Conductor;

// Just to keep the file and the code a bit cleaner / Boiler Plate
var effects:Array<String> = [
	"NONE",
	"DREAMY_BOUNCE",
	"DREAMY_WITH_BUMP_AND_CIRC",
	"BOUNCING"
];

var curEffect:String = "NONE";

function init() {strumLine.y += 12.5; trace("Reloaded!");}

// Dreamy Effect
var __defaultNotePostions:Map<StrumLine, Array<{x:Float, y:Float}>> = [playerStrums => []];

var __moveAmount:{x:Float, y:Float} = {x: 4, y: 16};
var __noteAngleAmount:Float = 8;

var __doDreamyCircle:Bool = true;

function initDreamy() {
	for (strumLine in [playerStrums, cpuStrums]) {
		var positions:Array<{x:Float, y:Float}> = [];
		for (strum in strumLine.members) positions.push({x: strum.x, y: strum.y});
		__defaultNotePostions.set(strumLine, positions);
	}
}

function dreamyUpdate(elapsed:Float) {
	if (__moveAmount.x == 0 && __moveAmount.y == 0) return;

	var __curBeat = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));

	for (strumLine in [playerStrums, cpuStrums]) {
		var oppositeMovement:Int = strumLine == cpuStrums ? -1 : 1;
		
		for (strum in strumLine.members) {
			var startPos = curEffect == "DREAMY_WITH_BUMP_AND_CIRC" ? strum : __defaultNotePostions[strumLine][strum.ID];
			strum.setPosition(
				startPos.x + ((-__moveAmount.x * oppositeMovement) * Math.sin((__curBeat + (strum.ID) * 0.25) * Math.PI)) + ((__doDreamyCircle ? 1 : 0) * (__moveAmount.x * 10 * oppositeMovement) * Math.sin((__curBeat * 0.25) * Math.PI)),
				startPos.y + ((-__moveAmount.y * oppositeMovement) * Math.cos((__curBeat + (strum.ID/1.25) * 0.25) * Math.PI)) + ((__doDreamyCircle ? 1 : 0) * (-__moveAmount.y * 2 * oppositeMovement) * Math.cos((__curBeat * 0.25) * Math.PI))
			);

			strum.angle = strum.noteAngle = ((__noteAngleAmount * oppositeMovement) * Math.sin(__curBeat));
		}
	}

	camHUD.angle = Math.sin(__curBeat * 2) * 3;
	camAngleOffset = camHUD.angle/2;
}

// Circling Effect
var __strumLineOffsets:Map<StrumLine, {x:Float, y:Float}> = [playerStrums => {x: 0, y:0}];

function initCircling() {
	for (strumLine in [playerStrums, cpuStrums])
		__strumLineOffsets.set(strumLine, {x: 0, y: 0});
}

function updateCircling(elapsed:Float) {
	var __curBeat = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));

	for (strumLine in [playerStrums, cpuStrums]) { 
		var oppositeMovement:Int = strumLine == cpuStrums ? -1 : 1;

		__strumLineOffsets[strumLine] = {
			x: FlxG.width/2 + ((-FlxG.width/4 * oppositeMovement) * ((Math.cos(__curBeat)))),
			y: FlxG.height/2 + ((-FlxG.height/2.5 * oppositeMovement) * ((Math.sin(__curBeat * 2)/2))),
		};

		__strumLineOffsets[strumLine].y -= 60;
	}

	for (strumLine in [playerStrums, cpuStrums]) {
		if (__strumLineOffsets[strumLine].x == 0 && __strumLineOffsets[strumLine].y == 0) continue;

		for (strum in 0...strumLine.members.length) {
			strumLine.members[strum].setPosition(__strumLineOffsets[strumLine].x + (112 * (strum - 2)),__strumLineOffsets[strumLine].y - (112/2));
		}
	}
}

// Bump effect
var __notePostionsOffsets:Map<StrumLine, Array<{x:Float, y:Float}>> = [playerStrums => []];

var __bumpDirections = ["LEFT", "RIGHT", "DOWN", "UP"];
var presetSectionPatterns:Array<Array<Array<String>>> = [
	[ // The crowd pleaser
		["LEFT", null, null, "RIGHT"],
		[null, "DOWN", "DOWN", null],
		["DOWN", "DOWN", null, null],
		[null, null, "UP", "UP"]
	],
	[ // The safe route
		["LEFT", null, null, "RIGHT"],
		[null, "DOWN", "DOWN", null],
		["LEFT", null, null, "RIGHT"],
		[null, "UP", "UP", null],
	],
	[ // The stair case
		["LEFT", "LEFT", null, null],
		[null, "DOWN", "DOWN", null],
		[null, null, "RIGHT", "RIGHT"],
		[null, "UP", "UP", null],
	],
	[ // The man
		["LEFT", null, "DOWN", null],
		[null, "UP", "UP", null],
		[null, "DOWN", "DOWN", null],
		[null, "UP", null, "RIGHT"],
	]
];

var sectionBeatBumps:Map<Int, {bumps:Array<Array<String>>, timeMulti:Float}> = [-999 => {bumps:[], timeMulti: -1}];
var bumpAmount:Float = 80;

function bump(strumLine:StrumLine, noteID:Int, direction:String, timeMulti:Float) {
	if (!__bumpDirections.contains(direction)) return;

	FlxTween.cancelTweensOf(__notePostionsOffsets[strumLine][noteID]);
	__notePostionsOffsets[strumLine][noteID] = {x: 0, y: 0};
	
	switch (direction) {
		case "LEFT", "RIGHT":
			__notePostionsOffsets[strumLine][noteID].x = bumpAmount * (direction == "LEFT" ? -1 : 1);
		case "UP", "DOWN":
			__notePostionsOffsets[strumLine][noteID].y = bumpAmount * 1.25 * (direction == "UP" ? -1 : 1);
	}

	FlxTween.tween(__notePostionsOffsets[strumLine][noteID], {x: 0}, (Conductor.stepCrochet / 1000) * timeMulti);
	FlxTween.tween(__notePostionsOffsets[strumLine][noteID], {y: 0}, (Conductor.stepCrochet / 1000) * timeMulti);
}

function initBump() {
	for (strumLine in [playerStrums, cpuStrums]) {
		var positions:Array<{x:Float, y:Float}> = [];
		for (strum in strumLine.members) positions.push({x: 0, y: 0});
		__notePostionsOffsets.set(strumLine, positions);
	}

	for (section in 48...64) {
		sectionBeatBumps.set(section, {
			bumps: presetSectionPatterns[FlxG.random.int(0, presetSectionPatterns.length-1)],
			timeMulti: 2
		});
	}
}

function bumpBeatHit(curBeat:Int) {
	if (sectionBeatBumps[Conductor.curMeasure] != null) {
		for (strumLine in [playerStrums, cpuStrums]) {
			for (strumID in 0...4) {
				var direction:Null<String> = sectionBeatBumps[Conductor.curMeasure].bumps[curBeat % 4][strumID];

				if (direction != null) bump(strumLine, strumID, direction, sectionBeatBumps[Conductor.curMeasure].timeMulti);
			}
		}
	}
}

function bumpUpdate(elapsed:Float) {
	// apply offset
	switch (curEffect) {
		case "DREAMY_WITH_BUMP_AND_CIRC":
			for (strumLine in [playerStrums, cpuStrums]) {
				for (strum in 0...strumLine.members.length) {
					strumLine.members[strum].setPosition(strumLine.members[strum].x + __notePostionsOffsets[strumLine][strum].x,strumLine.members[strum].y + __notePostionsOffsets[strumLine][strum].y);
				}
			}
		default:
			for (strumLine in [playerStrums, cpuStrums]) {
				for (strum in 0...strumLine.members.length) {
					strumLine.members[strum].setPosition(__defaultNotePostions[strumLine][strum].x + __notePostionsOffsets[strumLine][strum].x,__defaultNotePostions[strumLine][strum].y + __notePostionsOffsets[strumLine][strum].y);
				}
			}
	}
}

// Init 

function create() {init();}
function postCreate() {initDreamy(); initBump(); initCircling();}

// Actual Song Code

function update(elapsed:Float) {
	switch (curEffect) {
		case "DREAMY": dreamyUpdate(elapsed);
		case "DREAMY_WITH_BUMP_AND_CIRC": 
			updateCircling(elapsed);
			dreamyUpdate(elapsed); 
			bumpUpdate(elapsed);
	}
}

function measureHit(measure:Int) {
	switch (measure) {
		case 48: //48
			curEffect = "DREAMY_WITH_BUMP_AND_CIRC";
			__moveAmount = {x: __moveAmount.x*2.5, y: __moveAmount.y/1.5};
			__noteAngleAmount /= 2;
			__doDreamyCircle = false;
		case 64:
			curEffect = "DREAMY";
			__moveAmount = {x: __moveAmount.x/2, y: __moveAmount.y*2};
			__doDreamyCircle = true;
		case 72:
			curEffect = "NONE";
	}
}

function beatHit(curBeat:Int) {
	bumpBeatHit(curBeat);
}

function stepHit(curStep:Int) {
	switch (curStep) {}
}