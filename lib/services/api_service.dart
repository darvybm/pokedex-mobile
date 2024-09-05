import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temp/models/pokemonMove.dart';

import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/models/pokemon.dart';
import 'package:temp/models/pokemon_list.dart';
import 'package:temp/models/pokemon_gallery.dart';
import 'package:temp/database/pokemon_database.dart';


class ApiService {
  // Fetch una lista con paginación. Para cambiar cantidad de paginacion, modificar limit=
  static Future<void> fetchData(void Function(PokemonList, List<PokemonDetail>) updateState) async {
    final response = await http.get(
        Uri.parse("https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20")
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pokemonList = PokemonList.fromJson(data);
      final newPokemonDetails = await fetchPokemonDetailsForList(pokemonList.results);
      final newPokemonGalleries = await fetchPokemonGalleriesForList(pokemonList.results);

      // Insertando PokemonList en la base de datos
      await PokemonDB.insertPokemonList(pokemonList);
      // Usando Batch para insertar detalles a base de datos.
      await PokemonDB.insertPokemonDetails(newPokemonDetails);
      await PokemonDB.insertPokemonGalleries(newPokemonGalleries);

      updateState(pokemonList, newPokemonDetails);
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }
  // Fetch a detalles de pokemones dentro de paginacion
  static Future<List<PokemonDetail>> fetchPokemonDetailsForList(List<Pokemon> pokemonList) async {
    final List<Future<PokemonDetail>> futures = [];

    for (var pokemon in pokemonList) {
      futures.add(fetchPokemon(pokemon.url));
    }

    return await Future.wait(futures);
  }
  // Fetch a pokemon especifico mediante URL
  static Future<PokemonDetail> fetchPokemon(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PokemonDetail.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  // Fetch a siguiente conjunto de pokemones en paginacion infinita.
  static Future<void> fetchMoreData(String next, void Function(PokemonList, List<PokemonDetail>) updateState) async {
    final response = await http.get(Uri.parse(next));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newPokemonList = PokemonList.fromJson(data);
      final newPokemonDetails = await fetchPokemonDetailsForList(newPokemonList.results);
      final newPokemonGalleries = await fetchPokemonGalleriesForList(newPokemonList.results);

      // Insertando PokemonList en la base de datos
      await PokemonDB.insertPokemonList(newPokemonList);
      // Usando Batch para insertar detalles a base de datos.
      await PokemonDB.insertPokemonDetails(newPokemonDetails);
      await PokemonDB.insertPokemonGalleries(newPokemonGalleries);

      updateState(newPokemonList, newPokemonDetails);
    } else {
      throw Exception('Failed to load more Pokémons');
    }
  }

  // Fetch a detalle de Pokemon por su ID
  static Future<PokemonDetail> fetchPokemonDetailById(int pokemonId) async {
    final String url = 'https://pokeapi.co/api/v2/pokemon/$pokemonId/';
    final Future<PokemonDetail> pokemon = fetchPokemon(url);

    return pokemon;
  }

  static Future<void> fetchPokemonSearch(String identifier, void Function(List<PokemonDetail>) updateState, BuildContext context,) async {
    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$identifier/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemonDetail = PokemonDetail.fromJson(data);
        updateState([pokemonDetail]);
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      updateState([]); // Update state with an empty list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha encontrado este Pokemon.')),
      );
    }
  }

  /// ////////////////////////////////////// GALERIA ////////////////////////////////////////
  // Conjunto de funciones para fetch de Galerias
  static Future<void> fetchDataGallery(void Function(PokemonList, List<PokemonGallery>) updateState) async {
    final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pokemonList = PokemonList.fromJson(data);
      final newPokemonGalleries = await fetchPokemonGalleriesForList(pokemonList.results);

      // Insertando PokemonList en la base de datos
      await PokemonDB.insertPokemonList(pokemonList);
      // Usando Batch para insertar detalles a base de datos.
      await PokemonDB.insertPokemonGalleries(newPokemonGalleries);

      updateState(pokemonList, newPokemonGalleries);
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }
  // Fetch a galerias de pokemones dentro de paginacion
  static Future<List<PokemonGallery>> fetchPokemonGalleriesForList(List<Pokemon> pokemonList) async {
    final List<Future<PokemonGallery>> futures = [];

    for (var pokemon in pokemonList) {
      futures.add(fetchPokemonGallery(pokemon.url));
    }

    return await Future.wait(futures);
  }
  // Fetch a pokemon especifico mediante URL
  static Future<PokemonGallery> fetchPokemonGallery(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PokemonGallery.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  // Fetch a siguiente conjunto de pokemones Gallery en paginacion infinita.
  static Future<void> fetchMoreDataGallery(String next, void Function(PokemonList, List<PokemonGallery>) updateState) async {
    final response = await http.get(Uri.parse(next));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newPokemonList = PokemonList.fromJson(data);
      final newPokemonGalleries = await fetchPokemonGalleriesForList(newPokemonList.results);

      // Insertando PokemonList en la base de datos
      await PokemonDB.insertPokemonList(newPokemonList);
      // Usando Batch para insertar detalles a base de datos.
      await PokemonDB.insertPokemonGalleries(newPokemonGalleries);

      updateState(newPokemonList, newPokemonGalleries);
    } else {
      throw Exception('Failed to load more Pokémons');
    }
  }

  // Fetch a galeria de Pokemon por su ID
  static Future<PokemonGallery> fetchPokemonGalleryById(int pokemonId) async {
    final String url = 'https://pokeapi.co/api/v2/pokemon/$pokemonId/';
    final Future<PokemonGallery> pokemon = fetchPokemonGallery(url);

    return pokemon;
  }

  static Future<void> fetchPokemonGallerySearch(String identifier, void Function(List<PokemonGallery>) updateState, BuildContext context,) async {
    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$identifier/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemonGallery = PokemonGallery.fromJson(data);
        updateState([pokemonGallery]);
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      updateState([]); // Update state with an empty list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha encontrado este Pokemon.')),
      );
    }
  }

  /// ///////////////////////////////////////////////////////////////////////////////////////

  // Fetch a Pokemon con ID generado aleatoriamente al llamar la funcion
  static Future<PokemonDetail> fetchRandomPokemonDetail() async {
    final randomId = Random().nextInt(1016) + 1;
    final String url = 'https://pokeapi.co/api/v2/pokemon/$randomId/';
    final Future<PokemonDetail> pokemon = fetchPokemon(url);

    return pokemon;
  }

  static Future<List<PokemonDetail>> fetchEvoluciones(String nombrePokemon) async {
    final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$nombrePokemon"));

    if (response.statusCode == 200) {
      final datosPokemon = json.decode(response.body);
      final especieUrl = datosPokemon["species"]["url"];

      final especieResponse = await http.get(Uri.parse(especieUrl));
      if (especieResponse.statusCode == 200) {
        final datosEspecie = json.decode(especieResponse.body);
        final cadenaEvolucionUrl = datosEspecie["evolution_chain"]["url"];

        final cadenaEvolucionResponse = await http.get(Uri.parse(cadenaEvolucionUrl));
        if (cadenaEvolucionResponse.statusCode == 200) {
          final datosCadenaEvolucion = json.decode(cadenaEvolucionResponse.body);
          final cadenaEvolucion = await getPokemonDetailsFromChain(datosCadenaEvolucion, nombrePokemon);
          return cadenaEvolucion;
        } else {
          print("No se pudo obtener la cadena de evolución.");
          return [];
        }
      } else {
        print("No se pudo obtener la información de la especie.");
        return [];
      }
    } else {
      print("No se pudo obtener la información del Pokémon.");
      return [];
    }
  }

  static Future<List<PokemonDetail>> getPokemonDetailsFromChain(Map<String, dynamic> datosCadenaEvolucion, String nombrePokemon) async {
    final List<PokemonDetail> cadenaEvolucion = [];

    Future<void> procesarEspecie(Map<String, dynamic> especie) async {
      final nombreEspecie = especie["species"]["name"];
      if (nombreEspecie != nombrePokemon) {
        final PokemonDetail pokemonDetail = await fetchPokemon("https://pokeapi.co/api/v2/pokemon/$nombreEspecie");
        cadenaEvolucion.add(pokemonDetail);
      }

      if (especie["evolves_to"] != null) {
        for (final evolucion in especie["evolves_to"]) {
          await procesarEspecie(evolucion);
        }
      }
    }

    final especieInicial = datosCadenaEvolucion["chain"];
    await procesarEspecie(especieInicial);

    return cadenaEvolucion;
  }


  static Future<String> fetchMoveDescription(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> flavorTextEntries = data['flavor_text_entries'];

      // Find the first flavor text entry with language "en"
      final englishFlavorTextEntry = flavorTextEntries.firstWhere(
            (entry) => entry['language']['name'] == 'en',
        orElse: () => null,
      );

      if (englishFlavorTextEntry != null) {
        return englishFlavorTextEntry['flavor_text'];
      }
    }

    // If no valid entry found or response code wasn't 200, return a default value
    return 'No Description';
  }


  static Future<List<Move>> fetchMovesByPokemonId(int pokemonId) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonId/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> pokemonData = json.decode(response.body);
      final List<dynamic> movesData = pokemonData['moves'];

      List<Move> moves = movesData.map((move) => Move.fromJson(move)).toList();
      return moves;
    } else {
      throw Exception('Failed to load moves');
    }
  }

  static Future<void> fetchSampleDataToDB() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/?offset=0&limit=300');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final PokemonList pokemonList = PokemonList.fromJson(data);
        final List<PokemonDetail> newPokemonDetails = await ApiService.fetchPokemonDetailsForList(pokemonList.results);
        final List<PokemonGallery> newPokemonGalleries = await ApiService.fetchPokemonGalleriesForList(pokemonList.results);

        await PokemonDB.insertPokemonList(pokemonList);
        await PokemonDB.insertPokemonDetails(newPokemonDetails);
        await PokemonDB.insertPokemonGalleries(newPokemonGalleries);

      } else {
        print('Failed to fetch sample data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during sample data fetch: $e');
    }
  }


}