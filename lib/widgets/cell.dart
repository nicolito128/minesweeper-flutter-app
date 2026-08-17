import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/domain/cell.dart';
import 'package:minesweeper/domain/game.dart';
import 'package:minesweeper/settings.dart';
import 'package:minesweeper/widgets/corner_border_painter.dart';

class CellWidget extends StatelessWidget {
  final Game game;
  final Cell cell;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CellWidget({
    super.key,
    required this.game,
    required this.cell,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget cellContent = Container(
      decoration: BoxDecoration(
        color: getCellColor(),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(
          getCellText(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getAdaptativeFontSize(context),
            color: getNumberColor(),
          ),
        ),
      ),
    );

    if (cell.isRevealed) {
      cellContent = CustomPaint(
        foregroundPainter: CornerBorderPainter(
          color: globalSettings.palette.primary,
          strokeWidth: 2.0,
          cornerLength: 4.0,
        ),
        child: cellContent,
      );
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: onLongPress,
      child: cellContent,
    );
  }

  Color getCellColor() {
    if (!cell.isRevealed) {
      return globalSettings.palette.primary;
    }
    if (cell is Mine) {
      return globalSettings.palette.background;
    }
    return globalSettings.palette.background;
  }

  Color getNumberColor() {
    if (cell is Count && cell.isRevealed) {
      var count = cell as Count;
      switch (count.adjacentMines) {
        case 1:
          return globalSettings.palette.cellLight;
        case 2:
          return globalSettings.palette.cellMedium;
        case 3:
          return globalSettings.palette.cellHigh;
        case 4:
          return globalSettings.palette.cellVeryHigh;
        default: // 5, 6, 7, 8
          return globalSettings.palette.cellHeavy;
      }
    }
    return globalSettings.palette.text;
  }

  String getCellText() {
    if (cell.isFlagged) return '⚑';
    if (!cell.isRevealed) return '';

    if (cell is Mine) return '×';
    if (cell is Count) {
      final c = cell as Count;
      return c.adjacentMines > 0 ? '${c.adjacentMines}' : '';
    }
    return '';
  }

  double getAdaptativeFontSize(BuildContext context) {
    double aspecRatio = min(1, MediaQuery.of(context).size.aspectRatio);
    double grids = (game.width * game.height).toDouble();
    double to3am = -0.0798;
    double idoneus = 48;
    double fac = (to3am * grids + idoneus) * aspecRatio;
    return max(fac, 8);
  }
}
