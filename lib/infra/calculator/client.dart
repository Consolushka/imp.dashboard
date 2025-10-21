import 'dart:convert';

import 'package:http/http.dart';

import '../../models/player_stat_imp_model.dart';

class CalculatorClient {
  final String _baseUrl;

  CalculatorClient(this._baseUrl);

  Future<Map<int, List<PlayerStatImp>>> imp(List<int> ids, List<String> pers) async {
    Map<int, List<PlayerStatImp>> res = <int, List<PlayerStatImp>>{};

    String idsParam = "";
    for (var i = 0; i < ids.length; i++) {
      idsParam += "ids=${ids[i]}";
      if (i < ids.length - 1) {
        idsParam += "&";
      }
    }

    String persParam = "";
    for (var i = 0; i < pers.length; i++) {
      persParam += "impPers=${pers[i]}";
      if (i < pers.length - 1) {
        persParam += "&";
      }
    }

    var uri = Uri.parse("$_baseUrl/imp?$idsParam&$persParam");

    var response = await get(uri, headers: {'Content-Type': 'application/json'});

    var responseBody = _handleBodyBytes(response);
    for (var el in (responseBody['data'] as List)) {
      var test = (el['impPers'] as List).map((impPer) => PlayerStatImp.fromJson(impPer)).toList();
      res[el['playerStatId']] = test;
    }
    return res;
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
