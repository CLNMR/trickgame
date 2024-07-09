import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

/// A quick and dirty widget to test some stuff.
class TestWidget extends StatelessWidget {
  /// Creates a [TestWidget].
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Testing',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('TestApp'),
          ),
          body: Center(
            child: TestWithGameWidget(),
          ),
        ),
      );
}

/// A testing widget that contains a game. Manipulate as desired.
class TestWithGameWidget extends StatefulWidget {
  /// Creates a [TestWithGameWidget].
  TestWithGameWidget({super.key}) : game = Game();

  final Game game;
  @override
  TestWithGameWidgetState createState() => TestWithGameWidgetState();
}

class TestWithGameWidgetState extends State<TestWithGameWidget> {
  @override
  Widget build(BuildContext context) {
    return Text('test');
  }
}
