import 'package:flutter/material.dart';

enum QSubError {
  CONNECTION,

  LISTEN,
}

class QSubEvent {
  String? id;

  /// The name of the event. Return empty string if not required.
  String? event;

  /// The payload of the event.
  String? data;

  QSubEvent({
    this.id,
    this.event,
    this.data,
  });
}

typedef QSubWidgetBuilder = Widget Function(
  BuildContext context,
  List<QSubEvent> data,
);

typedef QSubErrorWidgetBuilder = Widget Function(
  BuildContext context,
  QSubError error,
);
