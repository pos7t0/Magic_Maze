import 'package:flutter/material.dart';
import 'package:magic_maze/pages/add_deck.dart';
import 'package:magic_maze/pages/infoCard.dart';
import 'package:magic_maze/pages/modify_deck.dart';
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

  // Eliminar un mazo y sus cartas
  Future<void> _deleteDeck(int deckId) async {
    await dbHelper.removeCardsFromDeck(deckId); // Borrar cartas asociadas
    await dbHelper.removeDeck(deckId); // Borrar el mazo
    _loadDecks(); // Recargar la lista de mazos
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(deckName),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDeckPage(
                                deckId: deckId,
                                deckName: deckName,
                              ),
                            ),
                          ).then((_) {
                            _loadDecks(); // Recargar los mazos al volver
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Eliminar Mazo'),
                                content: const Text(
                                    '¿Estás seguro de que deseas eliminar este mazo y todas sus cartas?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmDelete == true) {
                            await _deleteDeck(deckId);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
                      children: [
                        ...cards.map((card) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: ListTile(
                              title: Text(card.name),
                              subtitle: Text(card.type),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InfoCard(card: card),
                                    ),
                                  ).then((_) {
                                    _loadDecks(); // Recargar los mazos al volver
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateDeckPage(),
            ),
          ).then((_) {
            _loadDecks(); // Recargar los mazos al volver
          });
        },
        tooltip: 'Crear nuevo mazo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
