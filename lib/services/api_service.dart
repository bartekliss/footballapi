// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team.dart';

class ApiService {
  final String apiKey = '2c170d5784cb801caab9ae1dd761bba7'; // https://dashboard.api-football.com/
  final String baseUrl = 'https://v3.football.api-sports.io';

  Future<List<Team>> fetchTeams(int leagueId, int season) async {
    final response = await http.get(
      Uri.parse('$baseUrl/teams?league=$leagueId&season=$season'),
      headers: {'x-rapidapi-key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // API Football zwraca listę w polu 'response'
      List<dynamic> list = data['response'];
      return list.map((e) => Team.fromJson(e)).toList();
    } else {
      throw Exception('Błąd pobierania danych');
    }
  }

  // Drugie zapytanie - np. o skład drużyny (Players)
  Future<List<dynamic>> fetchSquad(int teamId) async {
    // Implementacja analogiczna do fetchTeams, endpoint: /players/squads?team=$teamId
    return [];
  }
}