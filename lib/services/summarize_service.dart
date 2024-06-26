import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resumify_mobile/models/summary_model.dart';

class SummarizeService{
  static Future<SummaryModel> summarize(String text) async {

    try{
      var url = Uri.parse('http://10.0.2.2:5000/summarize');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
      var response = await http.post(
          url,
          headers: headers,
          body: jsonEncode({
            'text': text
          })
      );

      if (response.statusCode == 200) {
        SummaryModel summaryModel = SummaryModel.fromJson(json.decode(response.body));
        return summaryModel;

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