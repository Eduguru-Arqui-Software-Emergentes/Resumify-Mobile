import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resumify_mobile/models/resumen_model.dart';
import 'package:resumify_mobile/models/summary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumenService{
  static Future<void> addResumen(ResumenModel resumen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    try{
      var url = Uri.parse('http://10.0.2.2:8080/api/v1/resumen/${userId}/create');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      var response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(resumen.toJson())
      );

      if (response.statusCode != 201) {
        Future.error("Error on request: ${response.statusCode}");

      } else if (response.statusCode == 401) {
        return Future.error('Invalid Credentials');
      } else {
        return Future.error('Request error: ${response.statusCode}');
      }
    } catch (error) {
      return Future.error('Error on connectivity: ${error}');
    }
  }

  static Future<List<ResumenModel>> getResumenes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    try {
      var url = Uri.parse(
          'http://10.0.2.2:8080/api/v1/resumen/usuario/${userId}');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application",
        "Authorization": "Bearer $token"
      };

      List<ResumenModel> resumenList = [];

      final response = await http.get(
          url,
          headers: headers
      );

      if (response.statusCode == 200) {
        final resumenes = jsonDecode(response.body);

        for (var resumen in resumenes) {
          resumenList.add(ResumenModel.fromJson(resumen));
        }
      } else {
        return Future.error('Request error: ${response.statusCode}');
      }
      return resumenList;
    } catch (error) {
      return Future.error('Error on connectivity: ${error}');
    }
  }
}