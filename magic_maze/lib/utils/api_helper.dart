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
  Future<List<MagicCard>> searchCardsByName(String name,
      {int page = 1, int pageSize = 100}) async {
    final url =
        Uri.parse('$baseUrl/cards?name=$name&page=$page&pageSize=$pageSize');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cardList = data['cards'];

      return cardList.map((json) => MagicCard.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load cards by name. Status code: ${response.statusCode}');
    }
  }
}
