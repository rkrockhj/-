import 'package:flutter/material.dart';
import 'dice_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '博饼游戏',
      home: Scaffold(
        body: DiceGame(),
      ),
    );
  }
}
