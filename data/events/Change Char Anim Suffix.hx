//
function onEvent(eventEvent) {
    if (eventEvent.event.name == "Change Char Anim Suffix") {
        strumLines.members[eventEvent.event.params[0]].animSuffix = eventEvent.event.params[1];
        for (char in strumLines.members[eventEvent.event.params[0]].characters) {
            char.idleSuffix = eventEvent.event.params[1]; char.dance();
        }
    }
}