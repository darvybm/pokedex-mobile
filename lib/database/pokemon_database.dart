import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:temp/database/db_provider.dart';
import 'package:temp/models/pokemon.dart';
import 'package:temp/models/pokemon_gallery.dart';
import 'package:temp/models/pokemon_list.dart';
import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/models/pokemonStat.dart';
import 'package:temp/models/pokemonType.dart';
import 'package:temp/models/pokemonAbility.dart';
import 'package:temp/services/api_service.dart';


class PokemonDB{
  /// *************   OPERACIONES DE INSERCION   ************* ///
  // Para insertar Lista de Pokemons
  static Future<void> insertPokemonList(PokemonList pokemonList) async {
    final db = await DBProvider.db.database;
    for (var pokemon in pokemonList.results) {
      await db.insert(
          'Pokemon', pokemon.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // Para insertar UN Detalle de Pokemon
  static Future<void> insertPokemonDetail(PokemonDetail pokemonDetail) async {
    final db = await DBProvider.db.database;
    await db.insert(
        'PokemonDetail',
        {
          'id': pokemonDetail.id,
          'name': pokemonDetail.name,
          'weight': pokemonDetail.weight,
          'height': pokemonDetail.height,
          'is_default': pokemonDetail.isDefault ? 1 : 0,
          'species_name': pokemonDetail.speciesName,
          'official_front_default_img': pokemonDetail.officialFrontDefaultImg,
          'official_front_shiny_img': pokemonDetail.officialFrontShinyImg,
          'types': jsonEncode(pokemonDetail.types),
          'stats': jsonEncode(pokemonDetail.stats),
          'abilities': jsonEncode(pokemonDetail.abilities),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Para insertar una lista de Detalles de Pokemon
  static Future<void> insertPokemonDetails(List<PokemonDetail> pokemonDetails) async {
    final db = await DBProvider.db.database;
    final batch = db.batch();

    for (var detail in pokemonDetails) {
      batch.insert(
        'PokemonDetail',
        {
          'id': detail.id,
          'name': detail.name,
          'weight': detail.weight,
          'height': detail.height,
          'is_default': detail.isDefault ? 1 : 0,
          'species_name': detail.speciesName,
          'official_front_default_img': detail.officialFrontDefaultImg,
          'official_front_shiny_img': detail.officialFrontShinyImg,
          'types': jsonEncode(detail.types),
          'stats': jsonEncode(detail.stats),
          'abilities': jsonEncode(detail.abilities),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit();
  }

  // Para insertar una lista de Galerías de Pokemon
  static Future<void> insertPokemonGalleries(List<PokemonGallery> pokemonGalleries) async {
    final db = await DBProvider.db.database;
    final batch = db.batch();

    for (var gallery in pokemonGalleries) {
      batch.insert(
        'PokemonGallery',
        {
          'id': gallery.id,
          'name': gallery.name,
          'types': jsonEncode(gallery.types),
          'sprites': jsonEncode(gallery.sprites)
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit();
  }

  // Para insertar pokemon favorito
  static Future<void> insertFavoritePokemon(int pokemonId) async {
    final db = await DBProvider.db.database;
    await db.insert(
      'FavoritePokemonDetail',
      {
        'pokemon_detail_id': pokemonId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Para insertar un nuevo pokemon del día (Solo utilizado la primera vez)
  static Future<void> insertDailyPokemon(int pokemonId, String lastFetchedDate) async {
    final db = await DBProvider.db.database;
    await db.insert(
      'DailyPokemon',
      {'pokemon_id': pokemonId, 'last_fetched_date': lastFetchedDate},
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if there is a conflict
    );
  }

  // Para actualizar el pokemon del día ya existente por el nuevo
  static Future<void> updateDailyPokemon(int pokemonId, String lastFetchedDate) async {
    final db =  await DBProvider.db.database;
    await db.update(
      'DailyPokemon',
      {'pokemon_id': pokemonId, 'last_fetched_date': lastFetchedDate},
      where: 'id = 1',
    );
  }


  /// *************   OPERACIONES DE SELECCION   ************* ///
  // Para obtener todos los Pokemon contenidos dentro de PokemonList
  static Future<List<Pokemon>> getAllPokemon() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('Pokemon');

    return List.generate(maps.length, (i) {
      return Pokemon(
        id: maps[i]['id'],
        name: maps[i]['name'],
        url: maps[i]['url'],
      );
    });
  }

  // Para obtener todos los PokemonDetail con su data
  static Future<List<PokemonDetail>> getAllPokemonDetails() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('PokemonDetail');

    return List.generate(maps.length, (i) {
      return PokemonDetail(
        id: maps[i]['id'],
        name: maps[i]['name'],
        weight: maps[i]['weight'],
        height: maps[i]['height'],
        isDefault: maps[i]['is_default'] == 1,
        speciesName: maps[i]['species_name'],
        officialFrontDefaultImg: maps[i]['official_front_default_img'],
        officialFrontShinyImg: maps[i]['official_front_shiny_img'],
        types: (jsonDecode(maps[0]['types']) as List)
            .map((type) => Type.fromJson(type))
            .toList(),
        stats: (jsonDecode(maps[0]['stats']) as List)
            .map((stat) => Stat.fromJson(stat))
            .toList(),
        abilities: (jsonDecode(maps[0]['abilities']) as List)
            .map((ability) => Ability.fromJson(ability))
            .toList(),
        // Add other fields as needed
      );
    });
  }

  // Para obtener todos los PokemonGallery con su data
  static Future<List<PokemonGallery>> getAllPokemonGallery() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('PokemonGallery');

    return List.generate(maps.length, (i) {
      return PokemonGallery(
        id: maps[i]['id'],
        name: maps[i]['name'],
        types: (jsonDecode(maps[0]['types']) as List)
            .map((type) => Type.fromJson(type))
            .toList(),
        sprites: (jsonDecode(maps[i]['sprites']) as List).cast<String?>(),
      );
    });
  }

  // Para obtener un único PokemonDetail y su data por su ID
  static Future<PokemonDetail?> getPokemonDetailById(int id) async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'PokemonDetail',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PokemonDetail(
        id: maps[0]['id'],
        name: maps[0]['name'],
        weight: maps[0]['weight'],
        height: maps[0]['height'],
        isDefault: maps[0]['is_default'] == 1,
        speciesName: maps[0]['species_name'],
        officialFrontDefaultImg: maps[0]['official_front_default_img'],
        officialFrontShinyImg: maps[0]['official_front_shiny_img'],
        types: (jsonDecode(maps[0]['types']) as List)
            .map((type) => Type.fromJson(type))
            .toList(),
        stats: (jsonDecode(maps[0]['stats']) as List)
            .map((stat) => Stat.fromJson(stat))
            .toList(),
        abilities: (jsonDecode(maps[0]['abilities']) as List)
            .map((ability) => Ability.fromJson(ability))
            .toList(),
        // Add other fields as needed
      );
    } else {
      return null;
    }
  }

  // Para obtener un único PokemonGallery y su data por su ID
  static Future<PokemonGallery?> getPokemonGalleryById(int id) async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'PokemonGallery',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PokemonGallery(
        id: maps[0]['id'],
        name: maps[0]['name'],
        types: (jsonDecode(maps[0]['types']) as List)
            .map((type) => Type.fromJson(type))
            .toList(),
        sprites: (jsonDecode(maps[0]['sprites']) as List).cast<String?>(),
      );
    } else {
      return null;
    }
  }

  // Para obtener todos los PokemonDetail que estén marcados como Favoritos
  static Future<List<PokemonDetail>> getAllFavoritePokemonDetails() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FavoritePokemonDetail',
      orderBy: 'pokemon_detail_id ASC',
    );

    // Extraer los IDs de los PokemonDetails en la tabla
    final List<int> pokemonIds = List<int>.from(maps.map((map) => map['pokemon_detail_id']));

    // Buscar los detalles usando estos IDs
    final List<PokemonDetail> favoritePokemonDetails = [];
    for (final int pokemonId in pokemonIds) {
      final pokemonDetail = await getPokemonDetailById(pokemonId);
      if (pokemonDetail != null) {
        favoritePokemonDetails.add(pokemonDetail);
      }
    }

    return favoritePokemonDetails;
  }

  // Para obtener el pokemon del dia actual
  static Future<Map<String, dynamic>?> getLastDailyPokemon() async {
    final db = await DBProvider.db.database;
    final List<Map<String, dynamic>> result =
    await db.query('DailyPokemon', orderBy: 'id DESC', limit: 1);

    if (result.isNotEmpty) {
      final pokemonId = result.first['pokemon_id'];
      final lastFetchedDate = result.first['last_fetched_date'];

      // Fetch the PokemonDetail separately using the ID
      final pokemonDetail = await ApiService.fetchPokemonDetailById(pokemonId);

      return {
        'pokemon': pokemonDetail,
        'last_fetched_date': lastFetchedDate,
      };
    }
    return null;
  }

  /// *************   OPERACIONES DE ELIMINACION   ************* ///
  // Para eliminar todos los Pokemon guardados (Y sus detalles)
  static Future<void> clearPokemonTable() async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM Pokemon');
    await db.rawDelete('DELETE FROM PokemonDetail');
  }

  // Para eliminar todos los Pokemon guardados (Y sus detalles)
  static Future<void> clearPokemonGalleryTable() async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM PokemonGallery');
  }

  // Para eliminar la lista de Pokemons Favoritos
  static Future<void> clearFavoritePokemonTable() async {
    final db = await DBProvider.db.database;
    await db.rawDelete('DELETE FROM FavoritePokemonDetail');
  }

  // Para eliminar UN pokemon de la lista de Favoritos
  static Future<void> removeFavoritePokemon(int pokemonId) async {
    final db = await DBProvider.db.database;
    await db.delete(
      'FavoritePokemonDetail',
      where: 'pokemon_detail_id = ?',
      whereArgs: [pokemonId],
    );
  }


  /// *************   OPERACIONES AUXILIARES   ************* ///
  // Para revisar si un Pokemon específico está marcado como favorito
  static Future<bool> isPokemonFavorite(int pokemonId) async {
    final db = await DBProvider.db.database;
    final result = await db.query(
      'FavoritePokemonDetail',
      where: 'pokemon_detail_id = ?',
      whereArgs: [pokemonId],
    );
    return result.isNotEmpty;
  }

  // Para manejar búsquedas de Pokemones por ID o por Nombre
  static Future<List<PokemonDetail>> searchPokemon(String searchText) async {
    final db = await DBProvider.db.database;

    // En caso que se haya buscado por nombre
    if (int.tryParse(searchText) == null) {
      List<Map<String, dynamic>> maps = await db.query(
        'PokemonDetail',
        where: 'name LIKE ?',
        whereArgs: ['%$searchText%'],
      );

      return List.generate(maps.length, (i) {
        return PokemonDetail(
          id: maps[i]['id'],
          name: maps[i]['name'],
          weight: maps[i]['weight'],
          height: maps[i]['height'],
          isDefault: maps[i]['is_default'] == 1,
          speciesName: maps[i]['species_name'],
          officialFrontDefaultImg: maps[i]['official_front_default_img'],
          officialFrontShinyImg: maps[i]['official_front_shiny_img'],
          types: (jsonDecode(maps[0]['types']) as List)
              .map((type) => Type.fromJson(type))
              .toList(),
          stats: (jsonDecode(maps[0]['stats']) as List)
              .map((stat) => Stat.fromJson(stat))
              .toList(),
          abilities: (jsonDecode(maps[0]['abilities']) as List)
              .map((ability) => Ability.fromJson(ability))
              .toList(),
          // Add other fields as needed
        );
      });
    }
    // En caso que se haya buscado por ID
    final int id = int.parse(searchText);
    final PokemonDetail? pokemonDetail = await getPokemonDetailById(id);

    if (pokemonDetail != null) {
      return [pokemonDetail];
    } else {
      return [];
    }
  }

  // Para manejar búsquedas de PokemonGallery por ID o por Nombre
  static Future<List<PokemonGallery>> searchPokemonGallery(String searchText) async {
    final db = await DBProvider.db.database;

    // En caso que se haya buscado por nombre
    if (int.tryParse(searchText) == null) {
      List<Map<String, dynamic>> maps = await db.query(
        'PokemonGallery',
        where: 'name LIKE ?',
        whereArgs: ['%$searchText%'],
      );

      return List.generate(maps.length, (i) {
        return PokemonGallery(
          id: maps[i]['id'],
          name: maps[i]['name'],
          types: (jsonDecode(maps[0]['types']) as List)
              .map((type) => Type.fromJson(type))
              .toList(),
          sprites: (jsonDecode(maps[i]['sprites']) as List).cast<String?>(),
        );
      });
    }
    // En caso que se haya buscado por ID
    final int id = int.parse(searchText);
    final PokemonGallery? pokemonGallery = await getPokemonGalleryById(id);

    if (pokemonGallery != null) {
      return [pokemonGallery];
    } else {
      return [];
    }
  }

  // Para manejar búsquedas de Pokemones por ID o por Nombre
  static Future<List<PokemonDetail>> searchFavoritePokemon(String searchText) async {
    final db = await DBProvider.db.database;

    // En caso que se haya buscado por nombre
    if (int.tryParse(searchText) == null) {
      List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT PokemonDetail.*
      FROM PokemonDetail
      JOIN FavoritePokemonDetail ON PokemonDetail.id = FavoritePokemonDetail.pokemon_detail_id
      WHERE PokemonDetail.name LIKE ?
    ''', ['%$searchText%']);

      return List.generate(maps.length, (i) {
        return PokemonDetail(
          id: maps[i]['id'],
          name: maps[i]['name'],
          weight: maps[i]['weight'],
          height: maps[i]['height'],
          isDefault: maps[i]['is_default'] == 1,
          speciesName: maps[i]['species_name'],
          officialFrontDefaultImg: maps[i]['official_front_default_img'],
          officialFrontShinyImg: maps[i]['official_front_shiny_img'],
          types: (jsonDecode(maps[0]['types']) as List)
              .map((type) => Type.fromJson(type))
              .toList(),
          stats: (jsonDecode(maps[0]['stats']) as List)
              .map((stat) => Stat.fromJson(stat))
              .toList(),
          abilities: (jsonDecode(maps[0]['abilities']) as List)
              .map((ability) => Ability.fromJson(ability))
              .toList(),
          // Add other fields as needed
        );
      });
    }

    // En caso que se haya buscado por ID
    final int id = int.parse(searchText);
    List<Map<String, dynamic>> favoritePokemonMaps = await db.query(
      'FavoritePokemonDetail',
      where: 'pokemon_detail_id = ?',
      whereArgs: [id],
    );

    if (favoritePokemonMaps.isNotEmpty) {
      int pokemonDetailId = favoritePokemonMaps[0]['pokemon_detail_id'];
      final PokemonDetail? pokemonDetail = await getPokemonDetailById(pokemonDetailId);

      if (pokemonDetail != null) {
        return [pokemonDetail];
      }
    }

    return [];
  }

  static Future<bool> isPokemonTableEmpty() async {
    final db = await DBProvider.db.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Pokemon'));

    return count == 0;
  }

}