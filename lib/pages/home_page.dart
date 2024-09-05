import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/utils/colors.dart';
import 'package:temp/utils/screen_sizes.dart';
import 'package:temp/widgets/appbar_widget.dart';
import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/services/api_service.dart';
import 'package:temp/utils/general_utils.dart';
import 'package:temp/database/pokemon_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    initializeDB();
  }

  Future<void> initializeDB() async {
    final isPokemonTableEmpty = await PokemonDB.isPokemonTableEmpty();

    if (isPokemonTableEmpty) {
      await ApiService.fetchSampleDataToDB();
    }
  }

  Future<PokemonDetail> fetchDailyPokemon() async {
    final lastFetchedPokemonData = await PokemonDB.getLastDailyPokemon();

    // Verifica si no se ha registrado pokemon o si ha pasado un día desde la última obtención
    if (lastFetchedPokemonData == null ||
        DateTime.now().difference(
            DateTime.parse(lastFetchedPokemonData['last_fetched_date'] ?? '')
        ).inHours > 24) {
      // Obtiene un nuevo Pokemon aleatorio
      final newPokemon = await ApiService.fetchRandomPokemonDetail();

      if (lastFetchedPokemonData != null) {
        // Si ya existe un Pokemon del dia, actualízalo con el nuevo Pokemon y la hora actual
        await PokemonDB.updateDailyPokemon(newPokemon.id, DateTime.now().toIso8601String());
      } else {
        // Si no existe un Pokemon del dia, inserta el nuevo ID del Pokemon y la hora actual
        await PokemonDB.insertDailyPokemon(newPokemon.id, DateTime.now().toIso8601String());
      }

      return newPokemon;
    } else {
      // Devuelve el Pokemon del dia obtenido previamente
      final int lastFetchedPokemonId = lastFetchedPokemonData['pokemon_id'] ?? 0; // Provide a default value
      return ApiService.fetchPokemonDetailById(lastFetchedPokemonId);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home'),
      body: Stack(
        children: [
          Positioned(
            bottom: -ScreenUtil.screenHeight(context) * 0.1,
            right: -ScreenUtil.screenWidth(context) * 0.3,
            child: SvgPicture.asset(
                'assets/images/icons/pokeballcon.svg',
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.05), BlendMode.srcIn),
                width: ScreenUtil.diagonal(context) * 0.5,
            ),
          ),

          Positioned(
            child: Padding(
              padding: EdgeInsets.all(
                ScreenUtil.diagonal(context) * 0.015
              ),
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: PokemonDB.getLastDailyPokemon(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: LoadingAnimation(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return FutureBuilder<PokemonDetail>(
                          future: fetchDailyPokemon(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: LoadingAnimation(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              final PokemonDetail? pokemonDetail = snapshot.data;

                              if (pokemonDetail != null) {
                                return dayPokemonWidget(context, pokemonDetail);
                              } else {
                                return const Center(
                                  child: Text('No Pokemon available.'),
                                );
                              }
                            }
                          },
                        );
                      } else {
                        final Map<String, dynamic> dailyPokemonData = snapshot.data!;
                        final PokemonDetail? pokemonDetail = dailyPokemonData['pokemon'];
                        if (pokemonDetail != null) {
                          return dayPokemonWidget(context, pokemonDetail);
                        } else {
                          return const Center(
                            child: Text('No Pokemon available.'),
                          );
                        }
                      }
                    },
                  ),


                  SizedBox(height: ScreenUtil.screenHeight(context) * 0.02),

                  Row(
                    children: [
                      Expanded(flex: 4, child: searchPokemonWidget(context)),
                      SizedBox(width: ScreenUtil.screenWidth(context) * 0.03),
                      Expanded(flex: 6, child: pokedexWidget(context))
                    ],
                  ),

                  SizedBox(height: ScreenUtil.screenHeight(context) * 0.02),

                  pokemonGalleryWidget(context),
                  SizedBox(height: ScreenUtil.screenHeight(context) * 0.02),

                ],
              )
            )
          )
        ],
      ),
    );
  }

  Widget dayPokemonWidget(BuildContext context, PokemonDetail pokemon) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/pokemonDetail',
          arguments: pokemon, // Pasar el objeto PokemonDetail como argumento
        );
      },
      child: Stack(
        children: [
          // Fondo de imagen con opacidad reducida
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/${pokemon.types[0].name}.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // Contenedor con degradado y contenido
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MyColors.getColorByType(pokemon.types[0].name).withOpacity(0.8),
                  MyColors.getColorByType(pokemon.types[0].name)[1000]!.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CachedNetworkImage(
                    imageUrl: pokemon.officialFrontDefaultImg!,
                    placeholder: (context, url) => LoadingAnimation(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover, // o el BoxFit que desees
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  'Pokemon del día',
                  style: TextStyle(
                    fontSize: ScreenUtil.diagonal(context) * 0.025,
                    fontWeight: FontWeight.bold,
                    color: MyColors.greyLight,
                  ),
                ),
                Text(
                  GeneralUtils.capitalizeFirstLetter(pokemon.name),
                  style: TextStyle(
                    fontSize: ScreenUtil.diagonal(context) * 0.025,
                    fontWeight: FontWeight.w300,
                    color: MyColors.greyLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchPokemonWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/favorite');
      },
      child: Container(
        height: ScreenUtil.screenHeight(context) * 0.15,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MyColors.blue,
              MyColors.blueDark
            ]
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Favoritos',
                style: TextStyle(
                  fontSize: ScreenUtil.diagonal(context) * 0.025,
                  fontWeight: FontWeight.bold,
                  color: MyColors.greyLight
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/icons/starIcon.svg',
              colorFilter: const ColorFilter.mode(MyColors.greyLight, BlendMode.srcIn),
              width: ScreenUtil.diagonal(context) * 0.065,
            ),
          ],
        ),
      ),
    );
  }

  Widget pokedexWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/pokedex');
      },
      child: Container(
        height: ScreenUtil.screenHeight(context) * 0.15,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MyColors.red,
              MyColors.redDark
            ]
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png',
              width: ScreenUtil.diagonal(context) * 0.10,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Pokedex',
                    style: TextStyle(
                      fontSize: ScreenUtil.diagonal(context) * 0.025,
                      fontWeight: FontWeight.bold,
                      color: MyColors.greyLight
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/icons/pokeballcon.svg',
                  colorFilter: const ColorFilter.mode(MyColors.greyLight, BlendMode.srcIn),
                  width: ScreenUtil.diagonal(context) * 0.065
                )
              ],
            )
          ],
        ),

      ),
    );
  }

  Widget pokemonGalleryWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/gallery');
      },
      child: Container(
        width: ScreenUtil.screenWidth(context),
        height: ScreenUtil.screenHeight(context) * 0.16,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MyColors.grey,
              MyColors.darkGray
            ]
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/305.png',
              width: ScreenUtil.diagonal(context) * 0.18,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Galería',
                    style: TextStyle(
                      fontSize: ScreenUtil.diagonal(context) * 0.035,
                      fontWeight: FontWeight.bold,
                      color: MyColors.greyLight
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/icons/galleryIcon.svg',
                  colorFilter: const ColorFilter.mode(MyColors.greyLight, BlendMode.srcIn),
                  width: ScreenUtil.diagonal(context) * 0.06
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});
  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
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
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              width: ScreenUtil.diagonal(context) * 0.06, // Tamaño fijo para la animación
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pokeballRotationController.dispose();
    super.dispose();
  }
}
