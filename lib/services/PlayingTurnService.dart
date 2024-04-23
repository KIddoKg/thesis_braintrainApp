import 'dart:convert';

import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:http/http.dart' as http;

class PlayingTurnService {
  final AuthStorage authStorage = AuthStorage();

  Future<void> save(
      String gameType, String gameName, int score, int playTime) async {
    String accessToken = await authStorage.getAccessToken();

    var uri = Uri.parse("http://localhost:8080/api/playing-turn");
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map data = {
      'gameType': '$gameType',
      'gameName': '$gameName',
      'score': score,
      'playTime': playTime
    };
    var body = jsonEncode(data);

    try {
      await http.post(uri, headers: headers, body: body);
    } catch (error) {
      print("An error occurred: $error");
    }
  }
}
