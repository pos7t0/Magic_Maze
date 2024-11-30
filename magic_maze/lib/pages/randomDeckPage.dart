import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';
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

  // Método para obtener cartas aleatorias
  void _fetchRandomCards() async {
    try {
      const int randomCount = 60; // Número de cartas a obtener
      List<MagicCard> cards =
          await apiHelper.fetchRandomCards(count: randomCount);
      setState(() {
        _cards = cards;
      });
    } catch (e) {
      // Mostrar un mensaje en caso de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar cartas: $e')),
      );
    }
  }

  // Método para crear un mazo y guardar las cartas
  void _saveDeck() async {
    if (_cards.isEmpty) return;

    // Crear un nuevo mazo
    String deckName = 'Mazo aleatorio ${DateTime.now().toIso8601String()}';
    int deckId = await dbHelper.insertDeck(deckName);

    // Guardar las cartas en el mazo
    for (var card in _cards) {
      await dbHelper.insertCard(deckId, card);
    }

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mazo guardado con éxito!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cartas'),
      ),
      body: Stack(
        children: [
          // Lista de cartas
          if (_cards.isNotEmpty)
            ListView.builder(
              itemCount: _cards.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                var card = _cards[index];
                return ListTile(
                  title: Text(card.name),
                  subtitle: Text(card.type),
                );
              },
            ),
          // Botón para obtener cartas
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
          // Botón para guardar las cartas en un mazo, solo si hay cartas
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
