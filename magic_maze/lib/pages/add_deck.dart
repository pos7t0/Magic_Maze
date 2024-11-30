// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';
import 'package:magic_maze/utils/api_helper.dart';
import 'package:magic_maze/utils/database_helper.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key});

  @override
  State<CreateDeckPage> createState() => _CreateDeckPageState();
}

class _CreateDeckPageState extends State<CreateDeckPage> {
  final _deckNameController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isDeckCreated = false;
  bool _isLoading = false;
  List<MagicCard> _searchedCards = [];
  // ignore: prefer_final_fields
  List<MagicCard> _selectedCards = [];
  late int _deckId;

  final MagicApiHelper _apiHelper = MagicApiHelper();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Método para buscar cartas
  void _searchCards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cards = await _apiHelper.fetchCardsByName(_searchController.text);
      setState(() {
        _searchedCards = cards;
      });
    } catch (e) {
      setState(() {
        _searchedCards = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al buscar cartas: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para crear el mazo en la base de datos
  void _createDeck() async {
    if (_deckNameController.text.isEmpty) return;

    final deckId = await _databaseHelper.insertDeck(_deckNameController.text);
    setState(() {
      _deckId = deckId;
      _isDeckCreated = true;
    });
  }

  // Método para agregar las cartas seleccionadas
  void _addCardsToDeck() async {
    if (_selectedCards.isEmpty) return;

    for (var card in _selectedCards) {
      await _databaseHelper.insertCard(_deckId, card);
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cartas agregadas al mazo!'),
    ));
    Navigator.pop(context);
  }

  // Método para mostrar la imagen de la carta
  Widget _buildCardImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 50);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Mazo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isDeckCreated) ...[
                // Input para el nombre del mazo
                TextField(
                  controller: _deckNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre del Mazo'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createDeck,
                  child: const Text('Crear Mazo'),
                ),
              ] else ...[
                // Muestra el nombre del mazo creado
                Text('Mazo: ${_deckNameController.text}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Buscador de cartas con tamaño fijo
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _searchController,
                    decoration:
                        const InputDecoration(labelText: 'Buscar Carta'),
                    onChanged: (_) => _searchCards(),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isLoading) const CircularProgressIndicator(),
                if (!_isLoading && _searchedCards.isNotEmpty) ...[
                  // Lista de cartas encontradas
                  SizedBox(
                    height: 300, // Altura fija para la lista de cartas
                    child: ListView.builder(
                      itemCount: _searchedCards.length,
                      itemBuilder: (context, index) {
                        final card = _searchedCards[index];
                        return ListTile(
                          leading: _buildCardImage(
                              card.imageUrl), // Agrega la imagen de la carta
                          title: Text(card.name),
                          subtitle: Text(card.type),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _selectedCards.add(card);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Cartas Seleccionadas en un espacio scrolleable
                const Text('Cartas Seleccionadas:'),
                SizedBox(
                  height: 200, // Altura fija para las cartas seleccionadas
                  child: ListView.builder(
                    itemCount: _selectedCards.length,
                    itemBuilder: (context, index) {
                      final card = _selectedCards[index];
                      return ListTile(
                        leading: _buildCardImage(card.imageUrl),
                        title: Text(card.name),
                        subtitle: Text(card.type),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _selectedCards.remove(card);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Botón para guardar las cartas en el mazo
                ElevatedButton(
                  onPressed: _addCardsToDeck,
                  child: const Text('Guardar Cartas'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
