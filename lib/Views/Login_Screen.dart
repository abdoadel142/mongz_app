import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mongz_app/Views/Home_Page.dart';
import 'package:mongz_app/NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/auth';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = new FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  var done = false;
  var status = 'invalid Email or Password';
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _SignUPUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      await signup(data.name, data.password);
      if (done == true) {
        return null;
      } else {
        return status;
      }
    });
  }

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      await login(data.name, data.password);
      if (done == true) {
        return null;
      } else {
        return 'invalid user or password';
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {});
  }

  signup(email, password) async {
    Map<String, String> data = {
      "email": email,
      "password": password,
    };
    var response = await networkHandler.put("/auth/signup", data);

    if (response.statusCode == 422) {
      throw Exception(
          "Validation failed. Make sure the email address isn't used yet!");
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Creating a user failed!');
    }
    //Map<String, dynamic> output = json.decode(response.body);
    //print("SignUp Store Token: ");
    //print(output["token"]);
    // await storage.write(key: "token", value: output["token"]);
    done = true;
  }

  login(email, password) async {
//    Map<String, String> data = {
//      "email": email,
//      "password": password,
//    };
//    var response = await networkHandler.post("/auth/login", data);
//    if (response.statusCode == 422) {
//      // throw Exception('Validation failed.');
//      status = 'Validation failed.';
//    }
//    if (response.statusCode != 200 && response.statusCode != 201) {
//      // throw Exception('Could not authenticate you!');
//      status = 'Could not authenticate you!';
//    } else {
//      Map<String, dynamic> output = json.decode(response.body);
//      print("Login Store Token : ");
//      print(output["token"]);
//      await storage.write(key: "token", value: output["token"]);
//      done = true;
//    }
    done = true;
  }

  @override
  Widget build(BuildContext context) {

    return FlutterLogin(
      title: 'Mongz',
      logo: 'images/logol.png',
      messages: LoginMessages(
        usernameHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot password?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
        recoverPasswordDescription:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }

        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        if (value.length < 7) {
          return 'Password must be at least 7 digets';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        return _SignUPUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, firstPage.id);
      },
      onRecoverPassword: (name) {
        return _recoverPassword(name);
        // Show new password dialog
      },

      //showDebugButtons: true,
    );
  }
}
