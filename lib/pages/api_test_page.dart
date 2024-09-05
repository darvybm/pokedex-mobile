import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:temp/widgets/appbar_widget.dart';
import 'package:temp/widgets/gallery_dots_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/models/pokemon.dart';
import 'package:temp/models/pokemon_list.dart';
import 'package:temp/models/pokemon_gallery.dart';
import 'package:temp/models/pokemonAbility.dart';
import 'package:temp/models/pokemonMove.dart';
import 'package:temp/services/api_service.dart';
import 'package:temp/database/db_provider.dart';
import 'package:temp/database/pokemon_database.dart';
import 'package:temp/utils/general_utils.dart';


class ApiTestPage extends StatelessWidget {
  const ApiTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Test Page'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final pokemonDetail = await ApiService.fetchPokemon('https://pokeapi.co/api/v2/pokemon/25/');
                  openPokemonPage(context, pokemonDetail);
                } catch (error) {
                  print('Error: $error');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Ver Pikachu',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandomPokemonPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Pokemon del Dia',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PokemonListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Lista de Pokemon',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PokemonGalleryListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Galería de Pokemon',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritosListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Mis Favoritos',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ApiService.fetchSampleDataToDB();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pokemons fetched successfully.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  child: const Text(
                    'Cargar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16), // Add some space between buttons
                ElevatedButton(
                  onPressed: () async {
                    await PokemonDB.clearPokemonTable();
                    await PokemonDB.clearPokemonGalleryTable();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pokemons cleared from DB successfully.'),
                        duration: Duration(seconds: 2),
                      ),
                    );                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.red, // You can set the color you prefer
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  child: const Text(
                    'Borrar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DbPokemonListPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Lista Desde BD',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openPokemonPage(BuildContext context, PokemonDetail pokemonDetail) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => PokemonPage(pokemon: pokemonDetail),
  ));
}

class PokemonPage extends StatefulWidget {
  final PokemonDetail pokemon;

  const PokemonPage({super.key, required this.pokemon});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    getFavoriteStatus();
  }

  Future<void> getFavoriteStatus() async {
    final bool favorite = await PokemonDB.isPokemonFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final favoriteProvider = Provider.of<FavoritePokemonProvider>(context);
    // final bool _isFavorite = favoriteProvider.favoritePokemon.contains(widget.pokemon);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pokemon'),
      body: SingleChildScrollView(
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const SizedBox(height: 10),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   GeneralUtils.capitalizeFirstLetter(widget.pokemon.name),
                   style: const TextStyle(
                     fontSize: 32,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 IconButton(
                   icon: Icon(
                     isFavorite ? Icons.favorite : Icons.favorite_border,
                     color: isFavorite ? Colors.red : null,
                   ),
                   onPressed: () async {
                     if (isFavorite) {
                       await PokemonDB.removeFavoritePokemon(widget.pokemon.id);
                     } else {
                       await PokemonDB.insertFavoritePokemon(widget.pokemon.id);
                     }

                     // Update the local state to reflect the changes
                     setState(() {
                       isFavorite = !isFavorite;
                     });

                     final snackBarText = isFavorite
                         ? 'Se ha agregado ${widget.pokemon.name} a favoritos.'
                         : 'Se ha removido ${widget.pokemon.name} de favoritos.';
                     final snackBar = SnackBar(
                       content: Text(snackBarText),
                     );
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                   },
                 ),
               ],
             ),
             const SizedBox(height: 25),
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Text(
                       'Pokemon Number: ',
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       widget.pokemon.id.toString(),
                     ),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Text(
                       'Height: ',
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       widget.pokemon.height.toString(),
                     ),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Text(
                       'Weight: ',
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       widget.pokemon.weight.toString(),
                     ),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Text(
                       'Species: ',
                       style: TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       widget.pokemon.speciesName,
                     ),
                   ],
                 ),
                 const SizedBox(height: 15),
                 for (int i = 0; i < widget.pokemon.types.length; i++)
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         'Type ${i + 1}: ',
                         style: const TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       Text(
                         widget.pokemon.types[i].name,
                       ),
                     ],
                   ),
                 const SizedBox(height: 15),
                 for (int i = 0; i < widget.pokemon.stats.length; i++)
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         '${widget.pokemon.stats[i].name}: ',
                         style: const TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       Text(
                         widget.pokemon.stats[i].base_stat.toString(),
                       ),
                     ],
                   ),
                 const SizedBox(height: 15),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => PokemonAbilitiesPage(abilities: widget.pokemon.abilities),
                           ),
                         );
                       },
                       style: ElevatedButton.styleFrom(
                         foregroundColor: Colors.black,
                         backgroundColor: Colors.grey,
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       ),
                       child: const Text(
                         'Lista Habilidades',
                         style: TextStyle(fontSize: 16),
                       ),
                     ),
                     ElevatedButton(
                       onPressed: () async {
                         try {
                           List<Move> moves = await ApiService.fetchMovesByPokemonId(widget.pokemon.id);

                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => PokemonMovesPage(moves: moves),
                             ),
                           );
                         } catch (error) {
                           print('Error fetching moves: $error');
                           // Handle error (show a snackbar, dialog, etc.)
                         }
                       },
                       style: ElevatedButton.styleFrom(
                         foregroundColor: Colors.black,
                         backgroundColor: Colors.grey,
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       ),
                       child: const Text(
                         'Lista Movimientos',
                         style: TextStyle(fontSize: 16),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 40),
                 SizedBox(
                   width: 300,
                   height: 300,
                   child: FutureBuilder<String?>(
                     future: () async {

                       if (widget.pokemon.officialFrontDefaultImg != null) {
                         await precacheImage(
                           NetworkImage(widget.pokemon.officialFrontDefaultImg!),
                           context,
                         );
                         return widget.pokemon.officialFrontDefaultImg;
                       }
                       /******   PARA ERROR DE CONCATENACION DE URL DE SPRITES   ******/
                       // if (pokemon.officialFrontDefaultImg != null) {
                       //   String trimmedImgUrl = pokemon.officialFrontDefaultImg!.substring(57);
                       //   await precacheImage(
                       //     NetworkImage(trimmedImgUrl),
                       //     context,
                       //   );
                       //   return trimmedImgUrl;
                       // }

                       return null;
                     }(),
                     builder: (context, snapshot) {
                       if (snapshot.connectionState == ConnectionState.waiting) {
                         return const Center(
                           child: CircularProgressIndicator(),
                         );
                       }
                       if (snapshot.hasError) {
                         return const Text('No image available');
                       } else {
                         if (snapshot.data != null) {
                           return Image.network(
                             snapshot.data!,
                             fit: BoxFit.cover,
                             width: 300,
                             height: 300,
                             errorBuilder: (context, error, stackTrace) {
                               if (error is NetworkImageLoadException) {
                                 return Image.asset(
                                   'assets/images/utils/no_image.png',
                                   width: 300,
                                   height: 300,
                                 );
                               } else {
                                 return const Text('Error loading image');
                               }
                             },
                           );
                         } else {
                           return const Text('No image available');
                         }
                       }
                     },
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
      ),
    );
  }
}

class PokemonAbilitiesPage extends StatefulWidget {
  final List<Ability> abilities;
  const PokemonAbilitiesPage({super.key, required this.abilities});

  @override
  _PokemonAbilitiesPageState createState() => _PokemonAbilitiesPageState();
}

class _PokemonAbilitiesPageState extends State<PokemonAbilitiesPage> {

  Future<String> fetchAbilityDescription(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> flavorTextEntries = data['flavor_text_entries'];

      if (flavorTextEntries.isNotEmpty) {
        return flavorTextEntries[0]['flavor_text'];
      }
    }
    return 'No Description';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Habilidades'),
      body: ListView.builder(
        itemCount: widget.abilities.length,
        itemBuilder: (context, index) {
          final ability = widget.abilities[index];
          return ListTile(
            title: Text(
              GeneralUtils.capitalizeFirstLetter(ability.name),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: FutureBuilder<String>(
              future: fetchAbilityDescription(ability.url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('No Description');
                } else {
                  return Text(snapshot.data ?? 'No Description');
                }
              },
            ),
          );
        },
      ),
    );
  }
}


class PokemonMovesPage extends StatefulWidget {
  final List<Move> moves;
  const PokemonMovesPage({super.key, required this.moves});

  @override
  _PokemonMovesPageState createState() => _PokemonMovesPageState();
}

class _PokemonMovesPageState extends State<PokemonMovesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Movimientos'),
      body: ListView.builder(
        itemCount: widget.moves.length,
        itemBuilder: (context, index) {
          final move = widget.moves[index];
          return ListTile(
            title: Text(
              GeneralUtils.capitalizeFirstLetter(move.name),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: FutureBuilder<String>(
              future: ApiService.fetchMoveDescription(move.url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('No Description');
                } else {
                  return Text(snapshot.data ?? 'No Description');
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late PokemonList _pokemonList;
  final List<PokemonDetail> _pokemonDetailList = [];
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pokemonList = PokemonList(count: 0, next: "", previous: "", results: []);
    _searchController = TextEditingController();
    _scrollController.addListener(_scrollListener);
    ApiService.fetchData(updateState);
  }

  bool get isSearchActive => _searchController.text.isNotEmpty;
  void _scrollListener() {
    if (isSearchActive || _isLoading) {
      return;
    }
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _onSearchChanged() async {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      try {
        final searchResults = await PokemonDB.searchPokemon(searchText);
        updateSearchState(searchResults);
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _pokemonDetailList.clear();
        _isLoading = true;
      });
      ApiService.fetchData(updateState);
    }
  }

  void handleSearch() {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      try {
        ApiService.fetchPokemonSearch(searchText.toLowerCase(), updateSearchState, context);
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _pokemonDetailList.clear();
      });
      ApiService.fetchData(updateState);
    }
  }

  void updateState(PokemonList pokemonList, List<PokemonDetail> newPokemonDetails) {
    setState(() {
      _pokemonList = pokemonList;
      _pokemonDetailList.addAll(newPokemonDetails);
      _isLoading = false;
    });
  }

  void updateSearchState(List<PokemonDetail> newPokemonDetails) {
    setState(() {
      _pokemonDetailList.clear();
      _pokemonDetailList.addAll(newPokemonDetails);
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    final nextUrl = _pokemonList.next;
    if (nextUrl != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await ApiService.fetchMoreData(nextUrl, updateState);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End of the list')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pokemon List'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(labelText: 'Buscar Pokemon por Nombre/ID'),
                    onChanged: (value) => _onSearchChanged(),
                    enabled: !_isLoading,
                  ),
                ),
                ElevatedButton(
                  onPressed: handleSearch,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          _pokemonDetailList.isEmpty
              ? _searchController.text.isNotEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.not_interested,
                          size: 64.0,
                          color: Colors.grey,
                        ),
                        Text('Pokémon not found'),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator())
              : Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _pokemonDetailList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _pokemonDetailList.length) {
                      if (_isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container(); // Placeholder.
                      }
                    }

                    final pokemonDetail = _pokemonDetailList[index];
                    return ListTile(
                      title: Text('${pokemonDetail.id}. ${GeneralUtils.capitalizeFirstLetter(pokemonDetail.name)}'),
                      subtitle: Text(
                        'Weight: ${pokemonDetail.weight} | Height: ${pokemonDetail.height}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        openPokemonPage(context, pokemonDetail);
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class PokemonGalleryListPage extends StatefulWidget {
  const PokemonGalleryListPage({super.key});

  @override
  _PokemonGalleryListPageState createState() => _PokemonGalleryListPageState();
}

class _PokemonGalleryListPageState extends State<PokemonGalleryListPage> {
  late PokemonList _pokemonList;
  final List<PokemonGallery> _pokemonGalleryList = [];
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pokemonList = PokemonList(count: 0, next: "", previous: "", results: []);
    _searchController = TextEditingController();
    _scrollController.addListener(_scrollListener);
    ApiService.fetchDataGallery(updateState);
  }

  bool get isSearchActive => _searchController.text.isNotEmpty;
  void _scrollListener() {
    if (isSearchActive || _isLoading) {
      return;
    }
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _onSearchChanged() async {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      try {
        final searchResults = await PokemonDB.searchPokemonGallery(searchText);
        updateSearchState(searchResults);
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _pokemonGalleryList.clear();
        _isLoading = true;
      });
      ApiService.fetchDataGallery(updateState);
    }
  }

  void handleSearch() {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      try {
        ApiService.fetchPokemonGallerySearch(searchText.toLowerCase(), updateSearchState, context);
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _pokemonGalleryList.clear();
      });
      ApiService.fetchDataGallery(updateState);
    }
  }

  void updateState(PokemonList pokemonList, List<PokemonGallery> newPokemonGallery) {
    setState(() {
      _pokemonList = pokemonList;
      _pokemonGalleryList.addAll(newPokemonGallery);
      _isLoading = false;
    });
  }

  void updateSearchState(List<PokemonGallery> newPokemonGallery) {
    setState(() {
      _pokemonGalleryList.clear();
      _pokemonGalleryList.addAll(newPokemonGallery);
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    final nextUrl = _pokemonList.next;
    if (nextUrl != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await ApiService.fetchMoreDataGallery(nextUrl, updateState);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End of the list')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gallery'),
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(labelText: 'Buscar Pokemon por Nombre/ID'),
                      onChanged: (value) => _onSearchChanged(),
                      enabled: !_isLoading,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: handleSearch,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Buscar'),
                  ),
                ],
              ),
            ),

            _pokemonList.results.isEmpty
              ? _searchController.text.isNotEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.not_interested,
                          size: 64.0,
                          color: Colors.grey,
                        ),
                        Text('Pokémon not found'),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _pokemonGalleryList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _pokemonGalleryList.length) {
                        if (_isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container(); // Placeholder.
                        }
                      }

                      final pokemonGallery = _pokemonGalleryList[index];
                      return ListTile(
                        title: Text('${pokemonGallery.id}. ${GeneralUtils.capitalizeFirstLetter(pokemonGallery.name)}'),
                        subtitle: Text(
                          'Types: ${pokemonGallery.types.map((type) => type.name).join(', ')}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          openGalleryPageTest(context, pokemonGallery);
                        },
                      );
                    },
                  ),
              ),
          ],
      ),
    );
  }
}

void openGalleryPageTest(BuildContext context, PokemonGallery pokemonGallery) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => GalleryPageTest(pokemonGallery: pokemonGallery),
  ));
}

class GalleryPageTest extends StatefulWidget {
  final PokemonGallery pokemonGallery;

  const GalleryPageTest({super.key, required this.pokemonGallery});

  @override
  State<GalleryPageTest> createState() => _GalleryPageTestState();
}

class _GalleryPageTestState extends State<GalleryPageTest> {
    int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Galería'),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Text(
                GeneralUtils.capitalizeFirstLetter(widget.pokemonGallery.name),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 100.0),
              child: Text(
                widget.pokemonGallery.types.map((type) => type.name).join(', '),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
              ),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: widget.pokemonGallery.sprites
                        .where((url) => url != null)
                        .map((url)
                    {
                      if (url!.endsWith('.svg')) {
                        return Center(
                          child: SvgPicture.network(
                            url,
                            placeholderBuilder: (BuildContext context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            height: 200,
                            width: 200,
                          ),
                        );
                      } else {
                        return Center(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(url),
                          ),
                        );
                      }
                    }).toList(),
                  ),
                  const SizedBox(height: 15),
                  CustomDotsIndicator(
                    dotsCount: widget.pokemonGallery.sprites
                        .where((url) => url != null)
                        .length,
                    activeIndex: _current,
                    activeDot: SvgPicture.asset('assets/images/icons/pokeballOpenIcon.svg',
                      width: 40,
                      height: 40,
                      color: Colors.black38,
                    ),
                    inactiveDot: SvgPicture.asset('assets/images/icons/pokeballcon.svg',
                      width: 22,
                      height: 22,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RandomPokemonPage extends StatefulWidget {
  const RandomPokemonPage({super.key});

  @override
  State<RandomPokemonPage> createState() => _RandomPokemonPageState();
}

class _RandomPokemonPageState extends State<RandomPokemonPage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      setState(() {});
    });
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pokemon Test'),
      body: Center(
        child: buildCountWidget(),
      ),
    );
  }

  Widget buildCountWidget() {
    return FutureBuilder<PokemonDetail>(
      future: ApiService.fetchRandomPokemonDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available.'),
            );
        } else {
          PokemonDetail pokemon = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    GeneralUtils.capitalizeFirstLetter(pokemon.name),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Pokemon Number: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pokemon.id.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Height: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pokemon.height.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Weight: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pokemon.weight.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Species: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pokemon.speciesName,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      for (int i = 0; i < pokemon.types.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Type ${i + 1}: ',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              pokemon.types[i].name,
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      for (int i = 0; i < pokemon.stats.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${pokemon.stats[i].name}: ',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              pokemon.stats[i].base_stat.toString(),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PokemonAbilitiesPage(
                                          abilities: pokemon.abilities),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Lista Habilidades',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PokemonMovesPage(moves: widget.pokemon.moves),
                              //   ),
                              // );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text(
                                        "Opción no disponible en estos momentos"
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Lista Movimientos',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: FutureBuilder<String?>(
                          future: () async {

                            if (pokemon.officialFrontDefaultImg != null) {
                              await precacheImage(
                                NetworkImage(pokemon.officialFrontDefaultImg!),
                                context,
                              );
                              return pokemon.officialFrontDefaultImg;
                            }
                            /****   PARA ERROR DE CONCATENACION DE URL DE SPRITES   *****/
                            // if (pokemon.officialFrontDefaultImg != null) {
                            //   String trimmedImgUrl = pokemon.officialFrontDefaultImg!.substring(57);
                            //   await precacheImage(
                            //     NetworkImage(trimmedImgUrl),
                            //     context,
                            //   );
                            //   return trimmedImgUrl;
                            // }

                            return null;
                          }(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              // Handle errors.
                              return const Text('No image available');
                            } else {
                              if (snapshot.data != null) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 300,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (error is NetworkImageLoadException) {
                                      return Image.asset(
                                        'assets/images/utils/no_image.png',
                                        width: 300,
                                        height: 300,
                                      );
                                    } else {
                                      return const Text('Error loading image');
                                    }
                                  },
                                );
                              } else {
                                return const Text('No image available');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class FavoritosListPage extends StatefulWidget {
  const FavoritosListPage({Key? key}) : super(key: key);

  @override
  _FavoritosListPageState createState() => _FavoritosListPageState();
}

class _FavoritosListPageState extends State<FavoritosListPage> {
  late List<PokemonDetail> favoritePokemonDetails = [];

  @override
  void initState() {
    super.initState();
    getFavoritePokemonDetails();
  }

  Future<void> getFavoritePokemonDetails() async {
    final List<PokemonDetail> favorites = await PokemonDB.getAllFavoritePokemonDetails();
    setState(() {
      favoritePokemonDetails = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Favorites'),
      // ignore: unnecessary_null_comparison
      body: favoritePokemonDetails != null
          ? ListView.builder(
              itemCount: favoritePokemonDetails.length,
              itemBuilder: (context, index) {
                final pokemonDetail = favoritePokemonDetails[index];
                return ListTile(
                  title: Text('${pokemonDetail.id}. ${pokemonDetail.name}'),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}



class DbPokemonListPage extends StatefulWidget {
  const DbPokemonListPage({Key? key}) : super(key: key);

  @override
  _DbPokemonListPageState createState() => _DbPokemonListPageState();
}

class _DbPokemonListPageState extends State<DbPokemonListPage> {
  late Future<List<Pokemon>> futurePokemonList;

  @override
  void initState() {
    super.initState();
    futurePokemonList = fetchPokemonListFromDB();
  }

  Future<List<Pokemon>> fetchPokemonListFromDB() async {
    final db = await DBProvider.db.database;
    final pokemonList = await db.query('Pokemon');

    return pokemonList.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Database'),
      body: FutureBuilder<List<Pokemon>>(
        future: futurePokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final pokemonList = snapshot.data;

            if (pokemonList == null || pokemonList.isEmpty) {
              return const Center(child: Text('No Pokemon in the database.'));
            }

            return ListView.builder(
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _onPokemonGalleryTap(context, pokemonList[index].id);
                  },
                  child: ListTile(
                    title: Text('${pokemonList[index].id}. ${pokemonList[index].name}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _onPokemonTap(BuildContext context, int pokemonId) async {
    // Retrieve PokemonDetail from the database using the id
    final PokemonDetail? pokemonDetail = await PokemonDB.getPokemonDetailById(pokemonId);

    if (pokemonDetail != null) {
      // Navigate to PokemonPage with the retrieved PokemonDetail
      openPokemonPage(context, pokemonDetail);
    }else {
      // Display a Snackbar when PokemonDetail is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PokemonDetail not found for id: $pokemonId'),
        ),
      );
    }
  }

  void _onPokemonGalleryTap(BuildContext context, int pokemonId) async {
    // Retrieve PokemonDetail from the database using the id
    final PokemonGallery? pokemonGallery = await PokemonDB.getPokemonGalleryById(pokemonId);

    if (pokemonGallery != null) {
      // Navigate to PokemonPage with the retrieved PokemonDetail
      openGalleryPageTest(context, pokemonGallery);
    }else {
      // Display a Snackbar when PokemonDetail is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PokemonDetail not found for id: $pokemonId'),
        ),
      );
    }
  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   DBProvider.db.clearPokemonTable();
  // }
}