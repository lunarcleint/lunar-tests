function update(elapsed) {
    if (controls.ACCEPT && grpSongs.members[curSelected].text == "fnaf one vr") 
        FlxG.switchState(new ModState("fnaf1vr"));
}

