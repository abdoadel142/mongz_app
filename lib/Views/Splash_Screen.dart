import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mongz_app/Views/Home_Page.dart';
import 'package:mongz_app/Views/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongz_app/NetworkHandler.dart';
class Splash extends StatefulWidget {
static const id = 'splash';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  NetworkHandler networkHandler = new NetworkHandler();
 bool done=false;
  final storage = new FlutterSecureStorage();
String uid;
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
   checkLogin();
    startTimer();

  }
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     String email = prefs.get('email') ;
     String password = prefs.get("password");

 await login(email, password);

  }

  login(email, password) async {
   Map<String, String> data = {
     "email": email,
     "password": password,
   };
   var response = await networkHandler.post("/auth/login", data);
   if (response.statusCode == 422) {
     done = false;
   }
   if (response.statusCode != 200 && response.statusCode != 201) {
     done = false;
   } else {
     Map<String, dynamic> output = json.decode(response.body);
     print("Login Store Token : ");
     print(output["token"]);
     await storage.write(key: "token", value: output["token"]);
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString("id", output["userId"].toString());

     done = true;
   }

  }
  void startTimer() {
    Timer(Duration(seconds: 3), () {
      done? Navigator.pushReplacementNamed(context, firstPage.id)
          : Navigator.pushReplacementNamed(context, LoginScreen.id); //It will redirect  after 3 seconds
    });
  }
  @override
  Widget build(BuildContext context) {

    return  Container(
      color: Color(0xFFFF9600),
      child: Center(
          child: Image.asset(
            'images/logol.png',
            height: 200,
          ),
      ),
    );
  }
}
