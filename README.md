# qsub

Simple Flutter provided subscription to SSE (Server-Send Events) protocol, such as mercure

## Simple Example

```dart
import 'package:flutter/material.dart';
import 'package:qsub/qsub.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                const Text('Start?'),
                QSub(
                  url: Uri.http(
                    'mercure.pluto.dizoft.ru:8686',
                    '/.well-known/mercure',
                    <String, String>{
                      'topic':
                          'http://api.pluto.dizoft.ru/subscriptions/369fcd649fdb02ca42e88786a8c52f2156e1063bf1e30a2cc18451632c062ad8',
                    },
                  ),
                  builder: (BuildContext context, List<QSubEvent> events) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (BuildContext context, int index) {
                          final QSubEvent event = events.elementAt(index);

                          return ListTile(
                            title: Text(
                              event.data ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```