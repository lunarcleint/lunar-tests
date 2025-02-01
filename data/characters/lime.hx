import funkin.game.PlayState;

static var limeCamOffset = {x: 0, y:0};
static var limeCamAngle:Float = 0;

function onAnimationEnd(name:String) {limeCamOffset = {x: 0, y:0} limeCamAngle = 0;}
function onDance(event) {limeCamOffset = {x: 0, y:0} limeCamAngle = 0;}

var moveAmount:Float = 15;
var angleAmount:Float = .75;

function onPlaySingAnim(event) {
    switch (event.direction) {
        case 0: limeCamOffset = {x: -moveAmount, y: 0}; limeCamAngle = angleAmount; // ! LEFT
        case 1: limeCamOffset = {x: 0, y: moveAmount}; limeCamAngle = 0; // ! DOWN
        case 2: limeCamOffset = {x: 0, y:-moveAmount}; limeCamAngle = 0; // ! UP
        case 3: limeCamOffset = {x: moveAmount, y: 0}; limeCamAngle = -angleAmount; // !RIGHT
    }

	PlayState.instance.dad.animation.finishCallback = onAnimationEnd;
}

function onGetCamPos(event) {event.x += limeCamOffset.x; event.y += limeCamOffset.y;}