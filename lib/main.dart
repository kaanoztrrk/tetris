import 'package:flutter/material.dart';
import 'GameBoard.dart';

void main() {
  runApp(const Tetris());
}

class Tetris extends StatelessWidget {
  const Tetris({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      home: const GameBoard(),
    );
  }
}
