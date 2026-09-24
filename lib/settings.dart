import 'package:minesweeper/utils/themes.dart';
import 'package:minesweeper/utils/preferences.dart';

class Settings {
  late Palette palette;

  new() {
    palette = paletteKV[UserPreferences.theme] ?? paletteList[0];
  }
}

Settings globalSettings = Settings();
