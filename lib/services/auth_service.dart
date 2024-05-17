import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  static Future<void> signUp(String email, String password, String name, String username) async {

    try{
      var url = Uri.parse('http://localhost:8080/api/v1/autenticacion/signup');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      };
      var response = await http.post(
          url,
          headers: headers,
          body: jsonEncode({
            'email': email,
            'name': name,
            'password': password,
            'roles': "user",
            'userName': username
          })
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        return Future.value();
      } else if(response.statusCode == 400){
        var responseBody = json.decode(response.body);
        var message = responseBody['message'];
        return Future.error('${message}');
      } else {
        return Future.error('Request error: ${response.statusCode}');
      }
    } catch(error){
      return Future.error('Error on connectivity: $error');
    }
  }

  static Future<void> logIn(String username, String password) async {
    try {
      var url = Uri.parse('http://localhost:8080/api/v1/autenticacion/signin');
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'password': password, 'userName': username},),
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var token = responseBody['token'];
        var responseUsername = responseBody['userName'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userName', responseUsername);
      } else if (response.statusCode == 401) {
        return Future.error('Invalid Credentials');
      } else {
        return Future.error('Request error: ${response.statusCode}');
      }
    } catch (error) {
      return Future.error('Error on connectivity: ${error}');
    }
  }

  static Future<void> logOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}