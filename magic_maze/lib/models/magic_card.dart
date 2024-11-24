class MagicCard {
  final String name;
  final String type;
  final String rarity;
  final String text;
  final String imageUrl;

  MagicCard({
    required this.name,
    required this.type,
    required this.rarity,
    required this.text,
    required this.imageUrl,
  });

  // Método para convertir la respuesta JSON en un objeto MagicCard
  factory MagicCard.fromJson(Map<String, dynamic> json) {
    return MagicCard(
      name: json['name'],
      type: json['type'],
      rarity: json['rarity'],
      text: json['text'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
