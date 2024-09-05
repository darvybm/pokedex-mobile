import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await initDB();

    return _database!;
  }

  // Create the database and the Pokemon table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pokedex.db');

    // TESTING: Para eliminar base de datos:
    // return databaseFactory.deleteDatabase(path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE Pokemon(
              id INTEGER PRIMARY KEY,
              name TEXT,
              url TEXT
            )
            ''');

          await db.execute('''
            CREATE TABLE PokemonDetail(
              id INTEGER PRIMARY KEY,
              name TEXT,
              weight INTEGER,
              height INTEGER,
              is_default INTEGER,
              species_name TEXT,
              official_front_default_img TEXT,
              official_front_shiny_img TEXT,
              types TEXT,
              stats TEXT,
              abilities TEXT
            )
          '''); // Types, stats, abilites stored as JSON-encoded string

          await db.execute('''
            CREATE TABLE FavoritePokemonDetail(
              id INTEGER PRIMARY KEY,
              pokemon_detail_id INTEGER,
              FOREIGN KEY (pokemon_detail_id) REFERENCES PokemonDetail(id)
            )
          ''');

          await db.execute('''
            CREATE TABLE DailyPokemon(
              id INTEGER PRIMARY KEY,
              pokemon_id INTEGER,
              last_fetched_date TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE PokemonGallery(
              id INTEGER PRIMARY KEY,
              name TEXT,
              types TEXT,
              sprites TEXT
            )
          ''');
        });
  }
}