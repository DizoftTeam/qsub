import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:qsub/src/types.dart';

///
/// Виджет для подписки на события по SSE
///
class QSub extends StatefulWidget {
  /// Uri to SSE
  final Uri url;

  /// Builder events
  final QSubWidgetBuilder builder;

  final QSubErrorWidgetBuilder? errorBuilder;

  final WidgetBuilder? progressBuilder;

  const QSub({
    Key? key,
    required this.url,
    required this.builder,
    this.errorBuilder,
    this.progressBuilder,
  }) : super(key: key);

  @override
  State<QSub> createState() => _QSubState();
}

///
/// State of widget
///
class _QSubState extends State<QSub> {
  late final Future<EventSource> _future = EventSource.connect(widget.url);

  EventSource? _eventSource;

  final List<QSubEvent> _events = <QSubEvent>[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventSource>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<EventSource> snapshot) {
        if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!.call(context, QSubError.CONNECTION);
          }

          return const Text('Cant connect to SSE server');
        }

        if (snapshot.hasData) {
          if (_eventSource != null) {
            _eventSource = snapshot.data;
          }

          return _buildSSE(context);
        }

        return widget.progressBuilder != null
            ? widget.progressBuilder!.call(context)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  ///
  /// Построение стрим слушателя событий
  ///
  Widget _buildSSE(BuildContext context) {
    return StreamBuilder<Event>(
      stream: _eventSource!,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!.call(context, QSubError.LISTEN);
          }

          return const Text('Cant get data from SSE server');
        }

        if (snapshot.hasData) {
          final Event event = snapshot.data!;

          _events.add(QSubEvent(
            id: event.id,
            event: event.event,
            data: event.data,
          ));
        }

        return widget.builder(context, _events);
      },
    );
  }
}
