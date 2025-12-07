import 'dart:convert';

import 'package:http/http.dart';
import 'package:imp/infra/statistics/paginated_response.dart';
import 'package:imp/models/game_model.dart';
import 'package:imp/models/league_model.dart';
import 'package:imp/models/tournament_model.dart';

import '../../models/player_stat_imp_model.dart';

class StatisticsClient {
  final String _baseUrl;

  StatisticsClient(this._baseUrl);

  Future<List<League>> leagues() async {
    var uri = Uri.parse("$_baseUrl/leagues");

    var response = await get(uri, headers: {'Content-Type': 'application/json'});

    var responseBody = _handleBodyBytes(response);

    return (responseBody['data'] as List).map((item) => League.fromJson(item)).toList();
  }

  Future<List<Tournament>> tournaments() async {
    var uri = Uri.parse("$_baseUrl/tournaments");

    var response = await get(uri, headers: {'Content-Type': 'application/json'});

    var responseBody = _handleBodyBytes(response);
    return (responseBody['data'] as List).map((item) => Tournament.fromJson(item)).toList();
  }

  Future<List<Tournament>> tournamentsByLeague(int leagueId) async {
    var uri = Uri.parse("$_baseUrl/leagues/$leagueId/tournaments");

    var response = await get(uri, headers: {'Content-Type': 'application/json'});

    var responseBody = _handleBodyBytes(response);
    return (responseBody['data'] as List).map((item) => Tournament.fromJson(item)).toList();
  }

  Future<PaginatedResponse<Game>> gamesByTournamentPaginated(int tournamentId, int page) async {
    final response = await get(
      Uri.parse('$_baseUrl/tournaments/$tournamentId/games?page=$page'),
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = _handleBodyBytes(response);
    return PaginatedResponse.fromJson(responseBody, Game.fromJson);
  }

  Future<PaginatedResponse<Game>> gamesPaginated(int page) async {
    final response = await get(Uri.parse('$_baseUrl/games?page=$page'), headers: {'Content-Type': 'application/json'});

    final responseBody = _handleBodyBytes(response);
    return PaginatedResponse.fromJson(responseBody, Game.fromJson);
  }

  Future<Game> game(int id) async {
    var uri = Uri.parse("$_baseUrl/games/$id");

    var response = await get(uri, headers: {'Content-Type': 'application/json'});

    var responseBody = _handleBodyBytes(response);
    return Game.fromJson(responseBody['data']);
  }

  Future<Map<int, Map<String, double>>> imp(List<int> ids, List<String> pers) async {
    String idsParam = "";
    for (var i = 0; i < ids.length; i++) {
      idsParam += "ids[]=${ids[i]}";
      if (i < ids.length - 1) {
        idsParam += "&";
      }
    }

    String persParam = "";
    for (var i = 0; i < pers.length; i++) {
      persParam += "pers[]=${pers[i]}";
      if (i < pers.length - 1) {
        persParam += "&";
      }
    }

    var uri = Uri.parse("$_baseUrl/imp?$idsParam&$persParam");

    var response = await get(uri, headers: {'Content-Type': 'application/json'});

    var responseBody = _handleBodyBytes(response);
    var res1 = <int, Map<String, double>>{};
    var a = responseBody['data'] as Map;
    a.forEach((key, val) {
      var perMap = <String, double>{};
      var test = val as Map;
      for (var perVal in test.keys) {
        perMap[perVal] = test[perVal]['imp'].toDouble();
      }
      res1[int.parse(key)] = perMap;
    });

    return res1;
  }

  // Обрабатывает ответ от сервера и парсит ошибку если не 200ый статус ответа
  Map<String, dynamic> _handleBodyBytes(Response response) {
    var bodyString = utf8.decode(response.bodyBytes);
    if (response.statusCode != 200) {
      throw Exception(bodyString);
    }

    return jsonDecode(bodyString);
  }
}
