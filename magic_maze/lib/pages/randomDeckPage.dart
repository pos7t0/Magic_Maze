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
  int? _deckId; // ID del mazo creado o seleccionado

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

    // Crear el mazo
    final deckName = 'Mazo Aleatorio ${DateTime.now().toIso8601String()}';
    final deckId = await dbHelper.createDeck(deckName);

    // Guardar todas las cartas en el mazo
    for (var card in _cards) {
      await dbHelper.addCardToDeck(deckId, card.id, card.name,
          1); // Puedes ajustar la cantidad si lo necesitas
    }

    setState(() {
      _deckId = deckId; // Guardar el ID del mazo creado
    });

    // Mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mazo guardado exitosamente!')),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: InkWell(
          onTap: () {
            // Navegar a la página de información
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
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
