import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/models/pokemon_list.dart';
import 'package:temp/utils/colors.dart';
import 'package:temp/utils/screen_sizes.dart';
import 'package:temp/widgets/appbar_widget.dart';
import 'package:temp/widgets/pokemon_card.dart';
import 'package:temp/services/api_service.dart';
import 'package:temp/database/pokemon_database.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
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
        const SnackBar(content: Text('¡Has llegado al final de tu Pokedex!')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pokedex'),
      body: Stack(
        children: [
          // Widget para Pokeball de fondo
          Positioned(
            bottom: -ScreenUtil.screenHeight(context) * 0.1,
            right: -ScreenUtil.screenWidth(context) * 0.3,
            child: SvgPicture.asset(
              'assets/images/icons/pokeballcon.svg',
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.05), BlendMode.srcIn),
              width: ScreenUtil.diagonal(context) * 0.5,
            ),
          ),

          // Widget para contenido de pagina
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
              child: Column(
                children: [
                  // Widget de búsqueda
                  searchFieldWidget(),

                  const SizedBox(height: 10),
                  // Widget de Cartas de Pokemones
                  Expanded(
                    child: _pokemonDetailList.isEmpty
                    ? _searchController.text.isEmpty
                      // En caso de que la lista esté cargando por primera vez
                      ? const Center(child: LoadingAnimation(),)
                      // En caso de que la busqueda no encuentre Pokemon
                        : Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/pokemons/psyduck.png',
                              width: 250,
                              height: 250,
                            ),
                            const Text(
                              'Pokemon No Encontrado',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                _searchController.clear();
                                handleSearch();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_sync, size: 22),
                                  Text(
                                    ' Recargar',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    )
                    // En caso de que la lista sí contenga Pokemones
                    : GridView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: _pokemonDetailList.length + 2,
                      itemBuilder: (context, index) {
                        if (index == _pokemonDetailList.length) {
                          if (_isLoading) {
                            return const Center(
                              child: LoadingAnimation(),
                            );
                          } else {
                            return Container(); //Placeholder para mantener dimensiones de pag
                          }
                        } else if (index == _pokemonDetailList.length + 1) {
                          if (_isLoading) {
                            return const Center(
                              child: LoadingAnimation(),
                            );
                          } else {
                            return Container(); //Placeholder para mantener dimensiones de pag
                          }
                        }
                        final PokemonDetail pokemonDetail = _pokemonDetailList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil.diagonal(context) * 0.008,
                            horizontal: ScreenUtil.diagonal(context) * 0.008,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/pokemonDetail',
                                arguments: pokemonDetail, // Pasar el objeto PokemonDetail como argumento
                              );
                            },
                            child: PokemonCard(index: index, pokemon: pokemonDetail),
                          ),
                        );
                      },
                    )

                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  Widget searchFieldWidget() {
    return Container(
        decoration: BoxDecoration(
            color: MyColors.greyLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
                offset: Offset(0, 0),
                spreadRadius: -20,
              )
            ]),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _onSearchChanged(),
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  hintText: "Buscar por nombre o número",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: _searchController.text.isEmpty ? 20 : 10),
              child: GestureDetector(
                child: _searchController.text.isEmpty
                    ? const Icon(
                        Icons.search,
                        color: MyColors.greyDark,
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: MyColors.greyDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _searchController.clear();
                          handleSearch();
                        },
                      ),
              ),
            )
          ],
        )
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});
  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin{
  late AnimationController _pokeballRotationController;

  @override
  void initState() {
    super.initState();
    _pokeballRotationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pokeballRotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _pokeballRotationController.value * 2 * pi,
          child: UnconstrainedBox(
            child: SvgPicture.asset(
              'assets/images/icons/pokeballcon.svg',
              colorFilter: const ColorFilter.mode(MyColors.greyDark, BlendMode.srcIn),
              width: ScreenUtil.diagonal(context) * 0.06, // Tamaño fijo para la animación
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_pokeballRotationController.isAnimating) {
      _pokeballRotationController.stop();
    }
    _pokeballRotationController.dispose();
    super.dispose();
  }
}

