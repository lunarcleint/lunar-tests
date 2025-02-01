function onEvent(eventEvent)
    if (eventEvent.event.name == "Camera Bump Modulo") {
        camZoomingInterval = eventEvent.event.params[0];
        camZoomingStrength = eventEvent.event.params[1];
    }