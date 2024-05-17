import 'dart:async';
import 'package:resumify_mobile/presentation/screens/home_screen.dart';
import 'package:resumify_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool remember = false;

  void InitializeVar() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString("user")??"";
    String pass = prefs.getString("pass")??"";
    setState(() {
      remember = prefs.getBool("rem")??false;
    });
    _usernameController.text = user;
    _passwordController.text = pass;
  }

  @override
  void initState() {
    InitializeVar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 40, 40, 1.0),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text("Username",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter username",
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Password",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter password",
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: remember,
                        onChanged: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            remember = value!;
                          });
                          if(remember){
                            prefs.setString("user", _usernameController.text);
                            prefs.setString("pass", _passwordController.text);
                            prefs.setBool("rem", remember);
                          } else {
                            prefs.remove("user");
                            prefs.remove("pass");
                            prefs.setBool("rem", remember);
                          }},
                        checkColor: Colors.white,
                        activeColor: const Color.fromRGBO(10, 20, 120, 1.0),
                      ),
                      Text("Remember this credentials",
                        style: TextStyle(fontSize: 15, color: Colors.white),)
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(10, 20, 120, 1.0)),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });

                            AuthService.logIn(_usernameController.text, _passwordController.text).then((_) =>{
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => HomeScreen(index: 0,))),
                            }).catchError((error){
                              String errorMessage = "Ocurrió un error durante el inicio de sesión";
                              errorMessage = error.toString();
                              Fluttertoast.showToast(
                                  msg: errorMessage,
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: const Color.fromRGBO(
                                      255, 174, 0, 1.0),
                                  textColor: Colors.black,
                                  fontSize: 18.0
                              );
                            }).whenComplete(() {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          },
                          child: _isLoading
                              ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 3.0,
                              )
                          ) : Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Log in", style: TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                        )
                    ),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}