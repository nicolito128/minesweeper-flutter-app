import 'package:minesweeper/domain/cell.dart';

class Board {
  final int width;
  final int height;

  // Flat list as a matrix
  late final List<Cell> cells;

  new(this.width, this.height) {
    cells = List.generate(
      width * height,
      (pos) => Empty(pos % width, pos ~/ width),
    );
  }

  int getIndex(int x, int y) {
    return (y * width) + x;
  }

  bool inBounds(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  Cell getCell(int x, int y) {
    if (!inBounds(x, y)) {
      return Empty(-1, -1);
    }

    return cells.elementAt(getIndex(x, y));
  }

  void setCell(int x, int y, Cell cell) {
    if (!inBounds(x, y)) {
      return;
    }

    cell.x = x;
    cell.y = y;
    cells[getIndex(x, y)] = cell;
  }

  Iterable<Cell> iter() sync* {
    for (int i = 0; i < cells.length; i++) {
      final x = i % width;
      final y = i ~/ width;
      yield getCell(x, y);
    }
  }

  Iterable<Cell> neighbors(int x, int y) sync* {
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        // ignore origin
        if (dx == 0 && dy == 0) continue;

        final nx = x + dx;
        final ny = y + dy;

        if (inBounds(nx, ny)) {
          yield getCell(nx, ny);
        }
      }
    }
  }
}
