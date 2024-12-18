import 'package:flutter/material.dart';
import 'package:memory_game_provider/features/main_game/main_game_screen.dart';
import 'package:provider/provider.dart';

import 'features/main_game/main_game_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => MainGameProvider(),
        child: MainGameScreen(),
      ),
    );
  }
}
