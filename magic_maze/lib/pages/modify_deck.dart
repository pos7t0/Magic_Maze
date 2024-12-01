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
        return const Icon(Icons.broken_image, size: 50, color: Colors.white);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Mazo', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 11, 34, 63),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _updateDeckName,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 15, 50, 92),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _deckNameController,
                style: const TextStyle(color: Colors.white), // Texto en blanco
                decoration: const InputDecoration(
                  labelText: 'Nombre del mazo',
                  labelStyle: TextStyle(color: Colors.white), // Etiqueta en blanco
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white), // Texto en blanco
                decoration: const InputDecoration(
                  labelText: 'Buscar cartas',
                  labelStyle: TextStyle(color: Colors.white), // Etiqueta en blanco
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: _searchCards,
              ),
              const SizedBox(height: 16),
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading && _searchedCards.isNotEmpty) ...[
                const Text('Cartas encontradas:', style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _searchedCards.length,
                    itemBuilder: (context, index) {
                      final card = _searchedCards[index];
                      return ListTile(
                        leading: _buildCardImage(card.imageUrl),
                        title: Text(card.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(card.type, style: const TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => _addCardToDeck(card),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(color: Colors.white), // Separador en blanco
              const Text('Cartas en el mazo:', style: TextStyle(color: Colors.white)),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _deckCards.length,
                  itemBuilder: (context, index) {
                    final card = _deckCards[index];
                    return ListTile(
                      leading: _buildCardImage(card.imageUrl),
                      title: Text(card.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(card.type, style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
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