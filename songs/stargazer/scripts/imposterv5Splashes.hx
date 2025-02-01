import funkin.system.FunkinSprite;

function postCreate() {
    // add a few more splashes to be recycled cause the opponent plays now
    var splashGroup = splashHandler.getSplashGroup("v5");
    var splashSprite = splashGroup.members[splashGroup.members.length-1];

    for (i in 0...10) {
        var spr = FunkinSprite.copyFrom(splashSprite);
        spr.animation.finishCallback = function(name) {
            spr.active = spr.visible = false;
        };
        splashGroup.add(spr);
    }
}

function onNoteCreation(event) {event.note.splash = "v5";}
function onDadHit(event) {event.showSplash = !event.note.isSustainNote;}