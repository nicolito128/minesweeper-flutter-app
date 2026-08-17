import 'package:minesweeper/utils/colors.dart';

class Settings {
  late Palette palette;

  new() {
    palette = colorPalette0;
  }
}

Settings globalSettings = Settings();
