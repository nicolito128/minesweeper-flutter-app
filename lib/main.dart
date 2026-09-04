import 'package:flutter/material.dart';
import 'package:minesweeper/screens/start.dart';
import 'package:minesweeper/settings.dart';
import 'package:minesweeper/utils/audio_manager.dart';
import 'package:minesweeper/utils/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPreferences.init();
  await AudioManager.init();

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
      builder: (context, child) {
        return Listener(
          onPointerDown: (_) {
            AudioManager.playClick();
          },
          child: child,
        );
      },
      home: StartScreen(),
    );
  }
}
