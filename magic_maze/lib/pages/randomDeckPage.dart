import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';
import 'package:magic_maze/utils/api_helper.dart';

class RandomDeckPage extends StatefulWidget {
  const RandomDeckPage({Key? key}) : super(key: key);

  @override
  State<RandomDeckPage> createState() => _RandomDeckPageState();
}

class _RandomDeckPageState extends State<RandomDeckPage> {
  final MagicApiHelper apiHelper = MagicApiHelper();
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
          // Botón en la parte inferior central
          Card(
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.blue], // Mezcla de azul y transparencia
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      children: [
        Container(
          color: Colors.red.withOpacity(0.5), // Capa sólida adicional
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Combinación de colores',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  ),
),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _fetchRandomCards,
                child: const Text('Obtener Cartas'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}