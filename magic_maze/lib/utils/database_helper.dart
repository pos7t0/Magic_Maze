import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:magic_maze/models/magic_card.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'magic_cards.db');

    return await openDatabase(
      path,
      version: 2, // Incrementamos la versión para aplicar migraciones
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE magic_cards (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT,
        rarity TEXT,
        text TEXT,
        manaCost TEXT,
        colors TEXT,
        power INTEGER,
        toughness INTEGER,
        imageUrl TEXT,
        PRIMARY KEY (id, name) -- Permitir cartas repetidas si tienen el mismo id y nombre
      )
    ''');

    await db.execute('''
      CREATE TABLE decks_info (
        deck_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE deck_cards (
        deck_id INTEGER NOT NULL,
        card_id TEXT NOT NULL,
        card_name TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1, -- Permitir cantidades
        FOREIGN KEY (deck_id) REFERENCES decks_info(deck_id) ON DELETE CASCADE,
        FOREIGN KEY (card_id, card_name) REFERENCES magic_cards(id, name) ON DELETE CASCADE,
        PRIMARY KEY (deck_id, card_id, card_name)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Añadir migraciones si la versión de la base de datos se incrementa
      await db.execute('''
        CREATE TABLE decks_info (
          deck_id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE deck_cards (
          deck_id INTEGER NOT NULL,
          card_id TEXT NOT NULL,
          card_name TEXT NOT NULL,
          quantity INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY (deck_id) REFERENCES decks_info(deck_id) ON DELETE CASCADE,
          FOREIGN KEY (card_id, card_name) REFERENCES magic_cards(id, name) ON DELETE CASCADE,
          PRIMARY KEY (deck_id, card_id, card_name)
        )
      ''');
    }
  }

  // Insertar una carta en la base de datos
  Future<int> insertCard(MagicCard card) async {
    final db = await database;
    return await db.insert(
      'magic_cards',
      card.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.ignore, // Ignorar si la carta ya existe
    );
  }

  // Crear un nuevo deck
  Future<int> createDeck(String name, {String? description}) async {
    final db = await database;
    return await db.insert('decks_info', {
      'name': name,
      'description': description ?? '',
    });
  }

  // Obtener todos los decks
  Future<List<Map<String, dynamic>>> getAllDecks() async {
    final db = await database;
    return await db.query('decks_info');
  }

  // Agregar una carta a un deck
  Future<int> addCardToDeck(
      int deckId, String cardId, String cardName, int quantity) async {
    final db = await database;
    return await db.insert(
      'deck_cards',
      {
        'deck_id': deckId,
        'card_id': cardId,
        'card_name': cardName,
        'quantity': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las cartas de un deck
  Future<List<MagicCard>> getCardsFromDeck(int deckId) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT mc.* FROM magic_cards mc
      INNER JOIN deck_cards dc
      ON mc.id = dc.card_id AND mc.name = dc.card_name
      WHERE dc.deck_id = ?
    ''', [deckId]);

    return results.map((map) => MagicCard.fromJson(map)).toList();
  }

  // Eliminar una carta de un deck
  Future<int> removeCardFromDeck(
      int deckId, String cardId, String cardName) async {
    final db = await database;
    return await db.delete(
      'deck_cards',
      where: 'deck_id = ? AND card_id = ? AND card_name = ?',
      whereArgs: [deckId, cardId, cardName],
    );
  }

  // Actualizar la cantidad de una carta en un deck
  Future<int> updateCardQuantityInDeck(
      int deckId, String cardId, String cardName, int quantity) async {
    final db = await database;
    return await db.update(
      'deck_cards',
      {'quantity': quantity},
      where: 'deck_id = ? AND card_id = ? AND card_name = ?',
      whereArgs: [deckId, cardId, cardName],
    );
  }

  // Eliminar un deck completo
  Future<int> deleteDeck(int deckId) async {
    final db = await database;
    return await db.delete(
      'decks_info',
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );
  }
}
