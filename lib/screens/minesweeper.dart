import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/settings.dart';
import 'package:minesweeper/domain/cell.dart';
import 'package:minesweeper/domain/game.dart';
import 'package:minesweeper/utils/colors.dart';
import 'package:minesweeper/widgets/cell.dart';

enum TargetAction { revealCell, putFlag }

class MinesweeperScreen extends StatefulWidget {
  final int gameWidth;
  final int gameHeight;
  final int gameMines;

  const MinesweeperScreen({
    super.key,
    required this.gameWidth,
    required this.gameHeight,
    required this.gameMines,
  });

  @override
  State<MinesweeperScreen> createState() => _MinesweeperScreenState();
}

class _MinesweeperScreenState extends State<MinesweeperScreen> {
  TargetAction action = TargetAction.revealCell;
  late Game game;

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _timerStarted = false;
  bool _isPaused = false;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timerStarted) return;
    _timerStarted = true;
    _startTimerPeriod();
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timerStarted = false;
  }

  String get _formattedTime {
    final hours = (_elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_elapsedSeconds ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final palette = globalSettings.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        title: Text('Minesweeper', style: TextStyle(color: palette.secondary)),
        elevation: 0,
        iconTheme: IconThemeData(color: palette.secondary),
        leadingWidth: 112,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BackButton(),
            IconButton(
              tooltip: _isPaused ? 'Resume game' : 'Pause game',
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: _togglePause,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(palette),

            Expanded(
              child: Stack(
                children: [
                  InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    child: Center(child: buildBoard()),
                  ),
                  if (_isPaused) _buildPauseOverlay(palette),
                ],
              ),
            ),

            _buildActionSelector(palette),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Palette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: palette.secondary, size: 20),
              const SizedBox(width: 4),
              Text(
                _formattedTime,
                style: TextStyle(
                  color: palette.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.brightness_7, color: palette.secondary, size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.gameMines}',
                style: TextStyle(
                  color: palette.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.flag, color: palette.secondary, size: 20),
              const SizedBox(width: 4),
              Text(
                '${game.state.totalFlags}',
                style: TextStyle(
                  color: palette.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(Palette palette) {
    return Positioned.fill(
      child: ColoredBox(
        color: palette.background.withValues(alpha: 0.95),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pause_circle_outline,
                color: palette.secondary,
                size: 56,
              ),
              const SizedBox(height: 12),
              Text(
                'Game paused',
                style: TextStyle(
                  color: palette.secondary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _togglePause,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.secondary,
                  foregroundColor: palette.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionSelector(Palette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(color: palette.background),
      child: SegmentedButton<TargetAction>(
        segments: const [
          ButtonSegment<TargetAction>(
            value: TargetAction.revealCell,
            label: Text('Reveal'),
            icon: Icon(Icons.touch_app),
          ),
          ButtonSegment<TargetAction>(
            value: TargetAction.putFlag,
            label: Text('Flag'),
            icon: Icon(Icons.flag),
          ),
        ],
        selected: {action},
        onSelectionChanged: (Set<TargetAction> newSelection) {
          setState(() {
            action = newSelection.first;
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return palette.secondary;
            }
            return palette.background;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return palette.primary;
            }
            return palette.secondary;
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: palette.secondary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget buildBoard() {
    final palette = globalSettings.palette;
    final cells = game.cells();

    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(border: Border.all(color: palette.secondary)),
      child: AspectRatio(
        aspectRatio: widget.gameWidth / widget.gameHeight,
        child: GridView.builder(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.gameWidth,
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            final Cell cell = cells[index];
            return CellWidget(
              game: game,
              cell: cell,
              onTap: () {
                if (action == TargetAction.revealCell) {
                  revealCell(cell);
                } else {
                  flagCell(cell);
                }
              },
              onLongPress: () {
                if (action == TargetAction.revealCell) {
                  flagCell(cell);
                } else {
                  revealCell(cell);
                }
              },
            );
          },
        ),
      ),
    );
  }

  void startNewGame() {
    _resetTimer();
    setState(() {
      _isPaused = false;
      game = Game(widget.gameWidth, widget.gameHeight, widget.gameMines);
    });
  }

  void _togglePause() {
    if (game.status() != GameResult.playing) return;

    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _timer?.cancel();
    } else if (_timerStarted) {
      _startTimerPeriod();
    }
  }

  void _startTimerPeriod() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isPaused) return;
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void revealCell(Cell cell) {
    if (_isPaused || game.status() != GameResult.playing) return;

    _startTimer();

    setState(() {
      game.reveal(cell.x, cell.y);
    });
    checkGameEnd();
  }

  void flagCell(Cell cell) {
    if (_isPaused || game.status() != GameResult.playing) return;

    _startTimer();

    setState(() {
      game.toggleFlag(cell.x, cell.y);
    });
  }

  void checkGameEnd() {
    final status = game.status();
    if (status == GameResult.playerWon) {
      _stopTimer();
      _restartGameDialog('¡You won! 🎖');
    } else if (status == GameResult.playerLost) {
      _stopTimer();
      _restartGameDialog('¡Boom! You lost ˗ˏˋ ✸ ˎˊ˗');
    }
  }

  void _restartGameDialog(String title) {
    final palette = globalSettings.palette;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(title, style: TextStyle(color: palette.secondary)),
          backgroundColor: palette.background,
          content: Text(
            'Time: $_formattedTime',
            style: TextStyle(color: palette.secondary, fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.secondary,
              ),
              onPressed: () {
                Navigator.pop(context);
                startNewGame();
              },
              child: Text(
                'Try again',
                style: TextStyle(color: palette.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.secondary,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Go to home',
                style: TextStyle(color: palette.primary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Stay', style: TextStyle(color: palette.secondary)),
            ),
          ],
        ),
      ),
    );
  }
}
