import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';  // Importa el paquete de compartir
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
    final cards = await dbHelper.getCardsByDeckId(deckId);
    print('Cartas recuperadas para el mazo $deckId: ${cards.length}'); // Depuración
    return cards;
  }

  // Función para compartir un mazo completo (solo nombre y tipo de las cartas)
  void _shareDeck(int deckId, String deckName) async {
    // Obtener las cartas del mazo
    List<MagicCard> cards = await _getCardsForDeck(deckId);

    // Crear el texto de compartir con el nombre del mazo
    String deckInfo = 'Mazo: $deckName\n\n';

    // Recorrer las cartas del mazo y agregar solo nombre y tipo
    for (var card in cards) {
      deckInfo += '''
Carta: ${card.name}

----------------------------
''';
    }

    // Usar la librería share_plus para compartir el texto del mazo
    Share.share(deckInfo);
  }

  // Nueva función para compartir los detalles de una carta
  void _shareCardDetails(MagicCard card) {
    // Crear el texto de compartir con los detalles de la carta
    // Crear un texto detallado para compartir
  final String cardInfo = '''
Carta: ${card.name}
Tipo: ${card.type}
Rareza: ${card.rarity}
Coste de Maná: ${card.manaCost}
Colores: ${card.colors.join(', ')}
Poder: ${card.power}
Resistencia: ${card.toughness}
Texto: ${card.text}

Imagen: ${card.imageUrl}
''';

  // Usar la librería share_plus para compartir
  Share.share(cardInfo);
  }

  // Eliminar un mazo y sus cartas
  Future<void> _deleteDeck(int deckId) async {
    await dbHelper.removeCardsFromDeck(deckId); // Borrar cartas asociadas
    await dbHelper.removeDeck(deckId); // Borrar el mazo
    _loadDecks(); // Recargar la lista de mazos
  }

  // Función para crear el fondo con colores
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

  // Función para mapear los colores
  Color _getColor(String colorInitial) {
    switch (colorInitial.toLowerCase()) {
      case 'w':
        return const Color.fromARGB(255, 255, 255, 185);
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
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          _shareDeck(deckId, deckName); // Compartir el mazo completo
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

                    return ListView.builder(
                      shrinkWrap: true, // Asegura que la lista ocupe solo el espacio necesario
                      physics: NeverScrollableScrollPhysics(), // Evita el scroll en el ListView dentro del ExpansionTile
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
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
                                child: ListTile(
                                  title: Text(card.name),
                                  subtitle: Text(card.type),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InfoCard(card: card),
                                            ),
                                          ).then((_) {
                                            _loadDecks(); // Recargar los mazos al volver
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.share),
                                        onPressed: () {
                                          _shareCardDetails(card); // Compartir los detalles de la carta
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
              builder: (context) => CreateDeckPage(),
            ),
          ).then((_) {
            _loadDecks(); // Recargar los mazos al volver
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
