import 'package:flutter/material.dart';
import 'package:minesweeper/screens/start.dart';
import 'package:minesweeper/settings.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: globalSettings.palette.primary,
        ),
        primaryColor: globalSettings.palette.primary,
        scaffoldBackgroundColor: globalSettings.palette.background,
      ),
      home: StartScreen(),
    );
  }
}
