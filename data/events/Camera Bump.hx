function onEvent(eventEvent)
    if (eventEvent.event.name == "Camera Bump")
        (Reflect.getProperty(PlayState.instance, eventEvent.event.params[1])).zoom += eventEvent.event.params[0];