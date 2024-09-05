import 'package:flutter/material.dart';
import 'package:temp/models/pokemon_detail.dart';
import 'package:temp/pages/api_test_page.dart';
import 'package:temp/pages/favorite_page.dart';
import 'package:temp/pages/gallery_page.dart';
import 'package:temp/pages/home_page.dart';
import 'package:temp/pages/pokedex_page.dart';
import 'package:temp/pages/pokemon_detail_page.dart';
import 'package:temp/database/db_provider.dart';
import 'package:temp/pages/pokemon_gallery_detail_page.dart';

import 'models/pokemon_gallery.dart';

void main() async {
  // Inicialización necesaria al hacer el main() async
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando Base de Datos
  await DBProvider.db.initDB();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inconsolata'),
      title: 'Pokedex App',
      initialRoute: '/',
      routes: {
        '/pruebaAPI': (context) => const ApiTestPage(),
        '/': (context) => const HomePage(),
        '/pokedex': (context) => const PokedexPage(),
        '/gallery': (context) => GalleryPage(),
        '/favorite': (context) => const FavoritePage()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/pokemonDetail') {
          final args = settings.arguments as PokemonDetail;
          return MaterialPageRoute(
            builder: (context) {
              return PokemonDetailPage(pokemonDetail: args);
            },
          );
        } else if (settings.name == '/pokemonGalleryDetail') {
          final args = settings.arguments as PokemonGallery;
          return MaterialPageRoute(
            builder: (context) {
              return PokemonGalleryDetailPage(pokemonGallery: args);
            },
          );
        }
        return null;
      },
    );
  }
}
