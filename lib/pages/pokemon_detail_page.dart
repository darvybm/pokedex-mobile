import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/services/api_service.dart';
import 'package:temp/utils/colors.dart';
import 'package:temp/utils/screen_sizes.dart';
import 'package:temp/widgets/appbar_widget.dart';
import 'package:temp/utils/general_utils.dart';
import 'package:temp/database/pokemon_database.dart';
import 'package:temp/models/pokemonMove.dart';
import 'package:temp/widgets/pokemon_card_evolution.dart';
import 'home_page.dart';

class PokemonDetailPage extends StatefulWidget {
  final PokemonDetail pokemonDetail;
  const PokemonDetailPage({super.key, required this.pokemonDetail});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> with SingleTickerProviderStateMixin{
  bool isFavorite = false;
  double detailsStackHeight = 0.32;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String arrow = 'assets/images/icons/upIcon.svg';
  late List<Move>? moves;
  bool isLoadingMoves = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(
      begin: detailsStackHeight,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
    fetchMoves();
    getFavoriteStatus();
  }

  void fetchMoves() async {
    try {
      List<Move> fetchedMoves  = await ApiService.fetchMovesByPokemonId(widget.pokemonDetail.id);
      setState(() {
        moves = fetchedMoves;
        isLoadingMoves = false;
      });
    } catch (error) {
      print('Error fetching moves: $error');
      setState(() {
        isLoadingMoves = false; // Set loading state to false after an error
      });    }
  }

  Future<void> getFavoriteStatus() async {
    final bool favorite = await PokemonDB.isPokemonFavorite(widget.pokemonDetail.id);
    setState(() {
      isFavorite = favorite;
    });
  }

  void _toggleContainerHeight() {
    if (detailsStackHeight == 0.32) {
      detailsStackHeight = 0.7;

    } else {
      detailsStackHeight = 0.32;
    }
    _animation = Tween<double>(
      begin: detailsStackHeight == 0.32 ? 0.7 : 0.32,
      end: detailsStackHeight,
    ).animate(_animationController);

    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pokemon'),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  height: ScreenUtil.diagonal(context) * 0.6,
                  width: ScreenUtil.screenWidth(context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgrounds/${widget.pokemonDetail.types[0].name}.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    ),
                  ),
                ),
                Container(
                  height: ScreenUtil.diagonal(context) * 0.76,
                  width: ScreenUtil.screenWidth(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MyColors.getColorByType(widget.pokemonDetail.types[0].name).withOpacity(0.8),
                        MyColors.getColorByType(widget.pokemonDetail.types[0].name)[1000]!.withOpacity(0.8),
                      ],
                    ),
                     borderRadius: const BorderRadius.only(
                       topLeft: Radius.circular(20),
                       topRight: Radius.circular(20)
                     ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Spacer(), // Este widget expande el espacio entre el Switch y la imagen.
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? MyColors.greyLight : MyColors.greyLight,
                                size: ScreenUtil.diagonal(context) * 0.05,
                              ),
                              onPressed: () async {
                                if (isFavorite) {
                                  await PokemonDB.removeFavoritePokemon(widget.pokemonDetail.id);
                                } else {
                                  await PokemonDB.insertFavoritePokemon(widget.pokemonDetail.id);
                                }

                                // Update the local state to reflect the changes
                                setState(() {
                                  isFavorite = !isFavorite;
                                });

                                final snackBarText = isFavorite
                                    ? 'Se ha agregado ${widget.pokemonDetail.name} a favoritos.'
                                    : 'Se ha removido ${widget.pokemonDetail.name} de favoritos.';
                                final snackBar = SnackBar(
                                  content: Text(snackBarText),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil.diagonal(context) * 0.23,
                        child: CachedNetworkImage(
                          imageUrl: widget.pokemonDetail.officialFrontDefaultImg!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        GeneralUtils.capitalizeFirstLetter(widget.pokemonDetail.name),
                        style: TextStyle(
                            fontSize: ScreenUtil.diagonal(context) * 0.04,
                            fontWeight: FontWeight.bold,
                            color: MyColors.greyLight),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for(int i = 0; i < widget.pokemonDetail.types.length; i++)
                              typeWidget(context, widget.pokemonDetail.types[i].name),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.diagonal(context) * 0.002,
                  left: ScreenUtil.diagonal(context) * 0.01,
                  child: Text(
                    widget.pokemonDetail.id.toString().padLeft(3, '0'),
                    style: TextStyle(
                        fontSize: ScreenUtil.diagonal(context) * 0.06,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withOpacity(0.1)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onVerticalDragEnd: (_) {
                _toggleContainerHeight();
              },
              child: Container(
                height: ScreenUtil.diagonal(context) * _animation.value,
                width: ScreenUtil.screenWidth(context),
                decoration: const BoxDecoration(
                  color: Color(0xFFD2D2D2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      arrow,
                      width: ScreenUtil.diagonal(context) * 0.03,
                      colorFilter: ColorFilter.mode(MyColors.darkGray.withOpacity(0.2), BlendMode.srcIn),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTabController(
                          length: 3, // Número de pestañas
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD2D2D2), // Color de fondo del contenedor
                                  borderRadius: BorderRadius.circular(25), // Radio de las esquinas del contenedor
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyColors.darkGray.withOpacity(0.8), // Color de la sombra
                                      blurRadius: 10, // Radio de desenfoque de la sombra
                                      offset: const Offset(0, 4), // Desplazamiento de la sombra
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: TabBar(
                                    tabs: const [
                                      Tab(text: "    Datos    "),
                                      Tab(text: " Movimientos "),
                                      Tab(text: " Evoluciones ")
                                    ],
                                    labelColor: MyColors.greyLight,
                                    unselectedLabelColor: MyColors.darkGray,
                                    indicator: BoxDecoration(
                                      color: MyColors.getColorByType(widget.pokemonDetail.types[0].name)[750]!.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(50), // Radio del círculo
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    // Contenido de la pestaña "Datos"
                                    StatsCard(widget.pokemonDetail),

                                    // Contenido de la pestaña "Movimientos"
                                    isLoadingMoves
                                    ? const Center(child: LoadingAnimation(),)
                                    : moves != null
                                      ? MovesCard(widget.pokemonDetail, moves!)
                                      : const SizedBox(),
                                    // Contenido de la pestaña "Evoluciones"
                                    Center(
                                      child: FutureBuilder<List<PokemonDetail>>(
                                        future: ApiService.fetchEvoluciones(widget.pokemonDetail.name),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return const Text('Error al obtener las evoluciones');
                                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                            return const Text('No se encontraron evoluciones para este Pokémon.');
                                          } else {
                                            bool _isLoading = true;
                                            return ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                if (index == snapshot.data!.length) {
                                                  if (_isLoading) {
                                                    return const Center(
                                                      child: LoadingAnimation(),
                                                    );
                                                  } else {
                                                    _isLoading = false;
                                                  }
                                                } else if (index == snapshot.data!.length + 1) {
                                                  if (_isLoading) {
                                                    return const Center(
                                                      child: LoadingAnimation(),
                                                    );
                                                  } else {
                                                    _isLoading = false; //Placeholder para mantener dimensiones de pag
                                                  }
                                                }
                                                final PokemonDetail pokemonDetail = snapshot.data![index];
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
                                                    child: PokemonCardEvolution(index: index, pokemon: pokemonDetail),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
            ),
            ),
        ],
      ),
    );
  }

  Widget typeWidget(BuildContext context, String type) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(8),
      width:
          ScreenUtil.diagonal(context) * 0.05 + 5, // Ancho del círculo + margen
      height:
          ScreenUtil.diagonal(context) * 0.05 + 5, // Alto del círculo + margen
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.getColorByType(type)[750], // Color negro con transparencia
        boxShadow: [
          BoxShadow(offset: Offset(2, 2), blurRadius: 5, color: Colors.black.withOpacity(0.5), spreadRadius: 1)
        ]
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/types/$type.svg',
          width: ScreenUtil.diagonal(context) *
              0.025, // Ancho del ícono dentro del círculo
        ),
      ),
    );
  }
}

class MovesCard extends StatelessWidget {
  final PokemonDetail pokemonDetail;
  final List<Move> moves;

  MovesCard(this.pokemonDetail, this.moves);

  @override
  Widget build(BuildContext context) {
    Color baseColor = MyColors.getColorByType(pokemonDetail.types[0].name)[750]!
        .withOpacity(0.8);
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDEDEDE), // Color de fondo del Container
                borderRadius:
                BorderRadius.circular(20), // Redondea las esquinas
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Color de la sombra
                    blurRadius: 5, // Radio de desenfoque de la sombra
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Movimientos',
                          style: TextStyle(
                            fontSize: ScreenUtil.diagonal(context) * 0.025,
                            fontWeight: FontWeight.bold,
                            color: MyColors.greyLight, // Color del texto en el círculo verde
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      for(int i = 0; i < moves.length; i++)
                    GestureDetector(
                      onTap: () async {
                      String moveDescription = await ApiService.fetchMoveDescription(moves[i].url);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: baseColor, // Color del borde verde
                                      width: 2, // Grosor del borde
                                    ),
                                  ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        // Botón redondo de información
                                        Container(
                                          width: ScreenUtil.diagonal(context) * 0.04,
                                          height: ScreenUtil.diagonal(context) * 0.04,
                                          decoration: BoxDecoration(
                                            color: baseColor, // Color del botón (verde)
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '¡',
                                              style: TextStyle(
                                                color: Colors.white, // Color del icono (blanco)
                                                fontWeight: FontWeight.bold,
                                                fontSize: ScreenUtil.diagonal(context) * 0.025,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10), // Espacio entre el botón y el texto
                                        // Habilidad del Pokémon
                                        Expanded(
                                          child: Text(
                                            'Descripción',
                                            style: TextStyle(
                                              color: MyColors.darkGray, // Color del texto (blanco)
                                              fontSize: ScreenUtil.diagonal(context) * 0.02,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                  moveDescription,
                                  style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      },
                      child: _buildMoveItem(
                      title: GeneralUtils.capitalizeFirstLetter(moves[i].name),
                      context: context,
                      baseColor: baseColor,
                      ),
                    )

                    ],
                  )
                ],
              ),
            )
        ),
      ],
    );
  }

  Widget _buildMoveItem({
    required String title,
    required BuildContext context,
    required Color baseColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: baseColor, // Color del borde verde
          width: 2, // Grosor del borde
        ),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          // Botón redondo de información
          Container(
            width: ScreenUtil.diagonal(context) * 0.04,
            height: ScreenUtil.diagonal(context) * 0.04,
            decoration: BoxDecoration(
              color: baseColor, // Color del botón (verde)
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '¡',
                style: TextStyle(
                  color: Colors.white, // Color del icono (blanco)
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil.diagonal(context) * 0.025,
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Espacio entre el botón y el texto
          // Habilidad del Pokémon
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: MyColors.darkGray, // Color del texto (blanco)
                fontSize: ScreenUtil.diagonal(context) * 0.02,),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final PokemonDetail pokemonDetail;
  StatsCard(this.pokemonDetail);

  @override
  Widget build(BuildContext context) {
    Color baseColor = MyColors.getColorByType(pokemonDetail.types[0].name)[750]!.withOpacity(0.8);
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDEDEDE), // Color de fondo del Container
                borderRadius: BorderRadius.circular(20), // Redondea las esquinas
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Color de la sombra
                    blurRadius: 5, // Radio de desenfoque de la sombra
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoItem(
                        title: 'Altura',
                        value: GeneralUtils.convertHeightToMeters(pokemonDetail.height),
                        borderColor: baseColor, // Color del borde verde
                        context: context,
                        baseColor: baseColor,
                      ),
                      _buildInfoItem(
                        title: 'Peso',
                        value: GeneralUtils.convertWeightToKilograms(pokemonDetail.weight),
                        borderColor: baseColor, // Color del borde verde
                        context: context,
                        baseColor: baseColor,
                      ),
                    ],
                  )
                ],
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDEDEDE), // Color de fondo del Container
                borderRadius:
                    BorderRadius.circular(20), // Redondea las esquinas
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Color de la sombra
                    blurRadius: 5, // Radio de desenfoque de la sombra
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: baseColor, // Color del círculo verde
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Habilidades',
                          style: TextStyle(
                            fontSize: ScreenUtil.diagonal(context) * 0.025,
                            fontWeight: FontWeight.bold,
                            color: MyColors.greyLight, // Color del texto en el círculo verde
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(int i = 0; i < pokemonDetail.abilities.length; i++)
                      _buildHabilidadItem(title: GeneralUtils.capitalizeFirstLetter(pokemonDetail.abilities[i].name), context: context, baseColor: baseColor)
                    ],
                  )
                ],
              ),
            )
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFDEDEDE), // Color de fondo del Container
              borderRadius: BorderRadius.circular(20), // Redondea las esquinas
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // Color de la sombra
                  blurRadius: 5, // Radio de desenfoque de la sombra
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: baseColor, // Color del círculo verde
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Stats',
                        style: TextStyle(
                          fontSize: ScreenUtil.diagonal(context) * 0.025,
                          fontWeight: FontWeight.bold,
                          color: MyColors.greyLight, // Color del texto en el círculo verde
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    for(int i = 0; i < pokemonDetail.stats.length; i++)
                    _buildInfoStats(
                        title: GeneralUtils.capitalizeFirstLetter(pokemonDetail.stats[i].name), value: pokemonDetail.stats[i].base_stat.toString(), context: context, baseColor: baseColor,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String value,
    required Color borderColor,
    required BuildContext context,
    required Color baseColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil.diagonal(context) * 0.025),
        border: Border.all(
          color: borderColor, // Color del borde verde
          width: 2, // Grosor del borde
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.diagonal(context) * 0.003, horizontal: ScreenUtil.diagonal(context) * 0.050),
      margin: EdgeInsets.all(ScreenUtil.diagonal(context) * 0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil.diagonal(context) * 0.015,
              color: MyColors.darkGray, // Color del título (dark gray)
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ScreenUtil.diagonal(context) * 0.02,
              color: baseColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabilidadItem({
    required String title,
    required BuildContext context,
    required Color baseColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: baseColor, // Color del borde verde
          width: 2, // Grosor del borde
        ),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          // Botón redondo de información
          Container(
            width: ScreenUtil.diagonal(context) * 0.04,
            height: ScreenUtil.diagonal(context) * 0.04,
            decoration: BoxDecoration(
              color: baseColor, // Color del botón (verde)
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '¡',
                style: TextStyle(
                  color: Colors.white, // Color del icono (blanco)
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil.diagonal(context) * 0.025,
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Espacio entre el botón y el texto
          // Habilidad del Pokémon
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: MyColors.darkGray, // Color del texto (blanco)
                  fontSize: ScreenUtil.diagonal(context) * 0.02,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStats({
    required String title,
    required String value,
    required BuildContext context,
    required Color baseColor,
  }) {
    final int parsedValue = int.tryParse(value) ?? 0; // Parsea el valor a entero o establece 0 por defecto
    final double progress = parsedValue / 255; // Calcula el progreso de 0 a 1 basado en 255

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil.diagonal(context) * 0.02,
              color: MyColors.darkGray,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              width: ScreenUtil.diagonal(context) * 0.05,
              height: ScreenUtil.diagonal(context) * 0.05,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/stats/${title.toLowerCase().replaceAll(' ', '-')}.svg',
                  colorFilter: const ColorFilter.mode(MyColors.greyLight, BlendMode.srcIn),
                  height: ScreenUtil.diagonal(context) * 0.022,
                  width: ScreenUtil.diagonal(context) * 0.022,
                ),
              ),
            ),
            SizedBox(width: ScreenUtil.diagonal(context) * 0.01),
            Container(
              width: ScreenUtil.screenWidth(context) * 0.65,
              height: ScreenUtil.diagonal(context) * 0.05,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: baseColor,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: ScreenUtil.screenWidth(context) * 0.45,
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: ScreenUtil.diagonal(context) * 0.02,
                        color: baseColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _pokemonGalleryWidget(BuildContext context, PokemonDetail pokemonDetail) {
  return Container(
    width: ScreenUtil.screenWidth(context),
    height: ScreenUtil.diagonal(context) * 0.14,
    decoration: BoxDecoration(
      color: MyColors.getColorByType(pokemonDetail.types[0].name)[750]!.withOpacity(0.8),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Galería',
                style: TextStyle(
                    fontSize: ScreenUtil.diagonal(context) * 0.035,
                    fontWeight: FontWeight.bold,
                    color: MyColors.greyLight),
              ),
            ),
            SvgPicture.asset('assets/images/icons/galleryIcon.svg',
                colorFilter: const ColorFilter.mode(
                    MyColors.greyLight, BlendMode.srcIn),
                width: ScreenUtil.diagonal(context) * 0.06)
          ],
        )
      ],
    ),
  );
}