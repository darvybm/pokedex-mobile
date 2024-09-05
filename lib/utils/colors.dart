import 'package:flutter/material.dart';

class MyColors {
  static const greyLight = Color(0xFFEBEBEB);
  static const greyMedium = Color(0xFFD2D2D2);
  static const greyDark = Color(0xFF848484);
  static const grey = Color(0xFFA3A3AA);
  static const blue = Color(0xFF108AD3);
  static const red = Color(0xFFEA5E55);
  static const green = Color.fromARGB(255, 70, 176, 132);

  static const blueDark = Color(0xFF0B6499);
  static const redDark = Color.fromARGB(255, 189, 46, 36);
  static const greenDark = Color.fromARGB(255, 45, 112, 84);
  static const darkGray = Color(0xFF626262);

  /// Custom Pokemon Type Colors
  // Bug Type
  static const int _bugGreenPrimaryValue = 0xFF92BD2D;
  static const bugGreen = MaterialColor(
    _bugGreenPrimaryValue,
    <int, Color>{
      00: Color(0xFFD5E5A8),
      250: Color(0xFFB4C96A),
      500: Color(_bugGreenPrimaryValue),
      750: Color(0xFF6A9108),
      1000: Color(0xFF334802),
    },
  );

  // Dark Type
  static const int _darkPokemonGrayPrimaryValue = 0xFF585660;
  static const darkPokemonGray = MaterialColor(
    _darkPokemonGrayPrimaryValue,
    <int, Color>{
      00: Color(0xFFA6A6A6),
      250: Color(0xFF767479),
      500: Color(_darkPokemonGrayPrimaryValue),
      750: Color(0xFF3E3D4B),
      1000: Color(0xFF25242D),
    },
  );

  // Water Type
  static const int _waterBluePrimaryValue = 0xFF539DDF;
  static const waterBlue = MaterialColor(
    _waterBluePrimaryValue,
    <int, Color>{
      00: Color(0xFF9DC4EA),
      250: Color(0xFF6EA6E1),
      500: Color(_waterBluePrimaryValue),
      750: Color(0xFF3A78AF),
      1000: Color(0xFF2A5A84),
    },
  );

  // Electric Type
  static const int _electricYellowPrimaryValue = 0xFFF2D94E;
  static const electricYellow = MaterialColor(
    _electricYellowPrimaryValue,
    <int, Color>{
      00: Color(0xFFFFE89C),
      250: Color(0xFFFFD640),
      500: Color(_electricYellowPrimaryValue),
      750: Color(0xFFBCA733),
      1000: Color(0xFF8D7D25),
    },
  );

  // Fairy Type
  static const int _fairyPinkPrimaryValue = 0xFFEF90E6;
  static const fairyPink = MaterialColor(
    _fairyPinkPrimaryValue,
    <int, Color>{
      00: Color(0xFFFFBFF8),
      250: Color(0xFFE083D6),
      500: Color(_fairyPinkPrimaryValue),
      750: Color(0xFFBB36B0),
      1000: Color(0xFFA22F98),
    },
  );

  // Fire Type
  static const int _fireRedPrimaryValue = 0xFFFBA64C;
  static const fireRed = MaterialColor(
    _fireRedPrimaryValue,
    <int, Color>{
      00: Color(0xFFEF9D55),
      250: Color(0xFFDC8D3D),
      500: Color(_fireRedPrimaryValue),
      750: Color(0xFFC67825),
      1000: Color(0xFFB06B20),
    },
  );

  // Fighting Type
  static const int _fightingOrangePrimaryValue = 0xFFD3425F;
  static const fightingOrange = MaterialColor(
    _fightingOrangePrimaryValue,
    <int, Color>{
      00: Color(0xFFF57171),
      250: Color(0xFFE04747),
      500: Color(_fightingOrangePrimaryValue),
      750: Color(0xFFAB2F48),
      1000: Color(0xFF962138),
    },
  );

  // Flying Type
  static const int _flyingBluePrimaryValue = 0xFF8AA5DA;
  static const flyingBlue = MaterialColor(
    _flyingBluePrimaryValue,
    <int, Color>{
      00: Color(0xFFDCE9FD),
      250: Color(0xFFA5BBE7),
      500: Color(_flyingBluePrimaryValue),
      750: Color(0xFF5370A8),
      1000: Color(0xFF2D487C),
    },
  );

  // Ghost Type
  static const int _ghostBluePrimaryValue = 0xFF5160B7;
  static const ghostBlue = MaterialColor(
    _ghostBluePrimaryValue,
    <int, Color>{
      00: Color(0xFFA5A9DA),
      250: Color(0xFF7279B6),
      500: Color(_ghostBluePrimaryValue),
      750: Color(0xFF3645A1),
      1000: Color(0xFF273377),
    },
  );

  // Grass Type
  static const int _grassGreenPrimaryValue = 0xFF60BD58;
  static const grassGreen = MaterialColor(
    _grassGreenPrimaryValue,
    <int, Color>{
      00: Color(0xFFC7FAC3),
      250: Color(0xFF80D27B),
      500: Color(_grassGreenPrimaryValue),
      750: Color(0xFF38A231),
      1000: Color(0xFF32752D),
    },
  );

  // Ground Type
  static const int _groundOrangePrimaryValue = 0xFFDA7C4D;
  static const groundOrange = MaterialColor(
    _groundOrangePrimaryValue,
    <int, Color>{
      00: Color(0xFFEEA37B),
      250: Color(0xFFD07A4C),
      500: Color(_groundOrangePrimaryValue),
      750: Color(0xFFAB5D33),
      1000: Color(0xFF984D23),
    },
  );

  // Ice Type
  static const int _iceBluePrimaryValue = 0xFF51C4B6;
  static const iceBlue = MaterialColor(
    _iceBluePrimaryValue,
    <int, Color>{
      00: Color(0xFFCEF5EB),
      250: Color(0xFF87DED2),
      500: Color(_iceBluePrimaryValue),
      750: Color(0xFF2EA99D),
      1000: Color(0xFF136E65),
    },
  );

  // Normal Type
  static const int _normalGrayPrimaryValue = 0xFF9FA19E;
  static const normalGray = MaterialColor(
    _normalGrayPrimaryValue,
    <int, Color>{
      00: Color(0xFFECECEC),
      250: Color(0xFFCBCBCB),
      500: Color(_normalGrayPrimaryValue),
      750: Color(0xFF727372),
      1000: Color(0xFF505050),
    },
  );

  // Poison Type
  static const int _poisonGreenPrimaryValue = 0xFFB763CF;
  static const poisonGreen = MaterialColor(
    _poisonGreenPrimaryValue,
    <int, Color>{
      00: Color(0xFFD88BF5),
      250: Color(0xFFC773E1),
      500: Color(_poisonGreenPrimaryValue),
      750: Color(0xFF8E44A2),
      1000: Color(0xFF6F2C82),
    },
  );

  // Psychic Type
  static const int _psychicRedPrimaryValue = 0xFFFA8582;
  static const psychicRed = MaterialColor(
    _psychicRedPrimaryValue,
    <int, Color>{
      00: Color(0xFFFFE2E0),
      250: Color(0xFFFCB2AF),
      500: Color(_psychicRedPrimaryValue),
      750: Color(0xFFBD5450),
      1000: Color(0xFFA24643),
    },
  );

  // Rock Type
  static const int _rockBrownPrimaryValue = 0xFFC9BC8A;
  static const rockBrown = MaterialColor(
    _rockBrownPrimaryValue,
    <int, Color>{
      00: Color(0xFFFFE4B6),
      250: Color(0xFFDCD086),
      500: Color(_rockBrownPrimaryValue),
      750: Color(0xFF9A8D42),
      1000: Color(0xFF786E45),
    },
  );

  // Steel Type
  static const int _steelBluePrimaryValue = 0xFF478491;
  static const steelBlue = MaterialColor(
    _steelBluePrimaryValue,
    <int, Color>{
      00: Color(0xFFBBE9F6),
      250: Color(0xFF79B2BE),
      500: Color(_steelBluePrimaryValue),
      750: Color(0xFF285B64),
      1000: Color(0xFF10353B),
    },
  );

  // Dragon Type
  static const int _dragonBluePrimaryValue = 0xFF539DDF;
  static const dragonBlue = MaterialColor(
    _dragonBluePrimaryValue,
    <int, Color>{
      00: Color(0xFFBBDCFD),
      250: Color(0xFF72B0E7),
      500: Color(_dragonBluePrimaryValue),
      750: Color(0xFF216398),
      1000: Color(0xFF214C72),
    },
  );

  static MaterialColor getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'bug':
        return bugGreen;
      case 'dark':
        return darkPokemonGray;
      case 'water':
        return waterBlue;
      case 'electric':
        return electricYellow;
      case 'fairy':
        return fairyPink;
      case 'fire':
        return fireRed;
      case 'fighting':
        return fightingOrange;
      case 'flying':
        return flyingBlue;
      case 'ghost':
        return ghostBlue;
      case 'grass':
        return grassGreen;
      case 'ground':
        return groundOrange;
      case 'ice':
        return iceBlue;
      case 'normal':
        return normalGray;
      case 'poison':
        return poisonGreen;
      case 'psychic':
        return psychicRed;
      case 'rock':
        return rockBrown;
      case 'steel':
        return steelBlue;
      case 'dragon':
        return dragonBlue;
      default:
        return normalGray; // Color por defecto si no coincide ningún tipo
    }
  }
}