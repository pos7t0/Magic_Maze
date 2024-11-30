import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:magic_maze/models/magic_card.dart';

class DatabaseHelper {
  static const _databaseName = 'MagicMaze.db';
  static const _databaseVersion = 1;

  static const tableDecks = 'decks';
  static const tableCards = 'cards';

  Database? _database;

  // Abre la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si no existe, crea una nueva base de datos
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa la base de datos
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $tableDecks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      ''');

      await db.execute('''
       CREATE TABLE $tableCards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER,
        cardId TEXT, -- Cambiado a TEXT para que SQLite trate el ID como string
        name TEXT,
        type TEXT,
        rarity TEXT,
        text TEXT,
        manaCost TEXT,
        colors TEXT,
        power INTEGER,
        toughness INTEGER,
        imageUrl TEXT,
        FOREIGN KEY (deckId) REFERENCES $tableDecks (id)
      )
      ''');
    });
  }

  // Inserta un nuevo mazo
  Future<int> insertDeck(String name) async {
    final db = await database;
    return await db.insert(tableDecks, {'name': name});
  }

  // Inserta una carta en un mazo
  Future<int> insertCard(int deckId, MagicCard card) async {
    final db = await database;
    return await db.insert(tableCards, {
      'deckId': deckId,
      'cardId': card.id,
      'name': card.name,
      'type': card.type,
      'rarity': card.rarity,
      'text': card.text,
      'manaCost': card.manaCost,
      'colors': card.colors.join(','),
      'power': card.power,
      'toughness': card.toughness,
      'imageUrl': card.imageUrl,
    });
  }

  // Recupera todos los mazos
  Future<List<Map<String, dynamic>>> getDecks() async {
    final db = await database;
    return await db.query(tableDecks);
  }

  // Recupera las cartas de un mazo
  Future<List<MagicCard>> getCardsByDeckId(int deckId) async {
    final db = await database;
    final result = await db.query(
      tableCards,
      where: 'deckId = ?',
      whereArgs: [deckId],
    );

    return result.map((json) => MagicCard.fromJson(json)).toList();
  }
}