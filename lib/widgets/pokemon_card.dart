import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/utils/colors.dart';
import 'package:temp/utils/screen_sizes.dart';
import 'package:temp/utils/general_utils.dart';

class PokemonCard extends StatelessWidget {
  final int index;
  final PokemonDetail pokemon;
  const PokemonCard({super.key, required this.index, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.getColorByType(pokemon.types[0].name).withOpacity(0.8),
            MyColors.getColorByType(pokemon.types[0].name)[1000]!.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              'assets/images/icons/pokeballcon.svg',
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.05), BlendMode.srcIn),
              width: ScreenUtil.diagonal(context) * 0.1,
            ),
          ),
          Positioned(
            top: ScreenUtil.diagonal(context) * 0.04,
            right: ScreenUtil.diagonal(context) * 0.01,
            child: Text(
              pokemon.id.toString().padLeft(3, '0'),
              style: TextStyle(
                fontSize: ScreenUtil.diagonal(context) * 0.025,
                fontWeight: FontWeight.w900,
                color: Colors.black.withOpacity(0.1)
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  GeneralUtils.capitalizeFirstLetter(pokemon.name),
                  style: TextStyle(
                    fontSize: pokemon.name.length > 18
                        ? ScreenUtil.diagonal(context) * 0.018  // Reduce font size if name is over 18 characters
                        : ScreenUtil.diagonal(context) * 0.02,  // Default font size
                    fontWeight: FontWeight.bold,
                    color: MyColors.greyLight,
                  ),
                )
              ),
              if (pokemon.officialFrontDefaultImg != null)
                CachedNetworkImage(
                  imageUrl: pokemon.officialFrontDefaultImg!,
                  width: ScreenUtil.diagonal(context) * 0.09,
                  placeholder: (context, url) => SizedBox(height: ScreenUtil.diagonal(context) * 0.09),
                )
              else
                Text(
                  'No image available',
                  style: TextStyle(
                    fontSize: ScreenUtil.diagonal(context) * 0.02,
                    color: MyColors.greyLight,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(int i = 0; i < pokemon.types.length; i++)
                  typeWidget(context, pokemon.types[i].name),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget typeWidget(BuildContext context, String type) {
  return Container(
    margin: EdgeInsets.all(ScreenUtil.diagonal(context) * 0.005),
    padding: EdgeInsets.all(ScreenUtil.diagonal(context) * 0.006),
    width: ScreenUtil.diagonal(context) * 0.03 + 5, // Ancho del círculo + margen
    height: ScreenUtil.diagonal(context) * 0.03 + 5, // Alto del círculo + margen
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: MyColors.getColorByType(type),
        boxShadow: [
          BoxShadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black.withOpacity(0.3), spreadRadius: 1.5)
        ]
    ),
    child: Center(
      child: SvgPicture.asset(
        'assets/images/types/$type.svg',
      width: ScreenUtil.diagonal(context) * 0.025, // Ancho del ícono dentro del círculo
      ),
    ),
  );
}

