import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magic_maze/models/magic_card.dart';

class MagicApiHelper {
  static const String baseUrl = 'https://api.magicthegathering.io/v1/';

  // Método para obtener todas las cartas, con paginación
  Future<List<MagicCard>> fetchCards({int page = 1, int pageSize = 100}) async {
    final url = Uri.parse('$baseUrl/cards?page=$page&pageSize=$pageSize');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cardList = data['cards'];

      return cardList.map((json) => MagicCard.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load cards. Status code: ${response.statusCode}');
    }
  }

// Método para buscar cartas por nombre
  Future<List<MagicCard>> fetchCardsByName(String name,
      {bool exactMatch = false}) async {
    // Si exactMatch es verdadero, encierra el nombre entre comillas
    final formattedName = exactMatch ? '"$name"' : name;

    final url = Uri.parse('${baseUrl}cards?name=$formattedName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cardList = data['cards'];

      return cardList.map((json) => MagicCard.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch cards by name. Status code: ${response.statusCode}');
    }
  }

  // Método para obtener cartas aleatorias
  Future<List<MagicCard>> fetchRandomCards({required int count}) async {
    if (count < 60 || count > 100) {
      throw Exception('The number of cards must be between 60 and 100.');
    }

    final url = Uri.parse('$baseUrl/cards?random=true&pageSize=$count');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cardList = data['cards'];

      return cardList.map((json) => MagicCard.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load random cards. Status code: ${response.statusCode}');
    }
  }
}
