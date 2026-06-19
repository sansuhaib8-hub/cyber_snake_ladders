import 'package:flutter/material.dart';

class BoardCalculator {
  static int getDisplayCellNumber(int gridIndex) {
    int row = gridIndex ~/ 10;
    int col = gridIndex % 10;
    int actualRow = 9 - row;
    int actualCol = (actualRow % 2 == 1) ? (9 - col) : col;
    return (actualRow * 10) + actualCol + 1;
  }

  static Offset getCellCoordinates(int pos, double cellSize) {
    if (pos == 0) return Offset(cellSize * 0.5, cellSize * 0.5);
    int idx = pos - 1;
    int row = idx ~/ 10;
    int col = idx % 10;
    if (row % 2 == 1) col = 9 - col;
    double padding = (cellSize - (cellSize * 0.5)) / 2;
    return Offset(col * cellSize + padding, (9 - row) * cellSize + padding);
  }

  static Offset getCellCenter(int cell, Size size) {
    double cellWidth = size.width / 10;
    double cellHeight = size.height / 10;
    int idx = cell - 1;
    int row = idx ~/ 10;
    int col = idx % 10;
    if (row % 2 == 1) col = 9 - col;
    return Offset((col + 0.5) * cellWidth, (9 - row + 0.5) * cellHeight);
  }
}
