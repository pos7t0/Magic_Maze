import 'package:flutter/material.dart';
import 'package:magic_maze/utils/database_helper.dart';
import 'package:magic_maze/models/magic_card.dart';

class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _decks = [];

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  // Cargar los mazos desde la base de datos
  void _loadDecks() async {
    final decks = await dbHelper.getDecks();
    setState(() {
      _decks = decks;
    });
  }

  // Obtener las cartas de un mazo
  Future<List<MagicCard>> _getCardsForDeck(int deckId) async {
    return await dbHelper.getCardsByDeckId(deckId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mazos'),
      ),
      body: ListView.builder(
        itemCount: _decks.length,
        itemBuilder: (context, index) {
          final deck = _decks[index];
          final deckId = deck['id'] as int;
          final deckName = deck['name'] as String;

          return Card(
            margin: const EdgeInsets.all(10),
            child: ExpansionTile(
              title: Text(deckName),
              children: [
                FutureBuilder<List<MagicCard>>(
                  future: _getCardsForDeck(deckId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const ListTile(
                        title: Text('No hay cartas en este mazo.'),
                      );
                    }

                    final cards = snapshot.data!;
                    return Column(
                      children: cards.map((card) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: ListTile(
                            title: Text(card.name),
                            subtitle: Text(card.type),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                // Aquí se manejará la navegación a otra pantalla en el futuro
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
