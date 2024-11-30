import 'package:flutter/material.dart';
import 'package:magic_maze/models/magic_card.dart';

class InfoCard extends StatelessWidget {
  final MagicCard card; // Carta a mostrar

  const InfoCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manejo de la imagen de la carta
            Center(
              child: card.imageUrl.isNotEmpty
                  ? Image.network(
                      card.imageUrl,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ); // Muestra un ícono si no se puede cargar la imagen
                      },
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ), // Ícono si la URL está vacía
            ),
            const SizedBox(height: 16),

            // Información de la carta
            Text(
              'Tipo: ${card.type}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Rareza: ${card.rarity}'),
            const SizedBox(height: 8),
            Text('Costo de maná: ${card.manaCost}'),
            const SizedBox(height: 8),
            Text('Colores: ${card.colors.join(", ")}'),
            const SizedBox(height: 8),
            Text('Poder: ${card.power}'),
            const SizedBox(height: 8),
            Text('Resistencia: ${card.toughness}'),
            const SizedBox(height: 16),
            Text(
              card.text,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
