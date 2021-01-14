import 'package:flutter/material.dart';
import 'package:mongz_app/Views/Login_Screen.dart';
import 'package:mongz_app/Views/Home_Page.dart';
import 'package:mongz_app/Views/Splash_Screen.dart';
import 'package:mongz_app/Views/map_screen.dart';
import 'Views/Cart.dart';
import 'Views/Places.dart';
import 'Views/profile_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 @override
  Widget build(BuildContext context) {


    return MaterialApp(
        title: "Mongz",
        theme: ThemeData(
            primaryColor: Color(0xFFFF9600), accentColor: Color(0xFFFF9600)),
        debugShowCheckedModeBanner: false,
        initialRoute:  Splash.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          map_screen.id: (context) => map_screen(),
          firstPage.id: (context) => firstPage(),
          ProfilePage.id: (context) => ProfilePage(),
          Places.id: (context) => Places(),
          Cart.id: (context) => Cart(),
          Splash.id: (context) => Splash(),
        });
  }
}
