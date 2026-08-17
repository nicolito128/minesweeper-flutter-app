abstract class Cell {
  late int x;
  late int y;

  bool isRevealed = false;
  bool isFlagged = false;

  new(this.x, this.y);

  void reveal() {
    isRevealed = true;
  }

  void toggleFlag() {
    if (!isRevealed) {
      isFlagged = !isFlagged;
    }
  }

  @override
  String toString() {
    return '$runtimeType(x: $x, y: $y, revealed: $isRevealed, flagged: $isFlagged)';
  }
}

class Empty extends Cell {
  new(super.x, super.y);
}

class Mine extends Cell {
  new(super.x, super.y);
}

class Count extends Cell {
  late int adjacentMines;

  new(super.x, super.y, this.adjacentMines);

  @override
  String toString() {
    return 'Count(x: $x, y: $y, revealed: $isRevealed, flagged: $isFlagged, adjacentMines: $adjacentMines)';
  }
}
