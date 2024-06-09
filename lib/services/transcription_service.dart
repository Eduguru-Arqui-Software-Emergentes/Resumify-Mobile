import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resumify_mobile/models/transcription_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranscriptionService{
  static Future<TranscriptionModel> transcript(String urlVideo) async {

    try{
      var url = Uri.parse('http://10.0.2.2:5000/convert');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
      var response = await http.post(
          url,
          headers: headers,
          body: jsonEncode({
            'url': urlVideo
          })
      );

      if (response.statusCode == 200) {
        TranscriptionModel transcriptionModel = TranscriptionModel.fromJson(json.decode(response.body));
        return transcriptionModel;

      } else if (response.statusCode == 401) {
        return Future.error('Invalid Credentials');
      } else {
        return Future.error('Request error: ${response.statusCode}');
      }
    } catch (error) {
      return Future.error('Error on connectivity: ${error}');
    }
  }
}