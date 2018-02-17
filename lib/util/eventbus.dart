class EventBus {
  final Map<String, List<Function>> _event = new Map<String, List<Function>>();

  int get length => _event.keys.length;

  listen(String event, Function target) {
    List<Function> listeners;
    if (_event.containsKey(event)) {
      listeners = _event[event];
    } else {
      listeners = new List<Function>();
      _event[event] = listeners;
    }
    listeners.add(target);
  }

  leave(String event) {
    if (_event.containsKey(event)) {
      _event.remove(event);
    }
  }

  fire(String event, [Function dataProvider]) {
    if (_event.containsKey(event)) {
      List<Function> listeners = _event[event];

      listeners.forEach((Function target) {
        dataProvider == null ? target() : target(dataProvider); // ignore: invocation_of_non_function
      });
    }
  }
}

EventBus bus = new EventBus();
