import 'package:temp/models/pokemon.dart';

class PokemonList {
  final int count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  PokemonList({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    List<Pokemon> results = (json['results'] as List)
        .map((result) => Pokemon.fromJson(result))
        .toList();

    return PokemonList(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: results,
    );
  }
}
