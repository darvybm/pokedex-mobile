import 'dart:math';

import 'package:flutter/widgets.dart';

class ScreenUtil {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double diagonal(BuildContext context) {
    final double height = screenHeight(context);
    final double width = screenWidth(context);
    return sqrt(pow(height, 2) + pow(width, 2));
  }
}
