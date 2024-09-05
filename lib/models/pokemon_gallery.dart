import 'package:temp/models/pokemonType.dart';

class PokemonGallery {
  final int id;
  final String name;
  final List<Type> types;
  final List<String?> sprites; // Lista de URL de imagenes

  PokemonGallery({
    required this.id,
    required this.name,
    required this.types,
    required this.sprites,
  });

  factory PokemonGallery.fromJson(Map<String, dynamic> json) {
    // Parseando la lista de imagenes
    final spritesData = json['sprites'];
    final List<String?> spriteUrls = [
      spritesData['other']['dream_world']['front_default'],
      spritesData['other']['dream_world']['front_female'],
      spritesData['other']['home']['front_default'],
      spritesData['other']['home']['front_female'],
      spritesData['other']['home']['front_shiny'],
      spritesData['other']['home']['front_shiny_female'],
      spritesData['other']['official-artwork']['front_default'],
      spritesData['other']['official-artwork']['front_shiny'],
    ];

    // Parseando la lista de tipos
    final List<dynamic> typesData = json['types'];
    final List<Type> types = typesData.map((typeData) {
      return Type.fromJson(typeData);
    }).toList();

    return PokemonGallery(
      id: json['id'] as int,
      name: json['name'] as String,
      types: types,
      sprites: spriteUrls,
    );
  }
}

