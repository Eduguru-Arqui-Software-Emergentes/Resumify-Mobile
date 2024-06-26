import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resumify_mobile/models/translate_model.dart';

class TranslateService{
  static Future<TranslateModel> translate(String text, String lang) async {

    try{
      var url = Uri.parse('http://10.0.2.2:5000/translate');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
      var response = await http.post(
          url,
          headers: headers,
          body: jsonEncode({
            'text': text,
            "language": lang
          })
      );

      if (response.statusCode == 200) {
        TranslateModel translateModel = TranslateModel.fromJson(json.decode(response.body));
        return translateModel;

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