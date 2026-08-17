import 'dart:ui';

class Palette {
  final String name;

  final Color primary;
  final Color secondary;
  final Color background;

  final Color text;
  final Color flags;

  final Color cellLight;
  final Color cellMedium;
  final Color cellHigh;
  final Color cellVeryHigh;
  final Color cellHeavy;

  const new({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.text,
    required this.flags,

    required this.cellLight,
    required this.cellMedium,
    required this.cellHigh,
    required this.cellVeryHigh,
    required this.cellHeavy,
  });
}

final Palette colorPalette0 = const Palette(
  name: "Classic",
  primary: Color.fromARGB(255, 192, 192, 192),
  secondary: Color.fromARGB(255, 0, 0, 0),
  background: Color.fromARGB(255, 230, 230, 230),
  text: Color.fromARGB(255, 50, 50, 50),
  flags: Color.fromARGB(255, 255, 128, 128),
  cellLight: Color.fromARGB(255, 100, 181, 246),
  cellMedium: Color.fromARGB(255, 129, 199, 132),
  cellHigh: Color.fromARGB(255, 229, 115, 115),
  cellVeryHigh: Color.fromARGB(255, 186, 104, 200),
  cellHeavy: Color.fromARGB(255, 240, 98, 146),
);

final Palette colorPalette1 = const Palette(
  name: "Arabian Night",
  primary: Color.fromARGB(255, 126, 149, 252),
  secondary: Color.fromARGB(255, 234, 224, 207),
  background: Color.fromARGB(255, 17, 24, 68),
  text: Color.fromARGB(255, 234, 224, 207),
  flags: Color.fromARGB(255, 255, 160, 122),
  cellLight: Color.fromARGB(255, 173, 216, 230),
  cellMedium: Color.fromARGB(255, 152, 251, 152),
  cellHigh: Color.fromARGB(255, 255, 182, 193),
  cellVeryHigh: Color.fromARGB(255, 221, 160, 221),
  cellHeavy: Color.fromARGB(255, 250, 128, 114),
);

final Palette colorPalette2 = const Palette(
  name: "Hackerman",
  primary: Color.fromARGB(255, 40, 44, 52),
  secondary: Color.fromARGB(255, 57, 255, 20),
  background: Color.fromARGB(255, 18, 18, 18),
  text: Color.fromARGB(255, 220, 255, 220),
  flags: Color.fromARGB(255, 255, 179, 217),
  cellLight: Color.fromARGB(255, 167, 255, 235),
  cellMedium: Color.fromARGB(255, 185, 246, 202),
  cellHigh: Color.fromARGB(255, 255, 204, 204),
  cellVeryHigh: Color.fromARGB(255, 204, 153, 255),
  cellHeavy: Color.fromARGB(255, 255, 224, 130),
);

final Palette colorPalette3 = const Palette(
  name: "Sunset",
  primary: Color.fromARGB(255, 200, 75, 49),
  secondary: Color.fromARGB(255, 246, 216, 96),
  background: Color.fromARGB(255, 45, 10, 20),
  text: Color.fromARGB(255, 255, 235, 190),
  flags: Color.fromARGB(255, 255, 184, 77),
  cellLight: Color.fromARGB(255, 144, 202, 249),
  cellMedium: Color.fromARGB(255, 165, 214, 167),
  cellHigh: Color.fromARGB(255, 239, 154, 154),
  cellVeryHigh: Color.fromARGB(255, 206, 147, 216),
  cellHeavy: Color.fromARGB(255, 255, 204, 128),
);

final List<Palette> paletteList = [
  colorPalette0,
  colorPalette1,
  colorPalette2,
  colorPalette3,
];
