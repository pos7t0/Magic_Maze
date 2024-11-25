class MagicCard {
  final int id;
  final String name;
  final String type;
  final String rarity;
  final String text;
  final String manaCost;
  final String colors;
  final int power;
  final int toughness;
  final String imageUrl;

  MagicCard({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    required this.text,
    required this.manaCost,
    required this.colors,
    required this.power,
    required this.toughness,
    required this.imageUrl,
  });

  // Método para convertir la respuesta JSON en un objeto MagicCard
  factory MagicCard.fromJson(Map<String, dynamic> json) {
    return MagicCard(
      id: json["id"],
      name: json['name'],
      type: json['type'],
      rarity: json['rarity'],
      text: json['text'],
      manaCost: json["manaCost"],
      colors: json["colors"],
      power: json["power"],
      toughness: json["toughness"],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
