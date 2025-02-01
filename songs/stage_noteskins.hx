//
var noteSkin:String = "default";
var splashSkin:String = null;

function create() {
	if (stage != null && stage.stageXML != null) {
		if (stage.stageXML.exists("noteSkin")) noteSkin = stage.stageXML.get("noteSkin");
		if (stage.stageXML.exists("splashSkin")) splashSkin = stage.stageXML.get("splashSkin");
	}
}

var __usePixel:Bool = false;
function onStrumCreation(event) {
	event.sprite = "game/notes/" + noteSkin;
	if (Assets.exists(Paths.image(event.sprite + "_END"))) {
		__usePixel = true; event.cancel();
		var strum = event.strum;
		strum.loadGraphic(Paths.image(event.sprite), true, 17, 17);
		strum.animation.add("static", [event.strumID]);
		strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
		strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);
	}
}

function onNoteCreation(e) {
	if (e.noteType != null && Assets.exists(Paths.image("game/notes/types/" + e.noteType)))
		e.noteSprite = "game/notes/types/" + e.noteType;
	else {
		e.noteSprite = "game/notes/" + noteSkin;
	}
}

function onPostNoteCreation(e) {
	if (splashSkin != null) e.note.splash = splashSkin;
}