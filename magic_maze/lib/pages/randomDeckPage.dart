import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';
import 'package:magic_maze/pages/infoCard.dart';
import 'package:magic_maze/utils/api_helper.dart';
import 'package:magic_maze/utils/database_helper.dart';

class RandomDeckPage extends StatefulWidget {
  const RandomDeckPage({super.key});

  @override
  State<RandomDeckPage> createState() => _RandomDeckPageState();
}

class _RandomDeckPageState extends State<RandomDeckPage> {
  final MagicApiHelper apiHelper = MagicApiHelper();
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<MagicCard> _cards = [];
  int? _deckId;

  void _fetchRandomCards() async {
    try {
      const int randomCount = 60;
      List<MagicCard> cards = await apiHelper.fetchRandomCards(count: randomCount);
      setState(() {
        _cards = cards;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar cartas: $e')),
      );
    }
  }

  void _saveDeck() async {
    if (_cards.isEmpty) return;

    String deckName = 'Mazo aleatorio ${DateTime.now().toIso8601String()}';
    int deckId = await dbHelper.insertDeck(deckName);

    for (var card in _cards) {
      await dbHelper.insertCard(deckId, card);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mazo guardado con éxito!')),
    );
  }

  Decoration _getCardBackground(List<String> colors) {
    if (colors.isEmpty) {
      return const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      );
    }

    if (colors.length == 1) {
      return BoxDecoration(
        color: _getColor(colors[0]),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors.map(_getColor).toList(),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  Color _getColor(String colorInitial) {
    switch (colorInitial.toLowerCase()) {
      case 'w':
        return Color.fromARGB(255, 255, 255, 185);
      case 'u':
        return Colors.blue;
      case 'b':
        return Colors.black;
      case 'r':
        return Colors.red;
      case 'g':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Lista de Cartas'),
    backgroundColor: const Color.fromARGB(255, 11, 34, 63), // Color de fondo
    titleTextStyle: const TextStyle(
      color: Colors.white, // Cambia el color del texto del título
      fontSize: 20,        // Opcional: Ajusta el tamaño de la fuente
      fontWeight: FontWeight.bold, // Opcional: Ajusta el grosor del texto
    ),
  ),
      backgroundColor: const Color.fromARGB(255, 15, 50, 92),
      body: Stack(
        children: [
          if (_cards.isNotEmpty)
            ListView.builder(
              itemCount: _cards.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                var card = _cards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: _getCardBackground(card.colors),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        color: Colors.white, // Fondo neutro
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoCard(card: card),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  card.type,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _fetchRandomCards,
                child: const Text('Obtener Cartas'),
              ),
            ),
          ),
          if (_cards.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _saveDeck,
                  child: const Text('Guardar Mazo'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}