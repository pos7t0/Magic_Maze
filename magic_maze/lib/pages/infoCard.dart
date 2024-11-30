import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';

class InfoCard extends StatelessWidget {
  final MagicCard card;

  const InfoCard({super.key, required this.card});

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
        title: Text(card.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Card para la imagen
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: card.imageUrl.isNotEmpty
                          ? Image.network(
                              card.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  height: 200,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card para la información con estilo de contorno
              Container(
                decoration: _getCardBackground(card.colors),
                padding: const EdgeInsets.all(4), // Margen para el contorno
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo: ${card.type}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rareza: ${card.rarity}',
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Costo de maná: ${card.manaCost}',
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Colores: ${card.colors.join(", ")}',
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Poder: ${card.power}',
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Resistencia: ${card.toughness}',
                          softWrap: true,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          card.text,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}