class MagicCard {
  final String id;
  final String name;
  final String type;
  final String rarity;
  final String text;
  final String manaCost;
  final List<String> colors; // Cambiado a List<String>
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
      id: json["id"] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rarity: json['rarity'] ?? '',
      text: json['text'] ?? '',
      manaCost: json["manaCost"] ?? '',
      colors: List<String>.from(json["colors"] ?? []), // Manejo como lista
      power: int.tryParse(json["power"] ?? '0') ?? 0,
      toughness: int.tryParse(json["toughness"] ?? '0') ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'rarity': rarity,
      'text': text,
      'manaCost': manaCost,
      'colors': colors.join(','), // Convertir lista a string
      'power': power,
      'toughness': toughness,
      'imageUrl': imageUrl,
    };
  }
}
