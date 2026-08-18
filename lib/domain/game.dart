import 'dart:math';

import 'package:minesweeper/domain/board.dart';
import 'package:minesweeper/domain/cell.dart';

enum GameResult { playing, playerLost, playerWon }

class Game {
  final int width;
  final int height;
  final int totalMines;
  late int seed;
  late GameState state;

  new(this.width, this.height, this.totalMines) {
    seed = _generateSeed();
    state = GameState(width, height, totalMines, seed);
  }

  new seeded(this.width, this.height, this.totalMines, this.seed) {
    state = GameState(width, height, totalMines, seed);
  }

  int _generateSeed() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  GameResult status() {
    return state.result;
  }

  GameResult reveal(int x, int y) {
    state.reveal(x, y);
    return state.result;
  }

  void toggleFlag(int x, int y) {
    state.toggleFlag(x, y);
  }

  List<Cell> cells() {
    return state.board.iter().toList(growable: false);
  }
}

class GameState {
  final int width;
  final int height;
  final int seed;
  final int totalMines;

  int totalFlags = 0;
  int totalRevealed = 0;

  bool started = false;

  GameResult result = GameResult.playing;

  late final Board board;
  late final Random rand;

  new(this.width, this.height, this.totalMines, this.seed) {
    board = Board(width, height);
    rand = Random(seed);
  }

  void reveal(int x, int y) {
    if (!started) {
      _startBoard(x, y);
    }

    var cell = board.getCell(x, y);
    if (cell.x == -1 || cell.y == -1) {
      throw Exception("Trying to reveal an invalid cell");
    }

    if (cell.isRevealed) return;
    if (cell.isFlagged) {
      toggleFlag(cell.x, cell.y);
    }

    cell.reveal();
    totalRevealed++;

    switch (cell) {
      case Mine():
        _onMineRevealed(cell);
        return;
      case Empty():
        _onEmptyRevealed(cell);
      case Count():
        break;
    }

    _onWin();
  }

  void toggleFlag(int x, int y) {
    var cell = board.getCell(x, y);
    if (cell.x == -1 || cell.y == -1) {
      throw Exception("trying to toggle a flag in an invalid cell");
    }

    if (!cell.isFlagged && totalFlags >= totalMines) return;

    cell.toggleFlag();
    if (cell.isFlagged) {
      totalFlags++;
    } else {
      totalFlags--;
    }
  }

  void _startBoard(int firstX, int firstY) {
    final totalCells = width * height;
    final Set<int> minePositions = {};

    final safeZone = <int>{};
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        int nx = firstX + dx;
        int ny = firstY + dy;
        if (board.inBounds(nx, ny)) {
          safeZone.add(board.getIndex(nx, ny));
        }
      }
    }

    while (minePositions.length < totalMines) {
      final pos = rand.nextInt(totalCells);
      if (!safeZone.contains(pos)) {
        minePositions.add(pos);
      }
    }

    for (final pos in minePositions) {
      final oldCell = board.cells[pos];
      final newCell = Mine(oldCell.x, oldCell.y);
      board.cells[pos] = newCell;

      for (final nb in board.neighbors(newCell.x, newCell.y)) {
        final idx = board.getIndex(nb.x, nb.y);
        var currentCell = board.cells[idx];

        if (currentCell is Empty) {
          board.cells[idx] = Count(currentCell.x, currentCell.y, 1);
        } else if (currentCell is Count) {
          currentCell.adjacentMines++;
        }
      }
    }

    started = true;
  }

  void _onMineRevealed(Cell revealed) {
    started = false;
    result = GameResult.playerLost;
    for (final c in board.iter()) {
      if (c is Mine) {
        c.reveal();
      }
    }
  }

  void _onEmptyRevealed(Cell revealed) {
    for (final nb in board.neighbors(revealed.x, revealed.y)) {
      if (!nb.isRevealed) {
        switch (nb.runtimeType) {
          case Empty:
            nb.reveal();
            totalRevealed++;
            _onEmptyRevealed(nb);
            break;

          case Count:
            nb.reveal();
            totalRevealed++;
            break;
        }
      }
    }
  }

  void _onWin() {
    var revealed = totalRevealed >= (width * height - totalMines);
    if (revealed) {
      for (final cell in board.iter()) {
        if (cell is Mine) {
          cell.isFlagged = true;
          cell.isRevealed = false;
        } else {
          cell.isRevealed = true;
          cell.isFlagged = false;
        }
      }
      started = false;
      result = GameResult.playerWon;
    }
  }
}
