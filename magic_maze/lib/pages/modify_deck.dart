// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';
import 'package:magic_maze/utils/database_helper.dart';
import 'package:magic_maze/utils/api_helper.dart';

class EditDeckPage extends StatefulWidget {
  final int deckId;
  final String deckName;

  const EditDeckPage({
    super.key,
    required this.deckId,
    required this.deckName,
  });

  @override
  State<EditDeckPage> createState() => _EditDeckPageState();
}

class _EditDeckPageState extends State<EditDeckPage> {
  final _deckNameController = TextEditingController();
  final _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final MagicApiHelper _apiHelper = MagicApiHelper();
  List<MagicCard> _deckCards = [];
  List<MagicCard> _searchedCards = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _deckNameController.text = widget.deckName;
    _loadDeckCards();
  }

  // Cargar cartas del mazo
  void _loadDeckCards() async {
    final cards = await _dbHelper.getCardsByDeckId(widget.deckId);
    setState(() {
      _deckCards = cards;
    });
  }

  // Actualizar el nombre del mazo
  void _updateDeckName() async {
    if (_deckNameController.text.isNotEmpty) {
      await _dbHelper.updateDeckName(widget.deckId, _deckNameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre del mazo actualizado.')),
      );
      // Regresar a la página anterior
      Navigator.pop(context);
    }
  }

  // Buscar cartas
  void _searchCards(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchedCards = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final cards = await _apiHelper.fetchCardsByName(query);
      setState(() {
        _searchedCards = cards;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Agregar carta al mazo
  void _addCardToDeck(MagicCard card) async {
    await _dbHelper.insertCard(widget.deckId, card);
    _loadDeckCards();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carta añadida al mazo.')),
    );
  }

  // Eliminar carta del mazo
  void _removeCardFromDeck(MagicCard card) async {
    await _dbHelper.removeCardFromDeck(widget.deckId, card.id);
    _loadDeckCards();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Carta eliminada del mazo.')),
    );
  }

  // Construir widget de imagen de carta
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
      appBar: AppBar(
        title: const Text('Editar Mazo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateDeckName,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo para editar el nombre del mazo
              TextField(
                controller: _deckNameController,
                decoration: const InputDecoration(labelText: 'Nombre del mazo'),
              ),
              const SizedBox(height: 16),
              // Campo de búsqueda
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(labelText: 'Buscar cartas'),
                onChanged: _searchCards,
              ),
              const SizedBox(height: 16),
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading && _searchedCards.isNotEmpty) ...[
                // Lista de cartas encontradas
                const Text('Cartas encontradas:'),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _searchedCards.length,
                    itemBuilder: (context, index) {
                      final card = _searchedCards[index];
                      return ListTile(
                        leading: _buildCardImage(card.imageUrl),
                        title: Text(card.name),
                        subtitle: Text(card.type),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addCardToDeck(card),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(), // Separador visual
              // Lista de cartas en el mazo
              const Text('Cartas en el mazo:'),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _deckCards.length,
                  itemBuilder: (context, index) {
                    final card = _deckCards[index];
                    return ListTile(
                      leading: _buildCardImage(card.imageUrl),
                      title: Text(card.name),
                      subtitle: Text(card.type),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeCardFromDeck(card),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
