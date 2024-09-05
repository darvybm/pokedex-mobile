import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/utils/colors.dart';
import 'package:temp/utils/screen_sizes.dart';
import 'package:temp/widgets/appbar_widget.dart';
import 'package:temp/utils/general_utils.dart';

import '../models/pokemon_gallery.dart';
import '../widgets/gallery_dots_indicator.dart';
import 'home_page.dart';

class PokemonGalleryDetailPage extends StatefulWidget {
  final PokemonGallery pokemonGallery;
  const PokemonGalleryDetailPage({super.key, required this.pokemonGallery});

  @override
  State<PokemonGalleryDetailPage> createState() => _PokemonGalleryDetailPageState();
}

class _PokemonGalleryDetailPageState extends State<PokemonGalleryDetailPage> with SingleTickerProviderStateMixin{
  int _current = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gallery'),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  height: ScreenUtil.diagonal(context) * 0.8,
                  width: ScreenUtil.screenWidth(context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgrounds/${widget.pokemonGallery.types[0].name}.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    ),
                  ),
                ),
                Container(
                  height: ScreenUtil.diagonal(context) * 0.8,
                  width: ScreenUtil.screenWidth(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MyColors.getColorByType(widget.pokemonGallery.types[0].name).withOpacity(0.8),
                        MyColors.getColorByType(widget.pokemonGallery.types[0].name)[1000]!.withOpacity(0.8),
                      ],
                    ),
                     borderRadius: const BorderRadius.only(
                       topLeft: Radius.circular(20),
                       topRight: Radius.circular(20)
                     ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: ScreenUtil.diagonal(context) * 0.025),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          GeneralUtils.capitalizeFirstLetter(widget.pokemonGallery.name),
                          style: TextStyle(
                              fontSize: ScreenUtil.diagonal(context) * 0.06,
                              fontWeight: FontWeight.bold,
                              color: MyColors.greyLight),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for(int i = 0; i < widget.pokemonGallery.types.length; i++)
                                typeWidget(context, widget.pokemonGallery.types[i].name),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
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
                          items: widget.pokemonGallery.sprites.where((url) => url != null).map((url) {
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
                          dotsCount: widget.pokemonGallery.sprites.where((url) => url != null).length,
                          activeIndex: _current,
                          activeDot: SvgPicture.asset('assets/images/icons/pokeballOpenIcon.svg',
                            width: 40,
                            height: 40,
                            color: MyColors.greyLight,
                          ),
                          inactiveDot: SvgPicture.asset('assets/images/icons/pokeballcon.svg',
                            width: 22,
                            height: 22,
                            color: MyColors.greyLight,
                          ),
                        ),

                        CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.2, // Tamaño de la miniatura en relación con el carrusel principal
                            enableInfiniteScroll: false,
                          ),
                          items: widget.pokemonGallery.sprites
                              .where((url) => url != null)
                              .map((url) {
                            if (url!.endsWith('.svg')) {
                              return Center(
                                child: SvgPicture.network(
                                  url,
                                  placeholderBuilder: (BuildContext context) =>
                                  const Center(
                                    child: LoadingAnimation(),
                                  ),
                                  height: 100, // Tamaño de la miniatura
                                  width: 100, // Tamaño de la miniatura
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
                      ],
                    ),
                  ),
                ),
              ],
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