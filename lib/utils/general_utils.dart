

class GeneralUtils {
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    // Revisar si el texto no contiene un guión
    if (!text.contains('-')) {
      return text[0].toUpperCase() + text.substring(1);

    } else {
      List<String> words = text.split('-');
      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          words[i] = words[i][0].toUpperCase() + words[i].substring(1);
        }
      }
      return words.join(' ');
    }
  }

  // Función para convertir decimetros a metros (String)
  static String convertHeightToMeters(int heightInDecimeters) {
    double heightInMeters = heightInDecimeters / 10.0;
    return '$heightInMeters''m';
  }

  // Función para convertir hectogramos a kilogramos (String)
  static String convertWeightToKilograms(int weightInHectograms) {
    double weightInKilograms = weightInHectograms / 10.0;
    return '$weightInKilograms''kg';
  }
}