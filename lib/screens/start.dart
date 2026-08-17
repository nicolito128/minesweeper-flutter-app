import 'package:flutter/material.dart';

import 'package:minesweeper/screens/minesweeper.dart';
import 'package:minesweeper/screens/settings.dart';
import 'package:minesweeper/settings.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    final palette = globalSettings.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '(/•-•)/  ✷ MINESWEEPER',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: palette.secondary,
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton.icon(
              icon: Icon(Icons.play_arrow, color: palette.background),
              label: Text(
                'New Game',
                style: TextStyle(fontSize: 20, color: palette.background),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 55),
                backgroundColor: palette.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                // Trigger the dialog instead of navigating immediately
                _showDifficultyDialog(context);
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: Icon(
                Icons.settings_cell_rounded,
                color: palette.background,
              ),
              label: Text(
                'Settings',
                style: TextStyle(fontSize: 20, color: palette.background),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 55),
                backgroundColor: palette.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
                setState(() {});
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _startGame(BuildContext context, int width, int height, int mines) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MinesweeperScreen(
          gameWidth: width,
          gameHeight: height,
          gameMines: mines,
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    final palette = globalSettings.palette;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: palette.background,
          title: Text(
            'Select Difficulty',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: palette.secondary,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              onPressed: () => _startGame(context, 9, 9, 10),
              child: Text(
                'α Easy (9x9, 10 mines)',
                style: TextStyle(fontSize: 18, color: palette.secondary),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              onPressed: () => _startGame(context, 16, 16, 40),
              child: Text(
                'β Medium (16x16, 40 mines)',
                style: TextStyle(fontSize: 18, color: palette.secondary),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              onPressed: () => _startGame(context, 16, 30, 99),
              child: Text(
                'γ Hard (16x30, 99 mines)',
                style: TextStyle(fontSize: 18, color: palette.secondary),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              onPressed: () => _startGame(context, 16, 40, 180),
              child: Text(
                'ẟ Very hard (16x40, 180 mines)',
                style: TextStyle(fontSize: 18, color: palette.secondary),
              ),
            ),
          ],
        );
      },
    );
  }
}
